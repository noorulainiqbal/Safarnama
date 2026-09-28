import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../../core/utils/size_extension.dart';
import '../../../../../core/resources/colors.dart';

class AppBarIcon extends StatelessWidget {
  final dynamic icon;
  final VoidCallback? onTap;

  const AppBarIcon({super.key, required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(50),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(50),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
          child: Container(
            width: context.w(44),
            height: context.h(44),
            decoration: BoxDecoration(
              color: AppColors.backgroundGrey,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: icon is IconData
                  ? Icon(
                      icon,
                      size: context.sp(24),
                      color: AppColors.textPrimary,
                    )
                  : Image.asset(
                      icon,
                      width: context.w(24),
                      height: context.h(24),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
