import 'package:hive_flutter/hive_flutter.dart';

class HiveService {
  static Box? _sessionBox;
  static const String _boxName = 'session';
  static const String _emailKey = 'email';
  static const String _tokenKey = 'token';

  static Future<void> init() async {
    if (!Hive.isAdapterRegistered(0)) {
      await Hive.initFlutter();
    }
    _sessionBox = await Hive.openBox(_boxName);
  }

  static Future<void> _ensureInitialized() async {
    if (_sessionBox == null || !_sessionBox!.isOpen) {
      await init();
    }
  }

  static Future<void> saveUserSession(String email, String token) async {
    await _ensureInitialized();
    await _sessionBox!.put(_emailKey, email);
    await _sessionBox!.put(_tokenKey, token);
  }

  static Future<String?> getUserSession() async {
    await _ensureInitialized();
    return _sessionBox!.get(_emailKey);
  }

  static Future<String?> getToken() async {
    await _ensureInitialized();
    return _sessionBox!.get(_tokenKey);
  }

  static Future<void> clearSession() async {
    await _ensureInitialized();
    await _sessionBox!.clear();
  }
}
