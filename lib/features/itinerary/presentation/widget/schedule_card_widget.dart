// features/itinerary/presentation/widgets/modern_schedule_card_widget.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/utils/size_extension.dart';
import '../../../../core/resources/colors.dart';
import '../../../../core/resources/text_styles.dart';
import '../../domain/entities/schedule_entity.dart';

class ModernScheduleCard extends StatelessWidget {
  final ScheduleEntity schedule;
  final VoidCallback onTap;
  final VoidCallback onDelete;
  final Function(bool) onToggleComplete;

  const ModernScheduleCard({
    super.key,
    required this.schedule,
    required this.onTap,
    required this.onDelete,
    required this.onToggleComplete,
  });

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat('MMM d, y').format(schedule.date);

    return Dismissible(
      key: Key(schedule.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: context.w(20)),
        decoration: BoxDecoration(
          color: AppColors.accentRed,
          borderRadius: BorderRadius.circular(context.w(16)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.delete_outline,
              color: Colors.white,
              size: context.w(28),
            ),
            SizedBox(height: context.h(4)),
            Text(
              'Delete',
              style: AppTextStyles.medium(
                context,
                12,
              ).copyWith(color: Colors.white),
            ),
          ],
        ),
      ),
      confirmDismiss: (direction) => _confirmDelete(context),
      onDismissed: (_) => onDelete(),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: schedule.isCompleted
                ? AppColors.backgroundGrey
                : AppColors.backgroundWhite,
            borderRadius: BorderRadius.circular(context.w(16)),
            border: Border.all(
              color: schedule.isCompleted
                  ? AppColors.borderGrey
                  : Colors.transparent,
              width: 1,
            ),
            boxShadow: schedule.isCompleted
                ? []
                : [
                    BoxShadow(
                      color: AppColors.shadowLight,
                      blurRadius: 12,
                      offset: Offset(0, 2),
                    ),
                  ],
          ),
          padding: EdgeInsets.all(context.w(14)),
          child: Row(
            children: [
              // Completion Checkbox
              GestureDetector(
                onTap: () => onToggleComplete(!schedule.isCompleted),
                child: Container(
                  width: context.w(24),
                  height: context.h(24),
                  decoration: BoxDecoration(
                    color: schedule.isCompleted
                        ? AppColors.primaryOrange
                        : AppColors.backgroundWhite,
                    borderRadius: BorderRadius.circular(context.w(6)),
                    border: Border.all(
                      color: schedule.isCompleted
                          ? AppColors.primaryOrange
                          : AppColors.borderGrey,
                      width: 2,
                    ),
                  ),
                  child: schedule.isCompleted
                      ? Icon(
                          Icons.check,
                          size: context.w(16),
                          color: AppColors.backgroundWhite,
                        )
                      : null,
                ),
              ),

              SizedBox(width: context.w(12)),

              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      schedule.title,
                      style: AppTextStyles.semibold(context, 16).copyWith(
                        color: schedule.isCompleted
                            ? AppColors.textSecondary
                            : AppColors.textPrimary,
                        decoration: schedule.isCompleted
                            ? TextDecoration.lineThrough
                            : null,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

                    SizedBox(height: context.h(6)),

                    // Location
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          size: context.w(14),
                          color: AppColors.textSecondary,
                        ),
                        SizedBox(width: context.w(4)),
                        Expanded(
                          child: Text(
                            schedule.location,
                            style: AppTextStyles.regular(
                              context,
                              13,
                            ).copyWith(color: AppColors.textSecondary),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: context.h(6)),

                    // Date & Time
                    Row(
                      children: [
                        Icon(
                          Icons.access_time_outlined,
                          size: context.w(14),
                          color: AppColors.textSecondary,
                        ),
                        SizedBox(width: context.w(4)),
                        Text(
                          '$formattedDate • ${schedule.time}',
                          style: AppTextStyles.regular(
                            context,
                            13,
                          ).copyWith(color: AppColors.textSecondary),
                        ),
                      ],
                    ),

                    // Completion badge
                    if (schedule.isCompleted &&
                        schedule.completedAt != null) ...[
                      SizedBox(height: context.h(8)),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: context.w(8),
                          vertical: context.h(4),
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(context.w(6)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.check_circle,
                              size: context.w(12),
                              color: Colors.green,
                            ),
                            SizedBox(width: context.w(4)),
                            Text(
                              'Completed ${_formatCompletedTime(schedule.completedAt!)}',
                              style: AppTextStyles.medium(
                                context,
                                11,
                              ).copyWith(color: Colors.green),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              // Arrow indicator
              Icon(
                Icons.chevron_right,
                size: context.w(20),
                color: AppColors.textSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _confirmDelete(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Text(
              'Delete Schedule',
              style: AppTextStyles.semibold(context, 18),
            ),
            content: Text(
              'Are you sure you want to delete "${schedule.title}"?',
              style: AppTextStyles.regular(context, 14),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: Text(
                  'Cancel',
                  style: AppTextStyles.medium(
                    context,
                    14,
                  ).copyWith(color: AppColors.textSecondary),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pop(ctx, true),
                child: Text(
                  'Delete',
                  style: AppTextStyles.semibold(
                    context,
                    14,
                  ).copyWith(color: AppColors.accentRed),
                ),
              ),
            ],
          ),
        ) ??
        false;
  }

  String _formatCompletedTime(DateTime completedAt) {
    final now = DateTime.now();
    final difference = now.difference(completedAt);

    if (difference.inMinutes < 1) {
      return 'just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays == 1) {
      return 'yesterday';
    } else {
      return '${difference.inDays}d ago';
    }
  }
}
