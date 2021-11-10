import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:the_zikir_app/theme/colors/light_colors.dart';
import 'package:the_zikir_app/widgets/task_column.dart';

class DhikrListTile extends StatelessWidget {
  DhikrListTile(
      {this.icon,
      this.iconColor,
      this.onTap,
      required this.subtitle,
      required this.title,
      this.tailingIcon,
      this.dateTime});

  final Function()? onTap;
  final IconData? icon;
  final Color? iconColor;
  final String title;
  final String subtitle;
  final DateTime? dateTime;
  final IconData? tailingIcon;

  Widget build(BuildContext context) {
    return Column(children: [
      SizedBox(height: 15.0),
      GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: LightColors.kLightGreen),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TaskColumn(
              icon: icon ?? LineIcons.user,
              iconBackgroundColor: iconColor ??
                  LightColors.getThemeColor(
                      colorName: 'green', contrast: 'dark'),
              title: title,
              subtitle: subtitle,
              tailingIcon: tailingIcon,
              dateTime: dateTime,
            ),
          ),
        ),
      ),
    ]);
  }
}
