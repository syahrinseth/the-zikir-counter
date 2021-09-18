import 'package:equatable/equatable.dart';

abstract class ProfileState extends Equatable {
  ProfileState([List props = const []]) : super();
}

class ProfileLoading extends ProfileState {
  final String? name;
  final String? avatar;
  final String? counterGoal;
  final List props = [];
  ProfileLoading({this.name, this.avatar, this.counterGoal});
}

class ProfileInit extends ProfileState {
  final List props = [];
  final String? name;
  final String? avatar;
  final String? isDoneTutorial1;
  final String? isDoneTutorial2;
  final String? isDoneWelcomeScreen;
  final String? counterGoal;
  ProfileInit(
      {this.name,
      this.avatar,
      this.isDoneTutorial1,
      this.isDoneTutorial2,
      this.isDoneWelcomeScreen,
      this.counterGoal});
}

class ProfileLoaded extends ProfileState {
  final String? name;
  final String? avatar;
  final List props = [];
  final String? isDoneTutorial1;
  final String? isDoneTutorial2;
  final String? isDoneWelcomeScreen;
  final String? counterGoal;
  ProfileLoaded(
      {this.name,
      this.avatar,
      this.isDoneTutorial1,
      this.isDoneTutorial2,
      this.isDoneWelcomeScreen,
      this.counterGoal});
}

class ProfileSaved extends ProfileState {
  final String? name;
  final String? avatar;
  final String? counterGoal;
  final List props = [];
  ProfileSaved({this.name, this.avatar, this.counterGoal});
}

class ProfileError extends ProfileState {
  final String? message;
  final List props = [];
  ProfileError({this.message});
}
