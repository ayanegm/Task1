import 'package:flutter/material.dart';

class AuthService extends ChangeNotifier {
  static final instance = AuthService._();
  AuthService._();

  bool _isLoggedIn = false;
  bool get isLoggedIn => _isLoggedIn;
  void LogIn() {
    _isLoggedIn = true;
    notifyListeners();
  }

  void logOut() {
    _isLoggedIn = false;
    notifyListeners();
  }
}