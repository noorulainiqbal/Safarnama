import 'package:flutter/material.dart';
import '../../../../core/utils/size_extension.dart';
import '../../../../core/resources/colors.dart';

class SettingsSectionTitleWidget extends StatelessWidget {
  final String title;

  const SettingsSectionTitleWidget({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        fontFamily: 'SF UI Display',
        fontWeight: FontWeight.w600,
        fontSize: context.sp(18),
        color: AppColors.textPrimary,
      ),
    );
  }
}
