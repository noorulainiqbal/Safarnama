import 'package:flutter/material.dart';
import '../../../../core/utils/size_extension.dart';
import '../../../../core/resources/colors.dart';
import '../../../../core/resources/text_styles.dart';

class LanguageSelectorWidget extends StatelessWidget {
  final String selectedLanguage;
  final List<String> languages;
  final Function(String) onLanguageSelected;

  const LanguageSelectorWidget({
    super.key,
    required this.selectedLanguage,
    required this.languages,
    required this.onLanguageSelected,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showLanguageDialog(context),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: context.w(16),
          vertical: context.h(12),
        ),
        decoration: BoxDecoration(
          color: AppColors.backgroundGrey, // Changed to white as requested
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.borderGrey,
          ), // Added border for visibility on white
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: Text(
                selectedLanguage,
                style: AppTextStyles.semibold(
                  context,
                  16,
                ).copyWith(color: AppColors.textPrimary),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(width: context.w(8)),
            Icon(
              Icons.keyboard_arrow_down,
              size: context.sp(22),
              color: AppColors.textPrimary,
            ),
          ],
        ),
      ),
    );
  }

  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.white,
        title: Text(
          'Select Language',
          style: AppTextStyles.semibold(context, 18),
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: languages.length,
            itemBuilder: (context, index) {
              final language = languages[index];
              final isSelected = language == selectedLanguage;
              return ListTile(
                title: Text(
                  language,
                  style: isSelected
                      ? AppTextStyles.semibold(
                          context,
                          16,
                        ).copyWith(color: AppColors.primaryOrange)
                      : AppTextStyles.regular(
                          context,
                          16,
                        ).copyWith(color: AppColors.textPrimary),
                ),
                trailing: isSelected
                    ? Icon(Icons.check, color: AppColors.primaryOrange)
                    : null,
                onTap: () {
                  onLanguageSelected(language);
                  Navigator.pop(context);
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
