import 'package:equatable/equatable.dart';

abstract class ProfileState extends Equatable {
  ProfileState([List props = const []]) : super();
}

class ProfileLoading extends ProfileState {
  final String? name;
  final String? avatar;
  final String? counterGoal;
  final String? themeMode;
  final List props = [];
  ProfileLoading({this.name, this.avatar, this.counterGoal, this.themeMode});
}

class ProfileInit extends ProfileState {
  final List props = [];
  final String? name;
  final String? avatar;
  final String? isDoneTutorial1;
  final String? isDoneTutorial2;
  final String? isDoneWelcomeScreen;
  final String? counterGoal;
  final String? themeMode;
  ProfileInit(
      {this.name,
      this.avatar,
      this.isDoneTutorial1,
      this.isDoneTutorial2,
      this.isDoneWelcomeScreen,
      this.counterGoal,
      this.themeMode});
}

class ProfileLoaded extends ProfileState {
  final String? name;
  final String? avatar;
  final List props = [];
  final String? isDoneTutorial1;
  final String? isDoneTutorial2;
  final String? isDoneWelcomeScreen;
  final String? counterGoal;
  final String? themeMode;
  ProfileLoaded(
      {this.name,
      this.avatar,
      this.isDoneTutorial1,
      this.isDoneTutorial2,
      this.isDoneWelcomeScreen,
      this.counterGoal,
      this.themeMode});
}

class ProfileSaved extends ProfileState {
  final String? name;
  final String? avatar;
  final String? counterGoal;
  final String? themeMode;
  final List props = [];
  ProfileSaved({this.name, this.avatar, this.counterGoal, this.themeMode});
}

class ProfileError extends ProfileState {
  final String? message;
  final List props = [];
  ProfileError({this.message});
}
