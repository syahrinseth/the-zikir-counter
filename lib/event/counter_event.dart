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

class CounterUpdate extends CounterEvent {
  final String id;
  final String? title;
  final String? description;
  final int limiter;
  final String counterTheme;

  CounterUpdate(this.id,
      {this.title,
      this.description,
      required this.limiter,
      required this.counterTheme});

  @override
  List<Object> get props =>
      [id, title ?? '', description ?? '', limiter, counterTheme];
}
