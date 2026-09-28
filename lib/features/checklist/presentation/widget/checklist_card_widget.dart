import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../core/resources/colors.dart';
import 'checklist_item_widget.dart';
import 'checklist_item.dart';
import '../provider/checklist_provider.dart';

class ChecklistCardWidget extends StatelessWidget {
  final List<ChecklistItem> items;

  const ChecklistCardWidget({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    final provider = context.read<ChecklistProvider>();

    return Container(
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
        children: items
            .map(
              (item) => ChecklistItemWidget(
                item: item,
                onTap: () => provider.toggleItem(item),
              ),
            )
            .toList(),
      ),
    );
  }
}
