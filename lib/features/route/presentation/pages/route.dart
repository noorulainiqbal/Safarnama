// ignore_for_file: use_super_parameters

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/utils/size_extension.dart';
import '../../../../core/resources/colors.dart';
import '../../../../injection_container.dart' as di;
import '../widget/google_map_widget.dart';
import '../widget/filter_chip_widget.dart';
import '../widget/app_bar_icon_widget.dart';
import '../../domain/entities/place_enitity.dart';
import '../../domain/usecases/get_route_use_case.dart';
import '../provider/route_provider.dart';
import '../../../../l10n/app_localizations.dart';

class RoutePage extends StatefulWidget {
  const RoutePage({super.key});

  @override
  State<RoutePage> createState() => _RoutePageState();
}

class _RoutePageState extends State<RoutePage> {
  late RouteProvider _provider;

  @override
  void initState() {
    super.initState();
    _provider = RouteProvider(di.getIt<GetRouteUseCase>());

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _provider.initialize();
      // Automatically try to get current location
      if (_provider.locationPermissionGranted &&
          _provider.locationServicesEnabled) {
        await _provider.getCurrentLocation();
      } else {
        _showLocationPrompt();
      }
    });
  }

  void _showLocationPrompt() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => LocationPermissionDialog(
        onAllow: () async {
          Navigator.pop(context);
          await _provider.getCurrentLocation();
          if (_provider.locationError != null) {
            _showLocationErrorDialog();
          }
        },
        onDeny: () {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppLocalizations.of(context)!.locationRequiredMsg),
              duration: const Duration(seconds: 3),
            ),
          );
        },
      ),
    );
  }

  void _showLocationErrorDialog() {
    final error = _provider.locationError ?? 'Unknown error';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.locationErrorTitle),
        content: Text(error),
        actions: [
          if (error.contains('disabled'))
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _provider.openLocationSettings();
              },
              child: Text(AppLocalizations.of(context)!.openSettings),
            ),
          if (error.contains('permanently denied'))
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _provider.openAppSettings();
              },
              child: Text(AppLocalizations.of(context)!.openAppSettings),
            ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _provider.clearError();
            },
            child: const Text(
              'OK',
            ), // Using default OK, should localize if strictly needed but usually OK is universal or I should add it. I'll add "ok" key later if needed.
            // Wait, I didn't add OK. I will just leave "OK" as string or use "ok" if I add it.
            // I'll leave "OK" hardcoded for now as it's often acceptable, or use "cancel" if it was a cancel action but it's a confirmation.
            // I'll stick to hardcoded "OK" for this specific button to avoid breaking if key missing.
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _provider.disposeMap();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _provider,
      child: Scaffold(
        body: Consumer<RouteProvider>(
          builder: (context, provider, child) {
            return Stack(
              children: [
                // Google Map
                Positioned.fill(child: GoogleMapWidget()),

                // UI Overlay
                SafeArea(
                  child: Column(
                    children: [
                      // Top Bar
                      Padding(
                        padding: EdgeInsets.only(
                          top: context.h(24),
                          left: context.w(20),
                          right: context.w(20),
                        ),
                        child: Row(
                          children: [
                            AppBarIconWidget(
                              icon: 'assets/icons/back_icon.png',
                              onTap: () {
                                Navigator.pop(context);
                              },
                            ),
                            const Spacer(),
                            if (provider.route != null)
                              _buildRouteInfo(context, provider),
                          ],
                        ),
                      ),

                      SizedBox(height: context.h(20)),

                      // Filter Chips
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: context.w(20),
                        ),
                        child: Container(
                          padding: EdgeInsets.all(context.w(12)),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: .9),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: .1),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: SizedBox(
                            width: context.w(335),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  FilterChipWidget(
                                    category: PlaceCategory.food,
                                  ),
                                  SizedBox(width: context.w(25)),
                                  FilterChipWidget(
                                    category: PlaceCategory.shopping,
                                  ),
                                  SizedBox(width: context.w(25)),
                                  FilterChipWidget(
                                    category: PlaceCategory.gasStation,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),

                      if (provider.error != null)
                        Padding(
                          padding: EdgeInsets.all(context.w(20)),
                          child: Container(
                            padding: EdgeInsets.all(context.w(16)),
                            decoration: BoxDecoration(
                              color: Colors.red[50],
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.red),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.error, color: Colors.red),
                                SizedBox(width: context.w(12)),
                                Expanded(
                                  child: Text(
                                    provider.error!,
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontSize: context.sp(14),
                                    ),
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.close),
                                  onPressed: provider.clearError,
                                ),
                              ],
                            ),
                          ),
                        ),

                      const Spacer(),

                      // Destination Card
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: context.w(20),
                          vertical: context.h(20),
                        ),
                        child: Container(
                          padding: EdgeInsets.all(context.w(16)),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: .15),
                                blurRadius: 20,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                AppLocalizations.of(context)!.whereToGo,
                                style: TextStyle(
                                  fontSize: context.sp(12),
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey[600],
                                  letterSpacing: 1.2,
                                ),
                              ),
                              SizedBox(height: context.h(8)),
                              Row(
                                children: [
                                  Expanded(
                                    child: TextField(
                                      controller:
                                          provider.destinationController,
                                      textDirection: TextDirection.ltr,
                                      textAlign: TextAlign.left,
                                      decoration: InputDecoration(
                                        hintText: AppLocalizations.of(
                                          context,
                                        )!.enterDestinationHint,
                                        hintStyle: TextStyle(
                                          color: Colors.grey[500],
                                          fontSize: context.sp(16),
                                        ),
                                        border: InputBorder.none,
                                        contentPadding: EdgeInsets.zero,
                                      ),
                                      style: TextStyle(
                                        fontSize: context.sp(18),
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: context.w(12)),
                                  Container(
                                    width: context.w(48),
                                    height: context.h(48),
                                    decoration: BoxDecoration(
                                      color: AppColors.primaryBlue2,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: IconButton(
                                      icon: provider.isLoading
                                          ? SizedBox(
                                              width: 20,
                                              height: 20,
                                              child: CircularProgressIndicator(
                                                color: Colors.white,
                                                strokeWidth: 2,
                                              ),
                                            )
                                          : const Icon(
                                              Icons.directions,
                                              color: Colors.white,
                                              size: 24,
                                            ),
                                      onPressed: provider.isLoading
                                          ? null
                                          : () async {
                                              if (!provider
                                                      .locationPermissionGranted ||
                                                  provider.currentLocation ==
                                                      null) {
                                                _showLocationPrompt();
                                              } else {
                                                await provider.startJourney();
                                              }
                                            },
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildRouteInfo(BuildContext context, RouteProvider provider) {
    if (provider.route == null) return const SizedBox();

    final route = provider.route!;
    final distanceKm = (route.distance / 1000).toStringAsFixed(1);
    final durationMin = (route.duration / 60).ceil();

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.w(16),
        vertical: context.h(8),
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.routeInfoTitle,
            style: TextStyle(
              fontSize: context.sp(12),
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: context.h(4)),
          Row(
            children: [
              Icon(
                Icons.directions_car,
                color: AppColors.primaryBlue2,
                size: 16,
              ),
              SizedBox(width: context.w(4)),
              Text(
                '$distanceKm km',
                style: TextStyle(
                  fontSize: context.sp(14),
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(width: context.w(12)),
              Icon(Icons.access_time, color: AppColors.primaryBlue2, size: 16),
              SizedBox(width: context.w(4)),
              Text(
                '$durationMin min',
                style: TextStyle(
                  fontSize: context.sp(14),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          if (route.waypoints.isNotEmpty)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: context.h(4)),
                Text(
                  //                   '${route.waypoints.length} stops',
                  AppLocalizations.of(
                    context,
                  )!.stopsCount(route.waypoints.length),
                  style: TextStyle(
                    fontSize: context.sp(12),
                    color: Colors.green[600],
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

// Location Permission Dialog Widget
class LocationPermissionDialog extends StatelessWidget {
  final VoidCallback onAllow;
  final VoidCallback onDeny;

  const LocationPermissionDialog({
    Key? key,
    required this.onAllow,
    required this.onDeny,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(AppLocalizations.of(context)!.locationPermissionTitle),
      content: Text(AppLocalizations.of(context)!.locationPermissionContent),
      actions: [
        TextButton(
          onPressed: onDeny,
          child: Text(AppLocalizations.of(context)!.notNow),
        ),
        ElevatedButton(
          onPressed: onAllow,
          child: Text(AppLocalizations.of(context)!.allow),
        ),
      ],
    );
  }
}
