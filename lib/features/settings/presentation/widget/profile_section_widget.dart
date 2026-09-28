import 'package:flutter/material.dart';
import '../../../../core/utils/size_extension.dart';
import '../../../../core/resources/assets.dart';
import '../../../../core/resources/colors.dart';

class ProfileSectionWidget extends StatelessWidget {
  const ProfileSectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(context.w(16)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            offset: const Offset(0, 6),
            blurRadius: 20,
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundImage: AssetImage(MyAssets.avatar1),
          ),
          SizedBox(width: context.w(16)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'John Doe',
                  style: TextStyle(
                    fontFamily: 'SF UI Display',
                    fontWeight: FontWeight.w600,
                    fontSize: context.sp(18),
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: context.h(4)),
                Text(
                  'john.doe@email.com',
                  style: TextStyle(
                    fontFamily: 'SF UI Display',
                    fontWeight: FontWeight.w400,
                    fontSize: context.sp(14),
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.chevron_right,
            color: AppColors.textSecondary,
            size: context.sp(24),
          ),
        ],
      ),
    );
  }
}
