import 'package:flutter/material.dart';
import 'package:jdonutscodetest/features/product/domain/product.dart';
import 'package:jdonutscodetest/features/shared/presentation/widgets.dart';

class ExploreProductItem extends StatelessWidget {
  const ExploreProductItem({
    super.key,
    required this.product,
    required this.onTap,
  });

  final DonutProduct product;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Material(
    color: Colors.white,
    borderRadius: BorderRadius.circular(22),
    clipBehavior: Clip.antiAlias,
    child: InkWell(
      onTap: onTap,
      child: SizedBox(
        width: 292,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: SizedBox(
                  height: 156,
                  width: double.infinity,
                  child: Hero(
                    tag: 'explore-${product.id}',
                    child: CachedImage(
                      url: product.imageUrl,
                      fallbackAsset: product.imageAsset,
                      width: double.infinity,
                      height: 156,
                      fit: BoxFit.cover,
                      fallback: ColoredBox(
                        color: Color(product.color),
                        child: Center(
                          child: Text(
                            product.emoji,
                            style: const TextStyle(fontSize: 68),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                product.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: Color(0xff29252b),
                ),
              ),
              const SizedBox(height: 5),
              Expanded(
                child: Text(
                  product.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
                    height: 1.35,
                    color: Color(0xff6b6870),
                  ),
                ),
              ),
              const SizedBox(height: 2),
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
        ),
      ),
    ),
  );
}
