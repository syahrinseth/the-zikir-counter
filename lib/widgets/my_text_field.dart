import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_zikir_app/bloc/profile_bloc.dart';
import 'package:the_zikir_app/state/profile_state.dart';
import 'package:the_zikir_app/theme/colors/light_colors.dart';

class MyTextField extends StatelessWidget {
  final String label;
  final int maxLines;
  final int minLines;
  final Icon? icon;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final Function()? onTap;
  final bool? enabled;
  MyTextField(
      {required this.label,
      this.maxLines = 1,
      this.minLines = 1,
      this.icon,
      this.controller,
      this.keyboardType,
      this.enabled = true,
      this.onTap,
      this.textInputAction = TextInputAction.done});

  @override
  Widget build(BuildContext context) {
    ProfileState parentState = BlocProvider.of<ProfileBloc>(context).state;
    return TextField(
      onTap: onTap,
      enabled: enabled,
      keyboardType: keyboardType,
      style: TextStyle(
        color: LightColors.getThemeColor(
          state: parentState,
          colorName: 'black',
          contrast: 'dark',
        ),
      ),
      minLines: minLines,
      maxLines: maxLines,
      controller: controller,
      textInputAction: textInputAction,
      decoration: InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.always,
          suffixIcon: icon == null ? null : icon,
          labelText: label,
          labelStyle: TextStyle(
            color: LightColors.getThemeColor(
              state: parentState,
              colorName: 'black',
              contrast: 'dark',
            ),
          ),
          focusedBorder:
              UnderlineInputBorder(borderSide: BorderSide(color: Colors.black)),
          border:
              UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey))),
    );
  }
}
