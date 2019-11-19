import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:async';

import 'package:infinideas/models/premium_handler.dart';

class AlertsProvider {
  BuildContext context;

  AlertsProvider(this.context);

  AlertDialog getAlertForAndroidPremium(PremiumHandler primium, String toUnlock) {
    return AlertDialog(
      title: _getUnlockTitle(toUnlock),
      content: _getUnlockContent(),
      actions: _getUnlockActions(primium),
    );
  }

  CupertinoAlertDialog getAlertForiOSPremium(PremiumHandler primium, String toUnlock) {
    return CupertinoAlertDialog(
      title: _getUnlockTitle(toUnlock),
      content: _getUnlockContent(),
      actions: _getUnlockActions(primium),
    );
  }

  Text _getUnlockTitle(String toUnlock) {
    return Text("Unlock $toUnlock");
  }

  Text _getUnlockContent() {
    return Text(
        "Infinideas is a free app but in order to keep the app up to date we decided to sell the Premium version, that includes Dark Mode and Favorite ideas");
  }

  _getUnlockActions(PremiumHandler primium) {
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
          primium.purchaseItem();
        },
      )
    ];
  }
}