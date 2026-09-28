import 'package:flutter/material.dart';
import '../../../../core/resources/assets.dart';
import '../../../../core/resources/colors.dart';
import '../../../../core/resources/text_styles.dart';
import '../../../../core/utils/size_extension.dart';

class TitleAvatarRow extends StatelessWidget {
  const TitleAvatarRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: context.w(182),
          height: context.h(32),
          child: Text(
            'Niladri Reservoir',
            style: AppTextStyles.semibold(context, 24),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Container(
          width: context.w(56),
          height: context.w(56),
          decoration: BoxDecoration(
            color: AppColors.lightBlueSoft,
            shape: BoxShape.circle,
          ),
          child: ClipOval(
            child: Image.asset(
              MyAssets.detailsgreenperson,
              width: context.w(56),
              height: context.w(56),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ],
    );
  }
}
