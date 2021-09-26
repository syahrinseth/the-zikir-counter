import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:line_icons/line_icons.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:the_zikir_app/bloc/counter_bloc.dart';
import 'package:the_zikir_app/bloc/profile_bloc.dart';
import 'package:the_zikir_app/data/models/counter.dart';
import 'package:the_zikir_app/event/counter_event.dart';
import 'package:the_zikir_app/event/profile_event.dart';
import 'package:the_zikir_app/screens/create_new_zikir.dart';
import 'package:the_zikir_app/screens/profile_edit.dart';
import 'package:the_zikir_app/screens/setting_page.dart';
import 'package:the_zikir_app/screens/view_report.dart';
import 'package:the_zikir_app/screens/view_zikir_counter.dart';
import 'package:the_zikir_app/state/counter_state.dart';
import 'package:the_zikir_app/state/profile_state.dart';
import 'package:the_zikir_app/theme/colors/light_colors.dart';
import 'package:the_zikir_app/widgets/active_project_card.dart';
import 'package:the_zikir_app/widgets/slide_left_route.dart';
import 'package:the_zikir_app/widgets/task_column.dart';
import 'package:the_zikir_app/widgets/top_container.dart';
import 'package:empty_widget/empty_widget.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';

class HomePage extends StatefulWidget {
  _HomePage createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  CounterBloc counterBloc = CounterBloc()..add(CounterInit());
  ProfileBloc profileBloc = ProfileBloc();
  List<GlobalKey> buttonKeys = [GlobalKey(), GlobalKey(), GlobalKey()];
  List<String> tutorialTexts = [
    'Tap this button to create new smart dhikr counter.',
    'Tap this section to edit your name and avatar.',
    'Tap this button to see your dhikr history.'
  ];
  List<ContentAlign> tutorialTextAligns = [
    ContentAlign.bottom,
    ContentAlign.bottom,
    ContentAlign.bottom
  ];
  // final BannerAd myBanner = BannerAd(
  //   adUnitId: GlobalVar.homeBannerAdId,
  //   size: AdSize.banner,
  //   request: AdRequest(),
  //   listener: BannerAdListener(),
  // );
  // final BannerAd myBanner2 = BannerAd(
  //   adUnitId: GlobalVar.menuBannerAdId,
  //   size: AdSize.banner,
  //   request: AdRequest(),
  //   listener: BannerAdListener(),
  // );

  Text subheading(String title) {
    return Text(
      title,
      style: TextStyle(
          color: Color(0xff3d7068),
          fontSize: 20.0,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.2),
    );
  }

