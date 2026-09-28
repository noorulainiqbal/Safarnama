import 'package:flutter/material.dart';
import '../../../../core/utils/size_extension.dart';
import '../../../../../core/resources/colors.dart';

class SmallLocationPinWidget extends StatelessWidget {
  final String image;

  const SmallLocationPinWidget({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.w(24),
      height: context.h(24),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.backgroundLightGrey,
      ),
      child: ClipOval(child: Image.asset(image, fit: BoxFit.cover)),
    );
  }
}
