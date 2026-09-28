import 'package:flutter/material.dart';
import 'package:project/core/resources/colors.dart';
import '../../../../core/utils/size_extension.dart';

class RichItem extends StatelessWidget {
  final String title;
  final String description;
  final double? fontSize;

  const RichItem({
    super.key,
    required this.title,
    required this.description,
    this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: title,
            style: TextStyle(
              fontFamily: 'SF UI Display',
              fontWeight: FontWeight.w600,
              fontSize: fontSize ?? context.sp(14),
              color: AppColors.textPrimary,
            ),
          ),
          TextSpan(
            text: description,
            style: TextStyle(
              fontFamily: 'SF UI Display',
              fontWeight: FontWeight.w400,
              fontSize: fontSize ?? context.sp(14),
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
