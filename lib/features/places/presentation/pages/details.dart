import 'package:flutter/material.dart';
import '../../domain/entities/place_entity.dart';
import '../widget/hero_image_section.dart';
import '../widget/details_top_bar.dart';
import '../widget/details_content_card.dart';

class DetailsPage extends StatelessWidget {
  final PlaceEntity place;
  const DetailsPage({super.key, required this.place});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Main scrollable content
          SingleChildScrollView(
            child: Column(
              children: [
                // Hero image section
                HeroImageSection(imageUrl: place.imageUrl),

                // White content card
                DetailsContentCard(place: place),
              ],
            ),
          ),

          // Top bar (positioned absolutely)
          DetailsTopBar(place: place),
        ],
      ),
    );
  }
}
