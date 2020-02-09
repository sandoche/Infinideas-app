import 'package:flutter/material.dart';
import 'styles.dart';

var lightTheme = new ThemeData(
    appBarTheme: AppBarTheme(
      color: Color(0xff65638f),
    ),
    brightness: Brightness.light,
    accentColor: Colors.blue,
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

getAppBarBrightness(isDarkmode) {
  if(isDarkmode) {
    return Brightness.dark;
  } else {
    return Brightness.light;
  }
}

getMenuIconColor(isDarkmode) {
  if(isDarkmode) {
    return Colors.white;
  } else {
    return COLOR_DARK;
  }
}

getStyleMeta(isDarkmode) {
  if (isDarkmode) {
    return STYLE_METADATA_DARK_THEME;
  } else {
    return STYLE_METADATA_LIGHT_THEME;
  }
}

getAppBarBackground(isDarkmode) {
  if (isDarkmode) {
    return Color(0xff303030);
  } else {
    return COLOR_LIGHT;
  }
}

getMenuTextStyle(isDarkmode) {
  if(isDarkmode) {
    return STYLE_TEXT_DARK_THEME;
  } else {
    return COLOR_PRIMARY;
  }
}

getTextStyle(isDarkmode) {
  if(isDarkmode) {
    return STYLE_APP_TITLE_DARK_THEME;
  } else {
    return STYLE_APP_TITLE_LIGHT_THEME;
  }
}

getStyleAboutText(isDarkmode) {
  if(isDarkmode) {
    return STYLE_TEXT_DARK_THEME;
  } else {
    return STYLE_TEXT_LIGHT_THEME;
  }
}

getStyleAboutMenu(isDarkmode) {
  if(isDarkmode) {
    return STYLE_ABOUT_TEXT_DARK_THEME;
  } else {
    return STYLE_ABOUT_TEXT_LIGHT_THEME;
  }
}