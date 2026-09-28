// lib/services/auth_service.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Register
  Future<User?> register(
    String email,
    String password, {
    String? username,
  }) async {
    final cred = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    final user = cred.user!;
    await _db.collection('users').doc(user.uid).set({
      'email': email,
      'username': username ?? '',
      'createdAt': FieldValue.serverTimestamp(),
      'settings': {
        'aiExplanation': true,
        'articles': true,
        'pushNotifications': true,
      },
    });
    return user;
  }

  // Login
  Future<User?> login(String email, String password) async {
    final cred = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return cred.user;
  }

  // Forgot password
  Future<void> sendPasswordReset(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  // Logout
  Future<void> logout() async {
    await _auth.signOut();
  }

  // Get current user stream
  Stream<User?> authStateChanges() => _auth.authStateChanges();

  // Fetch user doc stream
  Stream<DocumentSnapshot<Map<String, dynamic>>> userDocStream(String uid) {
    return _db.collection('users').doc(uid).snapshots();
  }

  // Update profile (username)
  Future<void> updateUsername(String uid, String username) async {
    await _db.collection('users').doc(uid).update({'username': username});
  }
}
