import 'package:flutter/material.dart';
import '../../../../core/utils/size_extension.dart';
import '../../../../../core/resources/colors.dart';

class LargeLocationPinWidget extends StatelessWidget {
  final String image;

  const LargeLocationPinWidget({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.w(60),
      height: context.h(60),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.backgroundWhite, width: 4),
      ),
      child: ClipOval(child: Image.asset(image, fit: BoxFit.cover)),
    );
  }
}
