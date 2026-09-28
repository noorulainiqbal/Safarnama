import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/utils/size_extension.dart';
import '../../../../../core/resources/colors.dart';
import '../provider/checklist_provider.dart';
import 'checklist_item.dart';

class ChecklistItemWidget extends StatelessWidget {
  final ChecklistItem item;
  final VoidCallback onTap;

  const ChecklistItemWidget({
    super.key,
    required this.item,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, // toggle checkbox
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: context.w(16),
          vertical: context.h(14),
        ),
        child: Row(
          children: [
            Expanded(
              child: Focus(
                onFocusChange: (hasFocus) {
                  if (!hasFocus) {
                    context.read<ChecklistProvider>().saveItemNow(item);
                  }
                },
                child: TextField(
                  controller: item.titleController,
                  style: TextStyle(
                    fontFamily: 'SF UI Display',
                    fontWeight: FontWeight.w500,
                    fontSize: context.sp(16),
                    color: AppColors.textPrimary,
                  ),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
            ),
            Container(
              width: context.w(24),
              height: context.h(24),
              decoration: BoxDecoration(
                color: item.isChecked ? AppColors.primaryOrange : Colors.white,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: item.isChecked
                      ? AppColors.primaryOrange
                      : AppColors.borderGrey,
                  width: 2,
                ),
              ),
              child: item.isChecked
                  ? Icon(Icons.check, size: context.sp(16), color: Colors.white)
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
