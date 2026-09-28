import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../../core/utils/size_extension.dart';
import '../../../../core/resources/assets.dart';

class PlaceCard extends StatelessWidget {
  final String imagePath;
  final String title;

  const PlaceCard({super.key, required this.imagePath, required this.title});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(context.w(20)),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: context.w(20), // approx blur(220px)
          sigmaY: context.h(20),
        ),
        child: Container(
          width: context.w(220),
          margin: EdgeInsets.only(right: context.w(16)),
          decoration: BoxDecoration(
            color: const Color(
              0x993E3E3E,
            ), // blurred dark background (60% opacity)
            borderRadius: BorderRadius.circular(context.w(20)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// IMAGE
              ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(context.w(20)),
                  topRight: Radius.circular(context.w(20)),
                ),
                child: Image.asset(
                  imagePath,
                  width: context.w(220),
                  height: context.h(140),
                  fit: BoxFit.cover,
                ),
              ),

              SizedBox(height: context.h(10)),

              /// TITLE
              Padding(
                padding: EdgeInsets.symmetric(horizontal: context.w(12)),
                child: Text(
                  title,
                  style: TextStyle(
                    fontFamily: "SF UI Display",
                    fontWeight: FontWeight.w500,
                    fontSize: context.sp(18),
                    height: 24 / 18,
                    letterSpacing: 0.5,
                    color: Colors.white,
                  ),
                ),
              ),

              SizedBox(height: context.h(12)),
            ],
          ),
        ),
      ),
    );
  }
}

class PlacesScroller extends StatelessWidget {
  const PlacesScroller({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: context.h(200), // fits image + text perfectly
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            SizedBox(width: context.w(20)), // left padding

            PlaceCard(
              imagePath: MyAssets.activity1, // update with your asset
              title: "Niladri Reservoir",
            ),

            PlaceCard(
              imagePath: MyAssets.activity2, // update with your asset
              title: "Niladri Reservoir",
            ),

            SizedBox(width: context.w(20)), // right padding
          ],
        ),
      ),
    );
  }
}
