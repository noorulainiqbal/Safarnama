import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/resources/assets.dart';
import '../../../../core/resources/colors.dart';
import '../../../../core/resources/text_styles.dart';
import '../../../../core/utils/size_extension.dart';
import 'package:provider/provider.dart';
import '../provider/profile_provider.dart';

class ProfileInfoSection extends StatelessWidget {
  const ProfileInfoSection({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProfileProvider>();
    final user = provider.user;

    return Column(
      children: [
        // Profile picture with icon positioned lower
        Container(
          width: context.w(96),
          height: context.w(96),
          decoration: BoxDecoration(
            color: Color(0xFFFEE4E4),
            shape: BoxShape.circle,
          ),
          child: ClipOval(
            // 🔹 Clip the child to circle
            child: Align(
              alignment: Alignment.bottomCenter,
              child: user?.photoUrl.isNotEmpty == true
                  ? Image.network(
                      user!.photoUrl,
                      width: context.w(80),
                      height: context.w(80),
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return SvgPicture.asset(
                          MyAssets.profileperson,
                          width: context.w(80),
                          height: context.w(80),
                          fit: BoxFit.contain,
                        );
                      },
                    )
                  : SvgPicture.asset(
                      MyAssets.profileperson,
                      width: context.w(80),
                      height: context.w(80),
                      fit: BoxFit.contain,
                    ),
            ),
          ),
        ),

        SizedBox(height: context.h(16)),

        // Name
        Text(
          user != null
              ? '${user.firstName} ${user.lastName}'.trim()
              : 'Loading...',
          style: AppTextStyles.semibold(context, 24),
        ),

        SizedBox(height: context.h(8)),

        // Email
        Text(
          user?.email ?? '',
          style: AppTextStyles.regular(
            context,
            14,
          ).copyWith(color: AppColors.lightGreyText),
        ),
      ],
    );
  }
}
