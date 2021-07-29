import 'package:flutter/material.dart';

class LightColors {
  static const Color kLightYellow = Color(0xFFFFF9EC);
  static const Color kLightYellow2 = Color(0xFFFFE4C7);
  static const Color kDarkYellow = Color(0xFFF9BE7C);
  static const Color kPalePink = Color(0xFFFED4D6);

  static const Color kRed = Color(0xFFE46472);
  static const Color kLavender = Color(0xFFD5E4FE);
  static const Color kBlue = Color(0xFF6488E4);
  static const Color kLightGreen = Color(0xFFD9E6DC);
  static const Color kGreen = Color(0xFF309397);

  static const Color kDarkBlue = Color(0xFF0D253F);

  static Color getThemeColor({String? colorName, String? contrast = 'light'}) {
    if (colorName == 'green') {
      if (contrast == 'light') {
        return Color(0xff43c59e);
      }
      return Color(0xff3d7068);
    } else if (colorName == 'red') {
      if (contrast == 'light') {
        return Color(0xFFD98880);
      }
      return Color(0xFF8B0000);
    } else if (colorName == 'blue') {
      if (contrast == 'light') {
        return Color(0xFFA9CCE3);
      }
      return Color(0xFF2980B9);
    }
    return Color(0xff3d7068);
  }
}
