// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'prodcut_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProdcutEntityAdapter extends TypeAdapter<ProdcutEntity> {
  @override
  final typeId = 1;

  @override
  ProdcutEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProdcutEntity(
      id: fields[0] as String?,
      code: fields[1] as String?,
      name: fields[2] as String?,
      description: fields[3] as String?,
      priceMmk: (fields[4] as num?)?.toInt(),
      color: (fields[5] as num?)?.toInt(),
      emoji: fields[6] as String?,
      imageUrl: fields[7] as String?,
      discountPercent: (fields[8] as num?)?.toInt(),
      isSeasonalSpecial: fields[10] == null ? false : fields[10] as bool,
      isPopular: fields[11] == null ? false : fields[11] as bool,
      isOrderAgain: fields[12] == null ? false : fields[12] as bool,
      isExploreNow: fields[13] == null ? false : fields[13] as bool,
      imageAsset: fields[14] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, ProdcutEntity obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.code)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.description)
      ..writeByte(4)
      ..write(obj.priceMmk)
      ..writeByte(5)
      ..write(obj.color)
      ..writeByte(6)
      ..write(obj.emoji)
      ..writeByte(7)
      ..write(obj.imageUrl)
      ..writeByte(8)
      ..write(obj.discountPercent)
      ..writeByte(10)
      ..write(obj.isSeasonalSpecial)
      ..writeByte(11)
      ..write(obj.isPopular)
      ..writeByte(12)
      ..write(obj.isOrderAgain)
      ..writeByte(13)
      ..write(obj.isExploreNow)
      ..writeByte(14)
      ..write(obj.imageAsset);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProdcutEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
