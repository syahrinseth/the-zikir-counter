import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_zikir_app/bloc/profile_bloc.dart';
import 'package:the_zikir_app/state/profile_state.dart';
import 'package:the_zikir_app/theme/colors/light_colors.dart';

class DhikrSnackBar {
  static SnackBar setSnackBar(BuildContext context,
      {Key? key, required String message, String colorName = 'green'}) {
    ProfileState profileState = BlocProvider.of<ProfileBloc>(context).state;
    return SnackBar(
      backgroundColor: LightColors.getThemeColor(
          state: profileState,
          colorName: colorName,
          contrast: 'light',
          isBackgroundColor: true),
      content: Text(message,
          style: TextStyle(
            color: LightColors.getThemeColor(
              state: profileState,
              colorName: 'white',
              contrast: 'dark',
            ),
          )),
      // action: SnackBarAction(
      //   label: 'Undo',
      //   onPressed: () {
      //     // Some code to undo the change.
      //   },
      // ),
    );
  }
}
