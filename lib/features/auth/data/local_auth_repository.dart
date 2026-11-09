import '../../../core/local/j_donuts_local_data_source.dart';
import '../../../core/result.dart';
import '../../../core/session/session_store.dart';
import '../domain/auth_entity.dart';
import '../domain/auth_repo.dart';
import 'auth_profile_dto.dart';

class LocalAuthRepository implements AuthRepository {
  LocalAuthRepository(this._localDataSource, this._sessionStore);

  final JDonutsLocalDataSource _localDataSource;
  final SessionStore _sessionStore;

  @override
  Future<Result<bool>> isRegistered(String phone) async {
    try {
      return Success(await _localDataSource.readMember(phone) != null);
    } catch (error) {
      return Failed(mapFailure(error));
    }
  }

  @override
  Future<Result<void>> register(AuthEntity member) async {
    try {
      await _localDataSource.writeMember(
        member.phone,
        AuthProfileDto.fromDomain(member).toMap(),
      );
      await _sessionStore.writePhone(member.phone);
      return const Success(null);
    } catch (error) {
      return Failed(mapFailure(error));
    }
  }

  @override
  Future<Result<void>> login(String phone) async {
    try {
      await _sessionStore.writePhone(phone);
      return const Success(null);
    } catch (error) {
      return Failed(mapFailure(error));
    }
  }

  @override
  Future<Result<void>> logout() async {
    try {
      await _sessionStore.clear();
      return const Success(null);
    } catch (error) {
      return Failed(mapFailure(error));
    }
  }

  @override
  Future<Result<String?>> currentPhone() async {
    try {
      return Success(await _sessionStore.readPhone());
    } catch (error) {
      return Failed(mapFailure(error));
    }
  }

  @override
  Future<Result<AuthEntity?>> profile(String phone) async {
    try {
      final data = await _localDataSource.readMember(phone);
      return Success(
        data == null
            ? null
            : AuthProfileDto.fromMap(data, phone: phone).toDomain(),
      );
    } catch (error) {
      return Failed(mapFailure(error));
    }
  }
}
