import 'package:flutter/material.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'ideas_feed.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new DynamicTheme(
        defaultBrightness: Brightness.light,
        data: (brightness) => new ThemeData(
          brightness: brightness
        ),
        themedWidgetBuilder: (context, theme) {
          return MaterialApp(
            title: 'Infinidea',
            theme: theme,
            home: IdeasFeed(title: 'Infinidea')
          );
        }
    );
  }
}

