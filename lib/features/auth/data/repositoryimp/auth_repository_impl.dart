// lib/features/auth/data/repositoryimp/auth_repository_impl.dart
import '../../domain/entities/user_entity.dart';
import '../datasource/auth_remote_datasource.dart';

import '../../domain/repository/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remote;

  AuthRepositoryImpl({required this.remote});

  @override
  Future<UserEntity> signUp({
    required String name,
    required String email,
    required String password,
  }) {
    return remote.signUp(name: name, email: email, password: password);
  }

  @override
  Future<UserEntity> signIn({required String email, required String password}) {
    return remote.signIn(email: email, password: password);
  }

  @override
  Future<void> resetPassword({required String email}) {
    return remote.resetPassword(email: email);
  }

  @override
  UserEntity? getCurrentUser() => remote.getCurrentUser();

  @override
  Stream<UserEntity?> authStateChanges() => remote.authStateChanges();

  @override
  Future<void> signOut() => remote.signOut();

  @override
  Future<void> sendEmailVerification() => remote.sendEmailVerification();

  @override
  Future<bool> isEmailVerified() => remote.isEmailVerified();
}
