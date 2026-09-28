import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/provider/locale_provider.dart';
import '../../../../l10n/app_localizations.dart';
import 'package:project/features/route/presentation/widget/app_bar_icon_widget.dart';
import '../../../../core/utils/size_extension.dart';
import '../../../../../core/resources/assets.dart';
import '../../../../../core/resources/colors.dart';
import '../widget/logout_button_widget.dart';
import '../widget/profile_section_widget.dart';
import '../widget/settings_card_widget.dart';
import '../widget/settings_divider_widget.dart';
import '../widget/settings_section_title.dart';
import '../widget/settings_tile_widget.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final ValueNotifier<bool> notificationsEnabled = ValueNotifier(true);
  final ValueNotifier<bool> darkModeEnabled = ValueNotifier(false);
  final ValueNotifier<bool> locationEnabled = ValueNotifier(true);

  @override
  void dispose() {
    notificationsEnabled.dispose();
    darkModeEnabled.dispose();
    locationEnabled.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
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
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          AppLocalizations.of(context)!.settingsTitle,
                          style: TextStyle(
                            fontFamily: "SF UI Display",
                            fontWeight: FontWeight.w600,
                            fontSize: context.sp(18),
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
            // Main Content
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: context.w(20)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Profile Section
                    const ProfileSectionWidget(),
                    SizedBox(height: context.h(24)),
                    // General Settings Section
                    SettingsSectionTitleWidget(
                      title: AppLocalizations.of(context)!.generalSection,
                    ),
                    SizedBox(height: context.h(12)),
                    SettingsCardWidget(
                      children: [
                        ValueListenableBuilder<bool>(
                          valueListenable: notificationsEnabled,
                          builder: (context, value, child) {
                            return SettingsTileWidget(
                              icon: Icons.notifications_outlined,
                              title: AppLocalizations.of(
                                context,
                              )!.notifications,
                              trailing: Switch(
                                value: value,
                                onChanged: (newValue) {
                                  notificationsEnabled.value = newValue;
                                },
                                activeThumbColor: AppColors.primaryOrange,
                              ),
                            );
                          },
                        ),
                        const SettingsDividerWidget(),
                        ValueListenableBuilder<bool>(
                          valueListenable: darkModeEnabled,
                          builder: (context, value, child) {
                            return SettingsTileWidget(
                              icon: Icons.dark_mode_outlined,
                              title: AppLocalizations.of(context)!.darkMode,
                              trailing: Switch(
                                value: value,
                                onChanged: (newValue) {
                                  darkModeEnabled.value = newValue;
                                },
                                activeThumbColor: AppColors.primaryOrange,
                              ),
                            );
                          },
                        ),
                        const SettingsDividerWidget(),
                        ValueListenableBuilder<bool>(
                          valueListenable: locationEnabled,
                          builder: (context, value, child) {
                            return SettingsTileWidget(
                              icon: Icons.location_on_outlined,
                              title: AppLocalizations.of(
                                context,
                              )!.locationServices,
                              trailing: Switch(
                                value: value,
                                onChanged: (newValue) {
                                  locationEnabled.value = newValue;
                                },
                                activeThumbColor: AppColors.primaryOrange,
                              ),
                            );
                          },
                        ),
                        const SettingsDividerWidget(),
                        SettingsTileWidget(
                          icon: Icons.language_outlined,
                          title: AppLocalizations.of(context)!.language,
                          subtitle:
                              context
                                  .watch<LocaleProvider>()
                                  .locale
                                  ?.languageCode
                                  .toUpperCase() ??
                              'EN',
                          hasArrow: true,
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Select Language'),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    ListTile(
                                      title: const Text('English'),
                                      onTap: () {
                                        context
                                            .read<LocaleProvider>()
                                            .setLocale(const Locale('en'));
                                        Navigator.pop(context);
                                      },
                                    ),
                                    ListTile(
                                      title: const Text('French'),
                                      onTap: () {
                                        context
                                            .read<LocaleProvider>()
                                            .setLocale(const Locale('fr'));
                                        Navigator.pop(context);
                                      },
                                    ),
                                    ListTile(
                                      title: const Text('Korean'),
                                      onTap: () {
                                        context
                                            .read<LocaleProvider>()
                                            .setLocale(const Locale('ko'));
                                        Navigator.pop(context);
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: context.h(24)),
                    // Account Settings Section
                    SettingsSectionTitleWidget(
                      title: AppLocalizations.of(context)!.accountSection,
                    ),
                    SizedBox(height: context.h(12)),
                    SettingsCardWidget(
                      children: [
                        SettingsTileWidget(
                          icon: Icons.person_outline,
                          title: AppLocalizations.of(context)!.editProfile,
                          hasArrow: true,
                        ),
                        SettingsDividerWidget(),
                        SettingsTileWidget(
                          icon: Icons.lock_outline,
                          title: AppLocalizations.of(context)!.changePassword,
                          hasArrow: true,
                        ),
                        SettingsDividerWidget(),
                        SettingsTileWidget(
                          icon: Icons.credit_card_outlined,
                          title: AppLocalizations.of(context)!.paymentMethods,
                          hasArrow: true,
                        ),
                        SettingsDividerWidget(),
                        SettingsTileWidget(
                          icon: Icons.security_outlined,
                          title: AppLocalizations.of(context)!.privacySecurity,
                          hasArrow: true,
                        ),
                      ],
                    ),
                    SizedBox(height: context.h(24)),
                    // Support Section
                    SettingsSectionTitleWidget(
                      title: AppLocalizations.of(context)!.supportSection,
                    ),
                    SizedBox(height: context.h(12)),
                    SettingsCardWidget(
                      children: [
                        SettingsTileWidget(
                          icon: Icons.help_outline,
                          title: AppLocalizations.of(context)!.helpCenter,
                          hasArrow: true,
                        ),
                        SettingsDividerWidget(),
                        SettingsTileWidget(
                          icon: Icons.description_outlined,
                          title: AppLocalizations.of(context)!.termsConditions,
                          hasArrow: true,
                        ),
                        SettingsDividerWidget(),
                        SettingsTileWidget(
                          icon: Icons.policy_outlined,
                          title: AppLocalizations.of(context)!.privacyPolicy,
                          hasArrow: true,
                        ),
                        SettingsDividerWidget(),
                        SettingsTileWidget(
                          icon: Icons.info_outline,
                          title: AppLocalizations.of(context)!.aboutApp,
                          subtitle: 'Version 1.0.0',
                          hasArrow: true,
                        ),
                      ],
                    ),
                    SizedBox(height: context.h(24)),
                    // Logout Button
                    const LogoutButtonWidget(),
                    SizedBox(height: context.h(40)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
