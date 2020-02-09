import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'themes.dart';
import 'styles.dart';

class About extends StatelessWidget {
  final bool isDarkTheme;

  _launchURL(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  About({Key key, @required this.isDarkTheme}) : super(key: key);

  retrieveProducts(BuildContext context) async {
    final bool available = await InAppPurchaseConnection.instance.isAvailable();
    if (available) {
      final QueryPurchaseDetailsResponse response =
          await InAppPurchaseConnection.instance.queryPastPurchases();
      if (response.error == null && response.pastPurchases.length > 0) {
        for (var pastPurchase in response.pastPurchases) {
          if (pastPurchase.productID == "com.sandoche.infinideas.premium") {
            saveDarkThemeUnlocked();
            if (Platform.isAndroid) {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: new Text("Dark Theme restored"),
                    actions: <Widget>[
                      FlatButton(
                        child: const Text('Close'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              );
            }
            if (Platform.isIOS &&
                pastPurchase.status == PurchaseStatus.purchased) {
              InAppPurchaseConnection.instance.completePurchase(pastPurchase);
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return CupertinoAlertDialog(
                    title: new Text("Dark Theme restored"),
                    actions: <Widget>[
                      FlatButton(
                        child: const Text('Close'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              );
            }
          }
        }
      }
    }
  }

  void saveDarkThemeUnlocked() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool("darkThemeUnlocked", true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text('About')),
        body: Container(
            margin: const EdgeInsets.all(30.0),
            child: Column(
              children: <Widget>[
                Align(
                  alignment: Alignment.topLeft,
                  child: Text('Infinite feed of ideas 💡',
                      style: getStyleAboutText(isDarkTheme)),
                ),
                Text(''),
                Text(
                    'This app has been built with Flutter for learning purpose (Learning Lab Challenge)',
                    style: getStyleAboutText(isDarkTheme)),
                Text(''),
                Expanded(
                    child: ListView(
                  children: <Widget>[
                    InkWell(
                        onTap: () {
                          _launchURL('https://learn.uno');
                        },
                        child: Container(
                          margin: MARGIN_ABOUT_LINK,
                          child: Text('⚗️ Learning Lab',
                              style: getStyleAboutMenu(isDarkTheme)),
                        )),
                    InkWell(
                        onTap: () {
                          _launchURL('https://infinideas.learn.uno/?contact');
                        },
                        child: Container(
                          margin: MARGIN_ABOUT_LINK,
                          child: Text('💡 Ask for a feature',
                              style: getStyleAboutMenu(isDarkTheme)),
                        )),
                    InkWell(
                        onTap: () {
                          retrieveProducts(context);
                        },
                        child: Container(
                          margin: MARGIN_ABOUT_LINK,
                          child: Text('🔓 Restore Dark Theme Purchase',
                              style: getStyleAboutMenu(isDarkTheme)),
                        )),
                  ],
                ))
              ],
            )));
  }
}
