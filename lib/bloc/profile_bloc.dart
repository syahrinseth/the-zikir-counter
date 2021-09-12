import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:the_zikir_app/event/profile_event.dart';
import 'package:the_zikir_app/state/profile_state.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

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
        String isDoneTutorial1 = profileBox.get('is_done_tutorial_1') ?? 'no';
        String isDoneTutorial2 = profileBox.get('is_done_tutorial_2') ?? 'no';
        String isDoneWelcomeScreen =
            profileBox.get('is_done_welcome_screen') ?? 'no';
        yield ProfileLoaded(
            name: name,
            avatar: avatar,
            isDoneTutorial1: isDoneTutorial1,
            isDoneTutorial2: isDoneTutorial2,
            isDoneWelcomeScreen: isDoneWelcomeScreen);
      } catch (e) {
        yield ProfileError(message: e.toString());
      }
    }
    if (event is ProfileDoneWelcomeScreen) {
      try {
        Box<String> profileBox = Hive.box<String>('myProfileBox');
        profileBox.put('is_done_welcome_screen', 'yes');
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
    if (event is ProfileShowTutorialMark) {
      try {
        ProfileState tempState = this.state;
        yield (ProfileLoading(
            name: tempState is ProfileLoaded ? tempState.name : null,
            avatar: tempState is ProfileLoaded ? tempState.avatar : null));
        List<TargetFocus> targets = initTargets(
            event.buttonKeys, event.tutorialTexts, event.contentAligns);
        TutorialCoachMark(
          event.context,
          targets: targets,
          colorShadow: Color(0xff3d7068),
          textSkip: "SKIP",
          paddingFocus: 10,
          opacityShadow: 0.8,
          onFinish: () {
            if (event.markFinishTutorial1 == true) {
              Box<String> profileBox = Hive.box<String>('myProfileBox');
              profileBox.put('is_done_tutorial_1', 'yes');
            }
            if (event.markFinishTutorial2 == true) {
              Box<String> profileBox = Hive.box<String>('myProfileBox');
              profileBox.put('is_done_tutorial_2', 'yes');
            }
            print("finish");
          },
          onClickTarget: (target) {
            print('onClickTarget: $target');
          },
          onSkip: () {
            if (event.markFinishTutorial1 == true) {
              Box<String> profileBox = Hive.box<String>('myProfileBox');
              profileBox.put('is_done_tutorial_1', 'yes');
            }
            if (event.markFinishTutorial2 == true) {
              Box<String> profileBox = Hive.box<String>('myProfileBox');
              profileBox.put('is_done_tutorial_2', 'yes');
            }
            print("skip");
          },
          onClickOverlay: (target) {
            print('onClickOverlay: $target');
          },
        )..show();
        yield (ProfileLoaded(
            name: tempState is ProfileLoaded ? tempState.name : null,
            avatar: tempState is ProfileLoaded ? tempState.avatar : null));
      } catch (e) {
        yield ProfileError(message: e.toString());
      }
    }
  }

  List<TargetFocus> initTargets(List<GlobalKey> buttonKeys,
      List<String> tutorialTexts, List<ContentAlign> contentAligns) {
    List<TargetFocus> targets = [];
    for (var i = 0; i < buttonKeys.length; i++) {
      targets.add(TargetFocus(
        enableOverlayTab: true,
        enableTargetTab: true,
        identify: "keyButton" + buttonKeys[i].toString(),
        keyTarget: buttonKeys[i],
        alignSkip: Alignment.topRight,
        contents: [
          TargetContent(
            align: contentAligns[i],
            builder: (context, controller) {
              return Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      tutorialTexts[i],
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ));
    }
    return targets;
  }
}
