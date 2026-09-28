// features/itinerary/presentation/pages/all_schedules_screen.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../../core/utils/size_extension.dart';
import '../../../../core/resources/assets.dart';
import '../../../../core/resources/colors.dart';
import '../../../../core/resources/text_styles.dart';
import '../../../route/presentation/widget/app_bar_icon_widget.dart';
import '../provider/itinerary_provider.dart';
import '../widget/schedule_card_widget.dart';
import 'add_schedule_screen.dart';
import '../../domain/entities/schedule_entity.dart';

class AllSchedulesScreen extends StatefulWidget {
  const AllSchedulesScreen({super.key});

  @override
  State<AllSchedulesScreen> createState() => _AllSchedulesScreenState();
}

class _AllSchedulesScreenState extends State<AllSchedulesScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ItineraryProvider>().loadSchedules();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundWhite,
      body: Consumer<ItineraryProvider>(
        builder: (context, provider, child) {
          return Column(
            children: [
              _buildAppBar(context),
              Expanded(
                child: provider.allSchedules.isEmpty
                    ? _buildEmptyState(context)
                    : _buildSchedulesList(context, provider),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: context.h(56),
        left: context.w(20),
        right: context.w(20),
        bottom: context.h(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AppBarIconWidget(
            icon: MyAssets.backicon,
            onTap: () => Navigator.pop(context),
          ),
          Text(
            'All Schedules',
            style: AppTextStyles.semibold(
              context,
              18,
            ).copyWith(color: AppColors.textPrimary),
          ),
          SizedBox(width: context.w(44)),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(context.w(40)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.calendar_today_outlined,
              size: context.w(100),
              color: AppColors.textSecondary.withValues(alpha: 0.3),
            ),
            SizedBox(height: context.h(16)),
            Text(
              'No schedules yet',
              style: AppTextStyles.medium(
                context,
                16,
              ).copyWith(color: AppColors.textSecondary),
            ),
            SizedBox(height: context.h(8)),
            Text(
              'Start adding schedules to plan your day',
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

  Widget _buildSchedulesList(BuildContext context, ItineraryProvider provider) {
    final groupedSchedules = _groupSchedulesByDate(provider.allSchedules);

    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: context.w(20)),
      itemCount: groupedSchedules.length,
      itemBuilder: (context, index) {
        final dateKey = groupedSchedules.keys.elementAt(index);
        final schedules = groupedSchedules[dateKey]!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(
                top: context.h(index == 0 ? 0 : 20),
                bottom: context.h(12),
              ),
              child: Text(
                _formatDateHeader(dateKey),
                style: AppTextStyles.semibold(
                  context,
                  18,
                ).copyWith(color: AppColors.textPrimary),
              ),
            ),
            ...schedules.map(
              (schedule) => Padding(
                padding: EdgeInsets.only(bottom: context.h(12)),
                child: ModernScheduleCard(
                  schedule: schedule,
                  onTap: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AddScheduleScreen(schedule: schedule),
                      ),
                    );
                    if (result == true) {
                      if (!context.mounted) return;
                      _showSuccessMessage(
                        context,
                        'Schedule updated successfully',
                      );
                    }
                  },
                  onDelete: () async {
                    final success = await provider.deleteSchedule(schedule.id);
                    if (success) {
                      if (!context.mounted) return;
                      _showSuccessMessage(
                        context,
                        'Schedule deleted successfully',
                      );
                    }
                  },
                  onToggleComplete: (_) {
                    provider.toggleCompletion(schedule.id);
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Map<DateTime, List<ScheduleEntity>> _groupSchedulesByDate(
    List<ScheduleEntity> schedules,
  ) {
    final Map<DateTime, List<ScheduleEntity>> grouped = {};

    for (var schedule in schedules) {
      final date = DateTime(
        schedule.date.year,
        schedule.date.month,
        schedule.date.day,
      );
      grouped.putIfAbsent(date, () => []);
      grouped[date]!.add(schedule);
    }

    final sortedKeys = grouped.keys.toList()..sort();
    return {for (var key in sortedKeys) key: grouped[key]!};
  }

  String _formatDateHeader(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));

    if (date == today) {
      return 'Today, ${DateFormat('MMMM d').format(date)}';
    } else if (date == tomorrow) {
      return 'Tomorrow, ${DateFormat('MMMM d').format(date)}';
    } else {
      return DateFormat('EEEE, MMMM d').format(date);
    }
  }

  void _showSuccessMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: const [
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 12),
          ],
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
