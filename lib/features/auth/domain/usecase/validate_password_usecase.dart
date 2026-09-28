// lib/features/auth/domain/usecase/validate_password_usecase.dart
class ValidatePasswordUseCase {
  // returns null if valid, otherwise error message
  String? call(String password) {
    if (password.isEmpty) return 'Password required';
    if (password.length < 8) return 'Password must be at least 8 characters';
    final pattern = RegExp(
      r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*#?&^~_.,;:])[A-Za-z\d@$!%*#?&^~_.,;:]{8,}$',
    );
    if (!pattern.hasMatch(password)) {
      return 'Use letters, numbers and a special character';
    }
    return null;
  }
}
