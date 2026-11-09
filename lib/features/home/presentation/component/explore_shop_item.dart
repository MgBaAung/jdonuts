import 'package:flutter/material.dart';
import 'package:jdonutscodetest/features/shared/presentation/widgets.dart';
import 'package:jdonutscodetest/features/shop/data/shop_model.dart';

class ExploreShopItem extends StatelessWidget {
  const ExploreShopItem({super.key, required this.shop});

  final ShopModel shop;

  @override
  Widget build(BuildContext context) => Container(
    width: 292,
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: CachedImage(
            url: shop.imageUrl ?? '',
            fallbackAsset: shop.imageAsset,
            width: double.infinity,
            height: 148,
            fit: BoxFit.cover,
            fallback: const ColoredBox(
              color: Color(0xffffeddd),
              child: Center(
                child: Icon(
                  Icons.storefront_rounded,
                  size: 56,
                  color: Color(0xffed4e9c),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 9),
        Text(
          shop.name ?? 'J’Donuts',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: Color(0xff29252b),
          ),
        ),
        const SizedBox(height: 4),
        Expanded(
          child: Text(
            [shop.address, shop.township]
                .whereType<String>()
                .where((part) => part.trim().isNotEmpty)
                .join(', '),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 13,
              height: 1.3,
              color: Color(0xff68656d),
            ),
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'Order Online',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w800,
            color: Color(0xffed4e9c),
          ),
        ),
      ],
    ),
  );
}
