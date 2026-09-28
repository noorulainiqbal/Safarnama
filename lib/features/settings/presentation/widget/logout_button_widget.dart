import 'package:flutter/material.dart';
import 'package:project/features/auth/presentation/pages/signup.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../core/utils/size_extension.dart';
import '../../../../core/resources/colors.dart';

class LogoutButtonWidget extends StatelessWidget {
  const LogoutButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // Navigate to login page
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => SignUpPage()),
          (route) => false,
        );
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(context.w(16)),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadowLight,
              offset: const Offset(0, 6),
              blurRadius: 20,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.logout,
              color: AppColors.accentRed,
              size: context.sp(24),
            ),
            SizedBox(width: context.w(12)),
            Text(
              AppLocalizations.of(context)!.logout,
              style: TextStyle(
                fontFamily: 'SF UI Display',
                fontWeight: FontWeight.w600,
                fontSize: context.sp(16),
                color: AppColors.accentRed,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
