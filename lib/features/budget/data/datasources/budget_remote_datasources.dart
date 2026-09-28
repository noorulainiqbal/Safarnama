import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import '../../domain/entities/budget_item_entity.dart';
import '../../domain/entities/monthly_budget_entity.dart';
import '../../domain/entities/budget_category.dart';
import '../models/budget_item_model.dart';
import '../models/monthly_budget_model.dart';

class BudgetRemoteDataSource {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  BudgetRemoteDataSource({required this.firestore, required this.auth});

  CollectionReference get _transactionsCollection =>
      firestore.collection('budget_transactions');

  CollectionReference get _monthlyBudgetsCollection =>
      firestore.collection('monthly_budgets');

  CollectionReference get _usersCollection => firestore.collection('users');

  // Transaction Operations
  Future<BudgetItemEntity> addTransaction(BudgetItemEntity transaction) async {
    final model = BudgetItemModel.fromEntity(transaction);
    final docRef = _transactionsCollection.doc();

    await docRef.set(model.toFirebase());

    return model.copyWith(id: docRef.id);
  }

  Future<List<BudgetItemEntity>> getTransactions({
    required String userId,
    DateTime? startDate,
    DateTime? endDate,
    BudgetCategory? category,
  }) async {
    Query query = _transactionsCollection.where('userId', isEqualTo: userId);
    // Removed orderBy to avoid index requirement. Sorting is done in memory.

    if (startDate != null) {
      query = query.where(
        'date',
        isGreaterThanOrEqualTo: startDate.millisecondsSinceEpoch,
      );
    }

    if (endDate != null) {
      query = query.where(
        'date',
        isLessThanOrEqualTo: endDate.millisecondsSinceEpoch,
      );
    }

    if (category != null) {
      query = query.where('category', isEqualTo: category.firebaseKey);
    }

    try {
      final snapshot = await query.get();

      final transactions = snapshot.docs.map((doc) {
        return BudgetItemModel.fromFirebase(
          doc.data() as Map<String, dynamic>,
          doc.id,
        );
      }).toList();

      // Sort in memory: Newest first
      transactions.sort((a, b) => b.date.compareTo(a.date));

      return transactions;
    } catch (e) {
      // Return empty list on error to prevent crashing the whole page, but log it.
      debugPrint("Error fetching transactions: $e");
      return [];
    }
  }

  // Monthly Budget Operations
  Future<MonthlyBudgetEntity> getMonthlyBudget({
    required String userId,
    required int year,
    required int month,
  }) async {
    final docId = '${userId}_${year}_$month';
    final doc = await _monthlyBudgetsCollection.doc(docId).get();

    if (doc.exists) {
      return MonthlyBudgetModel.fromFirebase(
        doc.data() as Map<String, dynamic>,
        doc.id,
      );
    }

    // Create default monthly budget if not exists
    return _createDefaultMonthlyBudget(
      userId: userId,
      year: year,
      month: month,
    );
  }

  Future<MonthlyBudgetEntity> updateMonthlyBudget({
    required String userId,
    required int year,
    required int month,
    required Map<BudgetCategory, double> categoryBudgets,
  }) async {
    final docId = '${userId}_${year}_$month';
    final docRef = _monthlyBudgetsCollection.doc(docId);

    final monthlyBudget = MonthlyBudgetModel(
      userId: userId,
      year: year,
      month: month,
      totalBudget: categoryBudgets.values.reduce((a, b) => a + b),
      totalSpent: 0, // Will be calculated from transactions
      categoryBudgets: categoryBudgets,
      categorySpent: {}, // Will be calculated from transactions
      transactions: [],
    );

    await docRef.set(monthlyBudget.toFirebase(), SetOptions(merge: true));

    // Update user's monthly budget reference
    await _usersCollection.doc(userId).update({
      'currentMonthlyBudget': docId,
      'updatedAt': DateTime.now().millisecondsSinceEpoch,
    });

    return monthlyBudget;
  }

