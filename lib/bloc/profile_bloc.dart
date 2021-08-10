import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:the_zikir_app/event/profile_event.dart';
import 'package:the_zikir_app/state/profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(ProfileInit());

  @override
  Stream<ProfileState> mapEventToState(ProfileEvent event) async* {
    if (event is ProfileGet) {
      try {
        yield ProfileLoading();
        Box<String> profileBox = Hive.box<String>('myProfileBox');
        String name = profileBox.get('name') ?? 'Smart Dhikr';
        String avatar = profileBox.get('avatar') ?? 'male';
        yield ProfileLoaded(name: name, avatar: avatar);
      } catch (e) {
        yield ProfileError(message: e.toString());
      }
    }
    if (event is ProfileUpdate) {
      try {
        yield ProfileLoading();
        Box<String> profileBox = Hive.box<String>('myProfileBox');
        profileBox.put('name', event.name);
        profileBox.put('avatar', event.avatar);
        yield ProfileSaved(name: event.name, avatar: event.avatar);
        // yield ProfileLoaded(name: event.name, avatar: event.avatar);
      } catch (e) {
        yield ProfileError(message: e.toString());
      }
    }
  }
}
