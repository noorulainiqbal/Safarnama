import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../../../../core/resources/assets.dart';
import '../../../../core/resources/colors.dart';
import '../../../../core/resources/text_styles.dart';
import '../../../../core/utils/size_extension.dart';
import '../../domain/entities/place_entity.dart';
import '../provider/places_provider.dart';

class DetailsTopBar extends StatelessWidget {
  final PlaceEntity place;
  const DetailsTopBar({super.key, required this.place});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: context.w(24),
            vertical: context.h(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Back button
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: context.w(44),
                  height: context.w(44),
                  decoration: BoxDecoration(
                    color: AppColors.lightBlack,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: SvgPicture.asset(
                      MyAssets.detailsbackarrow,
                      width: context.w(14),
                      height: context.w(14),
                      colorFilter: ColorFilter.mode(
                        AppColors.white,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ),
              ),

              // Title
              Text(
                AppLocalizations.of(context)!.detailsTitle,
                style: AppTextStyles.semibold(
                  context,
                  20,
                ).copyWith(color: AppColors.white),
              ),

              // Bookmark button
              Consumer<PlacesProvider>(
                builder: (context, provider, child) {
                  final isBookmarked = provider.isBookmarked(place.id);
                  return GestureDetector(
                    onTap: () => provider.toggleBookmark(place.id),
                    child: Container(
                      width: context.w(44),
                      height: context.w(44),
                      decoration: BoxDecoration(
                        color: AppColors.lightBlack,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Icon(
                          isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                          size: context.w(20),
                          color: AppColors.white,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
