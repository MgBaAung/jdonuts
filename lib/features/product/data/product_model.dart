import 'package:jdonutscodetest/base_architecture/core/master_object.dart';

// ignore: must_be_immutable
class ProdcutModel extends MasterObject<ProdcutModel> {
  String? code;
  String? name;
  String? description;
  int? priceMmk;
  int? color;
  String? emoji;
  String? imageUrl;
  String? imageAsset;
  int? discountPercent;
  bool isSeasonalSpecial;
  bool isPopular;
  bool isOrderAgain;
  bool isExploreNow;

  ProdcutModel({
    super.id,
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
  ProdcutModel fromMap(dynamicData) {
    id = dynamicData['id'];
    code = dynamicData['code'];
    name = dynamicData['name'];
    description = dynamicData['description'];
    priceMmk = dynamicData['priceMmk'];
    color = dynamicData['color'];
    emoji = dynamicData['emoji'];
    imageUrl = dynamicData['imageUrl'];
    imageAsset = dynamicData['imageUrl'];
    discountPercent = dynamicData['discountPercent'];
    isSeasonalSpecial = dynamicData['isSeasonalSpecial'] ?? false;
    isPopular = dynamicData['isPopular'] ?? false;
    isOrderAgain = dynamicData['isOrderAgain'] ?? false;
    isExploreNow = dynamicData['isExploreNow'] ?? false;
    return this;
  }

  @override
  List<ProdcutModel> fromMapList(List list) =>
      list.map((v) => ProdcutModel().fromMap(v)).toList();

  @override
  Map<String, dynamic>? toMap(ProdcutModel? object) {
    return {};
  }

  @override
  List<Map<String, dynamic>?> toMapList(List<ProdcutModel> objectList) {
    throw UnimplementedError();
  }

  @override
  List<Object?> get props => [
    id,
    code,
    name,
    description,
    priceMmk,
    color,
    emoji,
    imageUrl,
    imageAsset,
    discountPercent,
    isSeasonalSpecial,
    isPopular,
    isOrderAgain,
    isExploreNow,
  ];
}
