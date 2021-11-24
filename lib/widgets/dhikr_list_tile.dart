import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:the_zikir_app/state/profile_state.dart';
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
      this.dateTime,
      this.backgroundColor,
      this.profileState});

  final Function()? onTap;
  final IconData? icon;
  final Color? iconColor;
  final String title;
  final String subtitle;
  final DateTime? dateTime;
  final IconData? tailingIcon;
  final Color? backgroundColor;
  final ProfileState? profileState;

  Widget build(BuildContext context) {
    return Column(children: [
      SizedBox(height: 15.0),
      GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: backgroundColor ??
                  LightColors.getThemeColor(
                    state: profileState,
                    colorName: 'green',
                    contrast: 'super-light',
                    isBackgroundColor: true,
                  )),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TaskColumn(
              profileState: profileState,
              icon: icon ?? LineIcons.user,
              iconBackgroundColor: iconColor ??
                  LightColors.getThemeColor(
                    state: profileState,
                    colorName: 'green',
                    contrast: 'dark',
                  ),
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
