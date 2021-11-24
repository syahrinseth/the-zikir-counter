import 'package:flutter/material.dart';
import 'package:the_zikir_app/state/profile_state.dart';

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
  static const Color kDhikrGreen = Color(0xff43c59e);

  static const Color bgLightGreen = Color(0xff43c59e);
  static const Color bgLightGreenDark = Color(0xFF212121);
  static const Color bgDarkGreen = Color(0xff3d7068);
  static const Color bgDarkGreenDark = Colors.black87;
  static const Color bgSuperLightGreen = Color(0xFFD9E6DC);
  static const Color bgSuperLightGreenDark = Color(0xFF3b3a3a);
  static const Color bgLightYellow = Color(0xFFFFF9EC);
  static const Color bgLightYellowDark = Color(0xFF212121);
  static const Color bgDarkYellow = Color(0xFFF9BE7C);
  static const Color bgDarkYellowDark = Colors.black87;
  static const Color bgLightRed = Color(0xFFD98880);
  static const Color bgLightRedDark = Color(0xFF212121);
  static const Color bgDarkRed = Color(0xFF8B0000);
  static const Color bgDarkRedDark = Colors.black87;
  static const Color bgLightBlue = Color(0xFFA9CCE3);
  static const Color bgLightBlueDark = Color(0xFF212121);
  static const Color bgDarkBlue = Color(0xFF2980B9);
  static const Color bgDarkBlueDark = Colors.black87;

  static const Color txtLightGreen = Color(0xff43c59e);
  static const Color txtLightGreenDark = Colors.white70;
  static const Color txtDarkGreen = Color(0xff3d7068);
  static const Color txtDarkGreenDark = Colors.white70;
  static const Color txtSuperLightGreen = Color(0xFFD9E6DC);
  static const Color txtSuperLightGreenDark = Colors.white70;
  static const Color txtLightYellow = Color(0xFFFFF9EC);
  static const Color txtLightYellowDark = Colors.white70;
  static const Color txtDarkYellow = Color(0xFFF9BE7C);
  static const Color txtDarkYellowDark = Colors.white70;
  static const Color txtLightRed = Color(0xFFD98880);
  static const Color txtLightRedDark = Colors.white70;
  static const Color txtDarkRed = Color(0xFF8B0000);
  static const Color txtDarkRedDark = Colors.white70;
  static const Color txtLightBlue = Color(0xFFA9CCE3);
  static const Color txtLightBlueDark = Colors.white70;
  static const Color txtDarkBlue = Color(0xFF2980B9);
  static const Color txtDarkBlueDark = Colors.white70;
  static const Color txtDarkBlack = Colors.black;
  static const Color txtDarkBlackDark = Colors.white70;
  static const Color txtLightBlack = Color(0xFF212121);
  static const Color txtLightBlackDark = Colors.white70;
  static const Color txtDarkWhite = Colors.white;
  static const Color txtDarkWhiteDark = Colors.white70;
  static const Color txtLightWhite = Colors.white70;
  static const Color txtLightWhiteDark = Colors.white70;

  static Color getThemeColor(
      {String? colorName,
      String? contrast = 'light',
      bool isBackgroundColor = false,
      ProfileState? state}) {
    if (colorName == 'green') {
      if (contrast == 'light') {
        if (isDarkMode(state)) {
          return isBackgroundColor ? bgLightGreenDark : txtLightGreenDark;
        }
        return isBackgroundColor ? bgLightGreen : txtLightGreen;
      } else if (contrast == 'super-light') {
        if (isDarkMode(state)) {
          return isBackgroundColor
              ? bgSuperLightGreenDark
              : txtSuperLightGreenDark;
        }
        return isBackgroundColor ? bgSuperLightGreen : txtSuperLightGreen;
      }
      if (isDarkMode(state)) {
        return isBackgroundColor ? bgDarkGreenDark : txtDarkGreenDark;
      }
      return isBackgroundColor ? bgDarkGreen : txtDarkGreen;
    } else if (colorName == 'red') {
      if (contrast == 'light') {
        if (isDarkMode(state)) {
          return isBackgroundColor ? bgLightRedDark : txtLightRedDark;
        }
        return isBackgroundColor ? bgLightRed : txtLightRed;
      }
      if (isDarkMode(state)) {
        return isBackgroundColor ? bgDarkRedDark : txtDarkRedDark;
      }
      return isBackgroundColor ? bgDarkRed : txtDarkRed;
    } else if (colorName == 'blue') {
      if (contrast == 'light') {
        if (isDarkMode(state)) {
          return isBackgroundColor ? bgLightBlueDark : txtLightBlueDark;
        }
        return isBackgroundColor ? bgLightBlue : txtLightBlue;
      }
      if (isDarkMode(state)) {
        return isBackgroundColor ? bgDarkBlueDark : txtDarkBlueDark;
      }
      return isBackgroundColor ? bgDarkBlue : txtDarkBlue;
    } else if (colorName == 'yellow') {
      if (contrast == 'light') {
        if (isDarkMode(state)) {
          return isBackgroundColor ? bgLightYellowDark : txtLightYellowDark;
        }
        return isBackgroundColor ? bgLightYellow : txtLightYellow;
      }
      if (isDarkMode(state)) {
        return isBackgroundColor ? bgDarkYellowDark : txtDarkYellowDark;
      }
      return isBackgroundColor ? bgDarkYellow : txtDarkYellow;
    } else if (colorName == 'black') {
      if (contrast == 'light') {
        if (isDarkMode(state)) {
          return txtLightBlackDark;
        }
        return txtLightBlack;
      }
      if (isDarkMode(state)) {
        return txtDarkBlackDark;
      }
      return txtDarkBlack;
    } else if (colorName == 'white') {
      if (contrast == 'light') {
        if (isDarkMode(state)) {
          return txtLightWhiteDark;
        }
        return txtLightWhite;
      }
      if (isDarkMode(state)) {
        return txtDarkWhiteDark;
      }
      return txtDarkWhite;
    }
    if (isDarkMode(state)) {
      return isBackgroundColor ? bgDarkGreenDark : txtDarkGreenDark;
    }
    return isBackgroundColor ? bgDarkGreen : txtDarkGreen;
  }

  static bool isDarkMode(ProfileState? state) {
    if (state is ProfileLoaded) {
      if (state.themeMode == 'dark') {
        return true;
      }
    }
    if (state is ProfileSaved) {
      if (state.themeMode == 'dark') {
        return true;
      }
    }
    return false;
  }

  // static Color setBackgroundColor(BuildContext context,
  //     {required ProfileState state}) {
  //   if (state is ProfileLoaded) {
  //     final ThemeData mode = Theme.of(context);
  //     var whichMode = mode.brightness;
  //     print("which mode $whichMode");
  //     if (state.themeMode == 'system') {
  //     } else if (state.themeMode == 'light') {
  //     } else {}
  //   }
  //   // parentProfileBloc is ProfileLoaded
  //   //                       ? parentProfileBloc.themeMode == 'system'
  //   //                 ? ThemeMode.system
  //   //                 : (parentProfileBloc.themeMode == 'dark'
  //   //                     ? ThemeMode.dark
  //   //                     : ThemeMode.light))
  //   //                       : Color(0xff43c59e)

  //   return Color(0xff43c59e);
  // }
}