  static CircleAvatar plusIcon() {
    return CircleAvatar(
      radius: 25.0,
      backgroundColor: Color(0xff43c59e),
      child: Icon(
        Icons.add,
        size: 20.0,
        color: Colors.white,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    // myBanner.load();
    // myBanner2.load();
    counterBloc.add(CounterGetAll());
    profileBloc.add(ProfileGet());
  }

  @override
  void dispose() {
    super.dispose();
    counterBloc.close();
    profileBloc.close();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      // bottomNavigationBar: Container(
      //   child: AdWidget(ad: myBanner),
      //   width: myBanner.size.width.toDouble(),
      //   height: myBanner.size.height.toDouble(),
      // ),
      backgroundColor: LightColors.kLightYellow,
      body: SafeArea(
        child: BlocConsumer<CounterBloc, CounterState>(
          bloc: counterBloc,
          listener: (context, state) {},
          builder: (context, state) {
            return Column(
              children: <Widget>[
                BlocConsumer<ProfileBloc, ProfileState>(
                  bloc: profileBloc,
                  listener: (context, state) {
                    if (state is ProfileLoaded) {
                      if (state.isDoneTutorial1 == 'no') {
                        Future.delayed(Duration(seconds: 1), () {
                          profileBloc.add(ProfileShowTutorialMark(context,
                              buttonKeys: buttonKeys,
                              tutorialTexts: tutorialTexts,
                              contentAligns: tutorialTextAligns,
                              markFinishTutorial1: true));
                        });
                      }
                    }
                  },
                  builder: (context, profileState) {
                    return TopContainer(
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      height: 200,
                      width: width,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                GestureDetector(
                                  onTap: () {
                                    // Scaffold.of(context).openDrawer();
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => SettingPage()),
                                    ).then((value) {
                                      counterBloc.add(CounterGetAll());
                                      profileBloc.add(ProfileGet());
                                    });
                                  },
                                  child: Icon(CupertinoIcons.settings,
                                      color: Color(0xff3d7068), size: 30.0),
                                ),
                                GestureDetector(
                                  key: buttonKeys[2],
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ViewReport()),
                                    ).then((value) {
                                      counterBloc.add(CounterGetAll());
                                      profileBloc.add(ProfileGet());
                                    });
                                  },
                                  child: Icon(CupertinoIcons.chart_bar_fill,
                                      color: Color(0xff3d7068), size: 25.0),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 0, vertical: 0.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ProfileEdit()),
                                      ).then((value) {
                                        counterBloc.add(CounterGetAll());
                                        profileBloc.add(ProfileGet());
                                      });
                                    },
                                    child: CircularPercentIndicator(
                                      radius: 90.0,
                                      lineWidth: 5.0,
                                      animation: true,
                                      percent: Counter
                                          .getTotalCountPercentageFromCounters(
                                              counters: (state is CounterLoaded
                                                  ? state.counters ?? []
                                                  : [])),
                                      circularStrokeCap:
                                          CircularStrokeCap.round,
                                      progressColor: Color(0xff3d7068),
                                      backgroundColor: Color(0xff43c59e),
                                      center: CircleAvatar(
                                          backgroundColor: Color(0xff43c59e),
                                          radius: 35.0,
                                          child: profileState is ProfileLoaded
                                              ? (profileState.avatar == 'male'
                                                  ? SvgPicture.asset(
                                                      'assets/svgs/man.svg')
                                                  : SvgPicture.asset(
                                                      'assets/svgs/woman.svg'))
                                              : SizedBox()),
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      GestureDetector(
                                        key: buttonKeys[1],
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ProfileEdit()),
                                          ).then((value) {
                                            counterBloc.add(CounterGetAll());
                                            profileBloc.add(ProfileGet());
                                          });
                                        },
                                        child: Container(
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                (profileState is ProfileLoaded
                                                    ? (profileState.name ??
                                                        'Smart Dhikr')
                                                    : 'Smart Dhikr'),
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                  fontSize: 22.0,
                                                  color: Color(0xff3d7068),
                                                  fontWeight: FontWeight.w800,
                                                ),
                                              ),
                                              SizedBox(
                                                width: 2.0,
                                              ),
                                              Icon(Icons.edit,
                                                  color: Color(0xff3d7068),
                                                  size: 16.0)
                                            ],
                                          ),
                                        ),
                                      ),
                                      Container(
                                        child: Text(
                                          'Total Dhikr: ' +
                                              (state is CounterLoaded
                                                  ? Counter.getTotalCountFromCounters(
                                                          counters:
                                                              state.counters ??
                                                                  [])
                                                      .toString()
                                                  : ''),
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                            fontSize: 16.0,
                                            color: Color(0xff3d7068),
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            )
                          ]),
                    );
                  },
                ),
                Expanded(
                  child: SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    child: Column(
                      children: <Widget>[
                        Container(
                          color: Colors.transparent,
                          padding: EdgeInsets.symmetric(
                              horizontal: 0.0, vertical: 10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    subheading('Active Dhikr'),
                                    GestureDetector(
                                      key: buttonKeys[0],
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  CreateNewZikirCounter()),
                                        ).then((value) {
                                          counterBloc.add(CounterGetAll());
                                          profileBloc.add(ProfileGet());
                                        });
                                      },
                                      child: plusIcon(),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 5.0),
                              generateActiveZikirWidget(state),
                            ],
                          ),
                        ),
                        Container(
                          color: Colors.transparent,
                          padding: EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 10.0),
                          child: Column(
                            children: <Widget>[
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  subheading('Completed Dhikr'),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                CreateNewZikirCounter()),
                                      ).then((value) {
                                        counterBloc.add(CounterGetAll());
                                        profileBloc.add(ProfileGet());
                                      });
                                    },
                                    child: plusIcon(),
                                  ),
                                ],
                              ),
                              generateCompletedZikirWidget(state),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget generateActiveZikirWidget(CounterState state) {
    List<Widget> tempCountersWidget = state is CounterLoaded
        ? state.counters!
            .where((counter) {
              if ((counter.counter ?? 0) < (counter.limiter ?? 1)) {
                return true;
              }
              return false;
            })
            .toList()
            .asMap()
            .entries
            .map((entry) {
              int index = entry.key;
              Counter counter = entry.value;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: ActiveProjectsCard(
                    cardColor: LightColors.getThemeColor(
                        colorName: counter.counterTheme, contrast: 'dark'),
                    loadingPercent:
                        ((counter.counter ?? 0) / (counter.limiter ?? 1)),
                    title: counter.name ?? ('Counter ' + index.toString()),
                    subtitle: counter.displayDhikrNameTranslate(),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                ViewZikirCounter(id: counter.id)),
                      ).then((value) {
                        counterBloc.add(CounterGetAll());
                        profileBloc.add(ProfileGet());
                      });
                    }),
              );
            })
            .toList()
        : [];
    if (tempCountersWidget.length == 0) {
      return EmptyWidget(
        hideBackgroundAnimation: true,
        image: null,
        packageImage: PackageImage.Image_2,
        title: 'No Active Dhikr',
        subTitle: 'You have no active dhikr yet. Care to create one?',
        titleTextStyle: TextStyle(
          fontSize: 22,
          color: Color(0xff9da9c7),
          fontWeight: FontWeight.w500,
        ),
        subtitleTextStyle: TextStyle(
          fontSize: 14,
          color: Color(0xffabb8d6),
        ),
      );
    }
    return Container(
      width: double.infinity,
      height: 200,
      child: GridView.count(
        physics: AlwaysScrollableScrollPhysics(),
        childAspectRatio: 1.0, //1.0
        mainAxisSpacing: 0.1, //1.0
        crossAxisSpacing: 4.0,
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        crossAxisCount: 1,
        children: List.generate(
            tempCountersWidget.length, (index) => tempCountersWidget[index]),
      ),
    );
    // return Column(
    //   children: [
    //     Row(
    //       children: <Widget>[
    //         ActiveProjectsCard(
    //             cardColor: LightColors.kGreen,
    //             loadingPercent: 0.25,
    //             title: 'Selawat',
    //             subtitle: '1 hours progress',
    //             onTap: () {
    //               Navigator.push(
    //                 context,
    //                 MaterialPageRoute(
    //                     builder: (context) => ViewZikirCounter(index: 0)),
    //               );
    //             }),
    //         SizedBox(width: 20.0),
    //         ActiveProjectsCard(
    //           cardColor: LightColors.kRed,
    //           loadingPercent: 0.6,
    //           title: 'Zikir 2',
    //           subtitle: '2 hours progress',
    //         ),
    //       ],
    //     ),
    //     Row(
    //       children: <Widget>[
    //         ActiveProjectsCard(
    //           cardColor: LightColors.kDarkYellow,
    //           loadingPercent: 0.45,
    //           title: 'Zikir 4',
    //           subtitle: '3 hours progress',
    //         ),
    //         SizedBox(width: 20.0),
    //         ActiveProjectsCard(
    //           cardColor: LightColors.kBlue,
    //           loadingPercent: 0.9,
    //           title: 'Zikir 5',
    //           subtitle: '23 hours progress',
    //         ),
    //       ],
    //     ),
    //   ],
    // );
  }

  Widget generateCompletedZikirWidget(CounterState state) {
    List<Widget> tempCountersWidget = state is CounterLoaded
        ? state.counters!
            .where((counter) {
              if ((counter.counter ?? 0) < (counter.limiter ?? 1)) {
                return false;
              }
              return true;
            })
            .toList()
            .asMap()
            .entries
            .map((entry) {
              // int index = entry.key;
              Counter counter = entry.value;
              return Column(children: [
                SizedBox(height: 15.0),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              ViewZikirCounter(id: counter.id)),
                    ).then((value) {
                      counterBloc.add(CounterGetAll());
                      profileBloc.add(ProfileGet());
                    });
                  },
                  child: TaskColumn(
                    icon: LineIcons.check,
                    iconBackgroundColor: LightColors.getThemeColor(
                        colorName: counter.counterTheme, contrast: 'dark'),
                    title: counter.name ?? 'Counter',
                    subtitle: counter.counter.toString() + ' Total Dhikr Count',
                  ),
                ),
              ]);
            })
            .toList()
        : [];
    if (tempCountersWidget.length == 0) {
      return EmptyWidget(
        hideBackgroundAnimation: true,
        image: null,
        packageImage: PackageImage.Image_3,
        title: 'No Completed Dhikr',
        subTitle:
            'You have no completed dhikr yet. Do complete your current active dhikr to update this list.',
        titleTextStyle: TextStyle(
          fontSize: 22,
          color: Color(0xff9da9c7),
          fontWeight: FontWeight.w500,
        ),
        subtitleTextStyle: TextStyle(
          fontSize: 14,
          color: Color(0xffabb8d6),
        ),
      );
    }
    return Column(
      children: tempCountersWidget,
    );
  }
}
