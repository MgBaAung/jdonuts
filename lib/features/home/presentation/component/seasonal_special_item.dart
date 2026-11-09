import 'package:flutter/material.dart';
import 'package:jdonutscodetest/features/product/domain/product.dart';
import 'package:jdonutscodetest/features/shared/presentation/widgets.dart';
import 'package:jdonutscodetest/global/app_theme.dart';

class SeasonalSpecialItem extends StatelessWidget {
  const SeasonalSpecialItem({
    super.key,
    required this.product,
    required this.onTap,
  });

  final DonutProduct product;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      width: 208,
      margin: const EdgeInsets.only(right: 11, bottom: 3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              children: [
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: Color(product.color).withValues(alpha: .24),
                      borderRadius: BorderRadius.circular(11),
                    ),
                  ),
                ),
                Center(
                  child: Hero(
                    tag: 'seasonal-${product.id}',
                    child: SizedBox.square(
                      dimension: 100,
                      child: ClipOval(
                        child: CachedImage(
                          url: product.imageUrl,
                          fallbackAsset: product.imageAsset,
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                          fallback: Text(
                            product.emoji,
                            style: const TextStyle(fontSize: 42),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                if (product.discountPercent != null)
                  Positioned(
                    right: 5,
                    bottom: 5,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: const Color(0xffff893d),
                        borderRadius: BorderRadius.circular(9),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 7,
                          vertical: 3,
                        ),
                        child: Text(
                          '${product.discountPercent}% OFF',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          7.height,
          Text(
            product.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: ink,
            ),
          ),
          Text(
            '${formatMMK(product.price)} MMK',
            style: const TextStyle(fontSize: 10, color: ink),
          ),
        ],
      ),
    ),
  );
}
