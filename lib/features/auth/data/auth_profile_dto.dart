import '../domain/auth_entity.dart';

class AuthProfileDto {
  const AuthProfileDto({
    required this.phone,
    required this.firstName,
    required this.lastName,
    required this.birthDate,
    required this.points,
    required this.tier,
    required this.nextTierPoints,
    required this.notifications,
  });

  final String phone;
  final String firstName;
  final String lastName;
  final String? birthDate;
  final int points;
  final String tier;
  final int nextTierPoints;
  final int notifications;

  factory AuthProfileDto.fromMap(Map<dynamic, dynamic> map, {String? phone}) {
    T requiredValue<T>(String key) {
      final value = map[key];
      if (value is T) return value;
      throw FormatException('Invalid or missing member field "$key".');
    }

    return AuthProfileDto(
      phone: phone ?? requiredValue<String>('phone'),
      firstName: map['firstName'] as String? ?? '',
      lastName: map['lastName'] as String? ?? '',
      birthDate: map['birthDate'] as String?,
      points: map['points'] as int? ?? 680000,
      tier: map['tier'] as String? ?? 'Silver',
      nextTierPoints: map['nextTierPoints'] as int? ?? 1000000,
      notifications: map['notifications'] as int? ?? 0,
    );
  }

  factory AuthProfileDto.fromDomain(AuthEntity member) => AuthProfileDto(
    phone: member.phone,
    firstName: member.firstName,
    lastName: member.lastName,
    birthDate: member.birthDate?.toIso8601String(),
    points: member.points,
    tier: member.tier,
    nextTierPoints: member.nextTierPoints,
    notifications: member.notifications,
  );

  AuthEntity toDomain() => AuthEntity(
    phone: phone,
    firstName: firstName,
    lastName: lastName,
    birthDate: birthDate == null ? null : DateTime.tryParse(birthDate!),
    points: points,
    tier: tier,
    nextTierPoints: nextTierPoints,
    notifications: notifications,
  );

  Map<String, dynamic> toMap() => {
    'phone': phone,
    'firstName': firstName,
    'lastName': lastName,
    if (birthDate != null) 'birthDate': birthDate,
    'points': points,
    'tier': tier,
    'nextTierPoints': nextTierPoints,
    'notifications': notifications,
  };
}
