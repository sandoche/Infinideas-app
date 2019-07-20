import 'package:flutter/material.dart';
import 'themes.dart';

class About extends StatelessWidget {

  final bool isDarkTheme;

  About({Key key, @required this.isDarkTheme}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About'),
        backgroundColor: getAppBarBackground(isDarkTheme)
      ),
      body: Center(
        child: RaisedButton(
          onPressed: () {
            // Navigate back to first route when tapped.
          },
          child: Text('Back'),
        ),
      ),
    );
  }
}