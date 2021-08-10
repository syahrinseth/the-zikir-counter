import 'package:equatable/equatable.dart';

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

class ProfileUpdate extends ProfileEvent {
  ProfileUpdate({required this.name, required this.avatar});
  final String name;
  final String avatar;

  @override
  List<Object> get props => [];
}
