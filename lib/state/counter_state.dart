import 'package:equatable/equatable.dart';
import 'package:the_zikir_app/data/models/counter.dart';

abstract class CounterState extends Equatable {
  CounterState([List props = const []]) : super();
}

class CounterInit extends CounterState {
  final List props = [];
}

class CounterLoading extends CounterState {
  final Counter? counter;
  final List props = [];
  CounterLoading({this.counter});
}

class CounterLoaded extends CounterState {
  final Counter? counter;
  final List<Counter>? counters;
  final List props = [];
  CounterLoaded({this.counter, this.counters});
}

class CounterError extends CounterState {
  final List props = [];
  final String? message;
  CounterError({this.message});
}

class CounterSaved extends CounterState {
  final List props = [];
  CounterSaved();
}

class CounterDeleted extends CounterState {
  final List props = [];
  CounterDeleted();
}
