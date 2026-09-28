import 'package:flutter/material.dart';
import '../../../../core/utils/size_extension.dart';
import '../../../../core/resources/assets.dart';
import '../../../../core/resources/colors.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PlaceCardWidget extends StatelessWidget {
  final String image;
  final String title;
  final String location;
  final double rating;
  final double price;
  final bool isBookmarked;
  final VoidCallback? onBookmarkTap;

  const PlaceCardWidget({
    super.key,
    required this.image,
    required this.title,
    required this.location,
    required this.rating,
    required this.price,
    this.isBookmarked = false,
    this.onBookmarkTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.w(161),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1FB4BCC9),
            offset: Offset(0, 6),
            blurRadius: 16,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image with Bookmark Icon
          Stack(
            children: [
              Padding(
                padding: EdgeInsets.all(context.w(12)),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: image.startsWith('http')
                      ? Image.network(
                          image,
                          width: context.w(137),
                          height: context.h(124),
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: context.w(137),
                              height: context.h(124),
                              color: Colors.grey[300],
                              child: const Icon(Icons.error),
                            );
                          },
                        )
                      : Image.asset(
                          image,
                          width: context.w(137),
                          height: context.h(124),
                          fit: BoxFit.cover,
                        ),
                ),
              ),
              Positioned(
                top: context.h(20),
                right: context.w(20),
                child: GestureDetector(
                  onTap: onBookmarkTap,
                  child: Container(
                    height: context.w(32),
                    width: context.w(32),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(
                        alpha: 0.8,
                      ), // Glass-like effect
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Icon(
                        isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                        size: context.w(16),
                        color: isBookmarked
                            ? AppColors.primaryOrange
                            : AppColors.textPrimary,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          // Content
          Padding(
            padding: EdgeInsets.only(
              left: context.w(12),
              right: context.w(12),
              bottom: context.h(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontFamily: 'SF UI Display',
                    fontWeight: FontWeight.w600,
                    fontSize: context.sp(14),
                    height: 16 / 14,
                    letterSpacing: 0.5,
                    color: AppColors.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: context.h(6)),
                Row(
                  children: [
                    Image.asset(
                      MyAssets.map,
                      width: context.w(14),
                      height: context.h(14),
                      color: AppColors.textSecondary,
                    ),
                    SizedBox(width: context.w(3)),
                    Expanded(
                      child: Text(
                        location,
                        style: TextStyle(
                          fontFamily: 'SF UI Display',
                          fontWeight: FontWeight.w400,
                          fontSize: context.sp(12),
                          height: 16 / 12,
                          letterSpacing: 0.3,
                          color: AppColors.textSecondary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: context.h(6)),
                Row(
                  children: [
                    Row(
                      children: List.generate(
                        4,
                        (index) => Padding(
                          padding: EdgeInsets.only(right: context.w(2)),
                          child: SvgPicture.asset(
                            MyAssets.detailsstar,
                            width: context.w(12),
                            height: context.w(12),
                            // Reverted to original asset color behavior (likely yellow/orange)
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: context.w(4)),
                    Text(
                      rating.toStringAsFixed(1),
                      style: TextStyle(
                        fontFamily: 'SF UI Display',
                        fontWeight: FontWeight.w500,
                        fontSize: context.sp(12),
                        height: 16 / 12,
                        letterSpacing: 0.3,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: context.h(4)),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: '\$${price.toInt()}',
                        style: TextStyle(
                          fontFamily: 'SF UI Display',
                          fontWeight: FontWeight.w600,
                          fontSize: context.sp(12),
                          color: AppColors.primaryOrange,
                        ),
                      ),
                      TextSpan(
                        text: '/Person',
                        style: TextStyle(
                          fontFamily: 'SF UI Display',
                          fontWeight: FontWeight.w400,
                          fontSize: context.sp(12),
                          color: AppColors.textSecondary,
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
