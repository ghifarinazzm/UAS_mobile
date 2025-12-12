import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
  bool _isLoggedIn = false;
  String _userRole = 'guest'; // 'admin' atau 'user'
  String _username = '';

  bool get isLoggedIn => _isLoggedIn;
  String get userRole => _userRole;
  String get username => _username;

  // Fungsi Login Simulasi
  bool login(String username, String password) {
    // Simulasi Cek Database
    if (username == 'admin' && password == 'admin') {
      _isLoggedIn = true;
      _userRole = 'admin';
      _username = 'Administrator';
      notifyListeners();
      return true;
    } else if (username == 'user' && password == 'user') {
      _isLoggedIn = true;
      _userRole = 'user';
      _username = 'Pengguna Biasa';
      notifyListeners();
      return true;
    }
    
    // Login Gagal
    return false;
  }

  void logout() {
    _isLoggedIn = false;
    _userRole = 'guest';
    _username = '';
    notifyListeners();
  }
}