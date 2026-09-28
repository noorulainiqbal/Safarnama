import 'package:flutter/material.dart';
import '../../../../core/utils/size_extension.dart';
import '../../../../core/resources/text_styles.dart';

class TodayLabel extends StatelessWidget {
  const TodayLabel({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Transform.translate(
        offset: Offset(context.w(15), 0),
        child: Container(
          width: context.w(59), // slightly smaller width
          height: context.h(32), // slightly smaller height
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.grey.shade100, // light grey background
            borderRadius: BorderRadius.circular(
              context.w(8),
            ), // slightly smaller radius
          ),
          child: Text(
            "Today",
            style: AppTextStyles.medium(context, 13).copyWith(
              color: Colors.grey.shade500, // light grey text
            ),
          ),
        ),
      ),
    );
  }
}
