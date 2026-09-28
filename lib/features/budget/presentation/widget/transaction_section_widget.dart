import 'package:flutter/material.dart';
import '../../../../core/utils/size_extension.dart';
import '../../../../../core/resources/colors.dart';
import 'transaction_tile_widget.dart';
import 'transaction_item.dart';

class TransactionSectionWidget extends StatelessWidget {
  final String title;
  final List<TransactionItem> transactions;

  const TransactionSectionWidget({
    super.key,
    required this.title,
    required this.transactions,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            offset: const Offset(0, 6),
            blurRadius: 20,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Date Header
          Padding(
            padding: EdgeInsets.all(context.w(16)),
            child: Text(
              title,
              style: TextStyle(
                fontFamily: 'SF UI Display',
                fontWeight: FontWeight.w600,
                fontSize: context.sp(14),
                letterSpacing: 0.3,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          // Divider
          Padding(
            padding: EdgeInsets.symmetric(horizontal: context.w(16)),
            child: Divider(
              height: 1,
              thickness: 1,
              color: AppColors.backgroundGrey,
            ),
          ),
          // Transaction Items
          Column(
            children: List.generate(
              transactions.length,
              (index) => Column(
                children: [
                  TransactionTileWidget(item: transactions[index]),
                  if (index < transactions.length - 1)
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: context.w(16)),
                      child: Divider(
                        height: 1,
                        thickness: 1,
                        color: AppColors.backgroundGrey,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
