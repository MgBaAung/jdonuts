/// Abstraction for the signed-in phone stored by the data layer.
abstract interface class SessionStore {
  Future<String?> readPhone();
  Future<void> writePhone(String phone);
  Future<void> clear();
}

/// In-memory session used by tests and as a fallback.
class MemorySessionStore implements SessionStore {
  MemorySessionStore([this._phone]);
  String? _phone;

  @override
  Future<String?> readPhone() async => _phone;

  @override
  Future<void> writePhone(String phone) async => _phone = phone;

  @override
  Future<void> clear() async => _phone = null;
}
