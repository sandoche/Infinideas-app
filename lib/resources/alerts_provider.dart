import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:async';

import 'package:infinideas/models/premium_handler.dart';

class AlertsProvider {
  BuildContext context;

  AlertsProvider(this.context);

  AlertDialog getAlertForAndroidPremium(PremiumHandler premium, String toUnlock) {
    return AlertDialog(
      title: _getUnlockTitle(toUnlock),
      content: _getUnlockContent(),
      actions: _getUnlockActions(premium),
    );
  }

  CupertinoAlertDialog getAlertForiOSPremium(PremiumHandler premium, String toUnlock) {
    return CupertinoAlertDialog(
      title: _getUnlockTitle(toUnlock),
      content: _getUnlockContent(),
      actions: _getUnlockActions(premium),
    );
  }

  Text _getUnlockTitle(String toUnlock) {
    return Text("Unlock $toUnlock");
  }

  Text _getUnlockContent() {
    return Text(
        "Infinideas is a free app but in order to keep the app up to date we decided to sell the Premium version, that includes Dark Mode and Favorite ideas");
  }

  _getUnlockActions(PremiumHandler premium) {
    return <Widget>[
      FlatButton(
        child: const Text('Cancel'),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      FlatButton(
        child: const Text('Unlock Premium'),
        onPressed: () {
          Navigator.of(context).pop();
          premium.purchaseItem();
        },
      )
    ];
  }
}