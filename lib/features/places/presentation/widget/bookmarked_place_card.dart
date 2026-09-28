import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/resources/colors.dart';
import '../../../../core/resources/text_styles.dart';
import '../../../../core/utils/size_extension.dart';
import '../../../../core/resources/assets.dart';

class BookmarkedPlaceCard extends StatelessWidget {
  final String name;
  final String location;
  final String image;

  const BookmarkedPlaceCard({
    super.key,
    required this.name,
    required this.location,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.w(161),
      height: context.h(150),

      // Top + horizontal padding for centering
      padding: EdgeInsets.only(
        left: context.w(12),
        right: context.w(12),
        top: context.h(12),
      ),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(context.w(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(
              (0.04 * 255).toInt(),
            ), // runtime value
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image with bookmark icon
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(context.w(20)),
                child: Image.asset(
                  image,
                  width: context.w(140),
                  height: context.h(124),
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: context.h(8),
                right: context.w(8),
                child: Container(
                  width: context.w(24),
                  height: context.w(24),
                  decoration: BoxDecoration(
                    color: const Color(0x69F1EEEE), // constant
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: SvgPicture.asset(
                      MyAssets.profilebookmark,
                      width: context.w(16),
                      height: context.w(16),
                      colorFilter: const ColorFilter.mode(
                        Color(0xFFF36D0A),
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: context.h(6)),

          // Text container
          SizedBox(
            width: context.w(125),
            height: context.h(38),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Place name
                Text(
                  name,
                  style: AppTextStyles.semibold(context, 14),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),

                // Location row with exact design layout
                Row(
                  children: [
                    // Icon container 14x14 with inner offset
                    SizedBox(
                      width: context.w(14),
                      height: context.w(14),
                      child: Padding(
                        padding: EdgeInsets.only(
                          left: context.w(1.75),
                          top: context.h(1.17),
                        ),
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
                    ),

                    SizedBox(width: context.w(4)),

                    // Location text
                    Expanded(
                      child: Text(
                        location,
                        style: AppTextStyles.regular(
                          context,
                          12,
                        ).copyWith(color: AppColors.lightGreyText),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
