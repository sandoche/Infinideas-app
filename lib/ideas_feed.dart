import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/billing_client_wrappers.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:infinidea/blocs/IdeasBloc.dart';
import 'package:infinidea/models/idea.dart';
import 'idea_item.dart';
import 'about.dart';
import 'styles.dart';
import 'package:flutter/services.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
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

  ProductDetails productDetails;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    bloc.fetch(true);
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        bloc.fetch(false);
      }
    });
    final Stream purchaseUpdates =
        InAppPurchaseConnection.instance.purchaseUpdatedStream;
    _subscription = purchaseUpdates.listen(
        (purchases) {
          print('purchases' + purchases);
        },
        onDone: () {},
        onError: (error) {
          print('error' + error);
        });
    retrieveProducts();
  }

  Future<Null> _refresh() {
    return bloc.fetch(true);
  }

  bool isDarkTheme() {
    return Theme.of(context).brightness == Brightness.dark;
  }

  retrieveProducts() async {
    final bool available = await InAppPurchaseConnection.instance.isAvailable();
    final QueryPurchaseDetailsResponse response =
        await InAppPurchaseConnection.instance.queryPastPurchases();
    if (response.error != null) {
      // Handle the error.
    }
    if (!available) {
      Set<String> _kIds = <String>['darktheme'].toSet();
    } else {
      Set<String> _kIds = <String>['darktheme'].toSet();
      final ProductDetailsResponse response =
          await InAppPurchaseConnection.instance.queryProductDetails(_kIds);
      if (response.notFoundIDs.isNotEmpty) {}

      productDetails = response.productDetails[0];
    }
  }

  void purchaseItem(ProductDetails productDetails) {
    print('purchase item' + productDetails.toString());
    final PurchaseParam purchaseParam =
        PurchaseParam(productDetails: productDetails);
    if ((Platform.isIOS &&
            productDetails.skProduct.subscriptionPeriod == null) ||
        (Platform.isAndroid && productDetails.skuDetail.type == SkuType.subs)) {
      InAppPurchaseConnection.instance
          .buyConsumable(purchaseParam: purchaseParam);
    } else {
      InAppPurchaseConnection.instance
          .buyNonConsumable(purchaseParam: purchaseParam);
    }
  }

  void _toggleTheme() {
    purchaseItem(productDetails);
//    showDialog(
//      context: context,
//      builder: (BuildContext context) {
//        // return object of type Dialog
//        return AlertDialog(
//          title: new Text("Alert Dialog title"),
//          content: new Text("Alert Dialog body"),
//          actions: <Widget>[
//            // usually buttons at the bottom of the dialog
//            new FlatButton(
//              child: new Text("Close"),
//              onPressed: () {
//                Navigator.of(context).pop();
//              },
//            ),
//          ],
//        );
//      },
//    );

    DynamicTheme.of(context)
        .setThemeData(isDarkTheme() ? lightTheme : darkTheme);
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
                                  _toggleTheme();
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.info),
                                color: getMenuIconColor(isDarkTheme()),
                                tooltip: 'About',
                                onPressed: () {
                                  _openAboutPage(context, isDarkTheme());
                                }
                              ),
                            ]),
                        SliverList(
                            delegate: new SliverChildBuilderDelegate(
                                (BuildContext context, int index) {
                          return IdeaItem(
                            isDarkTheme: isDarkTheme(),
                            idea: snapshot.data[index],
                          );
                        }, childCount: snapshot.data.length))
                      ]));
            } else {
              return Center(child: CircularProgressIndicator());
            }
          }),
    );
  }
}
