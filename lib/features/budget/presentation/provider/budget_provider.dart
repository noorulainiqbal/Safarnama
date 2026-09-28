import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/entities/budget_item_entity.dart';
import '../../domain/entities/monthly_budget_entity.dart';
import '../../domain/entities/budget_category.dart';
import '../../domain/usecases/budget_usecases.dart';

class BudgetProvider extends ChangeNotifier {
  final GetMonthlyBudgetUseCase getMonthlyBudgetUseCase;
  final UpdateMonthlyBudgetUseCase updateMonthlyBudgetUseCase;
  final AddTransactionUseCase addTransactionUseCase;
  final GetTransactionsUseCase getTransactionsUseCase;
  final GetBudgetRecommendationsUseCase getBudgetRecommendationsUseCase;

  BudgetProvider({
    required this.getMonthlyBudgetUseCase,
    required this.updateMonthlyBudgetUseCase,
    required this.addTransactionUseCase,
    required this.getTransactionsUseCase,
    required this.getBudgetRecommendationsUseCase,
  });

  // State
  MonthlyBudgetEntity? _monthlyBudget;
  MonthlyBudgetEntity? get monthlyBudget => _monthlyBudget;

  List<BudgetItemEntity> _transactions = [];
  List<BudgetItemEntity> get transactions => _transactions;

  BudgetCategory? _selectedCategory;
  BudgetCategory? get selectedCategory => _selectedCategory;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  // Filter state
  DateTime? _filterStartDate;
  DateTime? _filterEndDate;

  // Initialize with current month
  DateTime _currentDate = DateTime.now();
  int get currentYear => _currentDate.year;
  int get currentMonth => _currentDate.month;

  // Actions
  Future<void> loadMonthlyBudget() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      _error = 'User not logged in';
      _isLoading = false;
      notifyListeners();
      return;
    }

    final result = await getMonthlyBudgetUseCase.execute(
      userId: user.uid,
      year: currentYear,
      month: currentMonth,
    );

    _isLoading = false;

    result.fold(
      (failure) {
        _error = failure;
        _monthlyBudget = null;
      },
      (budget) {
        _monthlyBudget = budget;
        _error = null;
      },
    );

    notifyListeners();
  }

  Future<void> loadTransactions() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final result = await getTransactionsUseCase.execute(
      userId: user.uid,
      startDate: _filterStartDate,
      endDate: _filterEndDate,
      category: _selectedCategory,
    );

    result.fold(
      (failure) => _error = failure,
      (transactions) => _transactions = transactions,
    );

    notifyListeners();
  }

  Future<void> addNewTransaction({
    required String title,
    required double amount,
    required BudgetCategory category,
    String? description,
    String? location,
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final transaction = BudgetItemEntity(
      id: '',
      title: title,
      amount: amount,
      category: category,
      date: DateTime.now(),
      userId: user.uid,
      description: description,
      location: location,
    );

    final result = await addTransactionUseCase.execute(transaction);

    result.fold((failure) => _error = failure, (newTransaction) {
      _transactions.insert(0, newTransaction);
      if (_monthlyBudget != null) {
        // Update monthly budget spent amount
        final updatedSpent = _monthlyBudget!.totalSpent + amount;
        final updatedCategorySpent = Map<BudgetCategory, double>.from(
          _monthlyBudget!.categorySpent,
        );
        updatedCategorySpent.update(
          category,
          (value) => value + amount,
          ifAbsent: () => amount,
        );

        _monthlyBudget = MonthlyBudgetEntity(
          userId: _monthlyBudget!.userId,
          year: _monthlyBudget!.year,
          month: _monthlyBudget!.month,
          totalBudget: _monthlyBudget!.totalBudget,
          totalSpent: updatedSpent,
          categoryBudgets: _monthlyBudget!.categoryBudgets,
          categorySpent: updatedCategorySpent,
          transactions: [..._monthlyBudget!.transactions, newTransaction],
        );
      }
    });

    notifyListeners();
  }

  Future<void> updateBudgetAllocation(
    Map<BudgetCategory, double> categoryBudgets,
  ) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    _isLoading = true;
    notifyListeners();

    final result = await updateMonthlyBudgetUseCase.execute(
      userId: user.uid,
      year: currentYear,
      month: currentMonth,
      categoryBudgets: categoryBudgets,
    );

    _isLoading = false;

    result.fold(
      (failure) => _error = failure,
      (budget) => _monthlyBudget = budget,
    );

    notifyListeners();
  }

  Future<Map<BudgetCategory, double>> getRecommendations(
    String destination,
    int durationDays,
  ) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return {};

    final result = await getBudgetRecommendationsUseCase.execute(
      userId: user.uid,
      destination: destination,
      durationDays: durationDays,
    );

    return result.fold((failure) {
      _error = failure;
      return {};
    }, (recommendations) => recommendations);
  }

  void selectCategory(BudgetCategory? category) {
    _selectedCategory = category;
    loadTransactions();
  }

  void setDateFilter(DateTime? startDate, DateTime? endDate) {
    _filterStartDate = startDate;
    _filterEndDate = endDate;
    loadTransactions();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  void changeMonth(int monthOffset) {
    _currentDate = DateTime(
      _currentDate.year,
      _currentDate.month + monthOffset,
    );
    loadMonthlyBudget();
    loadTransactions();
  }
}
