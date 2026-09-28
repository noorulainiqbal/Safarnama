// lib/features/auth/data/datasource/auth_remote_datasource.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class AuthRemoteDataSource {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserModel> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    UserCredential userCredential = await _firebaseAuth
        .createUserWithEmailAndPassword(email: email, password: password);

    // Update display name
    await userCredential.user?.updateDisplayName(name);
    await userCredential.user?.reload();

    final user = _firebaseAuth.currentUser;

    // Send verification email logic is handled by the Notifier/UI layer explicitly

    // Create new user in Firestore
    UserModel newUser = UserModel(
      uid: user!.uid,
      email: email,
      displayName: name,
    );
    await _firestore.collection('users').doc(user.uid).set(newUser.toMap());

    return newUser;
  }

  Future<UserModel> signIn({
    required String email,
    required String password,
  }) async {
    UserCredential userCredential = await _firebaseAuth
        .signInWithEmailAndPassword(email: email, password: password);

    // Check email verification
    final user = _firebaseAuth.currentUser;
    if (user != null && !user.emailVerified) {
      throw FirebaseAuthException(
        code: 'email-not-verified',
        message: 'Please verify your email before signing in.',
      );
    }

    return UserModel.fromFirebaseUser(userCredential.user!);
  }

  Future<void> resetPassword({required String email}) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message ?? 'Failed to send reset email');
    }
  }

  Future<void> resendVerificationEmail() async {
    final user = _firebaseAuth.currentUser;
    if (user != null && !user.emailVerified) {
      await user.sendEmailVerification();
    } else {
      throw Exception('User not found or already verified');
    }
  }

  UserModel? getCurrentUser() {
    final user = _firebaseAuth.currentUser;
    if (user != null) {
      return UserModel.fromFirebaseUser(user);
    }
    return null;
  }

  Stream<UserModel?> authStateChanges() {
    return _firebaseAuth.authStateChanges().map((user) {
      if (user != null) return UserModel.fromFirebaseUser(user);
      return null;
    });
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  Future<void> sendEmailVerification() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null && !user.emailVerified) {
      await user.sendEmailVerification();
    }
  }

  Future<bool> isEmailVerified() async {
    final user = FirebaseAuth.instance.currentUser;
    await user?.reload(); // refresh verification status
    return user?.emailVerified ?? false;
  }
}
