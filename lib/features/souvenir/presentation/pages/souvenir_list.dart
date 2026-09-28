import 'package:flutter/material.dart';
import 'package:project/features/route/presentation/widget/app_bar_icon_widget.dart';
import 'package:project/features/souvenir/presentation/pages/food_drink_souvenir.dart';
import 'package:project/features/souvenir/presentation/pages/cultural_handicrafts_souvenir.dart';
import 'package:project/features/souvenir/presentation/pages/art_stationery_souvenir.dart';
import 'package:project/features/souvenir/presentation/pages/practical_unique_souvenir.dart';

import '../../../../core/utils/size_extension.dart';
import '../../../../../core/resources/assets.dart';
import '../../../../../core/resources/colors.dart';
import '../widget/buildsouvenircardwidget.dart';
import '../../../../l10n/app_localizations.dart';

class SouvenirPage extends StatelessWidget {
  const SouvenirPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Top AppBar
          Padding(
            padding: EdgeInsets.only(
              top: context.h(56),
              left: context.w(20),
              right: context.w(20),
            ),
            child: SizedBox(
              width: context.w(335),
              height: context.h(44),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppBarIconWidget(
                    icon: MyAssets.backicon,
                    onTap: () => Navigator.pop(context),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        AppLocalizations.of(context)!.souvenirsTitle,
                        style: TextStyle(
                          fontFamily: "SF UI Display",
                          fontWeight: FontWeight.w600,
                          fontSize: context.sp(18),
                          height: 22 / 18,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: context.w(44)), // Spacer
                ],
              ),
            ),
          ),
          // Main Content
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: context.w(20)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: context.h(20)),
                  Text(
                    AppLocalizations.of(context)!.allPopularSouvenirs,
                    style: TextStyle(
                      fontFamily: 'SF UI Display',
                      fontWeight: FontWeight.w600,
                      fontSize: context.sp(20),
                      height: 28 / 20,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: context.h(16)),
                  Expanded(
                    child: ListView(
                      children: [
                        // Food & Drink
                        BuildSouvenirCardWidget(
                          image: MyAssets.place2,
                          title: AppLocalizations.of(context)!.foodDrink,
                          description: AppLocalizations.of(
                            context,
                          )!.foodDrinkDesc,
                          rating: AppLocalizations.of(
                            context,
                          )!.foodiesFavourite,
                          personCount: AppLocalizations.of(context)!.nItems(4),
                          avatar1: MyAssets.avatar1,
                          avatar2: MyAssets.avatar2,
                          avatar3: MyAssets.avatar3,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => FoodDrinkDetailsPage(),
                              ),
                            );
                          },
                        ),
                        SizedBox(height: context.h(16)),

                        // Cultural & Handicrafts
                        BuildSouvenirCardWidget(
                          image: MyAssets.activity1,
                          title: AppLocalizations.of(
                            context,
                          )!.culturalHandicrafts,
                          description: AppLocalizations.of(
                            context,
                          )!.culturalDesc,
                          rating: AppLocalizations.of(
                            context,
                          )!.personalisedPick,
                          personCount: AppLocalizations.of(context)!.nItems(6),
                          avatar1: MyAssets.avatar1,
                          avatar2: MyAssets.avatar2,
                          avatar3: MyAssets.avatar3,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => CulturalHandicraftsPage(),
                              ),
                            );
                          },
                        ),
                        SizedBox(height: context.h(16)),

                        // Art & Stationery
                        BuildSouvenirCardWidget(
                          image: MyAssets.activity2,
                          title: AppLocalizations.of(context)!.artStationery,
                          description: AppLocalizations.of(context)!.artDesc,
                          rating: AppLocalizations.of(context)!.artsyPick,
                          personCount: AppLocalizations.of(context)!.nItems(4),
                          avatar1: MyAssets.avatar1,
                          avatar2: MyAssets.avatar2,
                          avatar3: MyAssets.avatar3,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ArtStationeryPage(),
                              ),
                            );
                          },
                        ),
                        SizedBox(height: context.h(16)),

                        // Practical & Unique
                        BuildSouvenirCardWidget(
                          image: MyAssets.place2,
                          title: AppLocalizations.of(context)!.practicalUnique,
                          description: AppLocalizations.of(
                            context,
                          )!.practicalDesc,
                          rating: AppLocalizations.of(context)!.safePick,
                          personCount: AppLocalizations.of(context)!.nItems(10),
                          avatar1: MyAssets.avatar1,
                          avatar2: MyAssets.avatar2,
                          avatar3: MyAssets.avatar3,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => PracticalUniquePage(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
