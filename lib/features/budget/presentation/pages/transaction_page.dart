import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/utils/size_extension.dart';
import '../../../../core/resources/colors.dart';
import '../../../../core/resources/assets.dart';
import 'package:project/features/route/presentation/widget/app_bar_icon_widget.dart';
import '../widget/budget_summary_card.dart';
import '../widget/category_budget_card.dart';
import '../widget/add_tranaction_dialog.dart';
import '../widget/edit_budget_dialog.dart';
import '../provider/budget_provider.dart';
import '../../domain/entities/budget_category.dart';
import '../../domain/entities/budget_item_entity.dart';

class TransactionsPage extends StatefulWidget {
  const TransactionsPage({super.key});

  @override
  State<TransactionsPage> createState() => _TransactionsPageState();
}

class _TransactionsPageState extends State<TransactionsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<BudgetProvider>(context, listen: false);
      provider.loadMonthlyBudget();
      provider.loadTransactions();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BudgetProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          backgroundColor: Colors.white,
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => const AddTransactionDialog(),
              );
            },
            backgroundColor: AppColors.primaryOrange,
            child: const Icon(Icons.add, color: Colors.white),
          ),
          body: Column(
            children: [
              // Top Bar
              Padding(
                padding: EdgeInsets.only(
                  top: context.h(56),
                  left: context.w(20),
                  right: context.w(20),
                ),
                child: SizedBox(
                  width: context.w(335),
                  height: context.h(44),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AppBarIconWidget(
                        icon: MyAssets.backicon,
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),
                      Expanded(
                        child: Center(
                          child: Text(
                            "Budget & Transactions",
                            style: TextStyle(
                              fontFamily: "SF UI Display",
                              fontWeight: FontWeight.w600,
                              fontSize: context.sp(18),
                              height: 22 / 18,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.calendar_month,
                          color: AppColors.textPrimary,
                          size: context.sp(24),
                        ),
                        onPressed: () {
                          // Show month selector
                        },
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: context.h(30)),

              // Main Content
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: context.w(20)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (provider.isLoading)
                        Center(
                          child: Padding(
                            padding: EdgeInsets.all(context.w(20)),
                            child: CircularProgressIndicator(
                              color: AppColors.primaryOrange,
                            ),
                          ),
                        )
                      else if (provider.error != null)
                        Container(
                          padding: EdgeInsets.all(context.w(16)),
                          margin: EdgeInsets.only(bottom: context.h(16)),
                          decoration: BoxDecoration(
                            color: Colors.red[50],
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.red),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.error, color: Colors.red),
                              SizedBox(width: context.w(12)),
                              Expanded(
                                child: Text(
                                  provider.error!,
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontSize: context.sp(14),
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.close),
                                onPressed: provider.clearError,
                              ),
                            ],
                          ),
                        )
                      else if (provider.monthlyBudget != null) ...[
                        // Budget Summary Card
                        BudgetSummaryCard(
                          budget: provider.monthlyBudget!,
                          onEditBudget: () {
                            showDialog(
                              context: context,
                              builder: (context) => EditBudgetDialog(
                                currentBudget: provider.monthlyBudget!,
                              ),
                            );
                          },
                        ),
                        SizedBox(height: context.h(20)),

                        // Category Budgets
                        Text(
                          'Category Breakdown',
                          style: TextStyle(
                            fontFamily: 'SF UI Display',
                            fontWeight: FontWeight.w600,
                            fontSize: context.sp(16),
                            color: AppColors.textPrimary,
                          ),
                        ),
                        SizedBox(height: context.h(16)),

                        GridView.count(
                          crossAxisCount: 2,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          mainAxisSpacing: context.w(12),
                          crossAxisSpacing: context.h(12),
                          childAspectRatio: 1.3,
                          children: BudgetCategory.values.map((category) {
                            return CategoryBudgetCard(
                              category: category,
                              budget: provider.monthlyBudget!,
                              onTap: null, // Disabled click as requested
                            );
                          }).toList(),
                        ),

                        SizedBox(height: context.h(24)),

                        // Recent Transactions
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Recent Transactions',
                              style: TextStyle(
                                fontFamily: 'SF UI Display',
                                fontWeight: FontWeight.w600,
                                fontSize: context.sp(16),
                                color: AppColors.textPrimary,
                              ),
                            ),
                            if (provider.selectedCategory != null)
                              Chip(
                                label: Text(
                                  provider.selectedCategory!.displayName,
                                  style: TextStyle(
                                    fontSize: context.sp(12),
                                    color: Colors.white,
                                  ),
                                ),
                                backgroundColor: AppColors.primaryOrange,
                                deleteIcon: const Icon(Icons.close, size: 16),
                                onDeleted: () => provider.selectCategory(null),
                              ),
                          ],
                        ),
                        SizedBox(height: context.h(16)),

                        if (provider.transactions.isEmpty)
                          Container(
                            padding: EdgeInsets.all(context.w(40)),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.receipt_long,
                                  size: context.sp(48),
                                  color: AppColors.backgroundGrey,
                                ),
                                SizedBox(height: context.h(16)),
                                Text(
                                  'No transactions yet',
                                  style: TextStyle(
                                    fontSize: context.sp(16),
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                                SizedBox(height: context.h(8)),
                                Text(
                                  'Tap + to add your first transaction',
                                  style: TextStyle(
                                    fontSize: context.sp(14),
                                    color: AppColors.textSecondary.withValues(
                                      alpha: .7,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        else
                          ...provider.transactions.map((transaction) {
                            return _buildTransactionTile(context, transaction);
                          }),

                        SizedBox(height: context.h(40)),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTransactionTile(
    BuildContext context,
    BudgetItemEntity transaction,
  ) {
    return Container(
      margin: EdgeInsets.only(bottom: context.h(12)),
      padding: EdgeInsets.all(context.w(16)),
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
      child: Row(
        children: [
          Container(
            width: context.w(40),
            height: context.h(40),
            decoration: BoxDecoration(
              color: AppColors.backgroundGrey,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                transaction.category.emoji,
                style: TextStyle(fontSize: context.sp(20)),
              ),
            ),
          ),
          SizedBox(width: context.w(12)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.title,
                  style: TextStyle(
                    fontFamily: 'SF UI Display',
                    fontWeight: FontWeight.w600,
                    fontSize: context.sp(16),
                    color: AppColors.textPrimary,
                  ),
                ),
                if (transaction.description != null)
                  Text(
                    transaction.description!,
                    style: TextStyle(
                      fontSize: context.sp(12),
                      color: AppColors.textSecondary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'Rs ${transaction.amount.toStringAsFixed(0)}',
                style: TextStyle(
                  fontFamily: 'SF UI Display',
                  fontWeight: FontWeight.w600,
                  fontSize: context.sp(16),
                  color: AppColors.accentRed,
                ),
              ),
              SizedBox(height: context.h(2)),
              Text(
                '${transaction.date.day}/${transaction.date.month}/${transaction.date.year}',
                style: TextStyle(
                  fontFamily: 'SF UI Display',
                  fontWeight: FontWeight.w400,
                  fontSize: context.sp(12),
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
