import '../../../core/result.dart';
import 'auth_entity.dart';
import 'auth_repo.dart';
import 'auth_validators.dart';

/// Application actions for local authentication and member profile access.
class AuthUsecase {
  const AuthUsecase(this._repository);
  final AuthRepository _repository;

  Future<Result<bool>> loginIfRegistered(String phone) async {
    final normalized = AuthValidators.normalizePhone(phone);
    if (!AuthValidators.isValidPhone(normalized)) {
      return const Failed(
        ValidationFailure('Invalid Myanmar phone number.'),
      );
    }

    final registered = await _repository.isRegistered(normalized);
    if (registered case Failed<bool>()) return registered;
    final exists = (registered as Success<bool>).value;
    if (!exists) return const Success(false);

    final login = await _repository.login(normalized);
    return switch (login) {
      Success<void>() => const Success(true),
      Failed<void>(:final failure) => Failed(failure),
    };
  }

  Future<Result<void>> verifyOtp(String code) async {
    if (code.length != 6) {
      return const Failed(ValidationFailure('Enter the 6-digit code.'));
    }
    if (!AuthValidators.isValidOtp(code)) {
      return const Failed(ValidationFailure('Incorrect code.'));
    }
    return const Success(null);
  }

  Future<Result<void>> register({
    required String phone,
    required String firstName,
    required String lastName,
    required DateTime birthDate,
  }) async {
    final normalized = AuthValidators.normalizePhone(phone);
    final validation = !AuthValidators.isValidPhone(normalized)
        ? 'Invalid Myanmar phone number.'
        : AuthValidators.validateName(firstName, requiredName: true) ??
              AuthValidators.validateName(lastName, requiredName: false) ??
              AuthValidators.validateBirthDate(birthDate);
    if (validation != null) return Failed(ValidationFailure(validation));

    return _repository.register(
      AuthEntity(
        phone: normalized,
        firstName: firstName.trim(),
        lastName: lastName.trim(),
        birthDate: birthDate,
      ),
    );
  }

  Future<Result<String?>> currentPhone() => _repository.currentPhone();
  Future<Result<AuthEntity?>> profile(String phone) =>
      _repository.profile(phone);
  Future<Result<void>> logout() => _repository.logout();
}
