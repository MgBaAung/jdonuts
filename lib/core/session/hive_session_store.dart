import '../local/j_donuts_local_data_source.dart';
import 'session_store.dart';

/// Persists the signed-in phone in the application's Hive source of truth.
class HiveSessionStore implements SessionStore {
  const HiveSessionStore(this._localDataSource);

  final JDonutsLocalDataSource _localDataSource;

  @override
  Future<String?> readPhone() async =>
      await _localDataSource.readSessionPhone();

  @override
  Future<void> writePhone(String phone) =>
      _localDataSource.writeSessionPhone(phone);

  @override
  Future<void> clear() => _localDataSource.clearSessionPhone();
}
