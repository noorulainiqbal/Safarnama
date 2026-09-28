import 'package:flutter/material.dart';
import '../../../../core/utils/size_extension.dart';
import '../../../../core/resources/colors.dart';
import '../../domain/entities/budget_category.dart';
import '../../domain/entities/monthly_budget_entity.dart';

class CategoryBudgetCard extends StatelessWidget {
  final BudgetCategory category;
  final MonthlyBudgetEntity budget;
  final VoidCallback? onTap;

  const CategoryBudgetCard({
    super.key,
    required this.category,
    required this.budget,
    this.onTap,
  });

  Color _getProgressColor(double percentage) {
    if (percentage > 100) return AppColors.accentRed;
    if (percentage > 80) return AppColors.primaryOrange;
    return AppColors.accentBlue;
  }

  @override
  Widget build(BuildContext context) {
    final spent = budget.getCategorySpent(category);
    final allocated = budget.getCategoryBudget(category);
    final double percentage = allocated > 0 ? (spent / allocated) * 100 : 0;
    final remaining = allocated - spent;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(context.w(12)), // Reduced padding
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadowLight,
              offset: const Offset(0, 4),
              blurRadius: 12,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min, // Use min size
          children: [
            Row(
              children: [
                Container(
                  width: context.w(36), // Reduced size
                  height: context.h(36),
                  decoration: BoxDecoration(
                    color: AppColors.backgroundGrey,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      category.emoji,
                      style: TextStyle(fontSize: context.sp(18)),
                    ),
                  ),
                ),
                SizedBox(width: context.w(8)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        category.displayName,
                        style: TextStyle(
                          fontFamily: 'SF UI Display',
                          fontWeight: FontWeight.w600,
                          fontSize: context.sp(14), // Reduced font
                          color: AppColors.textPrimary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: context.h(2)),
                      Text(
                        'Rs ${spent.toStringAsFixed(0)} / ${allocated.toStringAsFixed(0)}',
                        style: TextStyle(
                          fontFamily: 'SF UI Display',
                          fontWeight: FontWeight.w500,
                          fontSize: context.sp(12), // Reduced font
                          color: AppColors.textSecondary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),

            Spacer(), // flexible space
            // Progress Bar
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${percentage.toStringAsFixed(0)}% used',
                      style: TextStyle(
                        fontFamily: 'SF UI Display',
                        fontWeight: FontWeight.w500,
                        fontSize: context.sp(10), // Reduced font
                        color: _getProgressColor(percentage),
                      ),
                    ),
                    Flexible(
                      child: Text(
                        remaining >= 0
                            ? 'Rs ${remaining.toStringAsFixed(0)} left'
                            : 'Rs ${(-remaining).toStringAsFixed(0)} over',
                        style: TextStyle(
                          fontFamily: 'SF UI Display',
                          fontWeight: FontWeight.w500,
                          fontSize: context.sp(10), // Reduced font
                          color: remaining >= 0
                              ? AppColors.accentBlue
                              : AppColors.accentRed,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: context.h(4)),

                Container(
                  height: context.h(4),
                  decoration: BoxDecoration(
                    color: AppColors.backgroundGrey,
                    borderRadius: BorderRadius.circular(2),
                  ),
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: (percentage / 100).clamp(0.0, 1.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: _getProgressColor(percentage),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
