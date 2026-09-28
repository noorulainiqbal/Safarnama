import 'package:dartz/dartz.dart';
import '../entities/budget_item_entity.dart';
import '../entities/monthly_budget_entity.dart';
import '../entities/budget_category.dart';
import '../repository/budget_repository.dart';

class AddTransactionUseCase {
  final BudgetRepository repository;

  AddTransactionUseCase(this.repository);

  Future<Either<String, BudgetItemEntity>> execute(
    BudgetItemEntity transaction,
  ) {
    return repository.addTransaction(transaction);
  }
}

class GetMonthlyBudgetUseCase {
  final BudgetRepository repository;

  GetMonthlyBudgetUseCase(this.repository);

  Future<Either<String, MonthlyBudgetEntity>> execute({
    required String userId,
    required int year,
    required int month,
  }) {
    return repository.getMonthlyBudget(
      userId: userId,
      year: year,
      month: month,
    );
  }
}

class UpdateMonthlyBudgetUseCase {
  final BudgetRepository repository;

  UpdateMonthlyBudgetUseCase(this.repository);

  Future<Either<String, MonthlyBudgetEntity>> execute({
    required String userId,
    required int year,
    required int month,
    required Map<BudgetCategory, double> categoryBudgets,
  }) {
    return repository.updateMonthlyBudget(
      userId: userId,
      year: year,
      month: month,
      categoryBudgets: categoryBudgets,
    );
  }
}

class GetBudgetRecommendationsUseCase {
  final BudgetRepository repository;

  GetBudgetRecommendationsUseCase(this.repository);

  Future<Either<String, Map<BudgetCategory, double>>> execute({
    required String userId,
    required String destination,
    int durationDays = 7,
  }) {
    return repository.getBudgetRecommendations(
      userId: userId,
      destination: destination,
      durationDays: durationDays,
    );
  }
}

class GetTransactionsUseCase {
  final BudgetRepository repository;

  GetTransactionsUseCase(this.repository);

  Future<Either<String, List<BudgetItemEntity>>> execute({
    required String userId,
    DateTime? startDate,
    DateTime? endDate,
    BudgetCategory? category,
  }) {
    return repository.getTransactions(
      userId: userId,
      startDate: startDate,
      endDate: endDate,
      category: category,
    );
  }
}
