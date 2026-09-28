import '../repository/auth_repository.dart';

class IsEmailVerifiedUseCase {
  final AuthRepository repository;

  IsEmailVerifiedUseCase(this.repository);

  Future<bool> call() {
    return repository.isEmailVerified();
  }
}
