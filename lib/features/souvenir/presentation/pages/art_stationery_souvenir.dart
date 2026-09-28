import 'package:flutter/material.dart';
import 'package:project/core/resources/colors.dart';
import '../../../../core/utils/size_extension.dart';
import '../../../../../core/resources/assets.dart';
import '../widget/appbariconwidget.dart';
import '../widget/richitemwidget.dart';
import '../../../../l10n/app_localizations.dart';

class ArtStationeryPage extends StatelessWidget {
  const ArtStationeryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      body: Stack(
        children: [
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
                          MyAssets.activity2,
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

                // Content
                Padding(
                  padding: EdgeInsets.all(context.w(20)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.souvenirArtTitle,
                        style: TextStyle(
                          fontFamily: 'SF UI Display',
                          fontWeight: FontWeight.w600,
                          fontSize: context.sp(24),
                          color: AppColors.textPrimary,
                        ),
                      ),
                      SizedBox(height: context.h(8)),
                      Text(
                        AppLocalizations.of(context)!.souvenirArtSubtitle,
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
                            AppLocalizations.of(context)!.souvenirArtRating,
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

                      // Avatars
                      Row(
                        children: [
                          SizedBox(
                            width: context.w(95),
                            height: context.h(32),
                            child: Stack(
                              children: [
                                CircleAvatar(
                                  radius: 16,
                                  backgroundImage: AssetImage(MyAssets.avatar1),
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
                        AppLocalizations.of(context)!.souvenirArtAboutTitle,
                        style: TextStyle(
                          fontFamily: 'SF UI Display',
                          fontWeight: FontWeight.w600,
                          fontSize: context.sp(18),
                          color: AppColors.textPrimary,
                        ),
                      ),
                      SizedBox(height: context.h(12)),
                      Text(
                        AppLocalizations.of(context)!.souvenirArtAboutDesc,
                        style: TextStyle(
                          fontFamily: 'SF UI Display',
                          fontWeight: FontWeight.w400,
                          fontSize: context.sp(14),
                          color: AppColors.textSecondary,
                          height: 1.5,
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
                        )!.souvenirArtItem1Title,
                        description: AppLocalizations.of(
                          context,
                        )!.souvenirArtItem1Desc,
                      ),
                      RichItem(
                        title: AppLocalizations.of(
                          context,
                        )!.souvenirArtItem2Title,
                        description: AppLocalizations.of(
                          context,
                        )!.souvenirArtItem2Desc,
                      ),
                      RichItem(
                        title: AppLocalizations.of(
                          context,
                        )!.souvenirArtItem3Title,
                        description: AppLocalizations.of(
                          context,
                        )!.souvenirArtItem3Desc,
                      ),
                      RichItem(
                        title: AppLocalizations.of(
                          context,
                        )!.souvenirArtItem4Title,
                        description: AppLocalizations.of(
                          context,
                        )!.souvenirArtItem4Desc,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Top bar
          Positioned(
            top: context.h(56),
            left: context.w(20),
            child: AppBarIcon(
              icon: MyAssets.backicon,
              onTap: () => Navigator.pop(context),
            ),
          ),
        ],
      ),
    );
  }
}
