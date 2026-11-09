import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:jdonutscodetest/base_architecture/core/base_entity.dart';
import 'package:jdonutscodetest/features/shop/data/shop_model.dart';

part 'shop_entity.g.dart';

@HiveType(typeId: 3)
class ShopEntity extends BaseEntity<ShopModel, ShopEntity> {
  @HiveField(4)
  String? id;
  @HiveField(0)
  String? name;
  @HiveField(1)
  String? address;
  @HiveField(2)
  String? distance;
  @HiveField(3)
  String? imageUrl;
  @HiveField(5)
  String? township;
  @HiveField(6)
  String? imageAsset;

  ShopEntity({
    this.id,
    this.name,
    this.address,
    this.distance,
    this.imageUrl,
    this.township,
    this.imageAsset,
  });

  @override
  ShopEntity fromModel(ShopModel model) => ShopEntity(
    id: model.id,
    name: model.name,
    address: model.address,
    distance: model.distance,
    imageUrl: model.imageUrl,
    township: model.township,
    imageAsset: model.imageAsset,
  );

  @override
  ShopModel toModel() => ShopModel(
    id: id,
    name: name,
    address: address,
    distance: distance,
    imageUrl: imageUrl,
    township: township,
    imageAsset: imageAsset,
  );

  static void register() {
    if (!Hive.isAdapterRegistered(3)) {
      Hive.registerAdapter(ShopEntityAdapter());
    }
  }
}
