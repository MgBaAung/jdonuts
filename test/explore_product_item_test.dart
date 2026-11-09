import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jdonutscodetest/features/home/presentation/component/explore_product_item.dart';
import 'package:jdonutscodetest/features/product/domain/product.dart';

void main() {
  testWidgets('explore card presents product details and opens its action', (
    tester,
  ) async {
    var tapped = false;
    final product = DonutProduct(
      id: 'blueberry',
      code: 'DON-002',
      name: 'Blueberry Glaze',
      description: 'A fluffy donut with a smooth blueberry glaze.',
      price: 3800,
      color: 0xff8580ef,
      emoji: '🫐',
      imageUrl: '',
      isExploreNow: true,
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            height: 310,
            child: ExploreProductItem(
              product: product,
              onTap: () => tapped = true,
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Blueberry Glaze'), findsOneWidget);
    expect(
      find.text('A fluffy donut with a smooth blueberry glaze.'),
      findsOneWidget,
    );
    expect(find.text('Order Online'), findsOneWidget);

    await tester.tap(find.text('Order Online'));
    expect(tapped, isTrue);
  });
}
