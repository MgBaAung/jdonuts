// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'banner_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BannerEntityAdapter extends TypeAdapter<BannerEntity> {
  @override
  final typeId = 4;

  @override
  BannerEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BannerEntity(
      id: fields[4] as String?,
      title: fields[0] as String?,
      subtitle: fields[1] as String?,
      color: (fields[2] as num?)?.toInt(),
      imageAsset: fields[3] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, BannerEntity obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.subtitle)
      ..writeByte(2)
      ..write(obj.color)
      ..writeByte(3)
      ..write(obj.imageAsset)
      ..writeByte(4)
      ..write(obj.id);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BannerEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
