import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/place_entity.dart';
import 'book_now_button.dart';
import '../../../../core/resources/assets.dart';
import '../../../../core/resources/colors.dart';
import '../../../../core/resources/text_styles.dart';
import '../../../../core/utils/size_extension.dart';

class DetailsContentCard extends StatelessWidget {
  final PlaceEntity place;
  const DetailsContentCard({super.key, required this.place});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.elliptical(context.w(187.5), context.h(35)),
          topRight: Radius.elliptical(context.w(187.5), context.h(35)),
        ),
      ),
      transform: Matrix4.translationValues(0, context.h(-30), 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Small grey line indicator at top
          Center(
            child: Container(
              margin: EdgeInsets.only(top: context.h(16)),
              width: context.w(38),
              height: context.h(5),
              decoration: BoxDecoration(
                color: AppColors.thinDivider.withAlpha(255),
                borderRadius: BorderRadius.circular(context.w(2)),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: context.w(18)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: context.h(18)),

                // Title and avatar row
                _buildTitleAvatarRow(context),

                // Subtitle text moved up
                Transform.translate(
                  offset: Offset(0, -context.h(8)), // move subtitle up
                  child: Text(
                    place.location,
                    style: AppTextStyles.regular(
                      context,
                      16,
                    ).copyWith(color: AppColors.lightGreyText.withAlpha(255)),
                  ),
                ),

                SizedBox(height: context.h(20)),

                // Info row (location, rating, price)
                _buildInfoRow(context),

                SizedBox(height: context.h(24)),

                // Image gallery
                _buildImageGallery(context),

                SizedBox(height: context.h(28)),

                // About section
                _buildAboutSection(context),

                SizedBox(height: context.h(25)),

                // Book Now button (separate widget)
                const BookNowButton(),

                SizedBox(height: context.h(32)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTitleAvatarRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Text(
            place.name,
            style: AppTextStyles.semibold(context, 24),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        SizedBox(width: context.w(12)),
        Transform.translate(
          offset: Offset(0, context.h(12)),
          child: Container(
            width: context.w(50),
            height: context.w(50),
            decoration: BoxDecoration(
              color: AppColors.lightBlueSoft,
              shape: BoxShape.circle,
            ),
            child: ClipOval(
              child: Image.asset(
                MyAssets.detailsgreenperson,
                width: context.w(50),
                height: context.w(50),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Location (Left)
        Expanded(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(
                MyAssets.detailslocation,
                width: context.w(17),
                height: context.w(17),
                colorFilter: ColorFilter.mode(
                  AppColors.lightGreyText.withAlpha(255),
                  BlendMode.srcIn,
                ),
              ),
              SizedBox(width: context.w(5)),
              Flexible(
                child: Text(
                  place.location,
                  style: AppTextStyles.regular(
                    context,
                    16,
                  ).copyWith(color: AppColors.lightGreyText.withAlpha(255)),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),

        // Rating (Center)
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                MyAssets.detailsstar,
                width: context.w(14),
                height: context.w(14),
              ),
              SizedBox(width: context.w(4)),
              Text(
                place.rating.toString(),
                style: AppTextStyles.regular(context, 16),
              ),
            ],
          ),
        ),

        // Price (Right)
        Expanded(
          child: Align(
            alignment: Alignment.centerRight,
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: '\$${place.price.toInt()}',
                    style: AppTextStyles.regular(
                      context,
                      16,
                    ).copyWith(color: AppColors.primaryOrange),
                  ),
                  TextSpan(
                    text: AppLocalizations.of(context)!.perPerson,
                    style: AppTextStyles.regular(
                      context,
                      16,
                    ).copyWith(color: AppColors.lightGreyText.withAlpha(255)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildImageGallery(BuildContext context) {
    // Hardcoded gallery for now, or could split the main image or just show placeholder
    final images = [
      MyAssets.details1,
      MyAssets.details2,
      MyAssets.details3,
      MyAssets.details4,
      MyAssets.details5,
    ];
    return SizedBox(
      height: context.w(42),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: images.length,
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.only(right: context.w(26)),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(context.w(12)),
              child: Image.asset(
                images[index],
                width: context.w(42),
                height: context.w(42),
                fit: BoxFit.cover,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAboutSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.aboutDestination,
          style: AppTextStyles.semibold(context, 23),
        ),
        SizedBox(height: context.h(10)),
        RichText(
          text: TextSpan(
            style: AppTextStyles.regular(
              context,
              13,
            ).copyWith(color: AppColors.lightGreyText.withAlpha(255)),
            children: [
              TextSpan(text: place.description),
              // TextSpan(
              //   text: ' Read More',
              //   style: AppTextStyles.medium(
              //     context,
              //     13,
              //   ).copyWith(color: const Color(0xFFFB6921)),
              // ),
            ],
          ),
        ),
      ],
    );
  }
}
