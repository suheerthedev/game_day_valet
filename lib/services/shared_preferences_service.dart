import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

/// A thin wrapper around [SharedPreferences] to be used via the app locator.
///
/// All methods are asynchronous to ensure the underlying preferences instance
/// is initialized on first use without requiring a separate init step.
class SharedPreferencesService {
  late SharedPreferences _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Primitive types
  Future<bool> setString(String key, String value) async {
    final prefs = _prefs;
    return prefs.setString(key, value);
  }

  Future<String?> getString(String key) async {
    final prefs = _prefs;
    return prefs.getString(key);
  }

  Future<bool> setBool(String key, bool value) async {
    final prefs = _prefs;
    return prefs.setBool(key, value);
  }

  Future<bool?> getBool(String key) async {
    final prefs = _prefs;
    return prefs.getBool(key);
  }

  Future<bool> setInt(String key, int value) async {
    final prefs = _prefs;
    return prefs.setInt(key, value);
  }

  Future<int?> getInt(String key) async {
    final prefs = _prefs;
    return prefs.getInt(key);
  }

  Future<bool> setDouble(String key, double value) async {
    final prefs = _prefs;
    return prefs.setDouble(key, value);
  }

  Future<double?> getDouble(String key) async {
    final prefs = _prefs;
    return prefs.getDouble(key);
  }

  Future<bool> setStringList(String key, List<String> value) async {
    final prefs = _prefs;
    return prefs.setStringList(key, value);
  }

  Future<List<String>?> getStringList(String key) async {
    final prefs = _prefs;
    return prefs.getStringList(key);
  }

  // JSON helpers
  Future<bool> setJson(String key, Map<String, dynamic> value) async {
    return setString(key, jsonEncode(value));
  }

  Future<Map<String, dynamic>?> getJson(String key) async {
    final raw = await getString(key);
    if (raw == null) return null;
    try {
      final decoded = jsonDecode(raw);
      if (decoded is Map<String, dynamic>) {
        return Map<String, dynamic>.from(decoded);
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  Future<bool> setObject<T>(
    String key,
    T value,
    Map<String, dynamic> Function(T value) toJson,
  ) async {
    return setString(key, jsonEncode(toJson(value)));
  }

  Future<T?> getObject<T>(
    String key,
    T Function(Map<String, dynamic> json) fromJson,
  ) async {
    final jsonMap = await getJson(key);
    if (jsonMap == null) return null;
    return fromJson(jsonMap);
  }

  // Utilities
  Future<bool> hasKey(String key) async {
    final prefs = _prefs;
    return prefs.containsKey(key);
  }

  Future<bool> remove(String key) async {
    final prefs = _prefs;
    return prefs.remove(key);
  }

  Future<bool> clear() async {
    final prefs = _prefs;
    return prefs.clear();
  }
}
