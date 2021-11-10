import 'package:flutter/material.dart';
import 'package:the_zikir_app/theme/colors/light_colors.dart';
import 'package:timeago/timeago.dart' as timeago;

class TaskColumn extends StatelessWidget {
  final IconData icon;
  final Color iconBackgroundColor;
  final String title;
  final String subtitle;
  final IconData? tailingIcon;
  final DateTime? dateTime;
  TaskColumn(
      {required this.icon,
      required this.iconBackgroundColor,
      required this.title,
      required this.subtitle,
      this.dateTime,
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
                ConstrainedBox(
                  constraints: BoxConstraints(minWidth: 150, maxWidth: 150),
                  child: Text(
                    title,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    softWrap: true,
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                ConstrainedBox(
                  constraints: BoxConstraints(minWidth: 150, maxWidth: 150),
                  child: Text(
                    subtitle,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    softWrap: true,
                    style: TextStyle(
                        fontSize: 12.0,
                        fontWeight: FontWeight.w500,
                        color: Colors.black45),
                  ),
                ),
              ],
            ),
          ],
        ),
        ConstrainedBox(
          constraints: BoxConstraints(minWidth: 10, maxWidth: 80),
          child: Text(
            dateTime == null
                ? ''
                : (timeago.format(dateTime ?? DateTime.now())[0].toUpperCase() +
                    timeago.format(dateTime ?? DateTime.now()).substring(1)),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            softWrap: true,
            style: TextStyle(
              fontSize: 10.0,
              color: Colors.black45,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        tailingIcon == null
            ? SizedBox()
            : Icon(
                tailingIcon,
                color: LightColors.kGreen,
              )
      ],
    );
  }
}
