import 'package:flutter/material.dart';
import 'package:task_managment/service/auth_service.dart';
import 'package:task_managment/service/hive_service.dart';

class AuthProvider with ChangeNotifier {
  bool _isLoggedIn = false;
  bool get isLoggedIn => _isLoggedIn;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<bool> login(String email, String password) async {
    _setLoading(true);
    try {
      final response = await AuthService.login(email, password);
      if (response['success']) {
        await HiveService.saveUserSession(email, response['token']);
        _isLoggedIn = true;
      } else {
        _errorMessage = response['error'];
        _isLoggedIn = false;
      }
    } catch (e) {
      _errorMessage = 'Login failed: $e';
    } finally {
      _setLoading(false);
    }
    return _isLoggedIn;
  }

  Future<bool> register(String email, String password) async {
    _setLoading(true);
    try {
      final response = await AuthService.register(email, password);
      if (response['success']) {
        await HiveService.saveUserSession(email, response['token']);
        _isLoggedIn = true;
      } else {
        _errorMessage = response['error'];
        _isLoggedIn = false;
      }
    } catch (e) {
      _errorMessage = 'Registration failed: $e';
    } finally {
      _setLoading(false);
    }
    return _isLoggedIn;
  }

  void logout() async {
    HiveService.clearSession();
    _isLoggedIn = false;
    notifyListeners();
  }

  Future<void> checkSession() async {
    final email = await HiveService.getUserSession();
    _isLoggedIn = email != null;
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
