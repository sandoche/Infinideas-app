import 'package:flutter/material.dart';

var lightTheme = new ThemeData(
    brightness: Brightness.light
);

var darkTheme = new ThemeData(
    brightness: Brightness.dark
);

getSliverAppBarBackground(isDarkmode) {
  if(isDarkmode) {
    return Color(0xff303030);
  } else {
    return Colors.white10;
  }
}
