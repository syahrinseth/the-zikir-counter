import 'package:charts_flutter/flutter.dart';
import 'package:equatable/equatable.dart';
import 'package:the_zikir_app/data/models/counter.dart';
import 'package:the_zikir_app/widgets/day_bar_graph_card.dart';

abstract class CounterState extends Equatable {
  CounterState([List props = const []]) : super();
}

class CounterLoading extends CounterState {
  final Counter? counter;
  final List props = [];
  CounterLoading({this.counter});
}

class CounterInitialize extends CounterState {
  final List props = [];
  CounterInitialize();
}

class CounterLoaded extends CounterState {
  final Counter? counter;
  final List<Counter>? counters;
  final List<Series<CounterDayBarChartData, DateTime>>? dayBarChartData;
  final List props = [];
  final DateTime? targetDateTime;
  CounterLoaded(
      {this.counter, this.counters, this.dayBarChartData, this.targetDateTime});
}

class CounterError extends CounterState {
  final List props = [];
  final String? message;
  CounterError({this.message});
}

class CounterSaved extends CounterState {
  final List props = [];
  final Counter? counter;
  CounterSaved({this.counter});
}

class CounterDeleted extends CounterState {
  final List props = [];
  CounterDeleted();
}
