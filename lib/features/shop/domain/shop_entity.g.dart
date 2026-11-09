// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shop_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ShopEntityAdapter extends TypeAdapter<ShopEntity> {
  @override
  final typeId = 3;

  @override
  ShopEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ShopEntity(
      id: fields[4] as String?,
      name: fields[0] as String?,
      address: fields[1] as String?,
      distance: fields[2] as String?,
      imageUrl: fields[3] as String?,
      township: fields[5] as String?,
      imageAsset: fields[6] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, ShopEntity obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.address)
      ..writeByte(2)
      ..write(obj.distance)
      ..writeByte(3)
      ..write(obj.imageUrl)
      ..writeByte(4)
      ..write(obj.id)
      ..writeByte(5)
      ..write(obj.township)
      ..writeByte(6)
      ..write(obj.imageAsset);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ShopEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
