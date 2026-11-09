import 'package:flutter/material.dart';
import 'package:jdonutscodetest/features/product/domain/product.dart';
import 'package:jdonutscodetest/features/shared/presentation/widgets.dart';
import 'package:jdonutscodetest/global/extension/num_extension.dart';

class OrderAgainItem extends StatelessWidget {
  const OrderAgainItem({super.key, required this.product, required this.onTap});

  final DonutProduct product;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Padding(
      padding: 10.rightSpacing,
      child: SizedBox(
        width: 136,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: ColoredBox(
                color: Colors.white,
                child: SizedBox(
                  height: 144,
                  width: double.infinity,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Hero(
                        tag: 'order-again-${product.id}',
                        child: CachedImage(
                          url: product.imageUrl,
                          fallbackAsset: product.imageAsset,
                          width: 110,
                          height: 126,
                          fit: BoxFit.contain,
                          fallback: Text(
                            product.emoji,
                            style: const TextStyle(fontSize: 54),
                          ),
                        ),
                      ),
                      Positioned(
                        right: 5,
                        bottom: 5,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: const Color(0xffff893d),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            child: Text(
                              '${product.discountPercent ?? 20}% off',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 7),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: Text(
                product.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 12,
                  height: 1.2,
                  fontWeight: FontWeight.w700,
                  color: ink,
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
