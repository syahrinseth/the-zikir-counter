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

class CounterIncrement extends CounterEvent {
  final Counter counter;
  final int index;
  CounterIncrement({required this.counter, required this.index});
  @override
  List<Object> get props => [counter, index];
}

class CounterDecrement extends CounterEvent {
  final Counter counter;
  final int index;
  CounterDecrement({required this.counter, required this.index});
  @override
  List<Object> get props => [counter, index];
}

class CounterReset extends CounterEvent {
  final Counter counter;
  final BuildContext context;
  final int index;
  CounterReset(this.context, {required this.counter, required this.index});
  @override
  List<Object> get props => [context, counter, index];
}

class CounterToggleVibration extends CounterEvent {
  final Counter counter;
  final int index;
  CounterToggleVibration({required this.counter, required this.index});
  @override
  List<Object> get props => [counter, index];
}

class CounterToggleSound extends CounterEvent {
  final Counter counter;
  final int index;
  CounterToggleSound({required this.counter, required this.index});
  @override
  List<Object> get props => [counter, index];
}
