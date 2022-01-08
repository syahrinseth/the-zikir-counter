import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:the_zikir_app/data/models/counter.dart';

class CounterEvent extends Equatable {
  const CounterEvent();

  @override
  List<Object> get props => [];
}

class CounterGetByIndex extends CounterEvent {
  final int index;
  CounterGetByIndex(this.index);
  @override
  List<Object> get props => [index];
}

class CounterPlaySound extends CounterEvent {
  @override
  List<Object> get props => [];
}

class CounterInit extends CounterEvent {
  @override
  List<Object> get props => [];
}

class CounterGetAll extends CounterEvent {
  CounterGetAll();
  @override
  List<Object> get props => [];
}

class CounterCreate extends CounterEvent {
  CounterCreate();
  @override
  List<Object> get props => [];
}

class CounterIncrement extends CounterEvent {
  final Counter counter;
  CounterIncrement({required this.counter});
  @override
  List<Object> get props => [counter];
}

class CounterDecrement extends CounterEvent {
  final Counter counter;
  CounterDecrement({required this.counter});
  @override
  List<Object> get props => [counter];
}

class CounterReset extends CounterEvent {
  final Counter counter;
  final BuildContext context;
  CounterReset(this.context, {required this.counter});
  @override
  List<Object> get props => [context, counter];
}

class CounterGetById extends CounterEvent {
  final String id;
  CounterGetById(this.id);

  @override
  List<Object> get props => [id];
}

class CounterToggleVibration extends CounterEvent {
  final Counter counter;
  CounterToggleVibration({required this.counter});
  @override
  List<Object> get props => [counter];
}

class CounterToggleSound extends CounterEvent {
  final Counter counter;
  CounterToggleSound({required this.counter});
  @override
  List<Object> get props => [counter];
}

class CounterDelete extends CounterEvent {
  final String id;
  CounterDelete(this.id);
  @override
  List<Object> get props => [id];
}

class CounterGetDayReport extends CounterEvent {
  final DateTime dateTime;
  CounterGetDayReport({required this.dateTime});

  @override
  List<Object> get props => [dateTime];
}

class CounterGetWeekReport extends CounterEvent {
  final DateTime dateTime;
  CounterGetWeekReport({required this.dateTime});

  @override
  List<Object> get props => [dateTime];
}

class CounterGetMonthReport extends CounterEvent {
  final DateTime dateTime;
  CounterGetMonthReport({required this.dateTime});

  @override
  List<Object> get props => [dateTime];
}

class CounterGetYearReport extends CounterEvent {
  final DateTime dateTime;
  CounterGetYearReport({required this.dateTime});

  @override
  List<Object> get props => [dateTime];
}

class CounterDayReportPrev extends CounterEvent {
  final DateTime currentDateTime;
  CounterDayReportPrev({required this.currentDateTime});

  @override
  List<Object> get props => [currentDateTime];
}

class CounterDayReportNext extends CounterEvent {
  final DateTime currentDateTime;
  CounterDayReportNext({required this.currentDateTime});

  @override
  List<Object> get props => [currentDateTime];
}

class CounterWeekReportNext extends CounterEvent {
  final DateTime currentDateTime;
  CounterWeekReportNext({required this.currentDateTime});

  @override
  List<Object> get props => [currentDateTime];
}

class CounterWeekReportPrev extends CounterEvent {
  final DateTime currentDateTime;
  CounterWeekReportPrev({required this.currentDateTime});

  @override
  List<Object> get props => [currentDateTime];
}

class CounterUpdate extends CounterEvent {
  final String id;
  final String? title;
  final String? description;
  final int limiter;
  final String counterTheme;
  final int counter;

  CounterUpdate(this.id,
      {this.title,
      this.description,
      required this.limiter,
      required this.counterTheme,
      required this.counter});

  @override
  List<Object> get props =>
      [id, title ?? '', description ?? '', limiter, counterTheme, counter];
}

class CounterGoalAchieved extends CounterEvent {
  final Counter counter;

  CounterGoalAchieved({required this.counter});

  @override
  List<Object> get props => [counter];
}

class CounterPlayGoalAchievementSound extends CounterEvent {
  final Counter counter;

  CounterPlayGoalAchievementSound({required this.counter});
}
