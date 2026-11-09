import 'package:flutter/material.dart';
import 'package:jdonutscodetest/features/product/domain/product.dart';
import 'package:jdonutscodetest/features/shared/presentation/widgets.dart';
import 'package:jdonutscodetest/global/app_theme.dart';
import 'package:jdonutscodetest/global/extension/num_extension.dart';

class PopularProductItem extends StatelessWidget {
  const PopularProductItem({
    super.key,
    required this.product,
    required this.onTap,
  });

  final DonutProduct product;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: SizedBox(
      width: 136,
      height: 176,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: ColoredBox(
              color: Colors.white,
              child: SizedBox(
                height: 174,
                width: double.infinity,
                child: Center(
                  child: Hero(
                    tag: 'popular-${product.id}',
                    child: CachedImage(
                      url: product.imageUrl,
                      fallbackAsset: product.imageAsset,
                      width: 110,
                      height: 156,
                      fit: BoxFit.fill,
                      fallback: Text(
                        product.emoji,
                        style: const TextStyle(fontSize: 54),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
         
          7.height,
          Padding(
            padding: [0, 0].symmetricPadding,
            child: Text(
              product.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 12,
                height: 1.2,
                fontWeight: FontWeight.w700,
                color: Color(0xff31241f),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
