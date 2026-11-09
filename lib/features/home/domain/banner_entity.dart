import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:jdonutscodetest/base_architecture/core/base_entity.dart';
import 'package:jdonutscodetest/features/home/data/banner_model.dart';

part 'banner_entity.g.dart';

@HiveType(typeId: 4)
class BannerEntity extends BaseEntity<BannerModel, BannerEntity> {
  @HiveField(4)
  String? id;
  @HiveField(0)
  String? title;
  @HiveField(1)
  String? subtitle;
  @HiveField(2)
  int? color;
  @HiveField(3)
  String? imageAsset;

  BannerEntity({this.id, this.title, this.subtitle, this.color, this.imageAsset});

  @override
  BannerEntity fromModel(BannerModel model) => BannerEntity(
    id: model.id,
    title: model.title,
    subtitle: model.subtitle,
    color: model.color,
    imageAsset: model.imageAsset,
  );

  @override
  BannerModel toModel() => BannerModel(
    id: id,
    title: title,
    subtitle: subtitle,
    color: color,
    imageAsset: imageAsset,
  );

  static void register() {
    if (!Hive.isAdapterRegistered(4)) {
      Hive.registerAdapter(BannerEntityAdapter());
    }
  }
}
