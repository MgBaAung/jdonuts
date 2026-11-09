const minimumRegistrationAge = 13;
const demoOtp = '123456';
const demoOtpPhone = '+959254135592';

/// Pure validation rules for the registration and login flow.
class AuthValidators {
  AuthValidators._();

  static String normalizePhone(String input) {
    var digits = input.replaceAll(RegExp(r'[^0-9]'), '');
    if (digits.startsWith('95')) digits = digits.substring(2);
    if (digits.startsWith('0')) digits = digits.substring(1);
    return '+95$digits';
  }

  static bool isValidPhone(String input) {
    final normalized = normalizePhone(input);
    return RegExp(r'^\+959[0-9]{7,9}$').hasMatch(normalized);
  }

  static String? validateName(String input, {required bool requiredName}) {
    final value = input.trim();
    if (value.isEmpty) return requiredName ? 'This field is required' : null;
    if (value.length > 50) return 'Use 50 characters or fewer';
    if (!RegExp(r"^[\p{L}\p{M} ]+$", unicode: true).hasMatch(value)) {
      return 'Use letters and spaces only';
    }
    return null;
  }

  static String? validateBirthDate(DateTime? date, {DateTime? today}) {
    if (date == null) return 'Select your date of birth';
    final now = today ?? DateTime.now();
    if (date.isAfter(now)) return 'Date cannot be in the future';
    var age = now.year - date.year;
    if (now.month < date.month || (now.month == date.month && now.day < date.day)) age--;
    if (age < minimumRegistrationAge) return 'You must be at least $minimumRegistrationAge';
    return null;
  }

  static bool isValidOtp(String value) => value == demoOtp;
}
