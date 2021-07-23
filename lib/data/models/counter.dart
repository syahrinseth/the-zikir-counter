import 'package:flutter/rendering.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'counter.g.dart';

@HiveType(typeId: 1)
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
  List<Counter>? histories;
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
        histories: json['histories'],
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
}
