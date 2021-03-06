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
import 'package:the_zikir_app/global_var.dart';
import 'package:the_zikir_app/screens/create_new_zikir.dart';
import 'package:the_zikir_app/screens/profile_edit.dart';
import 'package:the_zikir_app/screens/setting_page.dart';
import 'package:the_zikir_app/screens/view_report.dart';
import 'package:the_zikir_app/screens/view_zikir_counter.dart';
import 'package:the_zikir_app/state/counter_state.dart';
import 'package:the_zikir_app/state/profile_state.dart';
import 'package:the_zikir_app/theme/colors/light_colors.dart';
import 'package:the_zikir_app/widgets/active_project_card.dart';
import 'package:the_zikir_app/widgets/dhikr_list_tile.dart';
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

  Text subheading(String title, {required ProfileState state}) {
    return Text(
      title,
      style: TextStyle(
          color: LightColors.getThemeColor(
            state: state,
            colorName: 'green',
            contrast: 'dark',
          ),
          fontSize: 20.0,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.2),
    );
  }

  static CircleAvatar plusIcon(ProfileState state) {
    return CircleAvatar(
      radius: 25.0,
      backgroundColor: Color(0xff43c59e).withOpacity(0),
      child: Icon(
        CupertinoIcons.add_circled,
        size: 32.0,
        color: LightColors.getThemeColor(
            state: state,
            colorName: 'green',
            contrast: 'dark',
            isBackgroundColor: false),
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
    ProfileState parentState = BlocProvider.of<ProfileBloc>(context).state;
    return Scaffold(
      // bottomNavigationBar: Container(
      //   child: AdWidget(ad: myBanner),
      //   width: myBanner.size.width.toDouble(),
      //   height: myBanner.size.height.toDouble(),
      // ),
      // backgroundColor: LightColors.getThemeColor(
      //     state: parentState, colorName: 'yellow', isBackgroundColor: true),
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
                      color: LightColors.getThemeColor(
                          state: parentState,
                          colorName: 'green',
                          contrast: 'light',
                          isBackgroundColor: true),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                CupertinoButton(
                                  // padding: EdgeInsets.all(0),
                                  onPressed: () {
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
                                      color: LightColors.getThemeColor(
                                          state: parentState,
                                          colorName: 'green',
                                          contrast: 'dark'),
                                      size: 30.0),
                                ),
                                CupertinoButton(
                                  // padding: EdgeInsets.all(0),
                                  key: buttonKeys[2],
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ViewReport(
                                              profileState: parentState)),
                                    ).then((value) {
                                      counterBloc.add(CounterGetAll());
                                      profileBloc.add(ProfileGet());
                                    });
                                  },
                                  child: Icon(CupertinoIcons.chart_bar_fill,
                                      color: LightColors.getThemeColor(
                                          state: parentState,
                                          colorName: 'green',
                                          contrast: 'dark'),
                                      size: 25.0),
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
                                      progressColor: LightColors.getThemeColor(
                                          state: parentState,
                                          colorName: 'green',
                                          contrast: 'dark',
                                          isBackgroundColor: false),
                                      backgroundColor:
                                          LightColors.getThemeColor(
                                              state: parentState,
                                              colorName: 'green',
                                              contrast: 'light',
                                              isBackgroundColor: true),
                                      center: CircleAvatar(
                                          backgroundColor:
                                              LightColors.getThemeColor(
                                                  state: parentState,
                                                  colorName: 'green',
                                                  contrast: 'light',
                                                  isBackgroundColor: true),
                                          radius: 35.0,
                                          child: profileState is ProfileLoaded
                                              ? (profileState.avatar == 'male'
                                                  ? SvgPicture.asset(
                                                      'assets/svgs/man.svg',
                                                    )
                                                  : SvgPicture.asset(
                                                      'assets/svgs/woman.svg'))
                                              : SizedBox()),
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
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
                                              ConstrainedBox(
                                                constraints: BoxConstraints(
                                                    minWidth: 180,
                                                    maxWidth: 200),
                                                child: Text(
                                                  (profileState is ProfileLoaded
                                                      ? (profileState.name ??
                                                          'Smart Dhikr')
                                                      : 'Smart Dhikr'),
                                                  textAlign: TextAlign.end,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 2,
                                                  softWrap: true,
                                                  style: TextStyle(
                                                    fontSize: 22.0,
                                                    color: LightColors
                                                        .getThemeColor(
                                                            state: parentState,
                                                            colorName: 'green',
                                                            contrast: 'dark',
                                                            isBackgroundColor:
                                                                false),
                                                    fontWeight: FontWeight.w800,
                                                  ),
                                                ),
                                              ),
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
                                          textAlign: TextAlign.end,
                                          style: TextStyle(
                                            fontSize: 16.0,
                                            color: LightColors.getThemeColor(
                                                state: parentState,
                                                colorName: 'green',
                                                contrast: 'dark',
                                                isBackgroundColor: false),
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
                    physics: BouncingScrollPhysics(),
                    child: Column(
                      children: <Widget>[
                        Container(
                          // color: Colors.transparent,
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
                                    subheading('Active Dhikr',
                                        state: parentState),
                                    CupertinoButton(
                                      padding: EdgeInsets.all(0),
                                      key: buttonKeys[0],
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ViewZikirCounter()),
                                        ).then((value) {
                                          counterBloc.add(CounterGetAll());
                                          profileBloc.add(ProfileGet());
                                        });
                                      },
                                      child: plusIcon(parentState),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 5.0),
                              generateActiveZikirWidget(state,
                                  profileState: parentState),
                            ],
                          ),
                        ),
                        Container(
                          // color: Colors.transparent,
                          padding: EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 10.0),
                          child: Column(
                            children: <Widget>[
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  subheading('Completed Dhikr',
                                      state: parentState),
                                  CupertinoButton(
                                    padding: EdgeInsets.all(0),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ViewZikirCounter()),
                                      ).then((value) {
                                        counterBloc.add(CounterGetAll());
                                        profileBloc.add(ProfileGet());
                                      });
                                    },
                                    child: plusIcon(parentState),
                                  ),
                                ],
                              ),
                              generateCompletedZikirWidget(state,
                                  profileState: parentState),
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

  Widget generateActiveZikirWidget(CounterState state,
      {required ProfileState profileState}) {
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
                      colorName: counter.counterTheme,
                      contrast: 'dark',
                      isBackgroundColor: true,
                      state: profileState),
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
                    ).then(
                      (value) {
                        counterBloc.add(CounterGetAll());
                        profileBloc.add(ProfileGet());
                      },
                    );
                  },
                  dateTime: counter.updatedAt,
                ),
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
        physics: BouncingScrollPhysics(),
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

  Widget generateCompletedZikirWidget(CounterState state,
      {required ProfileState profileState}) {
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
                  // child: TaskColumn(
                  //   icon: LineIcons.check,
                  //   iconBackgroundColor: LightColors.getThemeColor(
                  //       colorName: counter.counterTheme, contrast: 'dark'),
                  //   title: counter.name ?? 'Counter',
                  //   subtitle: counter.counter.toString() + ' Total Dhikr Count',
                  // ),
                  child: DhikrListTile(
                      profileState: profileState,
                      icon: LineIcons.check,
                      backgroundColor: LightColors.getThemeColor(
                          isBackgroundColor: true,
                          colorName: 'green',
                          contrast: 'super-light',
                          state: profileState),
                      iconColor: LightColors.getThemeColor(
                          isBackgroundColor: false,
                          colorName: counter.counterTheme,
                          contrast: 'dark',
                          state: profileState),
                      title: counter.name ?? 'Counter',
                      subtitle:
                          counter.counter.toString() + ' Total Dhikr Count',
                      dateTime: counter.updatedAt,
                      tailingIcon: CupertinoIcons.forward),
                ),
              ]);
            })
            .toList()
        : [];
    if (tempCountersWidget.length == 0) {
      return EmptyWidget(
        hideBackgroundAnimation: true,
        image: null,
        packageImage: PackageImage.Image_2,
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
