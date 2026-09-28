import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/resources/assets.dart';
import '../../../../core/resources/colors.dart';
import '../../../../core/resources/text_styles.dart';
import '../../../../core/utils/size_extension.dart';

class SurprisePlaceCard extends StatelessWidget {
  final String name;
  final String location;
  final String image;
  final String rating;
  final String cost;

  const SurprisePlaceCard({
    super.key,
    required this.name,
    required this.location,
    required this.image,
    required this.rating,
    required this.cost,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.w(161),
      height: context.h(255),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(context.w(16)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: context.w(10),
            offset: Offset(0, context.h(4)),
          ),
        ],
      ),
      padding: EdgeInsets.symmetric(
        horizontal: context.w(12),
        vertical: context.h(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image with bookmark
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(context.w(20)),
                child: Image.asset(
                  image,
                  width: context.w(137),
                  height: context.h(124),
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: context.h(8),
                right: context.w(8),
                child: Container(
                  width: context.w(24),
                  height: context.h(24),
                  decoration: BoxDecoration(
                    color: Color(0x69F1EEEE),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: SvgPicture.asset(
                      MyAssets.profilebookmark,
                      width: context.w(16),
                      height: context.h(16),
                      colorFilter: ColorFilter.mode(
                        Color(0xF9F8F5F5),
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: context.h(8)),
          // Text container - 133×82
          SizedBox(
            width: context.w(133),
            height: context.h(82),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Place name - 16px height
                Text(
                  name,
                  style: AppTextStyles.semibold(context, 14).copyWith(
                    letterSpacing: context.w(0.5),
                    height: context.h(16) / context.h(14),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                // Location - 16px height
                Row(
                  children: [
                    SizedBox(
                      width: context.w(14),
                      height: context.h(14),
                      child: Stack(
                        children: [
                          Positioned(
                            left: context.w(1.75),
                            top: context.h(1.17),
                            child: SvgPicture.asset(
                              MyAssets.detailslocation,
                              width: context.w(11),
                              height: context.h(12),
                              colorFilter: ColorFilter.mode(
                                AppColors.lightGreyText,
                                BlendMode.srcIn,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: context.w(4)),
                    Expanded(
                      child: Text(
                        location,
                        style: AppTextStyles.regular(context, 12).copyWith(
                          color: AppColors.lightGreyText,
                          letterSpacing: context.w(0.3),
                          height: context.h(16) / context.h(12),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                // Rating - 16px height
                Row(
                  children: [
                    ...List.generate(
                      3,
                      (index) => Padding(
                        padding: EdgeInsets.only(right: context.w(2)),
                        child: SvgPicture.asset(
                          MyAssets.detailsstar,
                          width: context.w(12),
                          height: context.h(11),
                        ),
                      ),
                    ),
                    SizedBox(width: context.w(4)),
                    Text(
                      rating,
                      style: AppTextStyles.regular(context, 12).copyWith(
                        color: Color(0xFF202020),
                        letterSpacing: context.w(0.3),
                        height: context.h(16) / context.h(12),
                      ),
                    ),
                  ],
                ),
                // Cost - 16px height
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: '${cost.split('/')[0]}/', // e.g., "$761/"
                        style: AppTextStyles.medium(context, 12).copyWith(
                          color: AppColors.lightBlue,
                          letterSpacing: context.w(0.3),
                          height: context.h(16) / context.h(12),
                        ),
                      ),
                      TextSpan(
                        text: cost.split('/')[1], // e.g., "Person"
                        style: AppTextStyles.regular(context, 12).copyWith(
                          color: AppColors.lightGreyText,
                          letterSpacing: context.w(0.3),
                          height: context.h(16) / context.h(12),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
