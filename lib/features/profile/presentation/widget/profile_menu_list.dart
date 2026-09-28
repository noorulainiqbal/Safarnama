import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:project/features/budget/presentation/pages/transaction_page.dart';
import 'package:project/features/checklist/presentation/pages/checklist.dart';
import 'package:project/features/itinerary/presentation/pages/schedule_screen.dart';
import 'package:project/features/settings/presentation/pages/settings.dart';
import '../../../../core/resources/assets.dart';
import '../../../../core/resources/text_styles.dart';
import '../../../../core/utils/size_extension.dart';
import '../../../places/presentation/pages/bookmarked_places.dart';
import '../../../../l10n/app_localizations.dart';

class ProfileMenuList extends StatelessWidget {
  const ProfileMenuList({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.w(335),
      height: context.h(344),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(context.w(16)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: context.h(8),
        ), // reduced top/bottom padding
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildMenuItem(
              context,
              icon: MyAssets.profileIcon,
              title: AppLocalizations.of(context)!.budget,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TransactionsPage(),
                  ),
                );
              },
              isFirst: true,
            ),
            _buildDivider(context),
            _buildMenuItem(
              context,
              icon: MyAssets.profilebookmark,
              title: AppLocalizations.of(context)!.bookmarked,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const BookmarkedPlacesPage(),
                  ),
                );
              },
            ),
            _buildDivider(context),
            _buildMenuItem(
              context,
              icon: MyAssets.profiletravel,
              title: AppLocalizations.of(context)!.tripChecklist,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ChecklistPage(),
                  ),
                );
              },
            ),
            _buildDivider(context),
            _buildMenuItem(
              context,
              icon: Icons.calendar_month,
              title: AppLocalizations.of(context)!.tripItinerary,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ModernScheduleScreen(),
                  ),
                );
              },
            ),
            _buildDivider(context),
            _buildMenuItem(
              context,
              icon: MyAssets.profilesettings,
              title: AppLocalizations.of(context)!.settingsTitle,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SettingsPage()),
                );
              },
              isLast: true,
            ),
            _buildDivider(
              context,
            ), // optional last divider for spacing consistency
          ],
        ),
      ),
    );
  }

  Widget _buildDivider(BuildContext context) {
    return Divider(height: 1, thickness: 1, color: Color(0xFFF3F3F3));
  }

  Widget _buildMenuItem(
    BuildContext context, {
    dynamic icon,
    required String title,
    required VoidCallback onTap,
    bool isFirst = false,
    bool isLast = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: context.h(60), // slightly reduced to fit better with spacing
        padding: EdgeInsets.symmetric(horizontal: context.w(10)),
        child: Row(
          children: [
            // Icon container (white square with shadow)
            Container(
              width: context.w(40),
              height: context.w(40),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(context.w(8)),
              ),
              child: Center(
                child: icon is IconData
                    ? Icon(icon, size: context.w(24), color: Color(0xFF7D848D))
                    : SvgPicture.asset(
                        icon,
                        width: context.w(24),
                        height: context.w(24),
                        colorFilter: ColorFilter.mode(
                          Color(0xFF7D848D),
                          BlendMode.srcIn,
                        ),
                      ),
              ),
            ),
            SizedBox(width: context.w(16)),
            // Title
            Expanded(
              child: Text(title, style: AppTextStyles.medium(context, 16)),
            ),
            // Right arrow icon - moved slightly left
            Transform.translate(
              offset: Offset(context.w(-15), 0),
              child: SvgPicture.asset(
                MyAssets.profileleftarrow,
                width: context.w(14),
                height: context.w(14),
                colorFilter: ColorFilter.mode(
                  Color(0xA0292929),
                  BlendMode.srcIn,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
