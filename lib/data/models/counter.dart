import 'dart:math';
import 'dart:ui';

import 'package:hive/hive.dart';
import 'package:the_zikir_app/widgets/day_bar_graph_card.dart';
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
      this.limiter,
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

  // static List<charts.Series<CounterDayBarChartData, String>> getWeekReport(
  //     {required DateTime dateTime, required List<Counter> counters}) {
  //   // get counter histories from counters
  //   List<CounterHistory> targetCounterHistories = [];
  //   counters.forEach((element) {
  //     element.histories?.forEach((element) {
  //       // filter counter history for target date week
  //       int weekday = dateTime.weekday;
  //       switch (weekday) {
  //         case 1:
  //           // Mon
  //           break;
  //         case 2:
  //           // Tue
  //           break;
  //         case 3:
  //           // Wed
  //           break;
  //         case 4:
  //           // Thu
  //           break;
  //         case 5:
  //           // Fri
  //           break;
  //         case 6:
  //         // Sat
  //         case 7:
  //         // Sun
  //         default:
  //       }
  //       if (element.dateTime?.day == dateTime.day &&
  //           element.dateTime?.month == dateTime.month &&
  //           element.dateTime?.year == dateTime.year) {
  //         targetCounterHistories.add(element);
  //       }
  //     });
  //   });
  //   // group by counter by target hour and date.
  //   List<int> days = [];
  //   for (var i = 0; i <= 23; i++) {
  //     int totalCount = 0;
  //     targetCounterHistories.forEach((element) {
  //       if (element.dateTime?.hour == i) {
  //         totalCount += element.counter ?? 0;
  //       }
  //     });
  //     days.add(totalCount);
  //   }
  //   // convert days to list of chart series
  //   List<CounterDayBarChartData> data = days.asMap().entries.map((e) {
  //     int index = e.key;
  //     int counter = e.value;
  //     return CounterDayBarChartData(index.toString(), counter,
  //         charts.ColorUtil.fromDartColor(Color(0xff43c59e)));
  //   }).toList();
  //   // return
  //   return [
  //     new charts.Series<CounterDayBarChartData, String>(
  //       id: 'Sales',
  //       domainFn: (CounterDayBarChartData data, _) => data.hour,
  //       measureFn: (CounterDayBarChartData data, _) => data.count,
  //       data: data,
  //       colorFn: (CounterDayBarChartData data, _) => data.color,
  //       radiusPxFn: (CounterDayBarChartData data, _) => 40.0,
  //     ),
  //   ];
  // }
}

@HiveType(typeId: 1)
class CounterHistory {
  @HiveField(0)
  int? counter;

  @HiveField(1)
  DateTime? dateTime;

  CounterHistory({this.counter, this.dateTime});
}
