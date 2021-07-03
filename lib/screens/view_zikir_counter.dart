import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:line_icons/line_icons.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:the_zikir_app/bloc/counter_bloc.dart';
import 'package:the_zikir_app/data/models/counter.dart';
import 'package:the_zikir_app/event/counter_event.dart';
import 'package:the_zikir_app/state/counter_state.dart';
import 'package:the_zikir_app/widgets/back_button.dart';
import 'package:the_zikir_app/widgets/top_container.dart';

class ViewZikirCounter extends StatefulWidget {
  ViewZikirCounter({required this.index});
  final int index;

  @override
  _ViewZikirCounter createState() => _ViewZikirCounter();
}

class _ViewZikirCounter extends State<ViewZikirCounter> {
  CounterBloc counterBloc = CounterBloc();

  @override
  void initState() {
    // TODO: implement initState
    counterBloc.add(CounterGetByIndex(widget.index));
    super.initState();
  }

  @override
  void dispose() {
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
              return Column(
                children: <Widget>[
                  TopContainer(
                    padding: EdgeInsets.fromLTRB(20, 20, 20, 40),
                    width: width,
                    child: Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            MyBackButton(),
                            Icon(Icons.edit,
                                color: Color(0xff3d7068), size: 25.0),
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
                                backgroundColor: Color(0xff3d7068),
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
                                  Container(
                                    child: Text(
                                      state.counter!.name ?? '',
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                        fontSize: 22.0,
                                        color: Color(0xff3d7068),
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    child: Text(
                                      ((state.counter!.limiter ?? 1) -
                                                  (state.counter!.counter ?? 0))
                                              .toString() +
                                          ' To Go',
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
                      ],
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: GestureDetector(
                        onTap: () {
                          counterBloc.add(CounterIncrement(
                              counter: state.counter ?? Counter()));
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(vertical: 10.0),
                          padding: EdgeInsets.all(15.0),
                          decoration: BoxDecoration(
                            color: Color(0xff3d7068),
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
                                  counter: state.counter ?? Counter()));
                            },
                            child: Container(
                              child: Icon(
                                state.counter!.isSoundOn
                                    ? LineIcons.volumeUp
                                    : LineIcons.volumeMute,
                                size: 40.0,
                                color: Color(0xff3d7068),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              counterBloc.add(CounterToggleVibration(
                                  counter: state.counter ?? Counter()));
                            },
                            child: Container(
                              child: Icon(
                                state.counter!.isVibrationOn
                                    ? Icons.vibration
                                    : LineIcons.mobilePhone,
                                size: 40.0,
                                color: Color(0xff3d7068),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              counterBloc.add(CounterDecrement(
                                  counter: state.counter ?? Counter()));
                            },
                            child: Container(
                              child: Icon(
                                LineIcons.minus,
                                size: 40.0,
                                color: Color(0xff3d7068),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              counterBloc.add(CounterReset(
                                  counter: state.counter ?? Counter()));
                            },
                            child: Container(
                              child: Icon(
                                LineIcons.alternateTrash,
                                size: 40.0,
                                color: Color(0xff3d7068),
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
