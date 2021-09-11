import 'package:flutter/material.dart';

class TopContainer extends StatelessWidget {
  final double? height;
  final double width;
  final Widget child;
  final EdgeInsets padding;
  final Color? color;
  TopContainer(
      {this.height,
      required this.width,
      required this.child,
      required this.padding,
      this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
          color: color ?? Color(0xff43c59e),
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(40.0),
            bottomLeft: Radius.circular(40.0),
          )),
      height: height,
      width: width,
      child: child,
    );
  }
}
