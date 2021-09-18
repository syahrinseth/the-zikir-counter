import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final String label;
  final int maxLines;
  final int minLines;
  final Icon? icon;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  MyTextField(
      {required this.label,
      this.maxLines = 1,
      this.minLines = 1,
      this.icon,
      this.controller,
      this.keyboardType,
      this.textInputAction = TextInputAction.done});

  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: keyboardType,
      style: TextStyle(color: Colors.black87),
      minLines: minLines,
      maxLines: maxLines,
      controller: controller,
      textInputAction: textInputAction,
      decoration: InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.always,
          suffixIcon: icon == null ? null : icon,
          labelText: label,
          labelStyle: TextStyle(color: Colors.black45),
          focusedBorder:
              UnderlineInputBorder(borderSide: BorderSide(color: Colors.black)),
          border:
              UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey))),
    );
  }
}
