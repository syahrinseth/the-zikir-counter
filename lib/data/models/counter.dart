import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:quiver/time.dart';
import 'package:the_zikir_app/widgets/day_bar_graph_card.dart';
import 'package:the_zikir_app/widgets/month_bar_graph_card.dart';
import 'package:the_zikir_app/widgets/week_bar_graph_card.dart';
import 'package:the_zikir_app/widgets/year_bar_graph_card.dart';
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
      this.name = 'Dhikr Counter',
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
        name: json['name'] ?? 'Dhikr Counter',
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
        labelAccessorFn: (CounterDayBarChartData data, _) =>
            "${data.count.toString()}",
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
    dateTime = DateTime.parse(dateTime.year.toString() +
        dateTime.month.toString().padLeft(2, "0") +
        dateTime.day.toString().padLeft(2, "0"));
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
      switch (i) {
        case 0:
          // Mon
          dayName = 'Mon';
          break;
        case 1:
          // Tue
          dayName = 'Tue';
          break;
        case 2:
          // Wed
          dayName = 'Wed';
          break;
        case 3:
          // Thu
          dayName = 'Thu';
          break;
        case 4:
          // Fri
          dayName = 'Fri';
          break;
        case 5:
          // Sat
          dayName = 'Sat';
          break;
        case 6:
          // Sun
          dayName = 'Sun';
          break;
        default:
      }
      targetCounterHistories.forEach((element) {
        switch (i) {
          case 0:
            // Mon
            if (element.dateTime?.weekday == 1) {
              totalCount[i] += element.counter ?? 0;
            }
            break;
          case 1:
            // Tue
            if (element.dateTime?.weekday == 2) {
              totalCount[i] += element.counter ?? 0;
            }
            break;
          case 2:
            // Wed
            if (element.dateTime?.weekday == 3) {
              totalCount[i] += element.counter ?? 0;
            }
            break;
          case 3:
            // Thu
            if (element.dateTime?.weekday == 4) {
              totalCount[i] += element.counter ?? 0;
            }
            break;
          case 4:
            // Fri
            if (element.dateTime?.weekday == 5) {
              totalCount[i] += element.counter ?? 0;
            }
            break;
          case 5:
            // Sat
            if (element.dateTime?.weekday == 6) {
              totalCount[i] += element.counter ?? 0;
            }
            break;
          case 6:
            // Sun
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
          labelAccessorFn: (CounterWeekBarChartData data, _) =>
              data.count.toString()),
    ];
  }

  static List<charts.Series<CounterMonthBarChartData, DateTime>> getMonthReport(
      {required DateTime dateTime, required List<Counter> counters}) {
    // try {
    List<CounterHistory> targetCounterHistories = [];
    // filter counters for this year
    counters.forEach((element) {
      element.histories?.forEach((element) {
        if (element.dateTime?.year == dateTime.year &&
            element.dateTime?.month == dateTime.month) {
          targetCounterHistories.add(element);
        }
      });
    });
    int totalDaysInMonth = daysInMonth(dateTime.year, dateTime.month);
    List<Map> days = [];
    int index = 0;
    for (var i = 1; i <= totalDaysInMonth; i++) {
      days.add({
        'day': DateTime.parse(dateTime.year.toString() +
            '-' +
            (dateTime.month < 10
                ? ('0' + dateTime.month.toString())
                : dateTime.month.toString()) +
            '-' +
            (i < 10 ? ('0' + i.toString()) : i.toString())),
        'total': 0
      });
      // group by
      targetCounterHistories.forEach((element) {
        if (element.dateTime?.day == i) {
          days[index]['total'] += element.counter ?? 0;
        }
      });
      index++;
    }

    // convert days to list of chart series
    List<CounterMonthBarChartData> data = days.asMap().entries.map((e) {
      int key = e.key;
      Map day = e.value;
      return CounterMonthBarChartData(day['day'] ?? DateTime.now(),
          day['total'] ?? 0, charts.ColorUtil.fromDartColor(Color(0xff43c59e)));
    }).toList();
    // return
    return [
      new charts.Series<CounterMonthBarChartData, DateTime>(
        id: 'Dzikr Time Distribution',
        domainFn: (CounterMonthBarChartData data, _) => data.dateTime,
        measureFn: (CounterMonthBarChartData data, _) => data.count,
        data: data,
        colorFn: (CounterMonthBarChartData data, _) => data.color,
        radiusPxFn: (CounterMonthBarChartData data, _) => 40.0,
        labelAccessorFn: (CounterMonthBarChartData data, _) =>
            "${data.count.toString()}",
      ),
    ];
    // } catch (e) {
    //   print(e.toString());
    //   return [];
    // }
  }

  static List<charts.Series<CounterYearBarChartData, DateTime>> getYearReport(
      {required DateTime dateTime, required List<Counter> counters}) {
    // try {
    List<CounterHistory> targetCounterHistories = [];
    // filter counters for this year
    counters.forEach((element) {
      element.histories?.forEach((element) {
        if (element.dateTime?.year == dateTime.year) {
          targetCounterHistories.add(element);
        }
      });
    });
    int totalMonthInYear = 12;
    List<Map> months = [];
    int index = 0;
    for (var i = 1; i <= totalMonthInYear; i++) {
      months.add({
        'month': DateTime.parse(dateTime.year.toString() +
            '-' +
            (i < 10 ? ('0' + i.toString()) : i.toString()) +
            '-' +
            "01"),
        'total': 0
      });
      // group by
      targetCounterHistories.forEach((element) {
        if (element.dateTime?.month == i) {
          months[index]['total'] += element.counter ?? 0;
        }
      });
      index++;
    }

    // convert days to list of chart series
    List<CounterYearBarChartData> data = months.asMap().entries.map((e) {
      int key = e.key;
      Map day = e.value;
      return CounterYearBarChartData(day['month'] ?? DateTime.now(),
          day['total'] ?? 0, charts.ColorUtil.fromDartColor(Color(0xff43c59e)));
    }).toList();
    // return
    return [
      new charts.Series<CounterYearBarChartData, DateTime>(
        id: 'Dzikr Time Distribution',
        domainFn: (CounterYearBarChartData data, _) => data.dateTime,
        measureFn: (CounterYearBarChartData data, _) => data.count,
        data: data,
        colorFn: (CounterYearBarChartData data, _) => data.color,
        radiusPxFn: (CounterYearBarChartData data, _) => 40.0,
        labelAccessorFn: (CounterYearBarChartData data, _) =>
            "${data.count.toString()}",
      ),
    ];
    // } catch (e) {
    //   print(e.toString());
    //   return [];
    // }
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
