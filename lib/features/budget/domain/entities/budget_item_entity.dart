import 'budget_category.dart';

class BudgetItemEntity {
  final String id;
  final String title;
  final double amount;
  final BudgetCategory category;
  final DateTime date;
  final String userId;
  final String? description;
  final String? location;

  BudgetItemEntity({
    required this.id,
    required this.title,
    required this.amount,
    required this.category,
    required this.date,
    required this.userId,
    this.description,
    this.location,
  });
}
