import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenManager {
  final FlutterSecureStorage storage;

  TokenManager({required this.storage});
  Future<void> saveToken(String key, String token) async {
    await storage.write(key: key, value: token);
  }

  Future<String?> getToken(String key) async {
    final token = await storage.read(key: key);

    return token;
  }

  Future<void> deleteToken(String key) async {
    await storage.delete(key: key);
  }
}
