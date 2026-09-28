import 'package:flutter/material.dart';
import 'package:project/features/profile/presentation/pages/profile.dart';
import 'dart:ui';
import '../../../../core/utils/size_extension.dart';
import '../../../../core/resources/assets.dart';
import '../../../../core/resources/colors.dart';
import '../widget/weather.dart';
import '../widget/side_nav.dart';
import '../widget/activity.dart';
import '../widget/bottom_nav.dart';
import 'package:provider/provider.dart';
import '../../../weather/presentation/provider/weather_provider.dart';
import 'package:intl/intl.dart';
import '../../../../l10n/app_localizations.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch weather data when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<WeatherNotifier>().fetchWeather();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          width: context.w(375),
          height: context.h(900), // make it taller than screen height
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(MyAssets.homeback),
                fit: BoxFit.cover,
              ),
            ),
            child: Stack(
              children: [
                // ---------- TOP BAR ----------
                Positioned(
                  top: context.h(56),
                  left: context.w(20),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ProfilePage()),
                      );
                    },
                    borderRadius: BorderRadius.circular(22),
                    child: Container(
                      width: context.h(130),
                      height: context.w(44),
                      decoration: BoxDecoration(
                        color: AppColors.backgroundGrey,
                        borderRadius: BorderRadius.circular(22),
                      ),
                      child: Row(
                        children: [
                          SizedBox(width: context.w(5)),
                          // ------ Pink Circle Behind Profile Pic ------
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                width: context.w(37),
                                height: context.h(37),
                                decoration: BoxDecoration(
                                  color: AppColors.accentPink,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: context.h(5)),
                                child: ClipOval(
                                  child: Image.asset(
                                    MyAssets.profilepic,
                                    width: context.w(33),
                                    height: context.h(33),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(width: context.w(10)),
                          Text(
                            "Leonardo",
                            style: TextStyle(
                              color: AppColors.textPrimary,
                              fontFamily: "SF UI Display",
                              fontSize: context.sp(14),
                              fontWeight: FontWeight.w500,
                              height: context.h(16) / context.h(14),
                              letterSpacing: 0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // ------------------- Explore Title Text -------------------
                Positioned(
                  top: context.h(124),
                  left: context.w(20),
                  child: SizedBox(
                    width: context.w(300),
                    height: context.h(120),
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: AppLocalizations.of(context)!.exploreThe,
                            style: TextStyle(
                              fontFamily: "SF UI Display",
                              fontSize: context.sp(38),
                              fontWeight: FontWeight.w300,
                              height: 50 / 38,
                              color: AppColors.white,
                            ),
                          ),
                          TextSpan(
                            text: AppLocalizations.of(context)!.beautiful,
                            style: TextStyle(
                              fontFamily: "SF UI Display",
                              fontSize: context.sp(38),
                              fontWeight: FontWeight.w600,
                              height: 50 / 38,
                              color: AppColors.black,
                            ),
                          ),
                          TextSpan(
                            text: AppLocalizations.of(context)!.world,
                            style: TextStyle(
                              fontFamily: "SF UI Display",
                              fontSize: context.sp(38),
                              fontWeight: FontWeight.w600,
                              height: 50 / 38,
                              color: AppColors.primaryOrange,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                Positioned(
                  top: context.h(218.2),
                  left: context.w(155.84),
                  child: Transform.rotate(
                    angle: -0.27 * 3.1415926535 / 180,
                    child: Image.asset(
                      MyAssets.underline,
                      width: context.w(160.92),
                      height: context.h(10.34),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),

                //--------Location--------
                Positioned(
                  top: context.h(237),
                  left: context.w(130),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(context.w(22)),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(
                        sigmaX: context.w(20),
                        sigmaY: context.h(20),
                      ),
                      child: Container(
                        width: context.w(118),
                        height: context.h(44),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: AppColors.glassBackground,
                          borderRadius: BorderRadius.circular(context.w(22)),
                        ),
                        child: Text(
                          AppLocalizations.of(context)!.locationToronto,
                          style: TextStyle(
                            fontFamily: "SF UI Display",
                            fontSize: context.sp(20),
                            fontWeight: FontWeight.w200,
                            height: context.h(20) / context.h(16),
                            color: AppColors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                //---------- Weather Widget --------
                Positioned(
                  top: context.h(300),
                  left: context.w(20),
                  child: Consumer<WeatherNotifier>(
                    builder: (context, weatherNotifier, child) {
                      if (weatherNotifier.isLoading) {
                        return WeatherForecastCard(
                          day: "Loading...",
                          date: "",
                          location: "",
                          temperature: "",
                          description: "",
                          iconPath: "",
                        );
                      }

                      if (weatherNotifier.error != null) {
                        return WeatherForecastCard(
                          day: AppLocalizations.of(context)!.error,
                          date: "",
                          location: "",
                          temperature: "--",
                          description:
                              weatherNotifier.error ??
                              AppLocalizations.of(context)!.unknownError,
                          iconPath: MyAssets.sunnyicon,
                        );
                      }

                      final weather = weatherNotifier.weather;
                      if (weather == null) {
                        return WeatherForecastCard(
                          day: AppLocalizations.of(context)!.loading,
                          date: "",
                          location: "",
                          temperature: "",
                          description: "",
                          iconPath: "",
                        );
                      }

                      final date = DateTime.now();
                      final currentLocale = AppLocalizations.of(
                        context,
                      )!.localeName;
                      final dayName = DateFormat.EEEE(
                        currentLocale,
                      ).format(date);
                      final formattedDate = DateFormat.yMMMd(
                        currentLocale,
                      ).format(date);

                      // Map icon code to OpenWeatherMap URL
                      final iconUrl =
                          "http://openweathermap.org/img/wn/${weather.iconCode}@2x.png";

                      return WeatherForecastCard(
                        day: dayName,
                        date: formattedDate,
                        location: weather.cityName,
                        temperature: "${weather.temperature.round()}°C",
                        description: weather.comprehensiveDescription,
                        iconPath: iconUrl,
                      );
                    },
                  ),
                ),

                //--------------Side Nav---------------
                Positioned(
                  right: context.w(25),
                  top: context.h(290),
                  child: SideNavBar(),
                ),

                Positioned(
                  top: context.h(590),
                  left: 0,
                  right: 0,
                  child: const PlacesScroller(),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: const CustomBottomNavBar(),
    );
  }
}
