import 'package:flutter/material.dart';
import '../../../../core/utils/size_extension.dart';
import '../../../../../core/resources/colors.dart';

//SKIP used in onboard1, onboard2, onboard 3
class SkipButton extends StatelessWidget {
  final VoidCallback onTap;
  final double top;
  final double left;
  final String text;
  final double fontSize;
  final Color textColor;

  const SkipButton({
    super.key,
    required this.onTap,
    this.top = 56,
    this.left = 325,
    this.text = "Skip",
    this.fontSize = 18,
    this.textColor = AppColors.skipText,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: context.h(top),
      left: context.w(left),
      child: GestureDetector(
        onTap: onTap,
        child: SizedBox(
          width: context.w(31),
          height: context.h(24),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Gill Sans MT Regular',
              fontWeight: FontWeight.w400,
              fontSize: context.sp(fontSize),
              height: 24 / fontSize,
              color: textColor,
            ),
          ),
        ),
      ),
    );
  }
}
