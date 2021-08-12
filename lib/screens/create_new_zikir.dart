import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:line_icons/line_icons.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:the_zikir_app/bloc/counter_bloc.dart';
import 'package:the_zikir_app/bloc/profile_bloc.dart';
import 'package:the_zikir_app/data/models/counter.dart';
import 'package:the_zikir_app/event/counter_event.dart';
import 'package:the_zikir_app/event/profile_event.dart';
import 'package:the_zikir_app/screens/edit_zikir_counter.dart';
import 'package:the_zikir_app/state/counter_state.dart';
import 'package:the_zikir_app/state/profile_state.dart';
import 'package:the_zikir_app/theme/colors/light_colors.dart';
import 'package:the_zikir_app/widgets/back_button.dart';
import 'package:the_zikir_app/widgets/top_container.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class CreateNewZikirCounter extends StatefulWidget {
  CreateNewZikirCounter();

  @override
  _CreateNewZikirCounter createState() => _CreateNewZikirCounter();
}

class _CreateNewZikirCounter extends State<CreateNewZikirCounter> {
  CounterBloc counterBloc = CounterBloc();
  ProfileBloc profileBloc = ProfileBloc();
  List<GlobalKey> buttonKeys = [GlobalKey(), GlobalKey()];
  List<String> tutorialTexts = [
    'Tap on this section to start count your dhikir.',
    'Tap this button to edit your dhikr counter.'
  ];
  List<ContentAlign> tutorialTextAligns = [
    ContentAlign.top,
    ContentAlign.bottom,
  ];

  @override
  void initState() {
    // TODO: implement initState
    counterBloc.add(CounterCreate());
    profileBloc.add(ProfileGet());
    super.initState();
  }

