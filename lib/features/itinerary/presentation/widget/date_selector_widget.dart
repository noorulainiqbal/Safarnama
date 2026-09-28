// features/itinerary/presentation/widgets/date_selector_widget.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/utils/size_extension.dart';
import '../../../../core/resources/assets.dart';
import '../../../../core/resources/colors.dart';
import '../../../../core/resources/text_styles.dart';

class DateSelectorWidget extends StatelessWidget {
  final DateTime selectedDate;
  final Function(DateTime) onDateChanged;

  const DateSelectorWidget({
    super.key,
    required this.selectedDate,
    required this.onDateChanged,
  });

  @override
  Widget build(BuildContext context) {
    final weekDates = _getWeekDates(selectedDate);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: context.w(20)),
      child: Container(
        width: context.w(335),
        decoration: BoxDecoration(
          color: AppColors.backgroundWhite,
          borderRadius: BorderRadius.circular(context.w(24)),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadowBlack,
              blurRadius: 20,
              offset: Offset(0, 6),
            ),
          ],
        ),
        padding: EdgeInsets.symmetric(
          horizontal: context.w(16),
          vertical: context.h(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Row: Date and navigation icons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  DateFormat('d MMMM').format(selectedDate),
                  style: AppTextStyles.semibold(
                    context,
                    20,
                  ).copyWith(color: AppColors.textPrimary),
                ),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        onDateChanged(selectedDate.subtract(Duration(days: 7)));
                      },
                      child: Container(
                        padding: EdgeInsets.all(context.w(8)),
                        child: Image.asset(
                          MyAssets.backicon,
                          width: context.w(20),
                          height: context.h(20),
                        ),
                      ),
                    ),
                    SizedBox(width: context.w(4)),
                    GestureDetector(
                      onTap: () {
                        onDateChanged(selectedDate.add(Duration(days: 7)));
                      },
                      child: Container(
                        padding: EdgeInsets.all(context.w(8)),
                        child: Transform.rotate(
                          angle: 3.14159,
                          child: Image.asset(
                            MyAssets.backicon,
                            width: context.w(20),
                            height: context.h(20),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: context.h(12)),

            // Days Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(7, (index) {
                final date = weekDates[index];
                final isSelected = _isSameDay(date, selectedDate);
                final isToday = _isSameDay(date, DateTime.now());
                final dayName = DateFormat('E').format(date);
                final dayNumber = DateFormat('d').format(date);

                return GestureDetector(
                  onTap: () => onDateChanged(date),
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 200),
                    width: isSelected ? context.w(44) : context.w(40),
                    height: context.h(76),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(context.w(12)),
                      color: isSelected
                          ? AppColors.primaryOrange
                          : AppColors.backgroundGrey,
                      border: isToday && !isSelected
                          ? Border.all(
                              color: AppColors.primaryOrange,
                              width: 1.5,
                            )
                          : null,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          dayName.substring(0, 1),
                          style: AppTextStyles.regular(context, 15).copyWith(
                            color: isSelected
                                ? AppColors.backgroundWhite
                                : AppColors.textPrimary,
                          ),
                        ),
                        SizedBox(height: context.h(8)),
                        Text(
                          dayNumber,
                          style: AppTextStyles.semibold(context, 16).copyWith(
                            color: isSelected
                                ? AppColors.backgroundWhite
                                : AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  List<DateTime> _getWeekDates(DateTime date) {
    final startOfWeek = date.subtract(Duration(days: date.weekday % 7));
    return List.generate(7, (index) => startOfWeek.add(Duration(days: index)));
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}
