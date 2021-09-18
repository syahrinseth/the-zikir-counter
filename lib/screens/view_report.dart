import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiver/time.dart';
import 'package:the_zikir_app/bloc/counter_bloc.dart';
import 'package:the_zikir_app/data/models/counter.dart';
import 'package:the_zikir_app/event/counter_event.dart';
import 'package:the_zikir_app/state/counter_state.dart';
import 'package:the_zikir_app/widgets/day_bar_graph_card.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:the_zikir_app/widgets/month_bar_graph_card.dart';
import 'package:the_zikir_app/widgets/week_bar_graph_card.dart';
import 'package:the_zikir_app/widgets/year_bar_graph_card.dart';

class ViewReport extends StatefulWidget {
  @override
  _ViewReport createState() => _ViewReport();
}

class _ViewReport extends State<ViewReport>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  CounterBloc _dayReportCounterBloc = CounterBloc();
  CounterBloc _weekReportCounterBloc = CounterBloc();
  CounterBloc _monthReportCounterBloc = CounterBloc();
  CounterBloc _yearReportCounterBloc = CounterBloc();
  // final BannerAd myBanner = BannerAd(
  //   adUnitId: GlobalVar.historyBannerAdId,
  //   size: AdSize.banner,
  //   request: AdRequest(),
  //   listener: BannerAdListener(),
  // );

  @override
  void initState() {
    super.initState();
    // myBanner.load();
    _tabController = TabController(length: 4, vsync: this);
    _dayReportCounterBloc.add(CounterGetDayReport(dateTime: DateTime.now()));
    _weekReportCounterBloc.add(CounterGetWeekReport(dateTime: DateTime.now()));
    _monthReportCounterBloc
        .add(CounterGetMonthReport(dateTime: DateTime.now()));
    _yearReportCounterBloc.add(CounterGetYearReport(dateTime: DateTime.now()));
  }

  @override
  void dispose() {
    _tabController?.dispose();
    _dayReportCounterBloc.close();
    _weekReportCounterBloc.close();
    _monthReportCounterBloc.close();
    _yearReportCounterBloc.close();
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
      backgroundColor: Color(0xff43c59e),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
              width: width,
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Hero(
                        tag: 'backButton',
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Icon(
                              Icons.arrow_back_ios,
                              size: 25,
                              color: Color(0xff3d7068),
                            ),
                          ),
                        ),
                      ),
                      Text('Dhikr History'),
                      Hero(
                        tag: 'More',
                        child: GestureDetector(
                          onTap: () {
                            // Navigator.pop(context);
                          },
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Icon(
                              Icons.info,
                              size: 25,
                              color: Color(0xff43c59e),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  // SizedBox(
                  //   height: 10,
                  // ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Container(
                decoration: BoxDecoration(
                    color: Color(0xff3d7068),
                    borderRadius: BorderRadius.all(Radius.circular(10.0))),
                child: Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: TabBar(
                    labelPadding: EdgeInsets.all(0),
                    indicatorPadding: EdgeInsets.all(0),
                    controller: _tabController,
                    // give the indicator a decoration (color and border radius)
                    indicator: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        10.0,
                      ),
                      color: Colors.white,
                    ),
                    labelColor: Color(0xff3d7068),
                    unselectedLabelColor: Colors.white,
                    tabs: [
                      Tab(
                        text: 'Day',
                      ),
                      Tab(
                        text: 'Week',
                      ),
                      Tab(
                        text: 'Month',
                      ),
                      Tab(
                        text: 'Year',
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      BlocBuilder<CounterBloc, CounterState>(
                        bloc: _dayReportCounterBloc,
                        builder: (context, state) {
                          return SingleChildScrollView(
                            physics: AlwaysScrollableScrollPhysics(),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 20.0, horizontal: 10.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      state is CounterLoaded
                                          ? GestureDetector(
                                              onTap: () {
                                                _dayReportCounterBloc.add(
                                                    CounterDayReportPrev(
                                                        currentDateTime: state
                                                                .targetDateTime ??
                                                            DateTime.now()));
                                              },
                                              child: Icon(
                                                Icons.arrow_back_ios,
                                                size: 25,
                                                color: Colors.white,
                                              ),
                                            )
                                          : SizedBox(),
                                      Text(
                                        state is CounterLoaded
                                            ? (state.targetDateTime!.day
                                                    .toString() +
                                                '/' +
                                                state.targetDateTime!.month
                                                    .toString() +
                                                '/' +
                                                state.targetDateTime!.year
                                                    .toString())
                                            : '',
                                        style: TextStyle(
                                            color: Colors.white,
                                            letterSpacing: 2),
                                      ),
                                      state is CounterLoaded
                                          ? GestureDetector(
                                              onTap: () {
                                                if (!_isDateAMSameAsDateB(
                                                    dateA:
                                                        state.targetDateTime ??
                                                            DateTime.now(),
                                                    dateB: DateTime.now())) {
                                                  _dayReportCounterBloc.add(
                                                      CounterDayReportNext(
                                                          currentDateTime: state
                                                                  .targetDateTime ??
                                                              DateTime.now()));
                                                }
                                              },
                                              child: Icon(
                                                Icons.arrow_forward_ios,
                                                size: 25,
                                                color: _isDateAMSameAsDateB(
                                                        dateA: state
                                                                .targetDateTime ??
                                                            DateTime.now(),
                                                        dateB: DateTime.now())
                                                    ? Color(0xff3d7068)
                                                    : Colors.white,
                                              ),
                                            )
                                          : SizedBox()
                                    ],
                                  ),
                                ),
                                state is CounterLoaded
                                    ? Container(
                                        width: width,
                                        height: 350,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: DayBarGraphCard(
                                              state.dayBarChartData ?? [],
                                              title: 'Dhikred',
                                              desc:
                                                  'Total dhikred ${state.totalDhikrs ?? '0'}.'),
                                        ),
                                      )
                                    : Container(
                                        width: width,
                                        height: 350,
                                        child: Center(
                                          child: LoadingBouncingGrid.circle(
                                            backgroundColor: Colors.black54,
                                          ),
                                        ),
                                      ),
                              ],
                            ),
                          );
                        },
                      ),
                      BlocBuilder<CounterBloc, CounterState>(
                        bloc: _weekReportCounterBloc,
                        builder: (context, state) {
                          return SingleChildScrollView(
                            physics: AlwaysScrollableScrollPhysics(),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 20.0, horizontal: 10.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      state is CounterLoaded
                                          ? GestureDetector(
                                              onTap: () {
                                                _weekReportCounterBloc.add(
                                                    CounterGetWeekReport(
                                                        dateTime: state
                                                                .targetDateTime
                                                                ?.subtract(
                                                                    Duration(
                                                                        days:
                                                                            7)) ??
                                                            DateTime.now()));
                                              },
                                              child: Icon(
                                                Icons.arrow_back_ios,
                                                size: 25,
                                                color: Colors.white,
                                              ),
                                            )
                                          : SizedBox(),
                                      Text(
                                        state is CounterLoaded
                                            ? (Counter.getStartEndWeekFromDate(
                                                state.targetDateTime ??
                                                    DateTime.now()))
                                            : '',
                                        style: TextStyle(
                                            color: Colors.white,
                                            letterSpacing: 2),
                                      ),
                                      state is CounterLoaded
                                          ? GestureDetector(
                                              onTap: () {
                                                if (!_isDateAMSameAsDateB(
                                                    dateA:
                                                        state.targetDateTime ??
                                                            DateTime.now(),
                                                    dateB: DateTime.now())) {
                                                  _weekReportCounterBloc.add(
                                                      CounterGetWeekReport(
                                                          dateTime: state
                                                                  .targetDateTime
                                                                  ?.add(Duration(
                                                                      days:
                                                                          7)) ??
                                                              DateTime.now()));
                                                }
                                              },
                                              child: Icon(
                                                Icons.arrow_forward_ios,
                                                size: 25,
                                                color: _isDateAMSameAsDateB(
                                                        dateA: state
                                                                .targetDateTime ??
                                                            DateTime.now(),
                                                        dateB: DateTime.now())
                                                    ? Color(0xff3d7068)
                                                    : Colors.white,
                                              ),
                                            )
                                          : SizedBox()
                                    ],
                                  ),
                                ),
                                state is CounterLoaded
                                    ? Container(
                                        width: width,
                                        height: 350,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: WeekBarGraphCard(
                                              state.weekBarChartData ?? [],
                                              title: 'Dhikred',
                                              desc:
                                                  'Total dhikred ${state.totalDhikrs ?? '0'}.'),
                                        ),
                                      )
                                    : Container(
                                        width: width,
                                        height: 350,
                                        child: Center(
                                          child: LoadingBouncingGrid.circle(
                                            backgroundColor: Colors.black54,
                                          ),
                                        ),
                                      ),
                              ],
                            ),
                          );
                        },
                      ),
                      BlocBuilder<CounterBloc, CounterState>(
                        bloc: _monthReportCounterBloc,
                        builder: (context, state) {
                          return SingleChildScrollView(
                            physics: AlwaysScrollableScrollPhysics(),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 20.0, horizontal: 10.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      state is CounterLoaded
                                          ? GestureDetector(
                                              onTap: () {
                                                _monthReportCounterBloc.add(CounterGetMonthReport(
                                                    dateTime: state.targetDateTime?.subtract(Duration(
                                                            days: daysInMonth(
                                                                state.targetDateTime
                                                                        ?.year ??
                                                                    DateTime.now()
                                                                        .year,
                                                                state.targetDateTime
                                                                        ?.month ??
                                                                    DateTime.now()
                                                                        .month))) ??
                                                        DateTime.now()));
                                              },
                                              child: Icon(
                                                Icons.arrow_back_ios,
                                                size: 25,
                                                color: Colors.white,
                                              ),
                                            )
                                          : SizedBox(),
                                      Text(
                                        state is CounterLoaded
                                            ? (state.targetDateTime!.month
                                                    .toString() +
                                                '/' +
                                                state.targetDateTime!.year
                                                    .toString())
                                            : '',
                                        style: TextStyle(
                                            color: Colors.white,
                                            letterSpacing: 2),
                                      ),
                                      state is CounterLoaded
                                          ? GestureDetector(
                                              onTap: () {
                                                _monthReportCounterBloc.add(CounterGetMonthReport(
                                                    dateTime: state.targetDateTime?.add(Duration(
                                                            days: daysInMonth(
                                                                state.targetDateTime
                                                                        ?.year ??
                                                                    DateTime.now()
                                                                        .year,
                                                                state.targetDateTime
                                                                        ?.month ??
                                                                    DateTime.now()
                                                                        .month))) ??
                                                        DateTime.now()));
                                              },
                                              child: Icon(
                                                Icons.arrow_forward_ios,
                                                size: 25,
                                                color: _isDateAMSameAsDateB(
                                                        dateA: state
                                                                .targetDateTime ??
                                                            DateTime.now(),
                                                        dateB: DateTime.now())
                                                    ? Color(0xff3d7068)
                                                    : Colors.white,
                                              ),
                                            )
                                          : SizedBox()
                                    ],
                                  ),
                                ),
                                state is CounterLoaded
                                    ? Container(
                                        width: width,
                                        height: 350,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: MonthBarGraphCard(
                                              state.monthBarChartData ?? [],
                                              total: state.totalDhikrs ?? 0,
                                              title: 'Dhikred'),
                                          // child: MonthBarGraphCard
                                          //     .withSampleData(),
                                        ),
                                      )
                                    : Container(
                                        width: width,
                                        height: 350,
                                        child: Center(
                                          child: LoadingBouncingGrid.circle(
                                            backgroundColor: Colors.black54,
                                          ),
                                        ),
                                      ),
                              ],
                            ),
                          );
                        },
                      ),
                      BlocBuilder<CounterBloc, CounterState>(
                        bloc: _yearReportCounterBloc,
                        builder: (context, state) {
                          return SingleChildScrollView(
                            physics: AlwaysScrollableScrollPhysics(),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 20.0, horizontal: 10.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      state is CounterLoaded
                                          ? GestureDetector(
                                              onTap: () {
                                                _yearReportCounterBloc.add(CounterGetYearReport(
                                                    dateTime: DateTime.parse(((state
                                                                        .targetDateTime
                                                                        ?.year ??
                                                                    DateTime.now()
                                                                        .year) -
                                                                1)
                                                            .toString() +
                                                        "-" +
                                                        '01-01')));
                                              },
                                              child: Icon(
                                                Icons.arrow_back_ios,
                                                size: 25,
                                                color: Colors.white,
                                              ),
                                            )
                                          : SizedBox(),
                                      Text(
                                        state is CounterLoaded
                                            ? (state.targetDateTime!.year
                                                .toString())
                                            : '',
                                        style: TextStyle(
                                            color: Colors.white,
                                            letterSpacing: 2),
                                      ),
                                      state is CounterLoaded
                                          ? GestureDetector(
                                              onTap: () {
                                                if (!_isDateAMSameAsDateB(
                                                    dateA:
                                                        state.targetDateTime ??
                                                            DateTime.now(),
                                                    dateB: DateTime.now())) {
                                                  _yearReportCounterBloc.add(
                                                      CounterGetYearReport(
                                                          dateTime: DateTime.parse(
                                                              ((state.targetDateTime?.year ??
                                                                              DateTime.now().year) +
                                                                          1)
                                                                      .toString() +
                                                                  "-" +
                                                                  '01-01')));
                                                }
                                              },
                                              child: Icon(
                                                Icons.arrow_forward_ios,
                                                size: 25,
                                                color: _isDateAMSameAsDateB(
                                                        dateA: state
                                                                .targetDateTime ??
                                                            DateTime.now(),
                                                        dateB: DateTime.now())
                                                    ? Color(0xff3d7068)
                                                    : Colors.white,
                                              ),
                                            )
                                          : SizedBox()
                                    ],
                                  ),
                                ),
                                state is CounterLoaded
                                    ? Container(
                                        width: width,
                                        height: 350,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: YearBarGraphCard(
                                              state.yearBarChartData ?? [],
                                              title: 'Dhikred',
                                              desc:
                                                  'Total dhikred ${state.totalDhikrs ?? '0'}.'),
                                        ),
                                      )
                                    : Container(
                                        width: width,
                                        height: 350,
                                        child: Center(
                                          child: LoadingBouncingGrid.circle(
                                            backgroundColor: Colors.black54,
                                          ),
                                        ),
                                      ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  )),
              // child: SingleChildScrollView(
              //   physics: AlwaysScrollableScrollPhysics(),
              //   child: Column(
              //     children: [
              //       Container(
              //           width: width,
              //           height: 500,
              //           child: Padding(
              //             padding: const EdgeInsets.all(8.0),
              //             child: DayBarGraphCard.withSampleData(),
              //           )),
              //     ],
              //   ),
              // ),
            )
          ],
        ),
      ),
    );
  }

  bool _isDateAMSameAsDateB(
      {required DateTime dateA, required DateTime dateB}) {
    if (dateA.day == dateB.day &&
        dateA.month == dateB.month &&
        dateA.year == dateB.year) {
      return true;
    }
    return false;
  }
}
