import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object> get props => [];
}

class ProfileGet extends ProfileEvent {
  ProfileGet();
  @override
  List<Object> get props => [];
}

class ProfileInitiate extends ProfileEvent {
  ProfileInitiate();
  @override
  List<Object> get props => [];
}

class ProfileUpdate extends ProfileEvent {
  ProfileUpdate({this.name, this.avatar, this.counterGoal, this.themeMode});
  final String? name;
  final String? avatar;
  final String? counterGoal;
  final String? themeMode;
  @override
  List<Object> get props => [];
}

class ProfileShowTutorialMark extends ProfileEvent {
  ProfileShowTutorialMark(this.context,
      {required this.buttonKeys,
      required this.tutorialTexts,
      required this.contentAligns,
      this.markFinishTutorial1 = false,
      this.markFinishTutorial2 = false});
  final BuildContext context;
  final List<GlobalKey> buttonKeys;
  final List<String> tutorialTexts;
  final List<ContentAlign> contentAligns;
  final bool markFinishTutorial1;
  final bool markFinishTutorial2;
}

class ProfileDoneWelcomeScreen extends ProfileEvent {
  ProfileDoneWelcomeScreen();
}
