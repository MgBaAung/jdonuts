import 'package:flutter_test/flutter_test.dart';
import 'package:jdonutscodetest/core/result.dart';
import 'package:jdonutscodetest/features/auth/domain/auth_entity.dart';
import 'package:jdonutscodetest/features/auth/domain/auth_repo.dart';
import 'package:jdonutscodetest/features/auth/domain/auth_usecase.dart';

void main() {
  late _MemoryAuthRepository repository;
  late AuthUsecase usecase;

  setUp(() {
    repository = _MemoryAuthRepository();
    usecase = AuthUsecase(repository);
  });

  test(
    'registration normalizes the phone and persists trimmed profile data',
    () async {
      final result = await usecase.register(
        phone: '09254135592',
        firstName: ' Hania ',
        lastName: ' Tester ',
        birthDate: DateTime(2000, 1, 1),
      );

      expect(result, isA<Success<void>>());
      expect(repository.saved?.phone, '+959254135592');
      expect(repository.saved?.firstName, 'Hania');
      expect(repository.saved?.lastName, 'Tester');
    },
  );

  test('rejects invalid profile data before calling the repository', () async {
    final result = await usecase.register(
      phone: '123',
      firstName: '',
      lastName: '',
      birthDate: DateTime(2000, 1, 1),
    );

    expect(result, isA<Failed<void>>());
    expect(repository.saved, isNull);
  });

  test('login only creates a session for an existing member', () async {
    repository.registeredPhones.add('+959254135592');

    final result = await usecase.loginIfRegistered('09254135592');

    expect(result, const Success<bool>(true));
    expect(repository.current, '+959254135592');

    final missing = await usecase.loginIfRegistered('09250000000');
    expect(missing, const Success<bool>(false));
    expect(repository.current, '+959254135592');
  });
}

class _MemoryAuthRepository implements AuthRepository {
  final registeredPhones = <String>{};
  final profiles = <String, AuthEntity>{};
  AuthEntity? saved;
  String? current;

  @override
  Future<Result<String?>> currentPhone() async => Success(current);

  @override
  Future<Result<AuthEntity?>> profile(String phone) async =>
      Success(profiles[phone]);

  @override
  Future<Result<bool>> isRegistered(String phone) async =>
      Success(registeredPhones.contains(phone));

  @override
  Future<Result<bool>> login(String phone) async {
    current = phone;
    return const Success(true);
  }

  @override
  Future<Result<void>> logout() async {
    current = null;
    return const Success(null);
  }

  @override
  Future<Result<void>> register(AuthEntity member) async {
    saved = member;
    profiles[member.phone] = member;
    registeredPhones.add(member.phone);
    current = member.phone;
    return const Success(null);
  }
}
