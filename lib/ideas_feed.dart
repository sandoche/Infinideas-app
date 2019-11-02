import 'dart:async';
import 'dart:io';

import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:in_app_purchase/billing_client_wrappers.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:infinideas/blocs/IdeasBloc.dart';
import 'package:infinideas/models/idea.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'about.dart';
import 'connectivity_check.dart';
import 'idea_item.dart';
import 'themes.dart';

class IdeasFeed extends StatefulWidget {
  IdeasFeed({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _IdeasFeedState createState() => _IdeasFeedState();
}

class _IdeasFeedState extends State<IdeasFeed> {
  ScrollController _scrollController = new ScrollController();

  StreamSubscription<List<PurchaseDetails>> _subscription;
  bool loadingNewItems = false;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    displayAlertWhenNoConnection(context);
    setDefaultTheme();
    bloc.fetch(true);
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        setState(() {
          displayAlertWhenNoConnection(context);
          loadingNewItems = true;
          fetchNewItems();
        });
      }
    });
    final Stream purchaseUpdates =
        InAppPurchaseConnection.instance.purchaseUpdatedStream;
    _subscription = purchaseUpdates.listen((purchases) {
      if (purchases.length > 0) {
        if (purchases[0].productID == "com.sandoche.infinideas.darkmode" &&
            purchases[0].status == PurchaseStatus.purchased) {
          if (Platform.isIOS) {
            InAppPurchaseConnection.instance.completePurchase(purchases[0]);
          }
          saveDarkThemeUnlocked();
        }
      }
    });
    retrieveProducts();
  }

  fetchNewItems() async {
    bool isDoneFetching = await bloc.fetch(false);
    if (isDoneFetching) {
      setState(() {
        loadingNewItems = false;
      });
    }
  }

  bool isDarkTheme() {
    return Theme.of(context).brightness == Brightness.dark;
  }

  retrieveProducts() async {
    final bool available = await InAppPurchaseConnection.instance.isAvailable();
    if (available) {
      bool isDarkThemeUnlocked = await this.isDarkThemeUnlocked();
      if (!isDarkThemeUnlocked) {
        final QueryPurchaseDetailsResponse response =
            await InAppPurchaseConnection.instance.queryPastPurchases();
        if (response.error == null && response.pastPurchases.length > 0) {
          for (var pastPurchase in response.pastPurchases) {
            if (pastPurchase.productID == "com.sandoche.infinideas.darkmode") {
              saveDarkThemeUnlocked();
              if (Platform.isIOS &&
                  pastPurchase.status == PurchaseStatus.purchased) {
                InAppPurchaseConnection.instance.completePurchase(pastPurchase);
              }
            }
          }
        }
      }
    }
  }

  Future purchaseItem() async {
    final bool available = await InAppPurchaseConnection.instance.isAvailable();
    if (available) {
      ProductDetails productDetails;
      Set<String> productsIds = <String>['com.sandoche.infinideas.darkmode'].toSet();
      final ProductDetailsResponse response = await InAppPurchaseConnection
          .instance
          .queryProductDetails(productsIds);
      if (response.notFoundIDs.isNotEmpty) {}
      productDetails = response.productDetails[0];
      final PurchaseParam purchaseParam =
          PurchaseParam(productDetails: productDetails);
      if ((Platform.isIOS &&
              productDetails.skProduct.subscriptionPeriod == null) ||
          (Platform.isAndroid &&
              productDetails.skuDetail.type == SkuType.subs)) {
        InAppPurchaseConnection.instance
            .buyConsumable(purchaseParam: purchaseParam);
      } else {
        InAppPurchaseConnection.instance
            .buyNonConsumable(purchaseParam: purchaseParam);
      }
    }
  }

  Future toggleTheme() async {
    bool isDarkThemeUnlocked = await this.isDarkThemeUnlocked();
    if (isDarkThemeUnlocked) {
      switchTheme();
    } else {
      showAlertDialog();
    }
  }

  void showAlertDialog() {
    if (Platform.isAndroid) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text("Unlock Dark Theme"),
            content: new Text(
                "Infinideas is a free app but in order to keep the app up to date we decided to sell the Dark Theme."),
            actions: <Widget>[
              FlatButton(
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: const Text('Unlock Dark Theme'),
                onPressed: () {
                  Navigator.of(context).pop();
                  purchaseItem();
                },
              )
            ],
          );
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: new Text("Unlock Dark Theme"),
            content: new Text(
                "Infinideas is a free app but in order to keep the app up to date we decided to sell the Dark Theme."),
            actions: <Widget>[
              FlatButton(
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: const Text('Unlock Dark Theme'),
                onPressed: () {
                  Navigator.of(context).pop();
                  purchaseItem();
                },
              )
            ],
          );
        },
      );
    }
  }

  Future<bool> isDarkThemeUnlocked() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    bool isDarkThemeUnlocked = sharedPreferences.getBool("darkThemeUnlocked");
    return isDarkThemeUnlocked == null ? false : isDarkThemeUnlocked;
  }

  void saveDarkThemeUnlocked() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool("darkThemeUnlocked", true);
  }

  void saveDefaultTheme(bool isDarkTheme) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool("isDefaultThemeDark", isDarkTheme);
  }

  void switchTheme() {
    saveDefaultTheme(!isDarkTheme());
    DynamicTheme.of(context)
        .setThemeData(isDarkTheme() ? lightTheme : darkTheme);
  }

  setDefaultTheme() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    bool isDefaultThemeDark =
        sharedPreferences.getBool("isDefaultThemeDark") == null
            ? false
            : sharedPreferences.getBool("isDefaultThemeDark");
    ThemeData defaultTheme = isDefaultThemeDark ? darkTheme : lightTheme;
    DynamicTheme.of(context).setThemeData(defaultTheme);
  }

  void _openAboutPage(BuildContext context, bool isDarkTheme) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => About(isDarkTheme: isDarkTheme)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<List<Idea>>(
          stream: bloc.ideasStream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return CustomScrollView(
                  controller: _scrollController,
                  slivers: <Widget>[
                    SliverAppBar(
                        flexibleSpace: FlexibleSpaceBar(
                            centerTitle: false,
                            titlePadding:
                                const EdgeInsets.only(left: 26, bottom: 40),
                            title: Text('Infinideas',
                                style:
                                    getSliverAppBarTitleStyle(isDarkTheme()))),
                        backgroundColor:
                            getSliverAppBarBackground(isDarkTheme()),
                        expandedHeight: 150.0,
                        brightness: getAppBarBrightness(isDarkTheme()),
                        actions: <Widget>[
                          IconButton(
                            icon: Icon(Icons.favorite_border),
                            color: getMenuIconColor(isDarkTheme()),
                            tooltip: 'Favourites',
                            onPressed: () {
                              //toggleTheme();
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.brightness_6),
                            color: getMenuIconColor(isDarkTheme()),
                            tooltip: 'Toggle Theme',
                            onPressed: () {
                              toggleTheme();
                            },
                          ),
                          IconButton(
                              icon: Icon(Icons.info),
                              color: getMenuIconColor(isDarkTheme()),
                              tooltip: 'About',
                              onPressed: () {
                                _openAboutPage(context, isDarkTheme());
                              }),
                        ]),
                    SliverList(
                        delegate: new SliverChildBuilderDelegate(
                            (BuildContext context, int index) {
                      if (snapshot.data[index].isLast) {
                        return _loader();
                      } else {
                        return IdeaItem(
                          isDarkTheme: isDarkTheme(),
                          idea: snapshot.data[index],
                        );
                      }
                    }, childCount: snapshot.data.length))
                  ]);
            } else {
              return Center(child: CircularProgressIndicator());
            }
          }),
    );
  }

  Widget _loader() {
    return loadingNewItems
        ? new Align(
            child: new Container(
              width: 70.0,
              height: 50.0,
              child: new Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: new Center(child: new CircularProgressIndicator())),
            ),
          )
        : new SizedBox(
            width: 70.0,
            height: 50.0,
          );
  }
}
