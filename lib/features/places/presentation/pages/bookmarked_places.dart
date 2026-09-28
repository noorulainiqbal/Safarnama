import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/places_provider.dart';
import '../widget/bookmarked_places_header.dart';
import '../widget/place_card_widget.dart';
import 'package:project/features/places/presentation/pages/details.dart';
import '../../../../core/resources/text_styles.dart';
import '../../../../core/utils/size_extension.dart';
import '../../../../l10n/app_localizations.dart';

class BookmarkedPlacesPage extends StatelessWidget {
  const BookmarkedPlacesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Consumer<PlacesProvider>(
          builder: (context, provider, child) {
            // Fetch bookmarks on init if empty ??
            // Better to trigger fetch somewhere else or assume executed.
            // provider.fetchBookmarkedIds();
            // Actually `fetchPlaces` calls it.

            final bookmarks = provider.bookmarkedPlaces;

            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: context.w(24)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: context.h(16)),

                    // Header with back button
                    const BookmarkedPlacesHeader(),

                    SizedBox(height: context.h(28)),

                    // "Bookmarked Places" title
                    Text(
                      AppLocalizations.of(context)!.bookmarkedPlacesTitle,
                      style: AppTextStyles.semibold(context, 20),
                    ),

                    SizedBox(height: context.h(15)),

                    // Grid of bookmarked places
                    if (bookmarks.isEmpty)
                      Center(
                        child: Padding(
                          padding: EdgeInsets.only(top: context.h(50)),
                          child: Text(
                            AppLocalizations.of(context)!.noBookmarks,
                            style: AppTextStyles.regular(
                              context,
                              16,
                            ).copyWith(color: Colors.grey),
                          ),
                        ),
                      )
                    else
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: context.w(14),
                          mainAxisSpacing: context.h(16),
                          childAspectRatio: 0.62,
                        ),
                        itemCount: bookmarks.length,
                        itemBuilder: (context, index) {
                          final place = bookmarks[index];
                          return InkWell(
                            onTap: () {
                              // Navigate to details if needed, or stick to current behavior
                              // User said "functional meaning only the places user bookmarks should show"
                              // Assuming navigation is desired as well.
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      DetailsPage(place: place),
                                ),
                              );
                            },
                            child: PlaceCardWidget(
                              image: place.imageUrl,
                              title: place.name,
                              location: place.location,
                              rating: place.rating,
                              price: place.price,
                              isBookmarked: true,
                              onBookmarkTap: () =>
                                  provider.toggleBookmark(place.id),
                            ),
                          );
                        },
                      ),

                    SizedBox(height: context.h(32)),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
