import 'package:flutter/material.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'ideas_feed.dart';
import 'themes.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new DynamicTheme(
        defaultBrightness: Brightness.light,
        data: (brightness) => lightTheme,
        themedWidgetBuilder: (context, theme) {
          return MaterialApp(
            title: 'Infinideas',
            theme: theme,
            home: IdeasFeed(title: 'Infinideas')
          );
        }
    );
  }
}
