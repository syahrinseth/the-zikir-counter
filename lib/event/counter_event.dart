import 'package:equatable/equatable.dart';
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
  CounterReset({required this.counter});
  @override
  List<Object> get props => [];
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
