// lib/features/auth/domain/repository/auth_repository.dart
import '../entities/user_entity.dart';

abstract class AuthRepository {
  Future<UserEntity> signUp({
    required String name,
    required String email,
    required String password,
  });
  Future<UserEntity> signIn({required String email, required String password});
  Future<void> resetPassword({required String email});
  UserEntity? getCurrentUser();
  Stream<UserEntity?> authStateChanges();
  Future<void> signOut();
  Future<void> sendEmailVerification();
  Future<bool> isEmailVerified();
}
