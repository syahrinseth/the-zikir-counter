import 'package:hive/hive.dart';

part 'counter.g.dart';

@HiveType(typeId: 1)
class Counter {
  @HiveField(0)
  int? id;
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

  Counter({
    this.id,
    this.name,
    this.description,
    this.counter,
    this.histories,
    this.createdAt,
    this.updatedAt,
    this.limiter,
    this.isVibrationOn = true,
    this.isSoundOn = true,
  });

  static Counter fromJson(Map json) {
    return Counter(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      counter: json['counter'],
      histories: json['histories'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      limiter: json['limiter'],
      isVibrationOn: json['isVibrationOn'] ?? true,
      isSoundOn: json['isSoundOn'] ?? true,
    );
  }
}
