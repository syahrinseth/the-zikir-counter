import 'package:flutter/material.dart';
import 'package:the_zikir_app/theme/colors/light_colors.dart';

class TaskColumn extends StatelessWidget {
  final IconData icon;
  final Color iconBackgroundColor;
  final String title;
  final String subtitle;
  final IconData? tailingIcon;
  TaskColumn(
      {required this.icon,
      required this.iconBackgroundColor,
      required this.title,
      required this.subtitle,
      this.tailingIcon});
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Row(
          children: [
            CircleAvatar(
              radius: 20.0,
              backgroundColor: iconBackgroundColor,
              child: Icon(
                icon,
                size: 15.0,
                color: Colors.white,
              ),
            ),
            SizedBox(width: 10.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.w500,
                      color: Colors.black45),
                ),
              ],
            ),
          ],
        ),
        Icon(
          tailingIcon,
          color: LightColors.kGreen,
        )
      ],
    );
  }
}
