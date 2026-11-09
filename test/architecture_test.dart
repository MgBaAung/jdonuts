import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive.dart';
import 'package:jdonutscodetest/core/local/j_donuts_local_data_source.dart';
import 'package:jdonutscodetest/core/session/hive_session_store.dart';
import 'package:jdonutscodetest/features/auth/domain/auth_validators.dart';
import 'package:jdonutscodetest/features/product/data/product_dto.dart';

void main() {
  group('local architecture', () {
    late Directory directory;
    late Box<dynamic> box;
    late JDonutsLocalDataSource localDataSource;

    setUp(() async {
      directory = await Directory.systemTemp.createTemp('jdonuts_hive_test');
      Hive.init(directory.path);
      box = await Hive.openBox<dynamic>('j_donuts');
      localDataSource = JDonutsLocalDataSource(box: box);
    });

    tearDown(() async {
      await box.close();
      await Hive.deleteFromDisk();
      await directory.delete(recursive: true);
    });

    test('product DTO maps the Hive record into a domain entity', () {
      final product = ProductDto.fromMap(_productMap).toDomain();

      expect(product.id, 'pink-sprinkle');
      expect(product.name, 'Strawberry Sprinkle');
      expect(product.price, 3500);
      expect(
        product.imageUrl,
        'https://images.unsplash.com/photo-1685779923926-e9edebbb133d?auto=format&fit=crop&w=900&q=85',
      );
    });

    test('Hive session store writes, reads, and clears the session', () async {
      final session = HiveSessionStore(localDataSource);

      await session.writePhone('+959254135592');
      expect(await session.readPhone(), '+959254135592');

      await session.clear();
      expect(await session.readPhone(), isNull);
    });
  });

  group('auth validators', () {
    test('normalizes and accepts a Myanmar mobile number', () {
      expect(AuthValidators.normalizePhone('09254135592'), '+959254135592');
      expect(AuthValidators.isValidPhone('09254135592'), isTrue);
    });

    test('rejects invalid OTPs and underage registration dates', () {
      expect(AuthValidators.isValidOtp('000000'), isFalse);
      expect(
        AuthValidators.validateBirthDate(
          DateTime(2018, 1, 1),
          today: DateTime(2026, 1, 1),
        ),
        'You must be at least 13',
      );
    });
  });
}

const _productMap = <String, dynamic>{
  'id': 'pink-sprinkle',
  'code': 'DON-001',
  'name': 'Strawberry Sprinkle',
  'description': 'Strawberry glaze and colorful sprinkles.',
  'priceMmk': 3500,
  'color': 4294567387,
  'emoji': '🍩',
  'imageUrl': 'https://images.unsplash.com/photo-1685779923926-e9edebbb133d?auto=format&fit=crop&w=900&q=85',
  'isNew': true,
  'discountPercent': 15,
};
