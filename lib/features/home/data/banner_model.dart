// ignore: must_be_immutable
import 'package:jdonutscodetest/base_architecture/core/master_object.dart';

// ignore: must_be_immutable
class BannerModel extends MasterObject<BannerModel> {
  String? title;
  String? subtitle;
  int? color;
  String? imageAsset;

  BannerModel({
    super.id,
    this.title,
    this.subtitle,
    this.color,
    this.imageAsset,
  });

  @override
  BannerModel fromMap(dynamicData) {
    title = dynamicData['title'];
    id = dynamicData['id']?.toString() ?? title?.toString();
    subtitle = dynamicData['subtitle'];
    color = dynamicData['color'];
    imageAsset = dynamicData['imageAsset'];
    return this;
  }

  @override
  List<BannerModel> fromMapList(List list) =>
      list.map((v) => BannerModel().fromMap(v)).toList();

  @override
  Map<String, dynamic>? toMap(BannerModel? object) {
    return {};
  }

  @override
  List<Map<String, dynamic>?> toMapList(List<BannerModel> objectList) {
    throw UnimplementedError();
  }

  @override
  List<Object?> get props => [id, title, subtitle, color, imageAsset];
}
