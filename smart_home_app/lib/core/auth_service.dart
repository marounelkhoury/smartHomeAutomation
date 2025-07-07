import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Register user
  Future<User?> register(String email, String password) async {
    try {
      print('📤 [AuthService] Trying to register: $email');
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      print('✅ [AuthService] Registration success');
      return userCredential.user;
    } catch (e) {
      print('❌ [AuthService] Registration error: $e');
      return null;
    }
  }


  // Login user
  Future<User?> login(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      print("Login Error: $e");
      return null;
    }
  }

  // Logout user
  Future<void> logout() async {
    await _auth.signOut();
  }

  // Check if user is logged in
  User? getCurrentUser() {
    return _auth.currentUser;
  }
}
