import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../../../../core/utils/size_extension.dart';
import '../../../../../core/resources/colors.dart';

class LargeLocationMarkerWidget extends StatelessWidget {
  final bool isHighlighted;

  const LargeLocationMarkerWidget({super.key, this.isHighlighted = false});

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: -0.93 * math.pi / 180,
      child: SizedBox(
        width: context.w(100),
        height: context.h(160),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // Large shadow
            Positioned(
              bottom: 0,
              left: context.w(10.26),
              child: Container(
                width: context.w(84.88),
                height: context.h(49.56),
                decoration: BoxDecoration(
                  color: AppColors.textMapShadow.withValues(alpha: .15),
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
            ),
            // Highlight shadow
            if (isHighlighted)
              Positioned(
                bottom: context.h(13),
                left: context.w(34.33),
                child: Container(
                  width: context.w(39.18),
                  height: context.h(23.13),
                  decoration: BoxDecoration(
                    color: AppColors.primaryTeal.withValues(alpha: .5),
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
                size: context.sp(110),
                color: isHighlighted
                    ? AppColors.primaryTeal
                    : AppColors.primaryOrange,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
