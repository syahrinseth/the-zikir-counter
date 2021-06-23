import 'package:flutter/material.dart';
import 'package:the_zikir_app/theme/colors/light_colors.dart';

class MyBackButton extends StatelessWidget {
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
            color: Color(0xff3d7068),
          ),
        ),
      ),
    );
  }
}
