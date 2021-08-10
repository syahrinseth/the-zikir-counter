import 'package:equatable/equatable.dart';

abstract class ProfileState extends Equatable {
  ProfileState([List props = const []]) : super();
}

class ProfileLoading extends ProfileState {
  final String? name;
  final String? avatar;
  final List props = [];
  ProfileLoading({this.name, this.avatar});
}

class ProfileInit extends ProfileState {
  final List props = [];
  ProfileInit();
}

class ProfileLoaded extends ProfileState {
  final String? name;
  final String? avatar;
  final List props = [];
  ProfileLoaded({this.name, this.avatar});
}

class ProfileSaved extends ProfileState {
  final String? name;
  final String? avatar;
  final List props = [];
  ProfileSaved({this.name, this.avatar});
}

class ProfileError extends ProfileState {
  final String? message;
  final List props = [];
  ProfileError({this.message});
}
