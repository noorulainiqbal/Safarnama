import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../../../../core/utils/size_extension.dart';
import '../../../../../core/resources/colors.dart';

class LocationMarkerWidget extends StatelessWidget {
  const LocationMarkerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: -0.93 * math.pi / 180,
      child: SizedBox(
        width: context.w(50),
        height: context.h(70),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // Large shadow
            Positioned(
              bottom: 0,
              left: context.w(6.35),
              child: Container(
                width: context.w(35.02),
                height: context.h(20.45),
                decoration: BoxDecoration(
                  color: AppColors.textMapShadow.withValues(alpha: .15),
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
            ),
            // Small shadow
            Positioned(
              bottom: context.h(5),
              left: context.w(15.86),
              child: Container(
                width: context.w(16.16),
                height: context.h(9.54),
                decoration: BoxDecoration(
                  color: AppColors.textMapShadow.withValues(alpha: .5),
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
            ),
            // Pin icon
            Positioned(
              top: 0,
              left: 0,
              child: Icon(
                Icons.location_on,
                size: context.sp(45),
                color: AppColors.primaryOrange,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
