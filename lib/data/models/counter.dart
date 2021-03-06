import 'dart:ui';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:quiver/time.dart';
import 'package:the_zikir_app/global_var.dart';
import 'package:the_zikir_app/state/profile_state.dart';
import 'package:the_zikir_app/theme/colors/light_colors.dart';
import 'package:the_zikir_app/widgets/day_bar_graph_card.dart';
import 'package:the_zikir_app/widgets/dhikr_detail_chart.dart';
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
  @HiveField(11)
  bool? goalAchieved;

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
      this.counterTheme = 'green',
      this.goalAchieved});

  static Counter fromJson(Map json) {
    var uuid = Uuid().v1();
    Box<String> profileBox = Hive.box<String>('myProfileBox');
    String limiter = profileBox.get('counter_goal') ?? '100';
    Counter counter = Counter(
        id: json['id'] ?? uuid,
        name: json['name'] ?? 'Zikir Counter',
        description: json['description'],
        counter: json['counter'] ?? 0,
        histories: json['histories'] ?? [],
        createdAt: json['createdAt'] ?? DateTime.now(),
        updatedAt: json['updatedAt'] ?? DateTime.now(),
        limiter: json['limiter'] ?? int.parse(limiter),
        isVibrationOn: json['isVibrationOn'] ?? true,
        isSoundOn: json['isSoundOn'] ?? true,
        counterTheme: json['counterTheme'] ?? 'green',
        goalAchieved: json['goalAchieved'] ?? false);
    return counter;
  }

  static Counter createFromJson(Map json) {
    var box = Hive.box<Counter>('myZikirCountersBox');
    var uuid = Uuid().v1();
    Box<String> profileBox = Hive.box<String>('myProfileBox');
    String limiter = profileBox.get('counter_goal') ?? '100';
    Counter counter = Counter(
        id: json['id'] ?? uuid,
        name: json['name'] ?? 'Dhikr Counter',
        description: json['description'],
        counter: json['counter'] ?? 0,
        histories: json['histories'] ?? [],
        createdAt: json['createdAt'] ?? DateTime.now(),
        updatedAt: json['updatedAt'] ?? DateTime.now(),
        limiter: json['limiter'] ?? int.parse(limiter),
        isVibrationOn: json['isVibrationOn'] ?? true,
        isSoundOn: json['isSoundOn'] ?? true,
        counterTheme: json['counterTheme'] ?? 'green',
        goalAchieved: json['goalAchieved'] ?? false);
    box.put(counter.id, counter);
    return counter;
  }

  String displayDhikrNameTranslate() {
    List<Map> dhikrNames = GlobalVar.dhikrNames;
    Map dhikr = dhikrNames.firstWhere((element) {
      if (element['name'].toString().toLowerCase() ==
          this.name!.toLowerCase()) {
        return true;
      }
      return false;
    }, orElse: () => Map.from({'translate': null}));
    return '${dhikr['translate'] ?? ''}';
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
    if (percentageCount < totalPercentage) {
      return percentageCount / totalPercentage;
    }
    return 1.0;
  }

  static void saveCounter({required Counter counter}) {
    Box<Counter> countersBox = Hive.box<Counter>('myZikirCountersBox');
    countersBox.put(counter.id, counter);
  }

  static int getDayReportTotal(
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
    int total = 0;
    for (var i = 0; i <= 23; i++) {
      int totalCount = 0;
      targetCounterHistories.forEach((element) {
        if (element.dateTime?.hour == i) {
          totalCount += element.counter ?? 0;
        }
      });
      total += totalCount;
    }
    return total;
  }

  static List<charts.Series<CounterDayBarChartData, DateTime>> getDayReport(
      {required DateTime dateTime,
      required List<Counter> counters,
      required ProfileState profileState}) {
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
        charts.ColorUtil.fromDartColor(
          LightColors.getThemeColor(
              state: profileState,
              colorName: 'green',
              contrast: 'dark',
              isBackgroundColor: true),
        ),
      );
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

  static int getWeekReportTotal(
      {required DateTime dateTime, required List<Counter> counters}) {
    // get counter histories from counters
    int total = 0;
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
        endWeek = dateTime.add(Duration(days: 6, hours: 23, minutes: 59));
        break;
      case 2:
        // Tue
        startWeek = dateTime.subtract(Duration(days: 1));
        endWeek = dateTime.add(Duration(days: 5, hours: 23, minutes: 59));
        break;
      case 3:
        // Wed
        startWeek = dateTime.subtract(Duration(days: 2));
        endWeek = dateTime.add(Duration(days: 4, hours: 23, minutes: 59));
        break;
      case 4:
        // Thu
        startWeek = dateTime.subtract(Duration(days: 3));
        endWeek = dateTime.add(Duration(days: 3, hours: 23, minutes: 59));
        break;
      case 5:
        // Fri
        startWeek = dateTime.subtract(Duration(days: 4));
        endWeek = dateTime.add(Duration(days: 2, hours: 23, minutes: 59));
        break;
      case 6:
        // Sat
        startWeek = dateTime.subtract(Duration(days: 5));
        endWeek = dateTime.add(Duration(days: 1, hours: 23, minutes: 59));
        break;
      case 7:
        // Sun
        startWeek = dateTime.subtract(Duration(days: 6));
        endWeek = dateTime.add(Duration(hours: 23, minutes: 59));
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
    List<int> totalCount = [0, 0, 0, 0, 0, 0, 0];
    for (var i = 0; i < 7; i++) {
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
      total += totalCount[i];
    }
    return total;
  }

  static List<charts.Series<CounterWeekBarChartData, String>> getWeekReport(
      {required DateTime dateTime,
      required List<Counter> counters,
      required ProfileState profileState}) {
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
        endWeek = dateTime.add(Duration(days: 6, hours: 23, minutes: 59));
        break;
      case 2:
        // Tue
        startWeek = dateTime.subtract(Duration(days: 1));
        endWeek = dateTime.add(Duration(days: 5, hours: 23, minutes: 59));
        break;
      case 3:
        // Wed
        startWeek = dateTime.subtract(Duration(days: 2));
        endWeek = dateTime.add(Duration(days: 4, hours: 23, minutes: 59));
        break;
      case 4:
        // Thu
        startWeek = dateTime.subtract(Duration(days: 3));
        endWeek = dateTime.add(Duration(days: 3, hours: 23, minutes: 59));
        break;
      case 5:
        // Fri
        startWeek = dateTime.subtract(Duration(days: 4));
        endWeek = dateTime.add(Duration(days: 2, hours: 23, minutes: 59));
        break;
      case 6:
        // Sat
        startWeek = dateTime.subtract(Duration(days: 5));
        endWeek = dateTime.add(Duration(days: 1, hours: 23, minutes: 59));
        break;
      case 7:
        // Sun
        startWeek = dateTime.subtract(Duration(days: 6));
        endWeek = dateTime.add(Duration(hours: 23, minutes: 59));
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
      // int index = e.key;
      Map<String, dynamic> day = e.value;
      return CounterWeekBarChartData(
        day['day'],
        day['count'],
        charts.ColorUtil.fromDartColor(
          LightColors.getThemeColor(
              state: profileState,
              colorName: 'green',
              contrast: 'dark',
              isBackgroundColor: true),
        ),
      );
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
      {required DateTime dateTime,
      required List<Counter> counters,
      required ProfileState profileState}) {
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
      // int key = e.key;
      Map day = e.value;
      return CounterMonthBarChartData(
        day['day'] ?? DateTime.now(),
        day['total'] ?? 0,
        charts.ColorUtil.fromDartColor(
          LightColors.getThemeColor(
              state: profileState,
              colorName: 'green',
              contrast: 'dark',
              isBackgroundColor: true),
        ),
      );
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

  static int getMonthReportTotal(
      {required DateTime dateTime, required List<Counter> counters}) {
    List<CounterHistory> targetCounterHistories = [];
    int total = 0;
    try {
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
      for (var i = 1; i <= totalDaysInMonth; i++) {
        // group by
        targetCounterHistories.forEach((element) {
          if (element.dateTime?.day == i) {
            total += element.counter ?? 0;
          }
        });
      }
    } catch (e) {}
    return total;
  }

  static int getYearReportTotal(
      {required DateTime dateTime, required List<Counter> counters}) {
    List<CounterHistory> targetCounterHistories = [];
    int total = 0;
    try {
      // filter counters for this year
      counters.forEach((element) {
        element.histories?.forEach((element) {
          if (element.dateTime?.year == dateTime.year) {
            targetCounterHistories.add(element);
          }
        });
      });
      int totalMonthInYear = 12;
      for (var i = 1; i <= totalMonthInYear; i++) {
        // group by
        targetCounterHistories.forEach((element) {
          if (element.dateTime?.month == i) {
            total += element.counter ?? 0;
          }
        });
      }
    } catch (e) {
      print(e.toString());
    }
    return total;
  }

  static List<charts.Series<CounterYearBarChartData, DateTime>> getYearReport(
      {required DateTime dateTime,
      required List<Counter> counters,
      required ProfileState profileState}) {
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
      // int key = e.key;
      Map day = e.value;
      return CounterYearBarChartData(
        day['month'] ?? DateTime.now(),
        day['total'] ?? 0,
        charts.ColorUtil.fromDartColor(
          LightColors.getThemeColor(
              state: profileState,
              colorName: 'green',
              contrast: 'dark',
              isBackgroundColor: true),
        ),
      );
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

  double getPercent() {
    if ((this.limiter ?? 1) < (this.counter ?? 0)) {
      return 1.0;
    } else {
      return (this.counter ?? 0) / (this.limiter ?? 1);
    }
  }

  static List<charts.Series<CounterDetailChartData, String>> getDayDetailReport(
      {required List<Counter> counters,
      required DateTime dateTime,
      required ProfileState profileState}) {
    List<Map> targetCounterHistories = [];
    counters.forEach((counter) {
      int total = 0;
      counter.histories?.forEach((history) {
        // filter counter history for target date
        if (history.dateTime?.day == dateTime.day &&
            history.dateTime?.month == dateTime.month &&
            history.dateTime?.year == dateTime.year) {
          total += history.counter ?? 0;
        }
      });
      if (total > 0) {
        targetCounterHistories
            .add({'counter': total, 'counterName': counter.name});
      }
    });

    Map groupedData =
        groupBy(targetCounterHistories, (Map obj) => obj['counterName']);

    List<Map> temp = [];
    groupedData.forEach((key, value) {
      var total = 0;
      value.forEach((v) {
        total += int.parse(v['counter'].toString());
      });
      temp.add({'counterName': key, 'counter': total});
    });

    // convert days to list of chart series
    List<CounterDetailChartData> data = temp.asMap().entries.map((e) {
      Map dataMap = e.value;
      return CounterDetailChartData(
          dataMap['counterName'],
          dataMap['counter'],
          charts.ColorUtil.fromDartColor(LightColors.getThemeColor(
              state: profileState,
              colorName: 'green',
              contrast: 'dark',
              isBackgroundColor: true)));
    }).toList();
    // return
    return [
      new charts.Series<CounterDetailChartData, String>(
        id: 'Dhikr Detail',
        domainFn: (CounterDetailChartData dhikr, _) => dhikr.name,
        measureFn: (CounterDetailChartData dhikr, _) => dhikr.total,
        data: data,
        colorFn: (CounterDetailChartData data, _) => data.color,
        // Set a label accessor to control the text of the bar label.
        labelAccessorFn: (CounterDetailChartData dhikr, _) =>
            '${dhikr.name}: ${dhikr.total.toString()}',
      ),
    ];
  }

  static List<charts.Series<CounterDetailChartData, String>>
      getWeekDetailReport(
          {required List<Counter> counters,
          required DateTime dateTime,
          required ProfileState profileState}) {
    List<Map> targetCounterHistories = [];
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
        endWeek = dateTime.add(Duration(days: 6, hours: 23, minutes: 59));
        break;
      case 2:
        // Tue
        startWeek = dateTime.subtract(Duration(days: 1));
        endWeek = dateTime.add(Duration(days: 5, hours: 23, minutes: 59));
        break;
      case 3:
        // Wed
        startWeek = dateTime.subtract(Duration(days: 2));
        endWeek = dateTime.add(Duration(days: 4, hours: 23, minutes: 59));
        break;
      case 4:
        // Thu
        startWeek = dateTime.subtract(Duration(days: 3));
        endWeek = dateTime.add(Duration(days: 3, hours: 23, minutes: 59));
        break;
      case 5:
        // Fri
        startWeek = dateTime.subtract(Duration(days: 4));
        endWeek = dateTime.add(Duration(days: 2, hours: 23, minutes: 59));
        break;
      case 6:
        // Sat
        startWeek = dateTime.subtract(Duration(days: 5));
        endWeek = dateTime.add(Duration(days: 1, hours: 23, minutes: 59));
        break;
      case 7:
        // Sun
        startWeek = dateTime.subtract(Duration(days: 6));
        endWeek = dateTime.add(Duration(hours: 23, minutes: 59));
        break;
      default:
    }
    counters.forEach((counter) {
      counter.histories?.forEach((history) {
        int total = 0;
        // filter counter history for target date week
        if (startWeek!.isBefore(history.dateTime ?? DateTime.now()) &&
            endWeek!.isAfter(history.dateTime ?? DateTime.now())) {
          total += history.counter ?? 0;
        }
        if (total > 0) {
          targetCounterHistories
              .add({'counter': total, 'counterName': counter.name});
        }
      });
    });

    Map groupedData =
        groupBy(targetCounterHistories, (Map obj) => obj['counterName']);

    List<Map> temp = [];
    groupedData.forEach((key, value) {
      var total = 0;
      value.forEach((v) {
        total += int.parse(v['counter'].toString());
      });
      temp.add({'counterName': key, 'counter': total});
    });

    // convert days to list of chart series
    List<CounterDetailChartData> data = temp.asMap().entries.map((e) {
      Map dataMap = e.value;
      return CounterDetailChartData(
          dataMap['counterName'],
          dataMap['counter'],
          charts.ColorUtil.fromDartColor(LightColors.getThemeColor(
              state: profileState,
              colorName: 'green',
              contrast: 'dark',
              isBackgroundColor: true)));
    }).toList();
    // return
    return [
      new charts.Series<CounterDetailChartData, String>(
        id: 'Dhikr Detail',
        domainFn: (CounterDetailChartData dhikr, _) => dhikr.name,
        measureFn: (CounterDetailChartData dhikr, _) => dhikr.total,
        data: data,
        colorFn: (CounterDetailChartData data, _) => data.color,
        // Set a label accessor to control the text of the bar label.
        labelAccessorFn: (CounterDetailChartData dhikr, _) =>
            '${dhikr.name}: ${dhikr.total.toString()}',
      ),
    ];
  }

  static List<charts.Series<CounterDetailChartData, String>>
      getMonthDetailReport(
          {required List<Counter> counters,
          required DateTime dateTime,
          required ProfileState profileState}) {
    List<Map> targetCounterHistories = [];
    counters.forEach((counter) {
      counter.histories?.forEach((history) {
        int total = 0;
        if (history.dateTime?.year == dateTime.year &&
            history.dateTime?.month == dateTime.month) {
          total += history.counter ?? 0;
        }
        if (total > 0) {
          targetCounterHistories
              .add({'counter': total, 'counterName': counter.name});
        }
      });
    });

    Map groupedData =
        groupBy(targetCounterHistories, (Map obj) => obj['counterName']);

    List<Map> temp = [];
    groupedData.forEach((key, value) {
      var total = 0;
      value.forEach((v) {
        total += int.parse(v['counter'].toString());
      });
      temp.add({'counterName': key, 'counter': total});
    });

    // convert days to list of chart series
    List<CounterDetailChartData> data = temp.asMap().entries.map((e) {
      Map dataMap = e.value;
      return CounterDetailChartData(
          dataMap['counterName'],
          dataMap['counter'],
          charts.ColorUtil.fromDartColor(LightColors.getThemeColor(
              state: profileState,
              colorName: 'green',
              contrast: 'dark',
              isBackgroundColor: true)));
    }).toList();
    // return
    return [
      new charts.Series<CounterDetailChartData, String>(
        id: 'Dhikr Detail',
        domainFn: (CounterDetailChartData dhikr, _) => dhikr.name,
        measureFn: (CounterDetailChartData dhikr, _) => dhikr.total,
        data: data,
        colorFn: (CounterDetailChartData data, _) => data.color,
        // Set a label accessor to control the text of the bar label.
        labelAccessorFn: (CounterDetailChartData dhikr, _) =>
            '${dhikr.name}: ${dhikr.total.toString()}',
      ),
    ];
  }

  static List<charts.Series<CounterDetailChartData, String>>
      getYearDetailReport(
          {required List<Counter> counters,
          required DateTime dateTime,
          required ProfileState profileState}) {
    List<Map> targetCounterHistories = [];
    counters.forEach((counter) {
      counter.histories?.forEach((history) {
        int total = 0;
        if (history.dateTime?.year == dateTime.year) {
          total += history.counter ?? 0;
        }
        if (total > 0) {
          targetCounterHistories
              .add({'counter': total, 'counterName': counter.name});
        }
      });
    });

    Map groupedData =
        groupBy(targetCounterHistories, (Map obj) => obj['counterName']);

    List<Map> temp = [];
    groupedData.forEach((key, value) {
      var total = 0;
      value.forEach((v) {
        total += int.parse(v['counter'].toString());
      });
      temp.add({'counterName': key, 'counter': total});
    });

    // convert days to list of chart series
    List<CounterDetailChartData> data = temp.asMap().entries.map((e) {
      Map dataMap = e.value;
      return CounterDetailChartData(
          dataMap['counterName'],
          dataMap['counter'],
          charts.ColorUtil.fromDartColor(LightColors.getThemeColor(
              state: profileState,
              colorName: 'green',
              contrast: 'dark',
              isBackgroundColor: true)));
    }).toList();
    // return
    return [
      new charts.Series<CounterDetailChartData, String>(
        id: 'Dhikr Detail',
        domainFn: (CounterDetailChartData dhikr, _) => dhikr.name,
        measureFn: (CounterDetailChartData dhikr, _) => dhikr.total,
        data: data,
        colorFn: (CounterDetailChartData data, _) => data.color,
        // Set a label accessor to control the text of the bar label.
        labelAccessorFn: (CounterDetailChartData dhikr, _) =>
            '${dhikr.name}: ${dhikr.total.toString()}',
      ),
    ];
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
