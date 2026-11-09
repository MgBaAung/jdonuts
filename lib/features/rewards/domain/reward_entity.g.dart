// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reward_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RewardEntityAdapter extends TypeAdapter<RewardEntity> {
  @override
  final typeId = 2;

  @override
  RewardEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RewardEntity(
      id: fields[0] as String?,
      title: fields[1] as String?,
      completed: (fields[2] as num?)?.toInt(),
      target: (fields[3] as num?)?.toInt(),
      points: (fields[4] as num?)?.toInt(),
      kind: fields[5] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, RewardEntity obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.completed)
      ..writeByte(3)
      ..write(obj.target)
      ..writeByte(4)
      ..write(obj.points)
      ..writeByte(5)
      ..write(obj.kind);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RewardEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
