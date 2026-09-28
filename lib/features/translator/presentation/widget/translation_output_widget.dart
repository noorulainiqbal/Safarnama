import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/utils/size_extension.dart';
import '../../../../core/resources/colors.dart';
import '../../../../core/resources/text_styles.dart';
import '../../domain/entities/translation_entity.dart';

class TranslationOutputWidget extends StatelessWidget {
  final Translation? translation;
  final bool isLoading;
  final VoidCallback onSpeak;

  const TranslationOutputWidget({
    super.key,
    required this.translation,
    required this.isLoading,
    required this.onSpeak,
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
          /// ───────────── Header ─────────────
          Text(
            translation?.targetLanguage ?? 'Translation',
            style: AppTextStyles.semibold(
              context,
              13,
            ).copyWith(letterSpacing: 0.3, color: AppColors.textPrimary),
          ),

          SizedBox(height: context.h(12)),

          /// ───────────── Loading / Content ─────────────
          SizedBox(
            height: context.h(
              135,
            ), // Fixed height matching input (approx 6 lines)
            child: isLoading
                ? Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppColors.primaryOrange,
                      ),
                    ),
                  )
                : SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: translation != null
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                translation!.translatedText,
                                style: AppTextStyles.semibold(
                                  context,
                                  16,
                                ).copyWith(color: AppColors.textPrimary),
                              ),
                              if (translation!.romanization != null) ...[
                                SizedBox(height: context.h(8)),
                                Text(
                                  translation!.romanization!,
                                  style: AppTextStyles.regular(context, 13)
                                      .copyWith(
                                        letterSpacing: 0.3,
                                        color: AppColors.textSecondary,
                                      ),
                                ),
                              ],
                            ],
                          )
                        : Text(
                            'Translation will appear here...',
                            style: AppTextStyles.regular(context, 16).copyWith(
                              color: AppColors.textSecondary.withValues(
                                alpha: 0.5,
                              ),
                            ),
                          ),
                  ),
          ),

          SizedBox(height: context.h(16)),

          /// ───────────── Action Buttons ─────────────
          if (translation != null && !isLoading)
            Row(
              children: [
                _buildActionButton(
                  context,
                  icon: Icons.copy_outlined,
                  onTap: () {
                    Clipboard.setData(
                      ClipboardData(text: translation!.translatedText),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Copied to clipboard')),
                    );
                  },
                ),
              ],
            )
          else
            SizedBox(height: context.h(36)), // Placeholder for button row
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
