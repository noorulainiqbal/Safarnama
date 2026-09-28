// lib/features/auth/presentation/pages/forgotpassword.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/utils/size_extension.dart';
import '../../../../../core/resources/colors.dart';
import '../../../intro/presentation/widget/custombluebuttonwidget.dart';
import '../../../intro/presentation/widget/backarrowwidget.dart';
import '../widget/popup.dart';
import '../../presentation/provider/auth_notifier.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController emailController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  void showAutoClosePopup(BuildContext context) {
    final navigator = Navigator.of(context);

    // Show popup
    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withAlpha(80),
      builder: (_) => const CheckEmailDialog(),
    );

    // Close popup after 3 seconds and navigate back
    Future.delayed(const Duration(seconds: 3), () {
      navigator.pop(); // close popup
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthNotifier>();

    return Scaffold(
      backgroundColor: AppColors.white,
      body: Stack(
        children: [
          Positioned(
            top: context.h(57),
            left: context.w(20),
            child: BackArrowButton(onTap: () => Navigator.pop(context)),
          ),
          Positioned(
            top: context.h(56),
            left: context.w(20),
            right: context.w(20),
            bottom: context.h(20),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: context.h(84)),
                  SizedBox(
                    width: context.w(257),
                    child: Column(
                      children: [
                        Text(
                          'Forgot password',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'SF UI Display',
                            fontWeight: FontWeight.w600,
                            fontSize: context.sp(26),
                            height: 32 / 26,
                            color: AppColors.signinemailcolor,
                          ),
                        ),
                        SizedBox(height: context.h(14)),
                        Text(
                          'Enter your email account to reset your password',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'SF UI Display',
                            fontWeight: FontWeight.w400,
                            fontSize: context.sp(16),
                            height: 20 / 16,
                            color: AppColors.subtitleGrey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: context.h(40)),

                  // Email Field
                  Container(
                    width: double.infinity,
                    height: context.h(56),
                    decoration: BoxDecoration(
                      color: AppColors.signinbox,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: context.w(16)),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: emailController,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Email',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: context.h(40)),

                  // Reset Password Button
                  CustomBottomButton(
                    title: "Reset Password",
                    onPressed: () {
                      final email = emailController.text.trim();
                      if (email.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Please enter your email'),
                          ),
                        );
                        return;
                      }

                      final messenger = ScaffoldMessenger.of(context);

                      // Fire-and-forget async call
                      authProvider.resetPassword(email: email).then((success) {
                        if (success) {
                          // Show popup safely
                          if (!context.mounted) return;
                          showAutoClosePopup(context);
                        } else {
                          final msg =
                              authProvider.errorMessage ??
                              'Failed to send reset email';
                          messenger.showSnackBar(SnackBar(content: Text(msg)));
                        }
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
