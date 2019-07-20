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
            backgroundColor: getAppBarBackground(isDarkTheme)),
        body: Container(
            margin: const EdgeInsets.all(10.0),
            child: Column(
              children: <Widget>[
                const Text('Infinite feed of ideas 💡'),
                const Text(
                    'This app has been built with Flutter for learning purpose (Learning Lab Challenge)'),
                Expanded(
                        child: ListView(
                          padding: const EdgeInsets.all(8.0),
                          children: <Widget>[
                            Container(
                              height: 50,
                              child: const Text('Entry A'),
                            ),
                            Container(
                              height: 50,
                              child: const Text('Entry A'),
                            ),
                            Container(
                              height: 50,
                              child: const Text('Entry A'),
                            ),
                          ],
                        ))
              ],
            )));
  }
}
