/// Framework-independent member profile captured during registration.
class AuthEntity {
  const AuthEntity({
    required this.phone,
    required this.firstName,
    required this.lastName,
    this.birthDate,
    this.points = 680000,
    this.tier = 'Silver',
    this.nextTierPoints = 1000000,
    this.notifications = 0,
  });
  final String phone;
  final String firstName;
  final String lastName;
  final DateTime? birthDate;
  final int points;
  final String tier;
  final int nextTierPoints;
  final int notifications;
}
