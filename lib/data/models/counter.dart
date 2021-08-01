import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:the_zikir_app/widgets/day_bar_graph_card.dart';
import 'package:the_zikir_app/widgets/week_bar_graph_card.dart';
import 'package:uuid/uuid.dart';
import 'package:charts_flutter/flutter.dart' as charts;

part 'counter.g.dart';

@HiveType(typeId: 0)
class Counter {
  @HiveField(0)
  String id;
  @HiveField(1)
  String? name;
  @HiveField(2)
  String? description;
  @HiveField(3)
  int? counter;
  @HiveField(4)
  List<CounterHistory>? histories;
  @HiveField(5)
  DateTime? createdAt;
  @HiveField(6)
  DateTime? updatedAt;
  @HiveField(7)
  int? limiter;
  @HiveField(8)
  bool isVibrationOn;
  @HiveField(9)
  bool isSoundOn;
  @HiveField(10)
  String? counterTheme;

  Counter(
      {required this.id,
      this.name = 'Zikir Counter',
      this.description,
      this.counter = 0,
      this.histories,
      this.createdAt,
      this.updatedAt,
      this.limiter = 100,
      this.isVibrationOn = true,
      this.isSoundOn = true,
      this.counterTheme = 'green'});

  static Counter fromJson(Map json) {
    var uuid = Uuid().v1();
    Counter counter = Counter(
        id: json['id'] ?? uuid,
        name: json['name'] ?? 'Zikir Counter',
        description: json['description'],
        counter: json['counter'] ?? 0,
        histories: json['histories'] ?? [],
        createdAt: json['createdAt'] ?? DateTime.now(),
        updatedAt: json['updatedAt'] ?? DateTime.now(),
        limiter: json['limiter'] ?? 100,
        isVibrationOn: json['isVibrationOn'] ?? true,
        isSoundOn: json['isSoundOn'] ?? true,
        counterTheme: json['counterTheme'] ?? 'green');
    return counter;
  }

  static Counter createFromJson(Map json) {
    var box = Hive.box<Counter>('myZikirCountersBox');
    var uuid = Uuid().v1();
    Counter counter = Counter(
        id: json['id'] ?? uuid,
        name: json['name'] ?? 'Zikir Counter',
        description: json['description'],
        counter: json['counter'] ?? 0,
        histories: json['histories'] ?? [],
        createdAt: json['createdAt'] ?? DateTime.now(),
        updatedAt: json['updatedAt'] ?? DateTime.now(),
        limiter: json['limiter'] ?? 100,
        isVibrationOn: json['isVibrationOn'] ?? true,
        isSoundOn: json['isSoundOn'] ?? true,
        counterTheme: json['counterTheme'] ?? 'green');
    box.put(counter.id, counter);
    return counter;
  }

  static int getTotalCountFromCounters({required List<Counter> counters}) {
    List<int> listOfCounter = counters.map((e) => e.counter ?? 0).toList();
    int totalCount = 0;
    listOfCounter.forEach((e) {
      totalCount += e;
    });
    return totalCount;
  }

  static double getTotalCountPercentageFromCounters(
      {required List<Counter> counters}) {
    double totalPercentage = 1;
    double percentageCount = 0;
    counters.forEach((e) {
      totalPercentage += (e.limiter ?? 0).toDouble();
      percentageCount += (e.counter ?? 0).toDouble();
    });
    return percentageCount / totalPercentage;
  }

  static void saveCounter({required Counter counter}) {
    Box<Counter> countersBox = Hive.box<Counter>('myZikirCountersBox');
    countersBox.put(counter.id, counter);
  }

  static List<charts.Series<CounterDayBarChartData, DateTime>> getDayReport(
      {required DateTime dateTime, required List<Counter> counters}) {
    // get counter histories from counters
    List<CounterHistory> targetCounterHistories = [];
    counters.forEach((element) {
      element.histories?.forEach((element) {
        // filter counter history for target date
        if (element.dateTime?.day == dateTime.day &&
            element.dateTime?.month == dateTime.month &&
            element.dateTime?.year == dateTime.year) {
          targetCounterHistories.add(element);
        }
      });
    });
    // group by counter by target hour and date.
    List<int> days = [];
    for (var i = 0; i <= 23; i++) {
      int totalCount = 0;
      targetCounterHistories.forEach((element) {
        if (element.dateTime?.hour == i) {
          totalCount += element.counter ?? 0;
        }
      });
      days.add(totalCount);
    }
    // convert days to list of chart series
    List<CounterDayBarChartData> data = days.asMap().entries.map((e) {
      int index = e.key;
      int counter = e.value;
      return CounterDayBarChartData(
          DateTime(dateTime.year, dateTime.month, dateTime.day, index),
          counter,
          charts.ColorUtil.fromDartColor(Color(0xff43c59e)));
    }).toList();
    // return
    return [
      new charts.Series<CounterDayBarChartData, DateTime>(
        id: 'Sales',
        domainFn: (CounterDayBarChartData data, _) => data.dateTime,
        measureFn: (CounterDayBarChartData data, _) => data.count,
        data: data,
        colorFn: (CounterDayBarChartData data, _) => data.color,
        radiusPxFn: (CounterDayBarChartData data, _) => 40.0,
      ),
    ];
  }

