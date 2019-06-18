import 'package:flutter/material.dart';

const COLOR_LIGHT = Color(0xff65638f);
const COLOR_DARK = Color(0xff000000);

const BACKGROUND_TAG_LOW = Color(0xfffab95b);
const BACKGROUND_TAG_MEDIUM = Color(0xff2f89fc);
const BACKGROUND_TAG_HIGH = Color(0xffc6e377);

const STYLE_TEXT_TAG = TextStyle(
  fontSize: 8.0,
  color: Colors.white,
  fontWeight: FontWeight.w700
);

const STYLE_TITLES = TextStyle(
  fontSize: 22.0,
  fontWeight: FontWeight.w900
);

const STYLE_METADATA = TextStyle(
  color: COLOR_LIGHT
);

const STYLE_APP_TITLE_LIGHT_THEME = TextStyle(
  color: COLOR_DARK,
  fontSize: 24.0,
  fontWeight: FontWeight.w900
);

const STYLE_APP_TITLE_DARK_THEME = TextStyle(
  color: Colors.white,
  fontSize: 24.0,
  fontWeight: FontWeight.w900
);

getLabelBackgroundColor(count) {
  var result = BACKGROUND_TAG_LOW;
  if(count <= 10 && count > 0) {
    result = BACKGROUND_TAG_MEDIUM;
  } else if (count > 10) {
    result = BACKGROUND_TAG_HIGH;
  }
  return result;
}

getSliverAppBarTitleStyle(isDarkmode) {
  if(isDarkmode) {
    return STYLE_APP_TITLE_DARK_THEME;
  } else {
    return STYLE_APP_TITLE_LIGHT_THEME;
  }
}