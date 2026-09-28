import '../../domain/entities/monthly_budget_entity.dart';
import '../../domain/entities/budget_category.dart';
import '../models/budget_item_model.dart';

class MonthlyBudgetModel extends MonthlyBudgetEntity {
  MonthlyBudgetModel({
    required super.userId,
    required super.year,
    required super.month,
    required super.totalBudget,
    required super.totalSpent,
    required super.categoryBudgets,
    required super.categorySpent,
    required super.transactions,
  });

  factory MonthlyBudgetModel.fromFirebase(
    Map<String, dynamic> data,
    String id,
  ) {
    final categoryBudgets = <BudgetCategory, double>{};
    final categorySpent = <BudgetCategory, double>{};

    // Parse category budgets
    final budgets = data['categoryBudgets'] as Map<String, dynamic>? ?? {};
    budgets.forEach((key, value) {
      final category = BudgetCategory.values.firstWhere(
        (cat) => cat.firebaseKey == key,
        orElse: () => BudgetCategory.other,
      );
      categoryBudgets[category] = (value as num).toDouble();
    });

    // Parse category spent
    final spent = data['categorySpent'] as Map<String, dynamic>? ?? {};
    spent.forEach((key, value) {
      final category = BudgetCategory.values.firstWhere(
        (cat) => cat.firebaseKey == key,
        orElse: () => BudgetCategory.other,
      );
      categorySpent[category] = (value as num).toDouble();
    });

    return MonthlyBudgetModel(
      userId: data['userId'],
      year: data['year'],
      month: data['month'],
      totalBudget: (data['totalBudget'] as num).toDouble(),
      totalSpent: (data['totalSpent'] as num).toDouble(),
      categoryBudgets: categoryBudgets,
      categorySpent: categorySpent,
      transactions: List<Map<String, dynamic>>.from(
        data['transactions'] ?? [],
      ).map((t) => BudgetItemModel.fromFirebase(t, '')).toList(),
    );
  }

  Map<String, dynamic> toFirebase() {
    final categoryBudgetsMap = <String, double>{};
    final categorySpentMap = <String, double>{};

    categoryBudgets.forEach((category, amount) {
      categoryBudgetsMap[category.firebaseKey] = amount;
    });

    categorySpent.forEach((category, amount) {
      categorySpentMap[category.firebaseKey] = amount;
    });

    return {
      'userId': userId,
      'year': year,
      'month': month,
      'totalBudget': totalBudget,
      'totalSpent': totalSpent,
      'categoryBudgets': categoryBudgetsMap,
      'categorySpent': categorySpentMap,
      'transactions': transactions
          .map((t) => (t as BudgetItemModel).toFirebase())
          .toList(),
      'updatedAt': DateTime.now().millisecondsSinceEpoch,
    };
  }
}
