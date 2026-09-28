import 'package:flutter/material.dart';
import '../../../../core/utils/size_extension.dart';
import '../../../../../core/resources/assets.dart';
import '../../../../../core/resources/colors.dart';
import '../widget/appbariconwidget.dart';
import '../widget/richitemwidget.dart';
import '../../../../l10n/app_localizations.dart';

class FoodDrinkDetailsPage extends StatelessWidget {
  const FoodDrinkDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      body: Stack(
        children: [
          // Main Content
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Hero Image
                Stack(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      height: context.h(400),
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(30),
                          bottomRight: Radius.circular(30),
                        ),
                        child: Image.asset(
                          MyAssets.activity1,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      height: context.h(400),
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(30),
                          bottomRight: Radius.circular(30),
                        ),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            AppColors.black.withValues(alpha: 0.3),
                            AppColors.transparent,
                            AppColors.black.withValues(alpha: 0.5),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.all(context.w(20)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title & Subtitle
                      Text(
                        AppLocalizations.of(context)!.souvenirFoodTitle,
                        style: TextStyle(
                          fontFamily: 'SF UI Display',
                          fontWeight: FontWeight.w600,
                          fontSize: context.sp(24),
                          height: 1.2,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      SizedBox(height: context.h(8)),
                      Text(
                        AppLocalizations.of(context)!.souvenirFoodSubtitle,
                        style: TextStyle(
                          fontFamily: 'SF UI Display',
                          fontWeight: FontWeight.w400,
                          fontSize: context.sp(14),
                          color: AppColors.textSecondary,
                        ),
                      ),
                      SizedBox(height: context.h(20)),

                      // Rating
                      Row(
                        children: [
                          ...List.generate(
                            5,
                            (index) => Padding(
                              padding: EdgeInsets.only(right: context.w(4)),
                              child: Icon(
                                Icons.star,
                                size: context.sp(16),
                                color: AppColors.accentYellow,
                              ),
                            ),
                          ),
                          SizedBox(width: context.w(8)),
                          Text(
                            AppLocalizations.of(context)!.souvenirFoodRating,
                            style: TextStyle(
                              fontFamily: 'SF UI Display',
                              fontWeight: FontWeight.w600,
                              fontSize: context.sp(14),
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: context.h(24)),

                      // Participants
                      Row(
                        children: [
                          SizedBox(
                            width: context.w(95),
                            height: context.h(32),
                            child: Stack(
                              children: [
                                Positioned(
                                  left: 0,
                                  child: CircleAvatar(
                                    radius: 16,
                                    backgroundImage: AssetImage(
                                      MyAssets.avatar1,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  left: context.w(20),
                                  child: CircleAvatar(
                                    radius: 16,
                                    backgroundImage: AssetImage(
                                      MyAssets.avatar2,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  left: context.w(40),
                                  child: CircleAvatar(
                                    radius: 16,
                                    backgroundImage: AssetImage(
                                      MyAssets.avatar3,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: context.h(24)),

                      // About Section
                      Text(
                        AppLocalizations.of(context)!.souvenirFoodAboutTitle,
                        style: TextStyle(
                          fontFamily: 'SF UI Display',
                          fontWeight: FontWeight.w600,
                          fontSize: context.sp(18),
                          color: AppColors.textPrimary,
                        ),
                      ),
                      SizedBox(height: context.h(12)),
                      Text(
                        AppLocalizations.of(context)!.souvenirFoodAboutDesc,
                        style: TextStyle(
                          fontFamily: 'SF UI Display',
                          fontWeight: FontWeight.w400,
                          fontSize: context.sp(14),
                          height: 1.5,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      SizedBox(height: context.h(24)),

                      // Popular Picks
                      Text(
                        AppLocalizations.of(context)!.popularPicks,
                        style: TextStyle(
                          fontFamily: 'SF UI Display',
                          fontWeight: FontWeight.w600,
                          fontSize: context.sp(18),
                          color: AppColors.textPrimary,
                        ),
                      ),
                      SizedBox(height: context.h(12)),

                      // Rich Items
                      RichItem(
                        title: AppLocalizations.of(
                          context,
                        )!.souvenirFoodItem1Title,
                        description: AppLocalizations.of(
                          context,
                        )!.souvenirFoodItem1Desc,
                      ),
                      RichItem(
                        title: AppLocalizations.of(
                          context,
                        )!.souvenirFoodItem2Title,
                        description: AppLocalizations.of(
                          context,
                        )!.souvenirFoodItem2Desc,
                      ),
                      RichItem(
                        title: AppLocalizations.of(
                          context,
                        )!.souvenirFoodItem3Title,
                        description: AppLocalizations.of(
                          context,
                        )!.souvenirFoodItem3Desc,
                      ),
                      RichItem(
                        title: AppLocalizations.of(
                          context,
                        )!.souvenirFoodItem4Title,
                        description: AppLocalizations.of(
                          context,
                        )!.souvenirFoodItem4Desc,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Top Bar
          Positioned(
            top: context.h(56),
            left: context.w(20),
            right: context.w(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppBarIcon(
                  icon: MyAssets.backicon,
                  onTap: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
