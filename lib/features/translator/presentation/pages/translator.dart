// features/translator/presentation/pages/translator.dart

import 'package:flutter/material.dart';
import '../../../../l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../../../../core/utils/size_extension.dart';
import '../../../../core/resources/assets.dart';
import '../../../../core/resources/colors.dart';
import '../../../../core/resources/text_styles.dart';
import '../../../route/presentation/widget/app_bar_icon_widget.dart';
import '../provider/translator_provider.dart';
import '../widget/language_selector_widget.dart';
import '../widget/translation_input_widget.dart';
import '../widget/translation_output_widget.dart';

class TranslatorPage extends StatefulWidget {
  const TranslatorPage({super.key});

  @override
  State<TranslatorPage> createState() => _TranslatorPageState();
}

class _TranslatorPageState extends State<TranslatorPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TranslatorProvider>().initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Top Bar
            Padding(
              padding: EdgeInsets.only(
                top: context.h(56),
                left: context.w(20),
                right: context.w(20),
              ),
              child: SizedBox(
                width: context.w(335),
                height: context.h(44),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppBarIconWidget(
                      icon: MyAssets.backicon,
                      onTap: () => Navigator.pop(context),
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          AppLocalizations.of(context)!.translateTitle,
                          style: AppTextStyles.semibold(context, 18).copyWith(
                            height: 22 / 18,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: context.w(44)),
                  ],
                ),
              ),
            ),
            SizedBox(height: context.h(30)),

            // Language Selector
            Consumer<TranslatorProvider>(
              builder: (context, provider, _) {
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: context.w(20)),
                  child: Row(
                    children: [
                      Expanded(
                        child: LanguageSelectorWidget(
                          selectedLanguage: provider.sourceLanguage,
                          languages: provider.supportedLanguages,
                          onLanguageSelected: (language) {
                            provider.setSourceLanguage(language);
                          },
                        ),
                      ),
                      SizedBox(width: context.w(16)),
                      GestureDetector(
                        onTap: () => provider.swapLanguages(),
                        child: Container(
                          width: context.w(44),
                          height: context.h(44),
                          decoration: BoxDecoration(
                            color: AppColors.primaryOrange,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.swap_horiz,
                            size: context.sp(24),
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(width: context.w(16)),
                      Expanded(
                        child: LanguageSelectorWidget(
                          selectedLanguage: provider.targetLanguage,
                          languages: provider.supportedLanguages,
                          onLanguageSelected: (language) {
                            provider.setTargetLanguage(language);
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            SizedBox(height: context.h(24)),

            // Source Text Container
            Consumer<TranslatorProvider>(
              builder: (context, provider, _) {
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: context.w(20)),
                  child: TranslationInputWidget(
                    controller: provider.sourceTextController,
                    languageName: provider.sourceLanguage,
                    onClear: () => provider.clearSourceText(),
                    onCopy: () {},
                  ),
                );
              },
            ),
            SizedBox(height: context.h(20)),

            // Translate Button
            Consumer<TranslatorProvider>(
              builder: (context, provider, _) {
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: context.w(20)),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: provider.isLoading
                          ? null
                          : () => provider.translateText(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryOrange,
                        padding: EdgeInsets.symmetric(vertical: context.h(16)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: provider.isLoading
                          ? SizedBox(
                              height: context.h(20),
                              width: context.h(20),
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            )
                          : Text(
                              AppLocalizations.of(context)!.translateButton,
                              style: AppTextStyles.semibold(
                                context,
                                16,
                              ).copyWith(color: Colors.white),
                            ),
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: context.h(20)),

            // Error Message
            Consumer<TranslatorProvider>(
              builder: (context, provider, _) {
                if (provider.errorMessage != null) {
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: context.w(20)),
                    child: Container(
                      padding: EdgeInsets.all(context.w(12)),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.error_outline,
                            color: Colors.red,
                            size: context.sp(20),
                          ),
                          SizedBox(width: context.w(8)),
                          Expanded(
                            child: Text(
                              provider.errorMessage!,
                              style: AppTextStyles.regular(
                                context,
                                14,
                              ).copyWith(color: Colors.red.shade700),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
            if (context.watch<TranslatorProvider>().errorMessage != null)
              SizedBox(height: context.h(20)),

            // Translated Text Container
            Consumer<TranslatorProvider>(
              builder: (context, provider, _) {
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: context.w(20)),
                  child: TranslationOutputWidget(
                    translation: provider.currentTranslation,
                    isLoading: provider.isLoading,
                    onSpeak: () {}, // Removed implementation
                  ),
                );
              },
            ),
            SizedBox(height: context.h(24)),
          ],
        ),
      ),
    );
  }
}
