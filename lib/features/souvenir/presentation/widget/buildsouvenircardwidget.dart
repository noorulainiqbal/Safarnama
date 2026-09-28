import 'package:flutter/material.dart';
import '../../../../core/utils/size_extension.dart';
import '../../../../../core/resources/colors.dart';

class BuildSouvenirCardWidget extends StatelessWidget {
  final String image;
  final String title;
  final String description;
  final String rating;
  final String personCount;
  final String avatar1;
  final String avatar2;
  final String avatar3;
  final VoidCallback? onTap;

  const BuildSouvenirCardWidget({
    super.key,
    required this.image,
    required this.title,
    required this.description,
    required this.rating,
    required this.personCount,
    required this.avatar1,
    required this.avatar2,
    required this.avatar3,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: context.w(335),
        height: context.h(140),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadowLight,
              offset: const Offset(0, 6),
              blurRadius: 20,
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(context.w(12)),
          child: Row(
            children: [
              // Image
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  image,
                  width: context.w(95),
                  height: context.h(116),
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(width: context.w(14)),
              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Title
                    Text(
                      title,
                      style: TextStyle(
                        fontFamily: 'SF UI Display',
                        fontWeight: FontWeight.w600,
                        fontSize: context.sp(16),
                        height: 20 / 16,
                        letterSpacing: 0.5,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: context.h(8)),
                    // Description
                    Text(
                      description,
                      style: TextStyle(
                        fontFamily: 'SF UI Display',
                        fontWeight: FontWeight.w400,
                        fontSize: context.sp(13),
                        height: 16 / 13,
                        letterSpacing: 0.3,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    SizedBox(height: context.h(8)),
                    // Rating Row
                    Row(
                      children: [
                        ...List.generate(
                          3,
                          (index) => Icon(
                            Icons.star,
                            size: context.sp(12),
                            color: AppColors.accentYellow,
                          ),
                        ),
                        SizedBox(width: context.w(6)),
                        Text(
                          rating,
                          style: TextStyle(
                            fontFamily: 'SF UI Display',
                            fontWeight: FontWeight.w400,
                            fontSize: context.sp(13),
                            height: 16 / 13,
                            letterSpacing: 0.3,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: context.h(8)),
                    // Avatar Stack
                    Row(
                      children: [
                        SizedBox(
                          width: context.w(51),
                          height: context.h(24),
                          child: Stack(
                            children: [
                              Positioned(
                                left: 0,
                                child: CircleAvatar(
                                  radius: 12,
                                  backgroundImage: AssetImage(avatar1),
                                ),
                              ),
                              Positioned(
                                left: context.w(13),
                                child: CircleAvatar(
                                  radius: 12,
                                  backgroundImage: AssetImage(avatar2),
                                ),
                              ),
                              Positioned(
                                left: context.w(27),
                                child: CircleAvatar(
                                  radius: 12,
                                  backgroundImage: AssetImage(avatar3),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: context.w(6)),
                        Text(
                          personCount,
                          style: TextStyle(
                            fontFamily: 'SF UI Display',
                            fontWeight: FontWeight.w400,
                            fontSize: context.sp(13),
                            height: 16 / 13,
                            letterSpacing: 0.3,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
