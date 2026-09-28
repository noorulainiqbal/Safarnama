import 'package:flutter/material.dart';
import '../../../../core/resources/colors.dart';
import '../../../../core/resources/text_styles.dart';
import '../../../../core/utils/size_extension.dart';

class BookNowButton extends StatelessWidget {
  const BookNowButton({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        width: double.infinity,
        height: context.h(60),
        decoration: BoxDecoration(
          color: AppColors.lightBlue,
          borderRadius: BorderRadius.circular(context.w(18)),
        ),
        alignment: Alignment.center,
        child: Text(
          'Book Now',
          style: AppTextStyles.semibold(
            context,
            17,
          ).copyWith(color: AppColors.white),
        ),
      ),
    );
  }
}
