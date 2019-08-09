import 'package:flutter/material.dart';
import 'package:connectivity/connectivity.dart';
import 'dart:async' show Future;


Future<bool> isConnectionActivated(context) async {
  var connectivityResult = await (Connectivity().checkConnectivity());
  return !(connectivityResult != ConnectivityResult.mobile && connectivityResult != ConnectivityResult.wifi);
}

Future<void> displayAlertWhenNoConnection(context) async {
  var connected = await isConnectionActivated(context);
  if(!connected) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('No network'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Please enable your wifi or your network connection'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Got it !'),
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