import 'package:dartz/dartz.dart';
import '../../domain/entities/budget_item_entity.dart';
import '../../domain/entities/monthly_budget_entity.dart';
import '../../domain/entities/budget_category.dart';
import '../../domain/repository/budget_repository.dart';
import '../datasources/budget_remote_datasources.dart';

class BudgetRepositoryImpl implements BudgetRepository {
  final BudgetRemoteDataSource remoteDataSource;
  BudgetRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<String, BudgetItemEntity>> addTransaction(
    BudgetItemEntity transaction,
  ) async {
    try {
      final result = await remoteDataSource.addTransaction(transaction);
      return Right(result);
    } catch (e) {
      return Left('Failed to add transaction: $e');
    }
  }

  @override
  Future<Either<String, List<BudgetItemEntity>>> getTransactions({
    required String userId,
    DateTime? startDate,
    DateTime? endDate,
    BudgetCategory? category,
  }) async {
    try {
      final result = await remoteDataSource.getTransactions(
        userId: userId,
        startDate: startDate,
        endDate: endDate,
        category: category,
      );
      return Right(result);
    } catch (e) {
      return Left('Failed to get transactions: $e');
    }
  }

  @override
  Future<Either<String, BudgetItemEntity>> updateTransaction(
    BudgetItemEntity transaction,
  ) async {
    try {
      // Implementation for update
      return Right(transaction);
    } catch (e) {
      return Left('Failed to update transaction: $e');
    }
  }

  @override
  Future<Either<String, void>> deleteTransaction(String transactionId) async {
    try {
      // Implementation for delete
      return const Right(null);
    } catch (e) {
      return Left('Failed to delete transaction: $e');
    }
  }

  @override
  Future<Either<String, MonthlyBudgetEntity>> getMonthlyBudget({
    required String userId,
    required int year,
    required int month,
  }) async {
    try {
      final result = await remoteDataSource.getMonthlyBudget(
        userId: userId,
        year: year,
        month: month,
      );
      return Right(result);
    } catch (e) {
      return Left('Failed to get monthly budget: $e');
    }
  }

  @override
  Future<Either<String, MonthlyBudgetEntity>> updateMonthlyBudget({
    required String userId,
    required int year,
    required int month,
    required Map<BudgetCategory, double> categoryBudgets,
  }) async {
    try {
      final result = await remoteDataSource.updateMonthlyBudget(
        userId: userId,
        year: year,
        month: month,
        categoryBudgets: categoryBudgets,
      );
      return Right(result);
    } catch (e) {
      return Left('Failed to update monthly budget: $e');
    }
  }

  @override
  Future<Either<String, Map<BudgetCategory, double>>> getCategorySpending({
    required String userId,
    required int year,
    required int month,
  }) async {
    try {
      final result = await remoteDataSource.getCategorySpending(
        userId: userId,
        year: year,
        month: month,
      );
      return Right(result);
    } catch (e) {
      return Left('Failed to get category spending: $e');
    }
  }

  @override
  Future<Either<String, double>> getTotalSpent({
    required String userId,
    required int year,
    required int month,
  }) async {
    try {
      final spending = await remoteDataSource.getCategorySpending(
        userId: userId,
        year: year,
        month: month,
      );

      final total = spending.values.reduce((a, b) => a + b);
      return Right(total);
    } catch (e) {
      return Left('Failed to get total spent: $e');
    }
  }

  @override
  Future<Either<String, Map<BudgetCategory, double>>> getBudgetRecommendations({
    required String userId,
    required String destination,
    int durationDays = 7,
  }) async {
    try {
      final result = await remoteDataSource.getBudgetRecommendations(
        userId: userId,
        destination: destination,
        durationDays: durationDays,
      );
      return Right(result);
    } catch (e) {
      return Left('Failed to get budget recommendations: $e');
    }
  }
}
