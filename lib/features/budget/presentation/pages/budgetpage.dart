import 'package:flutter/material.dart';
import 'package:project/features/route/presentation/widget/app_bar_icon_widget.dart';
import '../../../../core/utils/size_extension.dart';
import '../../../../../core/resources/assets.dart';
import '../../../../../core/resources/colors.dart';
import '../widget/transaction_filter_chip_widget.dart';
import '../widget/transaction_section_widget.dart';
import '../widget/transaction_item.dart';
import '../../../../l10n/app_localizations.dart';

class TransactionsPage extends StatelessWidget {
  const TransactionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
                        AppLocalizations.of(context)!.transactionsTitle,
                        style: TextStyle(
                          fontFamily: "SF UI Display",
                          fontWeight: FontWeight.w600,
                          fontSize: context.sp(18),
                          height: 22 / 18,
                          color: AppColors.textPrimary,
                        ),
                      ), // Wait, child: Text(...) is for Center/Expanded? The original code was Text("Transactions", style...). I need to replace the whole Text widget content or just the string.

                      // TargetContent is the string "Transactions" inside Text widget, but with style.
                      // I will replace the string literal.
                    ),
                  ),
                  SizedBox(width: context.w(44)),
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
                  // Total Spendings Card
                  Container(
                    width: double.infinity,
                    height: context.h(140),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.shadowOrange,
                          offset: const Offset(0, 8),
                          blurRadius: 24,
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Stack(
                        children: [
                          // Background Image
                          Positioned.fill(
                            child: Image.asset(
                              MyAssets.activity1,
                              fit: BoxFit.cover,
                            ),
                          ),
                          // Gradient Overlay
                          Positioned.fill(
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    AppColors.primaryOrange.withValues(
                                      alpha: .9,
                                    ),
                                    AppColors.primaryOrangeDark.withValues(
                                      alpha: .85,
                                    ),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                              ),
                            ),
                          ),
                          // Content
                          Padding(
                            padding: EdgeInsets.all(context.w(20)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  AppLocalizations.of(context)!.totalSpendings,
                                  style: TextStyle(
                                    fontFamily: 'SF UI Display',
                                    fontWeight: FontWeight.w500,
                                    fontSize: context.sp(14),
                                    color: Colors.white.withValues(alpha: .9),
                                  ),
                                ),
                                SizedBox(height: context.h(8)),
                                Text(
                                  'Rs 75,000',
                                  style: TextStyle(
                                    fontFamily: 'SF UI Display',
                                    fontWeight: FontWeight.w600,
                                    fontSize: context.sp(32),
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: context.h(20)),
                  // Transaction Details Header
                  Text(
                    AppLocalizations.of(context)!.transactionDetailsTitle,
                    style: TextStyle(
                      fontFamily: 'SF UI Display',
                      fontWeight: FontWeight.w600,
                      fontSize: context.sp(16),
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: context.h(16)),
                  // Filter Chips
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        TransactionFilterChipWidget(
                          label: AppLocalizations.of(context)!.viewAll,
                          isSelected: true,
                        ),
                        SizedBox(width: context.w(12)),
                        TransactionFilterChipWidget(
                          label: AppLocalizations.of(context)!.food,
                          icon: Icons.restaurant,
                        ),
                        SizedBox(width: context.w(12)),
                        TransactionFilterChipWidget(
                          label: AppLocalizations.of(context)!.shopping,
                          icon: Icons.shopping_bag,
                        ),
                        SizedBox(width: context.w(12)),
                        TransactionFilterChipWidget(
                          label: AppLocalizations.of(context)!.travel,
                          icon: Icons.flight,
                        ),
                        SizedBox(width: context.w(12)),
                        TransactionFilterChipWidget(
                          label: AppLocalizations.of(context)!.more,
                          icon: Icons.more_horiz,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: context.h(24)),
                  // This Week Section
                  TransactionSectionWidget(
                    title:
                        '${AppLocalizations.of(context)!.thisWeek} (26 Nov to 30 Nov)', // Keeping dates hardcoded for now or should I localize format? The prompt didn't ask for date logic refactor. I'll just localize "This Week".
                    transactions: [
                      TransactionItem(
                        icon: Icons.flight_outlined,
                        title: AppLocalizations.of(context)!.travel,
                        amount: '-10000',
                        date: '28-11-24',
                      ),
                    ],
                  ),
                  SizedBox(height: context.h(24)),
                  // Last Week Section
                  TransactionSectionWidget(
                    title:
                        '${AppLocalizations.of(context)!.lastWeek} (19 Nov to 25 Nov)',
                    transactions: [
                      TransactionItem(
                        icon: Icons.restaurant_outlined,
                        title: AppLocalizations.of(context)!.food,
                        amount: '-2000',
                        date: '24-11-24',
                      ),
                      TransactionItem(
                        icon: Icons.shopping_bag_outlined,
                        title: AppLocalizations.of(context)!.shopping,
                        amount: '-3000',
                        date: '23-11-24',
                      ),
                      TransactionItem(
                        icon: Icons.receipt_outlined,
                        title: AppLocalizations.of(context)!.billPayment,
                        amount: '-1500',
                        date: '21-11-24',
                      ),
                    ],
                  ),
                  SizedBox(height: context.h(24)),
                  // Previous Week Section
                  TransactionSectionWidget(
                    title:
                        '${AppLocalizations.of(context)!.lastWeek} (12 Nov to 18 Nov)',
                    transactions: [
                      TransactionItem(
                        icon: Icons.phone_android_outlined,
                        title: AppLocalizations.of(context)!.recharge,
                        amount: '-1500',
                        date: '17-11-24',
                      ),
                      TransactionItem(
                        icon: Icons.restaurant_outlined,
                        title: AppLocalizations.of(context)!.food,
                        amount: '-1800',
                        date: '16-11-24',
                      ),
                      TransactionItem(
                        icon: Icons.build_outlined,
                        title: AppLocalizations.of(context)!.maintenance,
                        amount: '-1000',
                        date: '14-11-24',
                      ),
                    ],
                  ),
                  SizedBox(height: context.h(40)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
