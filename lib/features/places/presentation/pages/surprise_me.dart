import 'package:flutter/material.dart';
import 'package:project/features/places/presentation/pages/details.dart';
import '../../../../l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../provider/places_provider.dart';
import '../widget/bookmarked_places_header.dart';
import '../widget/place_card_widget.dart';
import '../../../../core/resources/text_styles.dart';
import '../../../../core/utils/size_extension.dart';
import '../../../../core/resources/colors.dart';

class SurpriseMePage extends StatelessWidget {
  const SurpriseMePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Access provider just to trigger fetch on init ?? No, stateless widget shouldn't trigger side effects in build.
    // Ideally use a stateful widget for init, OR call it in a button press, OR use a post-frame callback.
    // Requirement said: "shows the same 6 places cards thst search does with their same details".
    // And "button that is c,ickable and says pick random places for me to visit today".
    // So initially maybe empty? Or maybe show previous?
    // "the surprime me page shpuld show the user a button that is c,ickable and says pick random places for me to visit today , and it shows the same 6 places cards thst search does with their same details."
    // So distinct button action.

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: context.w(24)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: context.h(16)),

                // Header with back button
                BookmarkedPlacesHeader(
                  title: AppLocalizations.of(context)!.surpriseAdventures,
                ),

                SizedBox(height: context.h(32)),

                // Button
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      context.read<PlacesProvider>().fetchRandomPlaces();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryOrange,
                      foregroundColor: Colors.white,
                      elevation: 10,
                      shadowColor: AppColors.primaryOrange.withValues(
                        alpha: 0.4,
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: context.w(32),
                        vertical: context.h(18),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Text(
                      AppLocalizations.of(context)!.pickRandomPlaces,
                      style: AppTextStyles.medium(
                        context,
                        16,
                      ).copyWith(color: Colors.white),
                    ),
                  ),
                ),

                SizedBox(height: context.h(24)),

                // List or Instruction
                Consumer<PlacesProvider>(
                  builder: (context, provider, child) {
                    if (provider.isLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (provider.error != null) {
                      return Center(child: Text('Error: ${provider.error}'));
                    }

                    if (provider.randomPlaces.isEmpty) {
                      return SizedBox(
                        height: context.h(
                          500,
                        ), // Increased height to push text lower via Center widget
                        child: Center(
                          child: Text(
                            AppLocalizations.of(context)!.clickForSuggestions,
                            style: AppTextStyles.regular(
                              context,
                              16,
                            ).copyWith(color: AppColors.textSecondary),
                          ),
                        ),
                      );
                    }

                    return GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: context.w(14),
                        mainAxisSpacing: context.h(16),
                        childAspectRatio: 0.62,
                      ),
                      itemCount: provider.randomPlaces.length,
                      itemBuilder: (context, index) {
                        final place = provider.randomPlaces[index];
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetailsPage(place: place),
                              ),
                            );
                          },
                          child: PlaceCardWidget(
                            image: place.imageUrl,
                            title: place.name,
                            location: place.location,
                            rating: place.rating,
                            price: place.price,
                            isBookmarked: provider.isBookmarked(place.id),
                            onBookmarkTap: () =>
                                provider.toggleBookmark(place.id),
                          ),
                        );
                      },
                    );
                  },
                ),

                SizedBox(height: context.h(32)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
