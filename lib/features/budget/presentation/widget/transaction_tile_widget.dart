import 'package:flutter/material.dart';
import '../../../../core/utils/size_extension.dart';
import '../../../../../core/resources/colors.dart';
import 'transaction_item.dart';

class TransactionTileWidget extends StatelessWidget {
  final TransactionItem item;

  const TransactionTileWidget({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: context.w(16),
        vertical: context.h(14),
      ),
      child: Row(
        children: [
          Container(
            width: context.w(40),
            height: context.h(40),
            decoration: BoxDecoration(
              color: AppColors.backgroundGrey,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              item.icon,
              color: AppColors.primaryOrange,
              size: context.sp(22),
            ),
          ),
          SizedBox(width: context.w(12)),
          Expanded(
            child: Text(
              item.title,
              style: TextStyle(
                fontFamily: 'SF UI Display',
                fontWeight: FontWeight.w500,
                fontSize: context.sp(16),
                letterSpacing: 0.5,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                item.amount,
                style: TextStyle(
                  fontFamily: 'SF UI Display',
                  fontWeight: FontWeight.w600,
                  fontSize: context.sp(16),
                  color: AppColors.accentRed,
                ),
              ),
              SizedBox(height: context.h(2)),
              Text(
                item.date,
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