  static List<charts.Series<CounterWeekBarChartData, String>> getWeekReport(
      {required DateTime dateTime, required List<Counter> counters}) {
    // get counter histories from counters
    List<CounterHistory> targetCounterHistories = [];
    int weekday = dateTime.weekday;
    DateTime? startWeek;
    DateTime? endWeek;
    switch (weekday) {
      case 1:
        // Mon
        startWeek = dateTime;
        endWeek = dateTime.add(Duration(days: 6));
        break;
      case 2:
        // Tue
        startWeek = dateTime.subtract(Duration(days: 1));
        endWeek = dateTime.add(Duration(days: 5));
        break;
      case 3:
        // Wed
        startWeek = dateTime.subtract(Duration(days: 2));
        endWeek = dateTime.add(Duration(days: 4));
        break;
      case 4:
        // Thu
        startWeek = dateTime.subtract(Duration(days: 3));
        endWeek = dateTime.add(Duration(days: 3));
        break;
      case 5:
        // Fri
        startWeek = dateTime.subtract(Duration(days: 4));
        endWeek = dateTime.add(Duration(days: 2));
        break;
      case 6:
        // Sat
        startWeek = dateTime.subtract(Duration(days: 5));
        endWeek = dateTime.add(Duration(days: 1));
        break;
      case 7:
        // Sun
        startWeek = dateTime.subtract(Duration(days: 6));
        endWeek = dateTime;
        break;
      default:
    }
    counters.forEach((element) {
      element.histories?.forEach((element) {
        // filter counter history for target date week
        if (startWeek!.isBefore(element.dateTime ?? DateTime.now()) &&
            endWeek!.isAfter(element.dateTime ?? DateTime.now())) {
          targetCounterHistories.add(element);
        }
      });
    });
    // group by counter by target DayName.
    List<Map<String, dynamic>> days = [];
    List<int> totalCount = [0, 0, 0, 0, 0, 0, 0];
    String? dayName;
    for (var i = 0; i < 7; i++) {
      targetCounterHistories.forEach((element) {
        switch (i) {
          case 0:
            // Mon
            dayName = 'Mon';
            if (element.dateTime?.weekday == 1) {
              totalCount[i] += element.counter ?? 0;
            }
            break;
          case 1:
            // Tue
            dayName = 'Tue';
            if (element.dateTime?.weekday == 2) {
              totalCount[i] += element.counter ?? 0;
            }
            break;
          case 2:
            // Wed
            dayName = 'Wed';
            if (element.dateTime?.weekday == 3) {
              totalCount[i] += element.counter ?? 0;
            }
            break;
          case 3:
            // Thu
            dayName = 'Thu';
            if (element.dateTime?.weekday == 4) {
              totalCount[i] += element.counter ?? 0;
            }
            break;
          case 4:
            // Fri
            dayName = 'Fri';
            if (element.dateTime?.weekday == 5) {
              totalCount[i] += element.counter ?? 0;
            }
            break;
          case 5:
            // Sat
            dayName = 'Sat';
            if (element.dateTime?.weekday == 6) {
              totalCount[i] += element.counter ?? 0;
            }
            break;
          case 6:
            // Sun
            dayName = 'Sun';
            if (element.dateTime?.weekday == 7) {
              totalCount[i] += element.counter ?? 0;
            }
            break;
          default:
        }
      });
      days.add({'day': dayName, 'count': totalCount[i]});
    }
    // convert days to list of chart series
    List<CounterWeekBarChartData> data = days.asMap().entries.map((e) {
      int index = e.key;
      Map<String, dynamic> day = e.value;
      return CounterWeekBarChartData(day['day'], day['count'],
          charts.ColorUtil.fromDartColor(Color(0xff43c59e)));
    }).toList();
    // return
    return [
      new charts.Series<CounterWeekBarChartData, String>(
        id: 'Week Graph Report',
        domainFn: (CounterWeekBarChartData data, _) => data.dayName,
        measureFn: (CounterWeekBarChartData data, _) => data.count,
        data: data,
        colorFn: (CounterWeekBarChartData data, _) => data.color,
        radiusPxFn: (CounterWeekBarChartData data, _) => 40.0,
      ),
    ];
  }

  static String getStartEndWeekFromDate(DateTime currentDate) {
    int weekDays = currentDate.weekday;
    // get start and end weekdays date
    DateTime? startWeekDate;
    DateTime? endWeekDate;
    switch (weekDays) {
      case 1:
        startWeekDate = currentDate;
        endWeekDate = currentDate.add(Duration(days: 6));
        break;
      case 2:
        startWeekDate = currentDate.subtract(Duration(days: 1));
        endWeekDate = currentDate.add(Duration(days: 5));
        break;
      case 3:
        startWeekDate = currentDate.subtract(Duration(days: 2));
        endWeekDate = currentDate.add(Duration(days: 4));
        break;
      case 4:
        startWeekDate = currentDate.subtract(Duration(days: 3));
        endWeekDate = currentDate.add(Duration(days: 3));
        break;
      case 5:
        startWeekDate = currentDate.subtract(Duration(days: 4));
        endWeekDate = currentDate.add(Duration(days: 2));
        break;
      case 6:
        startWeekDate = currentDate.subtract(Duration(days: 5));
        endWeekDate = currentDate.add(Duration(days: 1));
        break;
      case 7:
        startWeekDate = currentDate.subtract(Duration(days: 6));
        endWeekDate = currentDate;
        break;
      default:
    }
    return startWeekDate!.day.toString() +
        '/' +
        startWeekDate.month.toString() +
        '/' +
        startWeekDate.year.toString() +
        '  -  ' +
        endWeekDate!.day.toString() +
        '/' +
        endWeekDate.month.toString() +
        '/' +
        endWeekDate.year.toString();
  }
}

@HiveType(typeId: 1)
class CounterHistory {
  @HiveField(0)
  int? counter;

  @HiveField(1)
  DateTime? dateTime;

  CounterHistory({this.counter, this.dateTime});
}
