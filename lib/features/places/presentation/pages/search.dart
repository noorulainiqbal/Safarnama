import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:project/features/places/presentation/pages/details.dart';
import 'package:project/features/route/presentation/widget/app_bar_icon_widget.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../core/utils/size_extension.dart';
import '../../../../../core/resources/assets.dart';
import '../../../../../core/resources/colors.dart';
import '../provider/places_provider.dart';
import '../widget/search_bar_widget.dart';
import '../widget/place_card_widget.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Fetch places when the page loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PlacesProvider>().fetchPlaces();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Consumer<PlacesProvider>(
        builder: (context, provider, child) {
          return Column(
            children: [
              // Top Bar
              Padding(
                padding: EdgeInsets.only(
                  top: context.h(56),
                  left: context.w(20),
                  right: context.w(20),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppBarIconWidget(
                      icon: MyAssets.backicon,
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                    Text(
                      AppLocalizations.of(context)!.searchTitle,
                      style: TextStyle(
                        fontFamily: "SF UI Display",
                        fontWeight: FontWeight.w600,
                        fontSize: context.sp(18),
                        height: 22 / 18,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        AppLocalizations.of(context)!.cancel,
                        style: TextStyle(
                          fontFamily: "SF UI Display",
                          fontWeight: FontWeight.w600,
                          fontSize: context.sp(16),
                          height: 20 / 16,
                          color: AppColors.primaryOrange,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: context.h(30)),
              // Search Bar
              Padding(
                padding: EdgeInsets.symmetric(horizontal: context.w(20)),
                child: SearchBarWidget(
                  controller: _searchController,
                  onChanged: (query) {
                    provider.search(query);
                  },
                ),
              ),
              SizedBox(height: context.h(30)),
              // Search Results
              Expanded(
                child: provider.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : provider.error != null
                    ? Center(child: Text('Error: ${provider.error}'))
                    : SingleChildScrollView(
                        padding: EdgeInsets.symmetric(
                          horizontal: context.w(20),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppLocalizations.of(context)!.searchPlacesHeader,
                              style: TextStyle(
                                fontFamily: 'SF UI Display',
                                fontWeight: FontWeight.w600,
                                fontSize: context.sp(20),
                                height: 28 / 20,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            SizedBox(height: context.h(16)),
                            // Grid of Cards
                            GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: context.w(14),
                                    mainAxisSpacing: context.h(16),
                                    childAspectRatio: 0.62, // Adjust as needed
                                  ),
                              itemCount: provider.places.length,
                              itemBuilder: (context, index) {
                                final place = provider.places[index];
                                return InkWell(
                                  onTap: () {
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
                                    isBookmarked: provider.isBookmarked(
                                      place.id,
                                    ),
                                    onBookmarkTap: () =>
                                        provider.toggleBookmark(place.id),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}
