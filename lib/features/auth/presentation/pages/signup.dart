// lib/features/auth/presentation/pages/signup.dart
import 'package:provider/provider.dart';
import '../../presentation/provider/auth_notifier.dart';
import 'package:flutter/material.dart';
import '../../../../l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/utils/size_extension.dart';
import '../../../../../core/resources/assets.dart';
import '../../../../../core/resources/colors.dart';
import '../pages/signin.dart';
import '../../../intro/presentation/widget/custombluebuttonwidget.dart';
import '../../../intro/presentation/widget/backarrowwidget.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final ValueNotifier<bool> _obscurePassword = ValueNotifier(true);

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    _obscurePassword.dispose();
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
            // Back Arrow Button
            Positioned(
              top: context.h(56),
              left: context.w(20),
              child: BackArrowButton(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const SignInPage()),
                  );
                },
              ),
            ),

            // Main Content
            Padding(
              padding: EdgeInsets.only(
                top: context.h(144),
                left: context.w(20),
              ),
              child: SizedBox(
                width: context.w(335),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        Text(
                          authProvider.isLoading
                              ? AppLocalizations.of(context)!.signingUp
                              : AppLocalizations.of(context)!.signUpTitle,
                          style: TextStyle(
                            fontFamily: 'SF UI Display',
                            fontWeight: FontWeight.w700,
                            fontSize: context.sp(26),
                            height: 32 / 26,
                            color: AppColors.signinemailcolor,
                          ),
                        ),
                        SizedBox(height: context.h(8)),
                        Text(
                          AppLocalizations.of(context)!.signUpSubtitle,
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
                    SizedBox(height: context.h(32)),

                    // Name
                    Container(
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
                              controller: nameController,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: AppLocalizations.of(
                                  context,
                                )!.fullNameHint,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: context.h(24)),

                    // Email
                    Container(
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
                                hintText: AppLocalizations.of(
                                  context,
                                )!.emailHint,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: context.h(24)),

                    // Password
                    Container(
                      width: context.w(335),
                      height: context.h(56),
                      decoration: BoxDecoration(
                        color: AppColors.signinbox,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: context.w(16)),
                      child: ValueListenableBuilder<bool>(
                        valueListenable: _obscurePassword,
                        builder: (context, obscure, child) {
                          return Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: passwordController,
                                  obscureText: obscure,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: AppLocalizations.of(
                                      context,
                                    )!.passwordHint,
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  _obscurePassword.value = !obscure;
                                },
                                child: SvgPicture.asset(
                                  MyAssets.signineye,
                                  width: context.w(24),
                                  height: context.h(24),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                    SizedBox(height: context.h(16)),
                    Text(
                      AppLocalizations.of(context)!.passwordLengthHint,
                      style: TextStyle(
                        fontFamily: 'SF UI Display',
                        fontWeight: FontWeight.w400,
                        fontSize: context.sp(14),
                        color: AppColors.subtitleGrey,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Bottom Section
            Padding(
              padding: EdgeInsets.only(
                top: context.h(538),
                left: context.w(20),
              ),
              child: SizedBox(
                width: context.w(335),
                child: Column(
                  children: [
                    CustomBottomButton(
                      title: AppLocalizations.of(context)!.signUpButton,
                      isLoading: authProvider.isLoading,
                      onPressed: () async {
                        if (authProvider.isLoading) return;

                        final name = nameController.text.trim();
                        final email = emailController.text.trim();
                        final password = passwordController.text.trim();

                        if (name.isEmpty || email.isEmpty || password.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                AppLocalizations.of(context)!.fillAllFields,
                              ),
                            ),
                          );
                          return;
                        }

                        // Show loading snackbar
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              AppLocalizations.of(context)!.signingUp,
                            ),
                            duration: Duration(seconds: 1),
                          ),
                        );

                        // ✅ Await the result
                        final success = await authProvider.signUp(
                          name: name,
                          email: email,
                          password: password,
                        );

                        if (!context.mounted) return;

                        if (success) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                AppLocalizations.of(
                                  context,
                                )!.verificationEmailSent,
                              ),
                              duration: Duration(seconds: 3),
                            ),
                          );

                          // Redirect after delay to let user read message
                          await Future.delayed(const Duration(seconds: 3));
                          if (!context.mounted) return;

                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const SignInPage(),
                            ),
                          );
                        } else {
                          // Show error from provider
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                authProvider.errorMessage ?? 'Signup failed',
                              ),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      },
                    ),

                    SizedBox(height: context.h(40)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.alreadyHaveAccount,
                          style: TextStyle(
                            fontFamily: 'SF UI Display',
                            fontWeight: FontWeight.w400,
                            fontSize: context.sp(14),
                            color: AppColors.signindonthvemail,
                          ),
                        ),
                        SizedBox(width: context.w(8)),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const SignInPage(),
                              ),
                            );
                          },
                          child: Text(
                            AppLocalizations.of(context)!.signIn,
                            style: TextStyle(
                              fontFamily: 'SF UI Display',
                              fontWeight: FontWeight.w500,
                              fontSize: context.sp(14),
                              color: AppColors.underlineOrange,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Or connect
            Padding(
              padding: EdgeInsets.only(
                top: context.h(670),
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

            // Social Buttons (UNCHANGED)
            Padding(
              padding: EdgeInsets.only(
                top: context.h(722),
                left: context.w(101),
              ),
              child: SizedBox(
                width: context.w(172),
                height: context.h(44),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SvgPicture.asset(MyAssets.signinfacebook),
                    SvgPicture.asset(MyAssets.signininsta),
                    SvgPicture.asset(MyAssets.signintwitter),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
