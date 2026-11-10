import 'package:flutter_test/flutter_test.dart';
import 'package:jdonutscodetest/features/auth/domain/auth_validators.dart';

void main() {
  group('AuthValidators phone rules', () {
    test('normalizes Myanmar local and international phone formats', () {
      expect(AuthValidators.normalizePhone('09 254 135 592'), '+959254135592');
      expect(
        AuthValidators.normalizePhone('+95 9 254 135 592'),
        '+959254135592',
      );
      expect(AuthValidators.isValidPhone('+959254135592'), isTrue);
    });

    test('rejects phone numbers outside the supported Myanmar format', () {
      expect(AuthValidators.isValidPhone(''), isFalse);
      expect(AuthValidators.isValidPhone('123456789'), isFalse);
      expect(AuthValidators.isValidPhone('09123'), isFalse);
    });
  });

  group('AuthValidators name rules', () {
    test('requires a first name but permits an optional empty last name', () {
      expect(
        AuthValidators.validateName('', requiredName: true),
        'This field is required',
      );
      expect(AuthValidators.validateName('', requiredName: false), isNull);
      expect(
        AuthValidators.validateName('  Hania  ', requiredName: true),
        isNull,
      );
    });

    test(
      'accepts Myanmar letters and rejects punctuation or overlong names',
      () {
        expect(AuthValidators.validateName('မေမေ', requiredName: true), isNull);
        expect(
          AuthValidators.validateName('Hania2', requiredName: true),
          'Use letters and spaces only',
        );
        expect(
          AuthValidators.validateName('a' * 51, requiredName: true),
          'Use 50 characters or fewer',
        );
      },
    );
  });

  group('AuthValidators birth date and OTP rules', () {
    test('checks missing, future, and age boundary dates', () {
      final today = DateTime(2026, 11, 10);
      expect(
        AuthValidators.validateBirthDate(null, today: today),
        'Select your date of birth',
      );
      expect(
        AuthValidators.validateBirthDate(DateTime(2026, 11, 11), today: today),
        'Date cannot be in the future',
      );
      expect(
        AuthValidators.validateBirthDate(DateTime(2013, 11, 11), today: today),
        'You must be at least 13',
      );
      expect(
        AuthValidators.validateBirthDate(DateTime(2013, 11, 10), today: today),
        isNull,
      );
    });

    test('accepts only the configured six-digit demo OTP', () {
      expect(AuthValidators.isValidOtp(demoOtp), isTrue);
      expect(AuthValidators.isValidOtp('12345'), isFalse);
      expect(AuthValidators.isValidOtp('123457'), isFalse);
      expect(AuthValidators.isValidOtp('abcdef'), isFalse);
    });
  });
}
