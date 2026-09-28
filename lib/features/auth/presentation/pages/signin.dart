// lib/features/auth/presentation/pages/signin.dart
import 'package:flutter/material.dart';
import '../../../../l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../../../../core/utils/size_extension.dart';
import '../../../../../core/resources/assets.dart';
import '../../../../../core/resources/colors.dart';
import '../../../intro/presentation/pages/onboard_3.dart';
import '../pages/forgotpassword.dart';
import 'package:project/features/intro/presentation/pages/home.dart';
import '../../../intro/presentation/widget/backarrowwidget.dart';
import '../../../intro/presentation/widget/custombluebuttonwidget.dart';
import '../../presentation/provider/auth_notifier.dart';
import '../pages/signup.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final ValueNotifier<bool> isPasswordVisible = ValueNotifier(false);

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    isPasswordVisible.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthNotifier>();

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            // Back arrow
            Positioned(
              top: context.h(57),
              left: context.w(20),
              child: BackArrowButton(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const Onboard3Page()),
                  );
                },
              ),
            ),

            // Title
            Positioned(
              top: context.h(140),
              left: context.w(119),
              child: SizedBox(
                width: context.w(138),
                height: context.h(34),
                child: Center(
                  child: Text(
                    authProvider.isLoading
                        ? AppLocalizations.of(context)!.signingIn
                        : AppLocalizations.of(context)!.signInTitle,
                    style: TextStyle(
                      fontFamily: 'SF UI Display',
                      fontWeight: FontWeight.w600,
                      fontSize: context.sp(26),
                      height: 34 / 26,
                      color: AppColors.black,
                    ),
                  ),
                ),
              ),
            ),

            // Subtitle
            Positioned(
              top: context.h(186),
              left: context.w(71),
              child: SizedBox(
                width: context.w(240),
                height: context.h(20),
                child: Center(
                  child: Text(
                    AppLocalizations.of(context)!.signInSubtitle,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'SF UI Display',
                      fontWeight: FontWeight.w400,
                      fontSize: context.sp(16),
                      height: 20 / 16,
                      color: AppColors.subtitleGrey,
                    ),
                  ),
                ),
              ),
            ),

            // Email Box
            Positioned(
              top: context.h(246),
              left: context.w(20),
              child: Container(
                width: context.w(335),
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
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: AppLocalizations.of(context)!.emailHint,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Password Box
            Positioned(
              top: context.h(326),
              left: context.w(20),
              child: Container(
                width: context.w(335),
                height: context.h(56),
                decoration: BoxDecoration(
                  color: AppColors.signinbox,
                  borderRadius: BorderRadius.circular(14),
                ),
                padding: EdgeInsets.symmetric(horizontal: context.w(16)),
                child: Row(
                  children: [
                    Expanded(
                      child: ValueListenableBuilder<bool>(
                        valueListenable: isPasswordVisible,
                        builder: (context, value, child) {
                          return TextField(
                            controller: passwordController,
                            obscureText: !value,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: AppLocalizations.of(
                                context,
                              )!.passwordHint,
                            ),
                          );
                        },
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        isPasswordVisible.value = !isPasswordVisible.value;
                      },
                      child: SvgPicture.asset(
                        MyAssets.signineye,
                        width: context.w(24),
                        height: context.h(24),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Forgot Password
            Positioned(
              top: context.h(398),
              left: context.w(219),
              child: SizedBox(
                width: context.w(135),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ForgotPasswordPage(),
                      ),
                    );
                  },
                  child: Text(
                    AppLocalizations.of(context)!.forgotPassword,
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontFamily: 'SF UI Display',
                      fontWeight: FontWeight.w500,
                      fontSize: context.sp(14),
                      height: 16 / 14,
                      color: AppColors.underlineOrange,
                    ),
                  ),
                ),
              ),
            ),

            // Sign In Button
            CustomBottomButton(
              title: AppLocalizations.of(context)!.signInButton,
              top: context.h(454),
              left: context.w(20),
              isLoading: authProvider.isLoading,
              onPressed: () {
                if (authProvider.isLoading) return;

                final email = emailController.text.trim();
                final password = passwordController.text.trim();

                if (email.isEmpty || password.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Please enter email and password',
                      ), // You might want to localize this too
                    ),
                  );
                  return;
                }

                final messenger = ScaffoldMessenger.of(context);
                final navigator = Navigator.of(context);

                // Show message immediately
                messenger.showSnackBar(
                  const SnackBar(
                    content: Text('Signing in...'), // localized?
                    duration: Duration(seconds: 2),
                  ),
                );

                // ✅ Perform async sign-in safely
                authProvider.signIn(email: email, password: password).then((
                  success,
                ) {
                  if (!mounted) return;
                  if (success) {
                    navigator.pushReplacement(
                      MaterialPageRoute(builder: (_) => const HomeScreen()),
                    );
                  } else {
                    final msg = authProvider.errorMessage ?? 'Sign in failed';
                    messenger.showSnackBar(SnackBar(content: Text(msg)));
                  }
                });
              },
            ),

            // Don't have account
            Positioned(
              top: context.h(550),
              left: context.w(88),
              child: Text(
                AppLocalizations.of(context)!.noAccount,
                style: TextStyle(
                  fontFamily: 'SF UI Display',
                  fontWeight: FontWeight.w400,
                  fontSize: context.sp(14),
                  color: AppColors.signindonthvemail,
                ),
              ),
            ),
            Positioned(
              top: context.h(550),
              left: context.w(245),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const SignUpPage()),
                  );
                },
                child: Text(
                  AppLocalizations.of(context)!.signUp,
                  style: TextStyle(
                    fontFamily: 'SF UI Display',
                    fontWeight: FontWeight.w500,
                    fontSize: context.sp(14),
                    color: AppColors.underlineOrange,
                  ),
                ),
              ),
            ),

            // Or connect
            Padding(
              padding: EdgeInsets.only(
                top: context.h(586),
                left: context.w(153),
              ),
              child: Text(
                AppLocalizations.of(context)!.orConnect,
                style: TextStyle(
                  fontFamily: 'SF UI Display',
                  fontWeight: FontWeight.w400,
                  fontSize: context.sp(14),
                  color: AppColors.signindonthvemail,
                ),
              ),
            ),

            // Social Icons
            Padding(
              padding: EdgeInsets.only(
                top: context.h(722),
              ), // keep original top
              child: Row(
                mainAxisAlignment:
                    MainAxisAlignment.center, // center in available space
                children: [
                  SvgPicture.asset(MyAssets.signinfacebook),
                  SizedBox(width: context.w(12)), // closer spacing
                  SvgPicture.asset(MyAssets.signininsta),
                  SizedBox(width: context.w(12)),
                  SvgPicture.asset(MyAssets.signintwitter),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
