import 'package:flutter/material.dart';
import '../../../../core/utils/size_extension.dart';
import '../../../../core/resources/assets.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../core/resources/colors.dart';

class SearchBarWidget extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) onChanged;

  const SearchBarWidget({
    super.key,
    required this.controller,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: context.h(48),
      padding: EdgeInsets.symmetric(horizontal: context.w(16)),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.primaryOrange,
          width:
              1, // Using 1 as 2 might be too thick for search bar, but plan said "orange outline".
        ),
      ),
      child: Row(
        children: [
          Image.asset(
            MyAssets.search,
            width: context.w(24),
            height: context.h(24),
            color: AppColors.textSecondary,
          ),
          SizedBox(width: context.w(12)),
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              decoration: InputDecoration(
                hintText: AppLocalizations.of(context)!.searchPlacesHeader,
                hintStyle: TextStyle(
                  fontFamily: 'SF UI Display',
                  fontWeight: FontWeight.w400,
                  fontSize: context.sp(16),
                  height: 16 / 16,
                  letterSpacing: 0.3,
                  color: AppColors.textSecondary,
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
              style: TextStyle(
                fontFamily: 'SF UI Display',
                fontWeight: FontWeight.w400,
                fontSize: context.sp(16),
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
