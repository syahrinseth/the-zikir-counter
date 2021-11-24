import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:the_zikir_app/state/profile_state.dart';
import 'package:the_zikir_app/theme/colors/light_colors.dart';

class AvatarPicker extends StatefulWidget {
  AvatarPicker({required this.controller, required this.profileState});
  final TextEditingController controller;
  final ProfileState profileState;

  @override
  _AvatarPicker createState() => _AvatarPicker();
}

class _AvatarPicker extends State<AvatarPicker> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              'Avatar',
              style: TextStyle(
                color: LightColors.getThemeColor(
                    state: widget.profileState,
                    colorName: 'black',
                    contrast: 'light'),
              ),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    widget.controller.value = TextEditingValue(text: 'male');
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Container(
                      decoration: BoxDecoration(
                          color: widget.controller.text == 'male'
                              ? LightColors.getThemeColor(
                                  state: widget.profileState,
                                  isBackgroundColor: true,
                                  colorName: 'green',
                                  contrast: 'dark')
                              : LightColors.getThemeColor(
                                  state: widget.profileState,
                                  isBackgroundColor: true,
                                  colorName: 'yellow',
                                  contrast: 'light'),
                          borderRadius: BorderRadius.circular(5.0)),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: CircleAvatar(
                            backgroundColor: widget.controller.text == 'male'
                                ? LightColors.getThemeColor(
                                    state: widget.profileState,
                                    isBackgroundColor: true,
                                    colorName: 'green',
                                    contrast: 'dark')
                                : LightColors.getThemeColor(
                                    state: widget.profileState,
                                    isBackgroundColor: true,
                                    colorName: 'yellow',
                                    contrast: 'light'),
                            radius: 35.0,
                            child: SvgPicture.asset('assets/svgs/man.svg'),
                          ),
                        ),
                      )),
                ),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    widget.controller.value = TextEditingValue(text: 'female');
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Container(
                      decoration: BoxDecoration(
                          color: widget.controller.text == 'female'
                              ? LightColors.getThemeColor(
                                  state: widget.profileState,
                                  isBackgroundColor: true,
                                  colorName: 'green',
                                  contrast: 'dark')
                              : LightColors.getThemeColor(
                                  state: widget.profileState,
                                  isBackgroundColor: true,
                                  colorName: 'yellow',
                                  contrast: 'light'),
                          borderRadius: BorderRadius.circular(5.0)),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: CircleAvatar(
                              backgroundColor:
                                  widget.controller.text == 'female'
                                      ? LightColors.getThemeColor(
                                          state: widget.profileState,
                                          isBackgroundColor: true,
                                          colorName: 'green',
                                          contrast: 'dark')
                                      : LightColors.getThemeColor(
                                          state: widget.profileState,
                                          isBackgroundColor: true,
                                          colorName: 'yellow',
                                          contrast: 'light'),
                              radius: 35.0,
                              // backgroundImage: AssetImage(
                              //   'assets/images/avatar.png',
                              // ),
                              child: SvgPicture.asset('assets/svgs/woman.svg',
                                  semanticsLabel: 'A red up arrow')),
                        ),
                      )),
                ),
              ),
            )
          ],
        )
      ],
    );
  }
}
