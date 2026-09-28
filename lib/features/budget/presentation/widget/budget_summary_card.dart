import 'package:flutter/material.dart';
import '../../../../core/utils/size_extension.dart';
import '../../../../core/resources/colors.dart';
import '../../domain/entities/monthly_budget_entity.dart';

class BudgetSummaryCard extends StatelessWidget {
  final MonthlyBudgetEntity budget;
  final VoidCallback? onEditBudget;

  const BudgetSummaryCard({super.key, required this.budget, this.onEditBudget});

  @override
  Widget build(BuildContext context) {
    final percentageUsed = budget.percentageUsed;
    final isOverBudget = budget.totalSpent > budget.totalBudget;

    return Container(
      width: double.infinity,
      // Removed fixed height to prevent overflow
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: [AppColors.primaryOrange, AppColors.primaryOrangeDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowOrange,
            offset: const Offset(0, 8),
            blurRadius: 24,
          ),
        ],
      ),
      child: Stack(
        children: [
          // Background Pattern
          Positioned.fill(
            child: Opacity(
              opacity: 0.1,
              child: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/pattern.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),

          Padding(
            padding: EdgeInsets.all(context.w(20)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Monthly Budget',
                      style: TextStyle(
                        fontFamily: 'SF UI Display',
                        fontWeight: FontWeight.w500,
                        fontSize: context.sp(14),
                        color: Colors.white.withValues(alpha: .9),
                      ),
                    ),
                    if (onEditBudget != null)
                      IconButton(
                        icon: Icon(
                          Icons.edit,
                          color: Colors.white,
                          size: context.sp(20),
                        ),
                        onPressed: onEditBudget,
                      ),
                  ],
                ),

                SizedBox(height: context.h(8)),

                // Budget Amount
                Text(
                  'Rs ${budget.totalBudget.toStringAsFixed(0)}',
                  style: TextStyle(
                    fontFamily: 'SF UI Display',
                    fontWeight: FontWeight.w600,
                    fontSize: context.sp(32),
                    color: Colors.white,
                  ),
                ),

                SizedBox(height: context.h(12)),

                // Progress Bar
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Spent: Rs ${budget.totalSpent.toStringAsFixed(0)}',
                          style: TextStyle(
                            fontFamily: 'SF UI Display',
                            fontWeight: FontWeight.w500,
                            fontSize: context.sp(12),
                            color: Colors.white.withValues(alpha: .9),
                          ),
                        ),
                        Text(
                          '${percentageUsed.toStringAsFixed(1)}%',
                          style: TextStyle(
                            fontFamily: 'SF UI Display',
                            fontWeight: FontWeight.w600,
                            fontSize: context.sp(12),
                            color: isOverBudget
                                ? Colors.red[200]
                                : Colors.white,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: context.h(6)),

                    // Progress Bar
                    Container(
                      height: context.h(6),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: .2),
                        borderRadius: BorderRadius.circular(3),
                      ),
                      child: FractionallySizedBox(
                        alignment: Alignment.centerLeft,
                        widthFactor: percentageUsed / 100,
                        child: Container(
                          decoration: BoxDecoration(
                            color: isOverBudget ? Colors.red : Colors.white,
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: context.h(4)),

                    // Remaining Budget
                    Text(
                      'Remaining: Rs ${budget.remainingBudget.toStringAsFixed(0)}',
                      style: TextStyle(
                        fontFamily: 'SF UI Display',
                        fontWeight: FontWeight.w500,
                        fontSize: context.sp(12),
                        color: budget.remainingBudget < 0
                            ? Colors.red[200]
                            : Colors.white.withValues(alpha: .9),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