  @override
  void dispose() async {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: BlocConsumer<CounterBloc, CounterState>(
          bloc: counterBloc,
          listener: (context, state) {
            // TODO: implement listener
            if (state is CounterError) {
              print(state.message);
            }
          },
          builder: (context, state) {
            if (state is CounterInit) {
              return Text('Loading');
            }
            if (state is CounterLoaded) {
              return BlocBuilder<ProfileBloc, ProfileState>(
                bloc: profileBloc,
                builder: (context, profileState) {
                  if (profileState is ProfileLoaded) {
                    if (profileState.isDoneTutorial == 'no') {
                      Future.delayed(Duration(seconds: 1), () {
                        profileBloc.add(ProfileShowTutorialMark(context,
                            buttonKeys: buttonKeys,
                            tutorialTexts: tutorialTexts,
                            contentAligns: tutorialTextAligns,
                            markFinishTutorial: true));
                      });
                    }
                  }
                  return Column(
                    children: <Widget>[
                      TopContainer(
                        color: LightColors.getThemeColor(
                            colorName: state.counter?.counterTheme,
                            contrast: 'light'),
                        padding: EdgeInsets.fromLTRB(20, 20, 20, 40),
                        width: width,
                        child: Column(
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                MyBackButton(
                                    color: LightColors.getThemeColor(
                                        colorName: state.counter?.counterTheme,
                                        contrast: 'dark')),
                                GestureDetector(
                                  key: buttonKeys[1],
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              EditZikirCounter(
                                                  counter: state.counter ??
                                                      Counter.fromJson({}))),
                                    ).then((value) {
                                      counterBloc.add(CounterGetById(
                                          state.counter?.id ?? ''));
                                    });
                                  },
                                  child: Icon(Icons.edit,
                                      color: LightColors.getThemeColor(
                                          colorName:
                                              state.counter?.counterTheme,
                                          contrast: 'dark'),
                                      size: 25.0),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 0, vertical: 0.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  CircularPercentIndicator(
                                    animation: false,
                                    radius: 90.0,
                                    percent: ((state.counter!.counter ?? 0) /
                                        (state.counter!.limiter ?? 1)),
                                    lineWidth: 5.0,
                                    circularStrokeCap: CircularStrokeCap.round,
                                    backgroundColor: LightColors.getThemeColor(
                                        colorName: state.counter?.counterTheme,
                                        contrast: 'dark'),
                                    progressColor: Color(0xffffffff),
                                    center: Text(
                                      '${(((state.counter!.counter ?? 0) / (state.counter!.limiter ?? 1)) * 100).round()}%',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white),
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Container(
                                        child: Text(
                                          state.counter!.name ?? '',
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                            fontSize: 22.0,
                                            color: LightColors.getThemeColor(
                                                colorName:
                                                    state.counter?.counterTheme,
                                                contrast: 'dark'),
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        child: Text(
                                          ((state.counter!.limiter ?? 1) -
                                                      (state.counter!.counter ??
                                                          0))
                                                  .toString() +
                                              ' to go',
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                            fontSize: 16.0,
                                            color: LightColors.getThemeColor(
                                                colorName:
                                                    state.counter?.counterTheme,
                                                contrast: 'dark'),
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: GestureDetector(
                            key: buttonKeys[0],
                            onTap: () {
                              counterBloc.add(CounterIncrement(
                                  counter:
                                      state.counter ?? Counter.fromJson({})));
                            },
                            child: Container(
                              margin: EdgeInsets.symmetric(vertical: 10.0),
                              padding: EdgeInsets.all(15.0),
                              decoration: BoxDecoration(
                                color: LightColors.getThemeColor(
                                    colorName: state.counter?.counterTheme,
                                    contrast: 'dark'),
                                borderRadius: BorderRadius.circular(40.0),
                              ),
                              child: Center(
                                child: Text(
                                  (state.counter!.counter ?? 0).toString(),
                                  style: TextStyle(
                                      color: Color(0xffffffff), fontSize: 80.0),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        height: 70,
                        width: width,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              GestureDetector(
                                onTap: () {
                                  counterBloc.add(CounterToggleSound(
                                      counter: state.counter ??
                                          Counter.fromJson({})));
                                },
                                child: Container(
                                  child: Icon(
                                    state.counter!.isSoundOn
                                        ? LineIcons.volumeUp
                                        : LineIcons.volumeMute,
                                    size: 40.0,
                                    color: LightColors.getThemeColor(
                                        colorName: state.counter?.counterTheme,
                                        contrast: 'dark'),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  counterBloc.add(CounterToggleVibration(
                                      counter: state.counter ??
                                          Counter.fromJson({})));
                                },
                                child: Container(
                                  child: Icon(
                                    state.counter!.isVibrationOn
                                        ? Icons.vibration
                                        : LineIcons.mobilePhone,
                                    size: 40.0,
                                    color: LightColors.getThemeColor(
                                        colorName: state.counter?.counterTheme,
                                        contrast: 'dark'),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  counterBloc.add(CounterDecrement(
                                      counter: state.counter ??
                                          Counter.fromJson({})));
                                },
                                child: Container(
                                  child: Icon(
                                    LineIcons.minus,
                                    size: 40.0,
                                    color: LightColors.getThemeColor(
                                        colorName: state.counter?.counterTheme,
                                        contrast: 'dark'),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () => showDialog<String>(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      AlertDialog(
                                    title: const Text('Reset Alert'),
                                    content: const Text(
                                        'Are you sure to reset this counter?'),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context, 'Cancel'),
                                        child: const Text('Cancel'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          counterBloc.add(CounterReset(context,
                                              counter: state.counter ??
                                                  Counter.fromJson({})));
                                          Navigator.pop(context, 'OK');
                                        },
                                        child: const Text('OK'),
                                      ),
                                    ],
                                  ),
                                ),
                                child: Container(
                                  child: Icon(
                                    Icons.restore,
                                    size: 40.0,
                                    color: LightColors.getThemeColor(
                                        colorName: state.counter?.counterTheme,
                                        contrast: 'dark'),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              );
            }
            return Text('');
          },
        ),
      ),
    );
  }
}
