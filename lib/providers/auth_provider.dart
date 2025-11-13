import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
  bool _isAuthenticated = false;
  Map<String, dynamic>? _userData;

  bool get isAuthenticated => _isAuthenticated;
  Map<String, dynamic>? get userData => _userData;

  // Mock user object for compatibility
  Map<String, dynamic>? get user => _userData;

  // Mock user data for demonstration
  Map<String, dynamic> get mockUserData => {
    'uid': 'mock-user-123',
    'name': 'John Doe',
    'email': 'john.doe@example.com',
    'phone': '+1234567890',
    'userType': 'patient',
    'profileImage': null,
    'address': '123 Main St, City, State',
  };

  AuthProvider() {
    // Initialize with mock authenticated state for demo
    _isAuthenticated = true; // Start authenticated for demo
    _userData = mockUserData;
  }

  Future<bool> login(String email, String password) async {
    // Simulate login delay
    await Future.delayed(const Duration(seconds: 1));

    // Mock login - accept any email/password for demo
    if (email.isNotEmpty && password.isNotEmpty) {
      _isAuthenticated = true;
      _userData = mockUserData;
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<bool> register(String email, String password, Map<String, dynamic> userData) async {
    // Simulate registration delay
    await Future.delayed(const Duration(seconds: 1));

    // Mock registration - accept any data for demo
    if (email.isNotEmpty && password.isNotEmpty) {
      _isAuthenticated = true;
      _userData = {
        ...userData,
        'email': email,
        'userType': userData['userType'] ?? 'patient',
      };
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<void> logout() async {
    // Simulate logout delay
    await Future.delayed(const Duration(milliseconds: 500));
    _isAuthenticated = false;
    _userData = null;
    notifyListeners();
  }

  // Method to simulate login for demo purposes
  void demoLogin() {
    _isAuthenticated = true;
    _userData = mockUserData;
    notifyListeners();
  }
}
