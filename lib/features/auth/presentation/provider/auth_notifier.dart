// lib/features/auth/presentation/provider/auth_notifier.dart
import 'package:flutter/material.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/usecase/signup_usecase.dart';
import '../../domain/usecase/signin_usecase.dart';
import '../../domain/usecase/reset_password_usecase.dart';
import '../../domain/usecase/validate_email_usecase.dart';
import '../../domain/usecase/validate_password_usecase.dart';
import '../../domain/usecase/signout_usecase.dart';
import '../../domain/usecase/get_current_user_usecase.dart';
import '../../domain/usecase/send_email_verification_usecase.dart';
import '../../domain/usecase/is_email_verified_usecase.dart';

class AuthNotifier extends ChangeNotifier {
  final SignUpUseCase signUpUseCase;
  final SignInUseCase signInUseCase;
  final ResetPasswordUseCase resetPasswordUseCase;
  final SignOutUseCase signOutUseCase;
  final GetCurrentUserUseCase getCurrentUserUseCase;
  final SendEmailVerificationUseCase sendEmailVerificationUseCase;
  final IsEmailVerifiedUseCase isEmailVerifiedUseCase;

  final ValidateEmailUseCase validateEmail = ValidateEmailUseCase();
  final ValidatePasswordUseCase validatePassword = ValidatePasswordUseCase();

  bool verificationEmailSent = false;
  UserEntity? currentUser;
  bool isLoading = false;
  String? errorMessage;

  AuthNotifier({
    required this.signUpUseCase,
    required this.signInUseCase,
    required this.resetPasswordUseCase,
    required this.signOutUseCase,
    required this.getCurrentUserUseCase,
    required this.sendEmailVerificationUseCase,
    required this.isEmailVerifiedUseCase,
  }) {
    currentUser = getCurrentUserUseCase();
  }

  void markVerificationEmailSent() {
    verificationEmailSent = true;
    notifyListeners();
  }

  Future<bool> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    errorMessage = null;

    final emailError = validateEmail(email);
    if (emailError != null) return _setError(emailError);

    final pwdError = validatePassword(password);
    if (pwdError != null) return _setError(pwdError);

    isLoading = true;
    notifyListeners();

    try {
      final user = await signUpUseCase.call(
        name: name,
        email: email,
        password: password,
      );

      currentUser = user;

      // Send verification email once
      await sendEmailVerificationUseCase();
      markVerificationEmailSent();

      isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      isLoading = false;
      notifyListeners();
      return _setError(e.toString());
    }
  }

  bool _setError(String msg) {
    errorMessage = msg;
    notifyListeners();
    return false;
  }

  Future<bool> signIn({required String email, required String password}) async {
    errorMessage = null;
    final emailError = validateEmail(email);
    if (emailError != null) {
      errorMessage = emailError;
      notifyListeners();
      return false;
    }
    if (password.isEmpty) {
      errorMessage = 'Password required';
      notifyListeners();
      return false;
    }

    isLoading = true;
    notifyListeners();

    try {
      final user = await signInUseCase.call(email: email, password: password);
      currentUser = user;

      // Check email verification
      final isVerified = await isEmailVerifiedUseCase();
      if (!isVerified) {
        await sendEmailVerificationUseCase(); // optional: resend email
        isLoading = false;
        notifyListeners();
        return _setError('Please verify your email before signing in');
      }

      isLoading = false;
      notifyListeners();
      return true;
    } on Exception catch (e) {
      isLoading = false;
      return _setError(e.toString());
    }
  }

  Future<bool> resetPassword({required String email}) async {
    errorMessage = null;
    final emailError = validateEmail(email);
    if (emailError != null) {
      errorMessage = emailError;
      notifyListeners();
      return false;
    }

    isLoading = true;
    notifyListeners();
    try {
      await resetPasswordUseCase.call(email: email);
      isLoading = false;
      notifyListeners();
      return true;
    } on Exception catch (e) {
      isLoading = false;
      errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<void> signOut() async {
    await signOutUseCase.call();
    currentUser = null;
    notifyListeners();
  }
}
