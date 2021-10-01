import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:line_icons/line_icons.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:the_zikir_app/bloc/counter_bloc.dart';
import 'package:the_zikir_app/data/models/counter.dart';
import 'package:the_zikir_app/event/counter_event.dart';
import 'package:the_zikir_app/screens/edit_zikir_counter.dart';
import 'package:the_zikir_app/state/counter_state.dart';
import 'package:the_zikir_app/theme/colors/light_colors.dart';
import 'package:the_zikir_app/widgets/back_button.dart';
import 'package:the_zikir_app/widgets/top_container.dart';

class ViewZikirCounter extends StatefulWidget {
  ViewZikirCounter({required this.id});
  final String id;

  @override
  _ViewZikirCounter createState() => _ViewZikirCounter();
}

class _ViewZikirCounter extends State<ViewZikirCounter> {
  CounterBloc counterBloc = CounterBloc()..add(CounterInit());
  // final BannerAd myBanner = BannerAd(
  //   adUnitId: GlobalVar.counterBannerAdId,
  //   size: AdSize.banner,
  //   request: AdRequest(),
  //   listener: BannerAdListener(),
  // );

  @override
  void initState() {
    // myBanner.load();
    counterBloc.add(CounterGetById(widget.id));
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
      // bottomNavigationBar: Container(
      //   child: AdWidget(ad: myBanner),
      //   width: myBanner.size.width.toDouble(),
      //   height: myBanner.size.height.toDouble(),
      // ),
      body: SafeArea(
        child: BlocConsumer<CounterBloc, CounterState>(
          bloc: counterBloc,
          listener: (context, state) {
            if (state is CounterError) {
              print(state.message);
            }
          },
          builder: (context, state) {
            if (state is CounterInit) {
              return Text('Loading');
            }
            if (state is CounterLoaded) {
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
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => EditZikirCounter(
                                          counter: state.counter ??
                                              Counter.fromJson({}))),
                                ).then((value) {
                                  counterBloc.add(CounterGetById(widget.id));
                                });
                              },
                              child: Icon(Icons.edit,
                                  color: LightColors.getThemeColor(
                                      colorName: state.counter?.counterTheme,
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
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                EditZikirCounter(
                                                    counter: state.counter ??
                                                        Counter.fromJson({}))),
                                      ).then((value) {
                                        counterBloc
                                            .add(CounterGetById(widget.id));
                                      });
                                    },
                                    child: Container(
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              ConstrainedBox(
                                                constraints: BoxConstraints(
                                                    minWidth: 180,
                                                    maxWidth: 200),
                                                child: Text(
                                                  state.counter!.name ?? '',
                                                  textAlign: TextAlign.end,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 2,
                                                  softWrap: true,
                                                  style: TextStyle(
                                                    fontSize: 22.0,
                                                    color: LightColors
                                                        .getThemeColor(
                                                            colorName: state
                                                                .counter
                                                                ?.counterTheme,
                                                            contrast: 'dark'),
                                                    fontWeight: FontWeight.w800,
                                                  ),
                                                ),
                                              ),
                                              ConstrainedBox(
                                                constraints: BoxConstraints(
                                                    minWidth: 180,
                                                    maxWidth: 200),
                                                child: Text(
                                                  state.counter!
                                                      .displayDhikrNameTranslate(),
                                                  textAlign: TextAlign.end,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                  softWrap: true,
                                                  style: TextStyle(
                                                    fontSize: 14.0,
                                                    color: LightColors
                                                        .getThemeColor(
                                                            colorName: state
                                                                .counter
                                                                ?.counterTheme,
                                                            contrast: 'dark'),
                                                    fontWeight: FontWeight.w800,
                                                  ),
                                                ),
                                              ),
                                              Text(
                                                'Dhikr goal ${state.counter!.counter} / ${state.counter!.limiter}',
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                  fontSize: 16.0,
                                                  color:
                                                      LightColors.getThemeColor(
                                                          colorName: state
                                                              .counter
                                                              ?.counterTheme,
                                                          contrast: 'dark'),
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              )
                                            ],
                                          ),
                                          SizedBox(
                                            width: 2.0,
                                          ),
                                          Icon(Icons.edit,
                                              color: LightColors.getThemeColor(
                                                  colorName: state
                                                      .counter?.counterTheme,
                                                  contrast: 'dark'),
                                              size: 16.0)
                                        ],
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
                        onTap: () {
                          counterBloc.add(CounterIncrement(
                              counter: state.counter ?? Counter.fromJson({})));
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
                                  counter:
                                      state.counter ?? Counter.fromJson({})));
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
                                  counter:
                                      state.counter ?? Counter.fromJson({})));
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
                                  counter:
                                      state.counter ?? Counter.fromJson({})));
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
                              builder: (BuildContext context) => AlertDialog(
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
            }
            return Text('');
          },
        ),
      ),
    );
  }
}
