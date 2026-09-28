// signup_usecase.dart
import '../entities/user_entity.dart';
import '../repository/auth_repository.dart';

class SignUpUseCase {
  final AuthRepository repository; // <- use repository interface

  SignUpUseCase(this.repository);

  Future<UserEntity> call({
    required String name,
    required String email,
    required String password,
  }) {
    return repository.signUp(name: name, email: email, password: password);
  }
}
