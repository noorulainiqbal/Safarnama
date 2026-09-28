import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../../../../core/resources/assets.dart';
import '../../../../core/resources/text_styles.dart';
import '../../../../core/utils/size_extension.dart';
import '../provider/profile_provider.dart';

class EditProfileHeader extends StatelessWidget {
  const EditProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: context.w(335),
      height: context.h(44),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: context.w(44),
              height: context.w(44),
              decoration: const BoxDecoration(
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
          Text('Edit Profile', style: AppTextStyles.semibold(context, 18)),
          Consumer<ProfileProvider>(
            builder: (context, provider, child) {
              if (provider.isLoading) {
                return Padding(
                  padding: EdgeInsets.all(context.w(8)),
                  child: SizedBox(
                    width: context.w(16),
                    height: context.w(16),
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: const Color(0xFFFF7029),
                    ),
                  ),
                );
              }

              return GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () async {
                  debugPrint('🔴 Tap detected: Save Profile');
                  final success = await provider.saveProfile();

                  if (!context.mounted) return;

                  if (success) {
                    debugPrint('🟢 Save Profile success, popping...');
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Profile updated successfully'),
                        backgroundColor: Colors.green,
                        duration: Duration(seconds: 2),
                      ),
                    );
                  } else {
                    debugPrint('❌ Save returned false');
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Failed to save profile. Please try again.',
                        ),
                        backgroundColor: Colors.red,
                        duration: Duration(seconds: 3),
                      ),
                    );
                  }
                },
                child: Padding(
                  padding: EdgeInsets.all(context.w(8)),
                  child: Text(
                    'Done',
                    style: AppTextStyles.semibold(
                      context,
                      16,
                    ).copyWith(color: const Color(0xFFFF7029)),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
