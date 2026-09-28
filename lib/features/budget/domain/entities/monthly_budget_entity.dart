import 'budget_category.dart';
import 'budget_item_entity.dart';

class MonthlyBudgetEntity {
  final String userId;
  final int year;
  final int month;
  final double totalBudget;
  final double totalSpent;
  final Map<BudgetCategory, double> categoryBudgets;
  final Map<BudgetCategory, double> categorySpent;
  final List<BudgetItemEntity> transactions;

  MonthlyBudgetEntity({
    required this.userId,
    required this.year,
    required this.month,
    required this.totalBudget,
    required this.totalSpent,
    required this.categoryBudgets,
    required this.categorySpent,
    required this.transactions,
  });

  double get remainingBudget => totalBudget - totalSpent;
  double get percentageUsed =>
      totalBudget > 0 ? (totalSpent / totalBudget) * 100 : 0;

  double getCategorySpent(BudgetCategory category) =>
      categorySpent[category] ?? 0;

  double getCategoryBudget(BudgetCategory category) =>
      categoryBudgets[category] ?? 0;

  double getCategoryRemaining(BudgetCategory category) =>
      getCategoryBudget(category) - getCategorySpent(category);
}
