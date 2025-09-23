import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:game_day_valet/services/logger_service.dart';

class SecureStorageService {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  static const String _tokenKey = 'token';

  Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  Future<String?> getToken() async {
    try {
      return await _storage.read(key: _tokenKey);
    } catch (e) {
      logger.warning(
          'Failed to read token from secure storage, clearing storage: $e');
      // If decryption fails (due to signing change), clear all data
      await clear();
      return null;
    }
  }

  Future<bool> hasToken() async {
    try {
      return await _storage.containsKey(key: _tokenKey);
    } catch (e) {
      logger.warning('Failed to check token existence, clearing storage: $e');
      await clear();
      return false;
    }
  }

  Future<void> deleteToken() async {
    try {
      await _storage.delete(key: _tokenKey);
    } catch (e) {
      logger.warning('Failed to delete token, clearing all: $e');
      await clear();
    }
  }

  Future<void> clear() async {
    try {
      await _storage.deleteAll();
    } catch (e) {
      logger.error('Failed to clear secure storage: $e');
    }
  }
}
