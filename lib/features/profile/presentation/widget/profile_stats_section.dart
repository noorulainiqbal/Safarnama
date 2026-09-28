import 'package:flutter/material.dart';
import '../../../../core/resources/text_styles.dart';
import '../../../../core/utils/size_extension.dart';
import '../../../../l10n/app_localizations.dart';

class ProfileStatsSection extends StatelessWidget {
  const ProfileStatsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.w(335),
      height: context.h(78),
      padding: EdgeInsets.symmetric(
        horizontal: context.w(20), // Only horizontal padding
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(context.w(16)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.stretch, // Makes dividers full height
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildStatItem(
            context,
            AppLocalizations.of(context)!.rewardPoints,
            '360',
          ),
          // Full-height vertical divider
          Container(width: 1, color: Color(0xFFF3F3F3)),
          _buildStatItem(
            context,
            AppLocalizations.of(context)!.travelTrips,
            '238',
          ),
          Container(width: 1, color: Color(0xFFF3F3F3)),
          _buildStatItem(
            context,
            AppLocalizations.of(context)!.bucketList,
            '473',
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(BuildContext context, String label, String value) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          label,
          style: AppTextStyles.semibold(
            context,
            14,
          ).copyWith(color: Color(0xFF202020)),
        ),
        SizedBox(height: context.h(4)),
        Text(
          value,
          style: AppTextStyles.semibold(
            context,
            16,
          ).copyWith(color: Color(0xFFFF7029)),
        ),
      ],
    );
  }
}
