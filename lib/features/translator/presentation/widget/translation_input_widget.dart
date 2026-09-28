import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/utils/size_extension.dart';
import '../../../../core/resources/colors.dart';
import '../../../../core/resources/text_styles.dart';

class TranslationInputWidget extends StatelessWidget {
  final TextEditingController controller;
  final String languageName;
  final VoidCallback onClear;
  final VoidCallback onCopy;

  const TranslationInputWidget({
    super.key,
    required this.controller,
    required this.languageName,
    required this.onClear,
    required this.onCopy,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(context.w(20)),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            offset: const Offset(0, 6),
            blurRadius: 20,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            languageName,
            style: AppTextStyles.semibold(
              context,
              13,
            ).copyWith(letterSpacing: 0.3, color: AppColors.textPrimary),
          ),
          SizedBox(height: context.h(12)),
          TextField(
            controller: controller,
            maxLines: 6,
            style: AppTextStyles.medium(
              context,
              16,
            ).copyWith(color: AppColors.textPrimary),
            decoration: InputDecoration(
              hintText: 'Enter text to translate...',
              hintStyle: AppTextStyles.regular(
                context,
                16,
              ).copyWith(color: AppColors.textSecondary.withValues(alpha: 0.5)),
              border: InputBorder.none,
              contentPadding: EdgeInsets.zero,
            ),
          ),
          SizedBox(height: context.h(16)),
          Row(
            children: [
              _buildActionButton(
                context,
                icon: Icons.copy_outlined,
                onTap: () {
                  if (controller.text.isNotEmpty) {
                    Clipboard.setData(ClipboardData(text: controller.text));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Copied to clipboard')),
                    );
                    onCopy();
                  }
                },
              ),
              const Spacer(),
              _buildActionButton(context, icon: Icons.close, onTap: onClear),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context, {
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: context.w(36),
        height: context.h(36),
        decoration: BoxDecoration(
          color: AppColors.backgroundGrey,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, size: context.sp(20), color: AppColors.textPrimary),
      ),
    );
  }
}
