import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/billing_client_wrappers.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:infinidea/blocs/IdeasBloc.dart';
import 'package:infinidea/models/idea.dart';
import 'idea_item.dart';
import 'about.dart';
import 'package:flutter/services.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'themes.dart';
import 'connectivity_check.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
        if (purchases[0].status == PurchaseStatus.purchased) {
          saveDarkThemeUnlocked();
          switchTheme();
        }
      }
    });
    retrieveProducts();
  }

  Future<Null> _refresh() {
    displayAlertWhenNoConnection(context);
    return bloc.fetch(true);
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
          if (response.pastPurchases[0].productID == "darktheme") {
            saveDarkThemeUnlocked();
            if (Platform.isIOS) {
              InAppPurchaseConnection.instance
                  .completePurchase(response.pastPurchases[0]);
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
      Set<String> productsIds = <String>['darktheme'].toSet();
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
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text("Payment"),
            content: new Text("Unlock the darktheme !!"),
            actions: <Widget>[
              FlatButton(
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: const Text('Unlock darktheme'),
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
              return RefreshIndicator(
                  onRefresh: _refresh,
                  child: CustomScrollView(
                      controller: _scrollController,
                      slivers: <Widget>[
                        SliverAppBar(
                            flexibleSpace: FlexibleSpaceBar(
                                centerTitle: false,
                                titlePadding:
                                    const EdgeInsets.only(left: 26, bottom: 40),
                                title: Text('InfinIdea',
                                    style: getSliverAppBarTitleStyle(
                                        isDarkTheme()))),
                            backgroundColor:
                                getSliverAppBarBackground(isDarkTheme()),
                            expandedHeight: 150.0,
                            actions: <Widget>[
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
                      ]));
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
