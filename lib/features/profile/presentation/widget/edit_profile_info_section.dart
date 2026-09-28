import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../../../../core/resources/assets.dart';
import '../../../../core/resources/text_styles.dart';
import '../../../../core/utils/size_extension.dart';
import '../provider/profile_provider.dart';

class EditProfileInfoSection extends StatelessWidget {
  const EditProfileInfoSection({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProfileProvider>();

    return Center(
      child: Column(
        children: [
          Container(
            width: context.w(96),
            height: context.w(96),
            decoration: const BoxDecoration(
              color: Color(0xFFF8D3D3),
              shape: BoxShape.circle,
            ),
            child: ClipOval(
              child: provider.photoUrl == null
                  ? SvgPicture.asset(
                      MyAssets.editprofileperson,
                      fit: BoxFit.contain,
                    )
                  : Image.asset(provider.photoUrl!, fit: BoxFit.cover),
            ),
          ),
          SizedBox(height: context.h(16)),
          Text(
            provider.firstNameController.text.isEmpty
                ? 'User'
                : provider.firstNameController.text,
            style: AppTextStyles.medium(context, 24),
          ),
          SizedBox(height: context.h(8)),
        ],
      ),
    );
  }
}
