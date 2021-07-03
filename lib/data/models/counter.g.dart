// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'counter.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CounterAdapter extends TypeAdapter<Counter> {
  @override
  final int typeId = 1;

  @override
  Counter read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Counter(
      id: fields[0] as int?,
      name: fields[1] as String?,
      description: fields[2] as String?,
      counter: fields[3] as int?,
      histories: (fields[4] as List?)?.cast<Counter>(),
      createdAt: fields[5] as DateTime?,
      updatedAt: fields[6] as DateTime?,
      limiter: fields[7] as int?,
      isVibrationOn: fields[8] as bool,
      isSoundOn: fields[9] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Counter obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.counter)
      ..writeByte(4)
      ..write(obj.histories)
      ..writeByte(5)
      ..write(obj.createdAt)
      ..writeByte(6)
      ..write(obj.updatedAt)
      ..writeByte(7)
      ..write(obj.limiter)
      ..writeByte(8)
      ..write(obj.isVibrationOn)
      ..writeByte(9)
      ..write(obj.isSoundOn);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CounterAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
