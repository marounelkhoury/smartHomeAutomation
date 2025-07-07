import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../core/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthProvider with ChangeNotifier {
  String? _username;
  String? _email;
  String? _phone;

  String? get username => _username;
  String? get email => _email;
  String? get phone => _phone;

  final AuthService _authService = AuthService();
  bool _isAuthenticated = false;
  bool _isLoading = true;
  User? _currentUser;

  bool get isAuthenticated => _isAuthenticated;
  bool get isLoading => _isLoading;
  User? get currentUser => _currentUser;

  Future<void> checkLoginStatus() async {
    final user = _authService.getCurrentUser();
    if (user != null) {
      _currentUser = user;
      _isAuthenticated = true;
      await loadUserProfile();
    } else {
      _isAuthenticated = false;
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    final user = await _authService.login(email, password);
    if (user != null) {
      _currentUser = user;
      _isAuthenticated = true;
      await loadUserProfile();
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<bool> register({
    required String email,
    required String password,
    required String username,
    required String phone,
  }) async {
    final user = await _authService.register(email, password);
    if (user != null) {
      _currentUser = user;
      _isAuthenticated = true;
      await loadUserProfile();


      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'uid': user.uid,
        'email': email,
        'username': username,
        'phone': phone,
      });

      notifyListeners();
      return true;
    }
    return false;
  }

  Future<void> loadUserProfile() async {
    if (_currentUser == null) return;

    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(_currentUser!.uid)
        .get();

    if (doc.exists) {
      final data = doc.data()!;
      _username = data['username'];
      _email = data['email'];
      _phone = data['phone'];
      notifyListeners();
    }
  }


  void logout() {
    _authService.logout();
    _currentUser = null;
    _isAuthenticated = false;
    notifyListeners();
  }
}
