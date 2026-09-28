// features/itinerary/presentation/widgets/modern_calendar_widget.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/utils/size_extension.dart';
import '../../../../core/resources/colors.dart';
import '../../../../core/resources/text_styles.dart';

class ModernCalendarWidget extends StatelessWidget {
  final DateTime selectedDate;
  final Function(DateTime) onDateChanged;
  final Map<DateTime, int> scheduleCounts; // Date -> count of schedules

  const ModernCalendarWidget({
    super.key,
    required this.selectedDate,
    required this.onDateChanged,
    this.scheduleCounts = const {},
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: context.w(20)),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.backgroundWhite,
          borderRadius: BorderRadius.circular(context.w(20)),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadowLight,
              blurRadius: 20,
              offset: Offset(0, 4),
            ),
          ],
        ),
        padding: EdgeInsets.all(context.w(20)),
        child: Column(
          children: [
            // Month/Year Header with navigation
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Previous Month
                IconButton(
                  onPressed: () {
                    final newDate = DateTime(
                      selectedDate.year,
                      selectedDate.month - 1,
                      selectedDate.day,
                    );
                    onDateChanged(newDate);
                  },
                  icon: Icon(Icons.chevron_left, size: context.w(28)),
                  color: AppColors.textPrimary,
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints(),
                ),

                // Month Year Display
                Text(
                  DateFormat('MMMM yyyy').format(selectedDate),
                  style: AppTextStyles.semibold(
                    context,
                    18,
                  ).copyWith(color: AppColors.textPrimary),
                ),

                // Next Month
                IconButton(
                  onPressed: () {
                    final newDate = DateTime(
                      selectedDate.year,
                      selectedDate.month + 1,
                      selectedDate.day,
                    );
                    onDateChanged(newDate);
                  },
                  icon: Icon(Icons.chevron_right, size: context.w(28)),
                  color: AppColors.textPrimary,
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints(),
                ),
              ],
            ),

            SizedBox(height: context.h(20)),

            // Day-by-Day Navigation
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Previous Day
                GestureDetector(
                  onTap: () {
                    onDateChanged(selectedDate.subtract(Duration(days: 1)));
                  },
                  child: Container(
                    width: context.w(40),
                    height: context.h(40),
                    decoration: BoxDecoration(
                      color: AppColors.backgroundGrey,
                      borderRadius: BorderRadius.circular(context.w(12)),
                    ),
                    child: Icon(
                      Icons.arrow_back_ios_new,
                      size: context.w(16),
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),

                // Current Date Display
                Expanded(
                  child: GestureDetector(
                    onTap: () => _showDatePicker(context),
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: context.w(12)),
                      padding: EdgeInsets.symmetric(
                        vertical: context.h(12),
                        horizontal: context.w(16),
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppColors.primaryOrange,
                            AppColors.primaryOrangeDark,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(context.w(16)),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.shadowOrange,
                            blurRadius: 12,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Text(
                            DateFormat('EEEE').format(selectedDate),
                            style: AppTextStyles.medium(context, 14).copyWith(
                              color: AppColors.backgroundWhite.withValues(
                                alpha: 0.9,
                              ),
                            ),
                          ),
                          SizedBox(height: context.h(4)),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                DateFormat('d').format(selectedDate),
                                style: AppTextStyles.semibold(context, 32)
                                    .copyWith(
                                      color: AppColors.backgroundWhite,
                                      height: 1,
                                    ),
                              ),
                              SizedBox(width: context.w(8)),
                              Padding(
                                padding: EdgeInsets.only(bottom: context.h(4)),
                                child: Text(
                                  DateFormat('MMM').format(selectedDate),
                                  style: AppTextStyles.medium(
                                    context,
                                    16,
                                  ).copyWith(color: AppColors.backgroundWhite),
                                ),
                              ),
                            ],
                          ),
                          if (_getScheduleCount(selectedDate) > 0) ...[
                            SizedBox(height: context.h(6)),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: context.w(8),
                                vertical: context.h(2),
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.backgroundWhite.withValues(
                                  alpha: 0.3,
                                ),
                                borderRadius: BorderRadius.circular(
                                  context.w(8),
                                ),
                              ),
                              child: Text(
                                '${_getScheduleCount(selectedDate)} schedule${_getScheduleCount(selectedDate) > 1 ? 's' : ''}',
                                style: AppTextStyles.medium(
                                  context,
                                  11,
                                ).copyWith(color: AppColors.backgroundWhite),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),

                // Next Day
                GestureDetector(
                  onTap: () {
                    onDateChanged(selectedDate.add(Duration(days: 1)));
                  },
                  child: Container(
                    width: context.w(40),
                    height: context.h(40),
                    decoration: BoxDecoration(
                      color: AppColors.backgroundGrey,
                      borderRadius: BorderRadius.circular(context.w(12)),
                    ),
                    child: Icon(
                      Icons.arrow_forward_ios,
                      size: context.w(16),
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: context.h(16)),

            // Quick Jump Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildQuickButton(
                  context,
                  'Today',
                  () => onDateChanged(DateTime.now()),
                  _isToday(selectedDate),
                ),
                _buildQuickButton(
                  context,
                  'Tomorrow',
                  () => onDateChanged(DateTime.now().add(Duration(days: 1))),
                  _isTomorrow(selectedDate),
                ),
                _buildQuickButton(
                  context,
                  'Next Week',
                  () => onDateChanged(DateTime.now().add(Duration(days: 7))),
                  false,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickButton(
    BuildContext context,
    String label,
    VoidCallback onTap,
    bool isActive,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: context.w(12),
          vertical: context.h(8),
        ),
        decoration: BoxDecoration(
          color: isActive
              ? AppColors.primaryOrange.withValues(alpha: 0.1)
              : AppColors.backgroundGrey,
          borderRadius: BorderRadius.circular(context.w(8)),
          border: isActive
              ? Border.all(color: AppColors.primaryOrange, width: 1.5)
              : null,
        ),
        child: Text(
          label,
          style: AppTextStyles.medium(context, 12).copyWith(
            color: isActive ? AppColors.primaryOrange : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }

  Future<void> _showDatePicker(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(primary: AppColors.primaryOrange),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      onDateChanged(picked);
    }
  }

  int _getScheduleCount(DateTime date) {
    final key = DateTime(date.year, date.month, date.day);
    return scheduleCounts[key] ?? 0;
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  bool _isTomorrow(DateTime date) {
    final tomorrow = DateTime.now().add(Duration(days: 1));
    return date.year == tomorrow.year &&
        date.month == tomorrow.month &&
        date.day == tomorrow.day;
  }
}
