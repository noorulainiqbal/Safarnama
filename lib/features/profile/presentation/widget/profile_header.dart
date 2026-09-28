import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/resources/assets.dart';
import '../../../../core/resources/text_styles.dart';
import '../../../../core/utils/size_extension.dart';
import '../pages/edit_profile.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: context.w(335),
      height: context.h(44),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Back button - fully round circle
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: context.w(46),
              height: context.w(46),
              decoration: BoxDecoration(
                color: Color(0xFFF7F7F9),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: SvgPicture.asset(
                  MyAssets.profilebackarrow,
                  width: context.w(15),
                  height: context.w(15),
                ),
              ),
            ),
          ),
          // Title - centered
          SizedBox(
            width: context.w(55),
            height: context.h(22),
            child: Text(
              'Profile',
              style: AppTextStyles.semibold(context, 18),
              textAlign: TextAlign.center,
            ),
          ),
          // Edit button - fully round circle
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const EditProfilePage(),
                ),
              );
            },
            child: Container(
              width: context.w(48),
              height: context.w(48),
              decoration: BoxDecoration(
                color: Color(0xFFF7F7F9),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: SvgPicture.asset(
                  MyAssets.profileedit,
                  width: context.w(24),
                  height: context.w(24),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
