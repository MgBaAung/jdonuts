import 'package:flutter/material.dart';
import 'package:jdonutscodetest/global/app_theme.dart';
import 'package:jdonutscodetest/global/extension/num_extension.dart';
import 'package:jdonutscodetest/global/extension/text_extension.dart';

import '../../shared/motion.dart';
import '../domain/product.dart';
import '../../shared/presentation/widgets.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key, required this.product});
  final DonutProduct product;
  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final total = product.price * quantity;
    return Scaffold(
      backgroundColor: const Color(0xfff4f5f7),
      body: SafeArea(
        child: Padding(
          padding: [16, 24].symmetricPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: 20.bottomSpacing,
                child: GestureDetector(
                  onTap: () => Navigator.of(context).maybePop(),
                  child: const Icon(Icons.arrow_back),
                ),
              ),
              Expanded(
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Positioned.fill(
                      bottom: 14,
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(13),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        product.code,
                                        style: context.light(
                                          fSize: 9,
                                          color: const Color(0xff999da3),
                                        ),
                                      ),
                                      const SizedBox(height: 3),
                                      Text(
                                        product.name,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: context
                                            .bold(fSize: 18, color: ink)
                                            .copyWith(height: 1.05),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '${formatMMK(product.price)} MMK',
                                        style: context.semibold(
                                          fSize: 10,
                                          color: ink,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                if (product.isNew)
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 5,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xffff8736),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      'New',
                                      style: context.semibold(
                                        fSize: 9,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            Expanded(
                              child: Center(
                                child: Hero(
                                  tag: product.id,
                                  child: CachedImage(
                                    url: product.imageUrl,
                                    fallbackAsset: product.imageAsset,
                                    width: 166,
                                    height: 166,
                                    fit: BoxFit.contain,
                                    fallback: Text(
                                      product.emoji,
                                      style: const TextStyle(fontSize: 72),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xfff0f2f3),
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(color: Colors.white, width: 5),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _QuantityButton(
                                icon: Icons.remove,
                                enabled: quantity > 1,
                                onTap: () => setState(() => quantity--),
                              ),
                              const SizedBox(width: 14),
                              AnimatedSwitcher(
                                duration: MotionDurations.tabSwitch,
                                transitionBuilder: (child, animation) =>
                                    ScaleTransition(
                                      scale: animation,
                                      child: child,
                                    ),
                                child: Text(
                                  '$quantity',
                                  key: ValueKey(quantity),
                                  style: context.bold(fSize: 14, color: ink),
                                ),
                              ),
                              const SizedBox(width: 14),
                              _QuantityButton(
                                icon: Icons.add,
                                enabled: true,
                                onTap: () => setState(() => quantity++),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              50.height,
              SizedBox(
                height: 150,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 13,
                            height: 13,
                            decoration: const BoxDecoration(
                              color: Color(0xff89bf45),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.question_mark_rounded,
                              size: 9,
                              color: Colors.white,
                            ),
                          ),
                          3.height,
                          Text(
                            'What’s\nthis?',
                            style: context.semibold(fSize: 10, color: ink),
                          ),
                        ],
                      ),
                    ),
                    8.width,
                    Container(width: 3, height: 100, color: Colors.white),
                    8.width,
                    Expanded(
                      child: SingleChildScrollView(
                        child: Text(
                          product.description,
                          style: context
                              .light(fSize: 14, color: const Color(0xff85878c))
                              .copyWith(height: 1.45),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 8, 10, 12),
                child: AuthPrimaryButton(
                  text: 'Add to cart  ·  ${formatMMK(total)} MMK',
                  onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        '$quantity ${product.name} added · ${formatMMK(total)} MMK',
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuantityButton extends StatelessWidget {
  const _QuantityButton({
    required this.icon,
    required this.enabled,
    required this.onTap,
  });
  final IconData icon;
  final bool enabled;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => InkWell(
    onTap: enabled ? onTap : null,
    borderRadius: BorderRadius.circular(18),
    child: Container(
      width: 27,
      height: 27,
      decoration: BoxDecoration(
        color: enabled ? const Color(0xff56cade) : const Color(0xffe5e9ea),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, size: 16, color: Colors.white),
    ),
  );
}
