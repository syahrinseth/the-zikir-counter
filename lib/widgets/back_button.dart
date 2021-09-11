import 'package:flutter/material.dart';

class MyBackButton extends StatelessWidget {
  final Color? color;
  MyBackButton({this.color});
  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'backButton',
      child: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Align(
          alignment: Alignment.centerLeft,
          child: Icon(
            Icons.arrow_back_ios,
            size: 25,
            color: color ?? Color(0xff3d7068),
          ),
        ),
      ),
    );
  }
}
