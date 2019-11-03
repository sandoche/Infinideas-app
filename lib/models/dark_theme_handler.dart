import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:infinideas/themes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DarkTheme {

  BuildContext context;

  DarkTheme(this.context);

  bool isDarkTheme() {
    return Theme.of(context).brightness == Brightness.dark;
  }

  void saveDefaultTheme(bool isDarkTheme) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool("isDefaultThemeDark", isDarkTheme);
  }

  void switchTheme() {
    saveDefaultTheme(!isDarkTheme());
    DynamicTheme.of(context)
        .setThemeData(isDarkTheme() ? lightTheme : darkTheme);
  }

  setDefaultTheme() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    bool isDefaultThemeDark =
    sharedPreferences.getBool("isDefaultThemeDark") == null
        ? false
        : sharedPreferences.getBool("isDefaultThemeDark");
    ThemeData defaultTheme = isDefaultThemeDark ? darkTheme : lightTheme;
    DynamicTheme.of(context).setThemeData(defaultTheme);
  }
}