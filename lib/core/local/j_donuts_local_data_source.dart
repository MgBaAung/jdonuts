import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:hive_ce/hive.dart';

/// Hive-backed catalog and member profiles, seeded from bundled JSON.
class JDonutsLocalDataSource {
  JDonutsLocalDataSource({required this._box, AssetBundle? bundle})
    : _bundle = bundle ?? rootBundle;

  static const currentSchemaVersion = 1;

  final Box<dynamic> _box;
  final AssetBundle _bundle;

  Future<void> ensureMigrated() async {
    final version = _box.get('schema_version') as int? ?? 0;
    if (version >= currentSchemaVersion) return;
    await _box.put('schema_version', currentSchemaVersion);
  }

  Future<Map<String, dynamic>> _readSeed() async {
    final cached = _box.get('store_seed');
    if (cached is Map) return Map<String, dynamic>.from(cached);
    final decoded = jsonDecode(
      await _bundle.loadString('assets/data/store_seed.json'),
    );
    if (decoded is! Map) {
      throw const FormatException(
        'The local store seed must be a JSON object.',
      );
    }
    final seed = Map<String, dynamic>.from(decoded);
    await _box.put('store_seed', seed);
    return seed;
  }

  Future<List<Map<String, dynamic>>> readMapList(String key) async {
    final stored = _box.get(key);
    if (stored is List) return _decodeMapList(stored, key);

    final seed = await _readSeed();
    final seededRows = seed[key];
    if (seededRows is! List) {
      throw FormatException('Missing list "$key" in the local store seed.');
    }
    final rows = _decodeMapList(seededRows, key);
    await _box.put(key, rows);
    return rows;
  }

  Future<List<String>> readStringList(String key) async {
    final stored = _box.get(key);
    if (stored is List) return _decodeStringList(stored, key);

    final seed = await _readSeed();
    final seededItems = seed[key];
    if (seededItems is! List) {
      throw FormatException('Missing list "$key" in the local store seed.');
    }
    final values = _decodeStringList(seededItems, key);
    await _box.put(key, values);
    return values;
  }

  Future<Map<String, dynamic>?> readMember(String phone) async {
    final value = _box.get('member:$phone');
    if (value == null) return null;
    if (value is! Map) {
      throw const FormatException('Invalid local member data.');
    }
    return Map<String, dynamic>.from(value);
  }

  Future<void> writeMember(String phone, Map<String, dynamic> profile) async {
    await _box.put('member:$phone', profile);
  }

  Future<String?> readSessionPhone() async =>
      _box.get('session_phone') as String?;

  Future<void> writeSessionPhone(String phone) async {
    await _box.put('session_phone', phone);
  }

  Future<void> clearSessionPhone() async {
    await _box.delete('session_phone');
  }

  List<Map<String, dynamic>> _decodeMapList(List<dynamic> rows, String key) =>
      rows
          .map((row) {
            if (row is! Map) throw FormatException('Invalid item in "$key".');
            return Map<String, dynamic>.from(row);
          })
          .toList(growable: false);

  List<String> _decodeStringList(List<dynamic> values, String key) => values
      .map((value) {
        if (value is! String) throw FormatException('Invalid item in "$key".');
        return value;
      })
      .toList(growable: false);
}
