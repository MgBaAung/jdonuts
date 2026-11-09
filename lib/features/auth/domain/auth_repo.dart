import '../../../core/result.dart';
import 'auth_entity.dart';

abstract interface class AuthRepository {
  Future<Result<bool>> isRegistered(String phone);
  Future<Result<void>> register(AuthEntity member);
  Future<Result<void>> login(String phone);
  Future<Result<void>> logout();
  Future<Result<String?>> currentPhone();
  Future<Result<AuthEntity?>> profile(String phone);
}
