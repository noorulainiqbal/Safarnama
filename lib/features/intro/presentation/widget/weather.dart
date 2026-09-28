import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../../core/utils/size_extension.dart';
import '../../../../../core/resources/colors.dart';

class WeatherForecastCard extends StatelessWidget {
  final String day;
  final String date;
  final String temperature;
  final String description;
  final String iconPath;
  final String location;

  const WeatherForecastCard({
    super.key,
    required this.day,
    required this.date,
    required this.location,
    required this.temperature,
    required this.description,
    required this.iconPath,
  });

  @override
  Widget build(BuildContext context) {
    if (day == "Loading...") {
      return ClipRRect(
        borderRadius: BorderRadius.circular(context.w(20)),
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: context.w(20),
            sigmaY: context.h(20),
          ),
          child: Container(
            width: context.w(200),
            height: context.h(250),
            padding: EdgeInsets.all(context.w(16)),
            decoration: BoxDecoration(
              color: AppColors.glassBackground,
              borderRadius: BorderRadius.circular(context.w(20)),
            ),
            child: const Center(
              child: CircularProgressIndicator(color: AppColors.white),
            ),
          ),
        ),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(context.w(20)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: context.w(20), sigmaY: context.h(20)),
        child: Container(
          width: context.w(200),
          height: context.h(250),
          padding: EdgeInsets.all(context.w(16)),
          decoration: BoxDecoration(
            color: AppColors.glassBackground,
            borderRadius: BorderRadius.circular(context.w(20)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// DAY & DATE (Top Left)
              Text(
                "$day, $date",
                style: TextStyle(
                  fontFamily: "SF UI Display",
                  fontSize: context.sp(14),
                  fontWeight: FontWeight.w400,
                  color: AppColors.white,
                ),
              ),
              SizedBox(height: context.h(4)),
              Text(
                location,
                style: TextStyle(
                  fontFamily: "SF UI Display",
                  fontSize: context.sp(12),
                  fontWeight: FontWeight.w500,
                  color: AppColors.white,
                ),
              ),

              SizedBox(height: context.h(20)),

              /// ICON + TEMPERATURE ROW
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  /// WEATHER ICON
                  iconPath.startsWith('http')
                      ? Image.network(
                          iconPath,
                          width: context.w(70),
                          height: context.h(70),
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.error, color: AppColors.white),
                        )
                      : Image.asset(
                          iconPath,
                          width: context.w(70),
                          height: context.h(70),
                          fit: BoxFit.contain,
                        ),
                  SizedBox(width: context.w(10)),

                  /// TEMPERATURE
                  Expanded(
                    child: Text(
                      temperature,
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontFamily: "SF UI Display",
                        fontSize: context.sp(35),
                        fontWeight: FontWeight.w600,
                        color: AppColors.white,
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: context.h(20)),

              /// DESCRIPTION (Bottom Centered)
              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    child: Text(
                      description,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontFamily: "SF UI Display",
                        fontSize: context.sp(14),
                        fontWeight: FontWeight.w400,
                        color: AppColors.white,
                        height: 1.4,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
