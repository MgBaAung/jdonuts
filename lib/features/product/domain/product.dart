class DonutProduct {
  const DonutProduct({
    required this.id,
    required this.code,
    required this.name,
    required this.description,
    required this.price,
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
  final String id, code, name, description, emoji, imageUrl;
  final String? imageAsset;
  final int price, color;
  final bool isNew;
  final int? discountPercent;
  final bool isSeasonalSpecial;
  final bool isPopular;
  final bool isOrderAgain;
  final bool isExploreNow;
}
