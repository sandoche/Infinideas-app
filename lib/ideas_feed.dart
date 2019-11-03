import 'dart:async';
import 'dart:io';

import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:in_app_purchase/billing_client_wrappers.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:infinideas/blocs/IdeasBloc.dart';
import 'package:infinideas/models/dark_theme_handler.dart';
import 'package:infinideas/models/idea.dart';
import 'package:infinideas/favorites_screen.dart';
import 'package:infinideas/models/premium_handler.dart';
import 'package:infinideas/resources/alerts_provider.dart';
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
  DarkTheme darkTheme;
  PremiumHandler primium;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    displayAlertWhenNoConnection(context);
    darkTheme = DarkTheme(context);
    darkTheme.setDefaultTheme();
    primium = PremiumHandler();
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
    _subscription = primium.getPurchaseSubscription();
    primium.retrieveProducts();
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
                                    getSliverAppBarTitleStyle(darkTheme.isDarkTheme()))),
                        backgroundColor:
                            getSliverAppBarBackground(darkTheme.isDarkTheme()),
                        expandedHeight: 150.0,
                        brightness: getAppBarBrightness(darkTheme.isDarkTheme()),
                        actions: <Widget>[
                          IconButton(
                            icon: Icon(Icons.favorite_border),
                            color: getMenuIconColor(darkTheme.isDarkTheme()),
                            tooltip: 'Favourites',
                            onPressed: () => Navigator.of(context)
                              .push(MaterialPageRoute(builder: (_) => FavoriteScreen())),
                          ),
                          IconButton(
                            icon: Icon(Icons.brightness_6),
                            color: getMenuIconColor(darkTheme.isDarkTheme()),
                            tooltip: 'Toggle Theme',
                            onPressed: () {
                              toggleTheme();
                            },
                          ),
                          IconButton(
                              icon: Icon(Icons.info),
                              color: getMenuIconColor(darkTheme.isDarkTheme()),
                              tooltip: 'About',
                              onPressed: () {
                                _openAboutPage(context, darkTheme.isDarkTheme());
                              }),
                        ]),
                    SliverList(
                        delegate: new SliverChildBuilderDelegate(
                            (BuildContext context, int index) {
                      if (snapshot.data[index].isLast) {
                        return _loader();
                      } else {
                        return IdeaItem(
                          isDarkTheme: darkTheme.isDarkTheme(),
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


  fetchNewItems() async {
    bool isDoneFetching = await bloc.fetch(false);
    if (isDoneFetching) {
      setState(() {
        loadingNewItems = false;
      });
    }
  }

  Future toggleTheme() async {
    bool isPrimiumUnlocked = await this.primium.isPremiumUnlocked();
    if (isPrimiumUnlocked) {
      darkTheme.switchTheme();
    } else {
      showUnlockPremiumAlert("Dark Theme");
    }
  }

  Future clickOnFavorites() async {
    bool isPrimiumUnlocked = await this.primium.isPremiumUnlocked();
    if (isPrimiumUnlocked) {
      _openFavoritesPage(context);
    } else {
      showUnlockPremiumAlert("Favorites");
    }
  }

  void showUnlockPremiumAlert(String toUnlock) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          if (Platform.isAndroid) {
            return AlertsProvider(context).getAlertForAndroidPremium(primium, toUnlock);
          } else {
            return AlertsProvider(context).getAlertForiOSPremium(primium, toUnlock);
          }
        });
  }

  void _openFavoritesPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => FavoriteScreen()),
    );
  }

  void _openAboutPage(BuildContext context, bool isDarkTheme) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => About(isDarkTheme: isDarkTheme)),
    );
  }
}
