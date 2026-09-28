import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:ui';
import '../../../../core/utils/size_extension.dart';
import '../../../../../core/resources/assets.dart';
import '../../../../../core/resources/colors.dart';

//used in signin and signup page
class BackArrowButton extends StatelessWidget {
  final VoidCallback onTap;
  final double size; // container size
  final double iconWidth; // arrow width
  final double iconHeight; // arrow height
  final Color backgroundColor; // button background
  final Color iconColor; // arrow color

  const BackArrowButton({
    super.key,
    required this.onTap,
    this.size = 44,
    this.iconWidth = 5.5,
    this.iconHeight = 11.5,
    this.backgroundColor = AppColors.signinbox,
    this.iconColor = AppColors.signinemailcolor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(size / 2),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
          child: Container(
            width: context.w(size),
            height: context.h(size),
            decoration: BoxDecoration(
              color: backgroundColor.withValues(alpha: .85),
              borderRadius: BorderRadius.circular(size / 2),
            ),
            child: Center(
              child: SvgPicture.asset(
                MyAssets.signinsignuparrow,
                width: context.w(iconWidth),
                height: context.h(iconHeight),
                colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
