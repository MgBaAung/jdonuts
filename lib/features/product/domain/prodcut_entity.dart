import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:jdonutscodetest/base_architecture/core/base_entity.dart';
import 'package:jdonutscodetest/features/product/data/product_model.dart';

part 'prodcut_entity.g.dart';

@HiveType(typeId: 1)
class ProdcutEntity extends BaseEntity<ProdcutModel, ProdcutEntity> {
  @HiveField(0)
  String? id;
  @HiveField(1)
  String? code;
  @HiveField(2)
  String? name;
  @HiveField(3)
  String? description;
  @HiveField(4)
  int? priceMmk;
  @HiveField(5)
  int? color;
  @HiveField(6)
  String? emoji;
  @HiveField(7)
  String? imageUrl;
  @HiveField(8)
  int? discountPercent;
  @HiveField(10)
  bool isSeasonalSpecial;
  @HiveField(11)
  bool isPopular;
  @HiveField(12)
  bool isOrderAgain;
  @HiveField(13)
  bool isExploreNow;
  @HiveField(14)
  String? imageAsset;

  ProdcutEntity({
    this.id,
    this.code,
    this.name,
    this.description,
    this.priceMmk,
    this.color,
    this.emoji,
    this.imageUrl,
    this.imageAsset,
    this.discountPercent,
    this.isSeasonalSpecial = false,
    this.isPopular = false,
    this.isOrderAgain = false,
    this.isExploreNow = false,
  });

  @override
  ProdcutEntity fromModel(ProdcutModel model) => ProdcutEntity(
    id: model.id,
    code: model.code,
    name: model.name,
    description: model.description,
    priceMmk: model.priceMmk,
    color: model.color,
    emoji: model.emoji,
    imageUrl: model.imageUrl,
    imageAsset: model.imageAsset,
    discountPercent: model.discountPercent,
    isSeasonalSpecial: model.isSeasonalSpecial,
    isPopular: model.isPopular,
    isOrderAgain: model.isOrderAgain,
    isExploreNow: model.isExploreNow,
  );

  @override
  ProdcutModel toModel() => ProdcutModel(
    id: id,
    code: code,
    name: name,
    description: description,
    priceMmk: priceMmk,
    color: color,
    emoji: emoji,
    imageUrl: imageUrl,
    imageAsset: imageAsset,
    discountPercent: discountPercent,
    isSeasonalSpecial: isSeasonalSpecial,
    isPopular: isPopular,
    isOrderAgain: isOrderAgain,
    isExploreNow: isExploreNow,
  );

  static void register() {
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(ProdcutEntityAdapter());
    }
  }
}