  Future<MonthlyBudgetEntity> _createDefaultMonthlyBudget({
    required String userId,
    required int year,
    required int month,
  }) async {
    // Default budget allocation (can be customized)
    final defaultBudgets = {
      BudgetCategory.food: 15000.0,
      BudgetCategory.shopping: 10000.0,
      BudgetCategory.travel: 20000.0,
      BudgetCategory.accommodation: 30000.0,
      BudgetCategory.transportation: 5000.0,
      BudgetCategory.entertainment: 5000.0,
      BudgetCategory.other: 5000.0,
    };

    return updateMonthlyBudget(
      userId: userId,
      year: year,
      month: month,
      categoryBudgets: defaultBudgets,
    );
  }

  // Analytics
  Future<Map<BudgetCategory, double>> getCategorySpending({
    required String userId,
    required int year,
    required int month,
  }) async {
    final startDate = DateTime(year, month, 1);
    final endDate = DateTime(year, month + 1, 0);

    final transactions = await getTransactions(
      userId: userId,
      startDate: startDate,
      endDate: endDate,
    );

    final Map<BudgetCategory, double> spending = {};

    for (final transaction in transactions) {
      spending.update(
        transaction.category,
        (value) => value + transaction.amount,
        ifAbsent: () => transaction.amount,
      );
    }

    return spending;
  }

  // Recommendations based on destination (mock for now, integrate with travel APIs)
  Future<Map<BudgetCategory, double>> getBudgetRecommendations({
    required String userId,
    required String destination,
    int durationDays = 7,
  }) async {
    // This is a mock implementation. In production, integrate with:
    // 1. Cost of living APIs (Numbeo, Expatistan)
    // 2. Travel expense APIs
    // 3. Historical data from similar trips

    // Mock data for common destinations
    final Map<String, Map<BudgetCategory, double>> destinationRates = {
      'miami': {
        BudgetCategory.food: 75.0, // per day
        BudgetCategory.accommodation: 150.0,
        BudgetCategory.transportation: 40.0,
        BudgetCategory.entertainment: 60.0,
      },
      'london': {
        BudgetCategory.food: 80.0,
        BudgetCategory.accommodation: 180.0,
        BudgetCategory.transportation: 45.0,
        BudgetCategory.entertainment: 70.0,
      },
      'tokyo': {
        BudgetCategory.food: 70.0,
        BudgetCategory.accommodation: 120.0,
        BudgetCategory.transportation: 30.0,
        BudgetCategory.entertainment: 50.0,
      },
      'dubai': {
        BudgetCategory.food: 85.0,
        BudgetCategory.accommodation: 200.0,
        BudgetCategory.transportation: 35.0,
        BudgetCategory.entertainment: 80.0,
      },
    };

    final destinationKey = destination.toLowerCase();
    final baseRates =
        destinationRates[destinationKey] ??
        {
          BudgetCategory.food: 50.0,
          BudgetCategory.accommodation: 100.0,
          BudgetCategory.transportation: 25.0,
          BudgetCategory.entertainment: 40.0,
        };

    // Calculate total for duration
    final Map<BudgetCategory, double> recommendations = {};
    baseRates.forEach((category, dailyRate) {
      recommendations[category] = dailyRate * durationDays;
    });

    // Add shopping budget (15% of total)
    final totalDaily = baseRates.values.reduce((a, b) => a + b);
    recommendations[BudgetCategory.shopping] = totalDaily * durationDays * 0.15;

    return recommendations;
  }
}

extension BudgetItemModelExtension on BudgetItemModel {
  BudgetItemModel copyWith({
    String? id,
    String? title,
    double? amount,
    BudgetCategory? category,
    DateTime? date,
    String? userId,
    String? description,
    String? location,
  }) {
    return BudgetItemModel(
      id: id ?? this.id,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      category: category ?? this.category,
      date: date ?? this.date,
      userId: userId ?? this.userId,
      description: description ?? this.description,
      location: location ?? this.location,
    );
  }
}
