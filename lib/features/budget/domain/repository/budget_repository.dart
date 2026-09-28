import 'package:dartz/dartz.dart';
import '../entities/budget_item_entity.dart';
import '../entities/monthly_budget_entity.dart';
import '../entities/budget_category.dart';

abstract class BudgetRepository {
  // CRUD Operations
  Future<Either<String, BudgetItemEntity>> addTransaction(
    BudgetItemEntity transaction,
  );
  Future<Either<String, List<BudgetItemEntity>>> getTransactions({
    required String userId,
    DateTime? startDate,
    DateTime? endDate,
    BudgetCategory? category,
  });
  Future<Either<String, BudgetItemEntity>> updateTransaction(
    BudgetItemEntity transaction,
  );
  Future<Either<String, void>> deleteTransaction(String transactionId);

  // Monthly Budget Operations
  Future<Either<String, MonthlyBudgetEntity>> getMonthlyBudget({
    required String userId,
    required int year,
    required int month,
  });

  Future<Either<String, MonthlyBudgetEntity>> updateMonthlyBudget({
    required String userId,
    required int year,
    required int month,
    required Map<BudgetCategory, double> categoryBudgets,
  });

  // Analytics
  Future<Either<String, Map<BudgetCategory, double>>> getCategorySpending({
    required String userId,
    required int year,
    required int month,
  });

  Future<Either<String, double>> getTotalSpent({
    required String userId,
    required int year,
    required int month,
  });

  // Recommendations
  Future<Either<String, Map<BudgetCategory, double>>> getBudgetRecommendations({
    required String userId,
    required String destination,
    int durationDays = 7,
  });
}
