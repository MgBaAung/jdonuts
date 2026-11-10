import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jdonutscodetest/features/product/domain/product.dart';
import 'package:jdonutscodetest/features/product/presentation/product_screen.dart';

void main() {
  testWidgets('quantity changes update the total and cart confirmation', (
    tester,
  ) async {
    const product = DonutProduct(
      id: 'blueberry',
      code: 'DON-002',
      name: 'Blueberry Glaze',
      description: 'A fluffy donut topped with blueberry glaze.',
      price: 3800,
      color: 0xff8580ef,
      emoji: '🫐',
      imageUrl: '',
    );

    await tester.pumpWidget(
      const MaterialApp(home: ProductScreen(product: product)),
    );

    expect(find.text('Blueberry Glaze'), findsOneWidget);
    expect(find.text('1'), findsOneWidget);
    expect(find.text('3,800 MMK'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();

    expect(find.text('2'), findsOneWidget);
    expect(find.textContaining('7,600 MMK'), findsOneWidget);

    await tester.tap(find.textContaining('ADD TO CART'));
    await tester.pump();
    expect(find.text('2 Blueberry Glaze added · 7,600 MMK'), findsOneWidget);
  });
}
