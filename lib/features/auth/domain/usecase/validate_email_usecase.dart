// lib/features/auth/domain/usecase/validate_email_usecase.dart
class ValidateEmailUseCase {
  // returns null if valid, otherwise error message
  String? call(String email) {
    final pattern = RegExp(
      r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}"
      r"[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}"
      r"[a-zA-Z0-9])?)*$",
    );
    if (email.trim().isEmpty) return 'Email required';
    if (!pattern.hasMatch(email.trim())) return 'Invalid email';
    return null;
  }
}
