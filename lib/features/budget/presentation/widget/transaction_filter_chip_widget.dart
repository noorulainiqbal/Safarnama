import 'package:flutter/material.dart';
import '../../../../core/utils/size_extension.dart';
import '../../../../../core/resources/colors.dart';

class TransactionFilterChipWidget extends StatelessWidget {
  final String label;
  final IconData? icon;
  final bool isSelected;

  const TransactionFilterChipWidget({
    super.key,
    required this.label,
    this.icon,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.w(16),
        vertical: context.h(10),
      ),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFFFF7029) : Colors.white,
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
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              size: context.sp(18),
              color: isSelected ? Colors.white : AppColors.textPrimary,
            ),
            SizedBox(width: context.w(6)),
          ],
          Text(
            label,
            style: TextStyle(
              fontFamily: 'SF UI Display',
              fontWeight: FontWeight.w600,
              fontSize: context.sp(14),
              color: isSelected ? Colors.white : AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
