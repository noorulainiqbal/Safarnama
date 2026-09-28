// features/itinerary/presentation/pages/modern_schedule_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../l10n/app_localizations.dart';

import '../../../../core/utils/size_extension.dart';
import '../../../../core/resources/assets.dart';
import '../../../../core/resources/colors.dart';
import '../../../../core/resources/text_styles.dart';
import '../../../route/presentation/widget/app_bar_icon_widget.dart';
import '../provider/itinerary_provider.dart';
import '../widget/modern_calender_widget.dart';
import '../widget/schedule_card_widget.dart';
import 'add_schedule_screen.dart';

class ModernScheduleScreen extends StatefulWidget {
  const ModernScheduleScreen({super.key});

  @override
  State<ModernScheduleScreen> createState() => _ModernScheduleScreenState();
}

class _ModernScheduleScreenState extends State<ModernScheduleScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ItineraryProvider>().loadSchedules();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      body: Consumer<ItineraryProvider>(
        builder: (context, provider, child) {
          return Stack(
            children: [
              Column(
                children: [
                  _buildAppBar(context, provider),
                  SizedBox(height: context.h(20)),

                  // Modern Calendar
                  ModernCalendarWidget(
                    selectedDate: provider.selectedDate,
                    onDateChanged: (date) {
                      provider.selectDate(date);
                    },
                  ),

                  SizedBox(height: context.h(24)),

                  // Tabs
                  _buildTabs(context, provider),

                  // Tab Content
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        _buildTodayTab(context, provider),
                        _buildUpcomingTab(context, provider),
                        _buildCompletedTab(context, provider),
                      ],
                    ),
                  ),
                ],
              ),

              // Add Button
              _buildAddButton(context),
            ],
          );
        },
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, ItineraryProvider provider) {
    return Padding(
      padding: EdgeInsets.only(
        top: context.h(56),
        left: context.w(20),
        right: context.w(20),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: AppBarIconWidget(
              icon: MyAssets.backicon,
              onTap: () => Navigator.pop(context),
            ),
          ),
          Text(
            AppLocalizations.of(context)!.mySchedule,
            style: AppTextStyles.semibold(
              context,
              20,
            ).copyWith(color: AppColors.textPrimary),
          ),
        ],
      ),
    );
  }

  Widget _buildTabs(BuildContext context, ItineraryProvider provider) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: context.w(20)),
      decoration: BoxDecoration(
        color: AppColors.backgroundGrey,
        borderRadius: BorderRadius.circular(context.w(12)),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          color: AppColors.primaryOrange,
          borderRadius: BorderRadius.circular(context.w(10)),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        labelColor: AppColors.backgroundWhite,
        unselectedLabelColor: AppColors.textSecondary,
        labelStyle: AppTextStyles.semibold(
          context,
          13,
        ), // Reduced font slightly
        unselectedLabelStyle: AppTextStyles.medium(context, 13),
        labelPadding: EdgeInsets.zero, // Remove default padding
        tabs: [
          Tab(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(AppLocalizations.of(context)!.today),
                if (provider.todaySchedules.isNotEmpty) ...[
                  SizedBox(width: context.w(4)), // Reduced spacing
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: context.w(4), // Reduced padding
                      vertical: context.h(2),
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(context.w(8)),
                    ),
                    child: Text(
                      '${provider.todaySchedules.length}',
                      style: AppTextStyles.semibold(context, 10),
                    ),
                  ),
                ],
              ],
            ),
          ),
          Tab(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(AppLocalizations.of(context)!.upcoming),
                if (provider.upcomingSchedules.isNotEmpty) ...[
                  SizedBox(width: context.w(4)), // Reduced spacing
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: context.w(4), // Reduced padding
                      vertical: context.h(2),
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(context.w(8)),
                    ),
                    child: Text(
                      '${provider.upcomingSchedules.length}',
                      style: AppTextStyles.semibold(context, 10),
                    ),
                  ),
                ],
              ],
            ),
          ),
          Tab(text: AppLocalizations.of(context)!.completed),
        ],
      ),
    );
  }

  Widget _buildTodayTab(BuildContext context, ItineraryProvider provider) {
    if (provider.todaySchedules.isEmpty) {
      return _buildEmptyState(
        context,
        AppLocalizations.of(context)!.noSchedulesToday,
        AppLocalizations.of(context)!.addScheduleHint,
        Icons.today_outlined,
      );
    }

    return ListView.separated(
      padding: EdgeInsets.fromLTRB(
        context.w(20),
        context.h(20),
        context.w(20),
        context.h(100),
      ),
      itemCount: provider.todaySchedules.length,
      separatorBuilder: (_, __) => SizedBox(height: context.h(12)),
      itemBuilder: (context, index) {
        final schedule = provider.todaySchedules[index];
        return ModernScheduleCard(
          schedule: schedule,
          onTap: () => _editSchedule(context, schedule),
          onDelete: () => _deleteSchedule(context, provider, schedule.id),
          onToggleComplete: (_) => provider.toggleCompletion(schedule.id),
        );
      },
    );
  }

  Widget _buildUpcomingTab(BuildContext context, ItineraryProvider provider) {
    if (provider.upcomingSchedules.isEmpty) {
      return _buildEmptyState(
        context,
        AppLocalizations.of(context)!.noUpcomingSchedules,
        AppLocalizations.of(context)!.planAheadHint,
        Icons.event_outlined,
      );
    }

    return ListView.separated(
      padding: EdgeInsets.fromLTRB(
        context.w(20),
        context.h(20),
        context.w(20),
        context.h(100),
      ),
      itemCount: provider.upcomingSchedules.length,
      separatorBuilder: (_, __) => SizedBox(height: context.h(12)),
      itemBuilder: (context, index) {
        final schedule = provider.upcomingSchedules[index];
        return ModernScheduleCard(
          schedule: schedule,
          onTap: () => _editSchedule(context, schedule),
          onDelete: () => _deleteSchedule(context, provider, schedule.id),
          onToggleComplete: (_) => provider.toggleCompletion(schedule.id),
        );
      },
    );
  }

  Widget _buildCompletedTab(BuildContext context, ItineraryProvider provider) {
    if (provider.completedSchedules.isEmpty) {
      return _buildEmptyState(
        context,
        AppLocalizations.of(context)!.noCompletedSchedules,
        AppLocalizations.of(context)!.checkOffHint,
        Icons.check_circle_outline,
      );
    }

    return ListView.separated(
      padding: EdgeInsets.fromLTRB(
        context.w(20),
        context.h(20),
        context.w(20),
        context.h(100),
      ),
      itemCount: provider.completedSchedules.length,
      separatorBuilder: (_, __) => SizedBox(height: context.h(12)),
      itemBuilder: (context, index) {
        final schedule = provider.completedSchedules[index];
        return ModernScheduleCard(
          schedule: schedule,
          onTap: () => _editSchedule(context, schedule),
          onDelete: () => _deleteSchedule(context, provider, schedule.id),
          onToggleComplete: (_) => provider.toggleCompletion(schedule.id),
        );
      },
    );
  }

  Widget _buildEmptyState(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
  ) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(context.w(40)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: context.w(80),
              color: AppColors.textSecondary.withValues(alpha: 0.3),
            ),
            SizedBox(height: context.h(16)),
            Text(
              title,
              style: AppTextStyles.semibold(
                context,
                16,
              ).copyWith(color: AppColors.textSecondary),
            ),
            SizedBox(height: context.h(8)),
            Text(
              subtitle,
              style: AppTextStyles.regular(
                context,
                14,
              ).copyWith(color: AppColors.textSecondary.withValues(alpha: 0.7)),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddButton(BuildContext context) {
    return Positioned(
      bottom: context.h(20),
      left: context.w(20),
      right: context.w(20),
      child: GestureDetector(
        onTap: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => AddScheduleScreen()),
          );
          if (result == true) {
            if (!context.mounted) return;
            _showSuccess(context, AppLocalizations.of(context)!.scheduleAdded);
          }
        },
        child: Container(
          height: context.h(56),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.primaryOrange, AppColors.primaryOrangeDark],
            ),
            borderRadius: BorderRadius.circular(context.w(16)),
            boxShadow: [
              BoxShadow(
                color: AppColors.shadowOrange,
                blurRadius: 15,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.add,
                color: AppColors.backgroundWhite,
                size: context.w(24),
              ),
              SizedBox(width: context.w(8)),
              Text(
                AppLocalizations.of(context)!.addNewSchedule,
                style: AppTextStyles.semibold(
                  context,
                  16,
                ).copyWith(color: AppColors.backgroundWhite),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _editSchedule(BuildContext context, schedule) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => AddScheduleScreen(schedule: schedule)),
    );
    if (result == true) {
      if (!context.mounted) return;
      _showSuccess(context, AppLocalizations.of(context)!.scheduleUpdated);
    }
  }

  Future<void> _deleteSchedule(
    BuildContext context,
    ItineraryProvider provider,
    String scheduleId,
  ) async {
    final success = await provider.deleteSchedule(scheduleId);
    if (success) {
      if (!context.mounted) return;
      _showSuccess(context, AppLocalizations.of(context)!.scheduleDeleted);
    }
  }

  void _showSuccess(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white, size: 20),
            SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 2),
      ),
    );
  }
}
