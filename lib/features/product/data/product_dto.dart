import '../domain/product.dart';

/// Serialization model for product data stored in the local Hive box.
class ProductDto {
  const ProductDto({
    required this.id,
    required this.code,
    required this.name,
    required this.description,
    required this.priceMmk,
    required this.color,
    required this.emoji,
    required this.imageUrl,
    this.imageAsset,
    this.isNew = false,
    this.discountPercent,
    this.isSeasonalSpecial = false,
    this.isPopular = false,
    this.isOrderAgain = false,
    this.isExploreNow = false,
  });

  final String id;
  final String code;
  final String name;
  final String description;
  final int priceMmk;
  final int color;
  final String emoji;
  final String imageUrl;
  final String? imageAsset;
  final bool isNew;
  final int? discountPercent;
  final bool isSeasonalSpecial;
  final bool isPopular;
  final bool isOrderAgain;
  final bool isExploreNow;

  factory ProductDto.fromMap(Map<dynamic, dynamic> map) => ProductDto(
    id: _required<String>(map, 'id'),
    code: _required<String>(map, 'code'),
    name: _required<String>(map, 'name'),
    description: _required<String>(map, 'description'),
    priceMmk: _required<int>(map, 'priceMmk'),
    color: _required<int>(map, 'color'),
    emoji: _required<String>(map, 'emoji'),
    imageUrl: _stringValue(map, 'imageUrl', legacyKey: 'imageAsset'),
    imageAsset:
        map['fallbackImageAsset'] as String? ?? map['imageAsset'] as String?,
    isNew: map['isNew'] as bool? ?? false,
    discountPercent: map['discountPercent'] as int?,
    isSeasonalSpecial: map['isSeasonalSpecial'] as bool? ?? false,
    isPopular: map['isPopular'] as bool? ?? false,
    isOrderAgain: map['isOrderAgain'] as bool? ?? false,
    isExploreNow: map['isExploreNow'] as bool? ?? false,
  );

  DonutProduct toDomain() => DonutProduct(
    id: id,
    code: code,
    name: name,
    description: description,
    price: priceMmk,
    color: color,
    emoji: emoji,
    imageUrl: imageUrl,
    imageAsset: imageAsset,
    isNew: isNew,
    discountPercent: discountPercent,
    isSeasonalSpecial: isSeasonalSpecial,
    isPopular: isPopular,
    isOrderAgain: isOrderAgain,
    isExploreNow: isExploreNow,
  );

  static T _required<T>(Map<dynamic, dynamic> map, String key) {
    final value = map[key];
    if (value is T) return value;
    throw FormatException('Invalid or missing product field "$key".');
  }

  static String _stringValue(
    Map<dynamic, dynamic> map,
    String key, {
    required String legacyKey,
  }) {
    final value = map[key] ?? map[legacyKey];
    if (value is String) return value;
    throw FormatException('Invalid or missing product field "$key".');
  }
}
