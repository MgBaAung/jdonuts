// ignore: must_be_immutable
import 'package:jdonutscodetest/base_architecture/core/master_object.dart';

// ignore: must_be_immutable
class ShopModel extends MasterObject<ShopModel> {
  String? name;
  String? address;
  String? distance;
  String? imageUrl;
  String? imageAsset;
  String? township;

  ShopModel({
    super.id,
    this.name,
    this.address,
    this.distance,
    this.imageUrl,
    this.imageAsset,
    this.township,
  });

  @override
  ShopModel fromMap(dynamicData) {
    name = dynamicData['name'];
    id = dynamicData['id']?.toString() ?? name?.toString();
    address = dynamicData['address'];
    distance = dynamicData['distance'];
    imageUrl = dynamicData['imageUrl'] ?? dynamicData['imageAsset'];
    imageAsset =
        dynamicData['fallbackImageAsset'] ??
        (dynamicData['imageUrl'] == null ? dynamicData['imageAsset'] : null);
    township = dynamicData['township'];
    return this;
  }

  @override
  List<ShopModel> fromMapList(List list) =>
      list.map((v) => ShopModel().fromMap(v)).toList();

  @override
  Map<String, dynamic>? toMap(ShopModel? object) {
    return {};
  }

  @override
  List<Map<String, dynamic>?> toMapList(List<ShopModel> objectList) {
    throw UnimplementedError();
  }

  @override
  List<Object?> get props => [
    id,
    name,
    address,
    township,
    distance,
    imageUrl,
    imageAsset,
  ];
}
