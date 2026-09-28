import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/utils/size_extension.dart';
import '../../../../core/resources/colors.dart';
import '../../domain/entities/budget_category.dart';
import '../../domain/entities/monthly_budget_entity.dart';
import '../provider/budget_provider.dart';

class EditBudgetDialog extends StatefulWidget {
  final MonthlyBudgetEntity currentBudget;

  const EditBudgetDialog({super.key, required this.currentBudget});

  @override
  State<EditBudgetDialog> createState() => _EditBudgetDialogState();
}

class _EditBudgetDialogState extends State<EditBudgetDialog> {
  // Using a map to store controllers for each category
  final Map<BudgetCategory, TextEditingController> _controllers = {};
  final ValueNotifier<bool> _isSaving = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    // Initialize controllers with current values
    for (final category in BudgetCategory.values) {
      final currentAmount =
          widget.currentBudget.categoryBudgets[category] ?? 0.0;
      _controllers[category] = TextEditingController(
        text: currentAmount.toStringAsFixed(0),
      );
    }
  }

  @override
  void dispose() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    _isSaving.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    _isSaving.value = true;

    final Map<BudgetCategory, double> newAllocations = {};

    _controllers.forEach((category, controller) {
      final value = double.tryParse(controller.text) ?? 0.0;
      newAllocations[category] = value;
    });

    final provider = Provider.of<BudgetProvider>(context, listen: false);

    // The provider method is async but we don't need to await for UI
    // since provider handles its own loading state,
    // but better to await to close dialog on completion
    await provider.updateBudgetAllocation(newAllocations);

    if (mounted) {
      _isSaving.value = false;
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.all(context.w(20)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Edit Budget',
                  style: TextStyle(
                    fontFamily: 'SF UI Display',
                    fontWeight: FontWeight.w600,
                    fontSize: context.sp(18),
                    color: AppColors.textPrimary,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  splashRadius: 20,
                ),
              ],
            ),
          ),

          Flexible(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: context.w(20)),
              child: Column(
                children: BudgetCategory.values.map((category) {
                  return Padding(
                    padding: EdgeInsets.only(bottom: context.h(16)),
                    child: Row(
                      children: [
                        Container(
                          width: context.w(36),
                          height: context.h(36),
                          decoration: BoxDecoration(
                            color: AppColors.backgroundGrey,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Text(
                              category.emoji,
                              style: TextStyle(fontSize: context.sp(18)),
                            ),
                          ),
                        ),
                        SizedBox(width: context.w(12)),
                        Expanded(
                          child: Text(
                            category.displayName,
                            style: TextStyle(
                              fontFamily: 'SF UI Display',
                              fontWeight: FontWeight.w500,
                              fontSize: context.sp(16),
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                        SizedBox(width: context.w(12)),
                        SizedBox(
                          width: context.w(100),
                          child: TextFormField(
                            controller: _controllers[category],
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: context.w(12),
                                vertical: context.h(8),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              prefixText: 'Rs ',
                              prefixStyle: TextStyle(
                                fontSize: context.sp(12),
                                color: AppColors.textSecondary,
                              ),
                            ),
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: context.sp(14),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

          Padding(
            padding: EdgeInsets.all(context.w(20)),
            child: ValueListenableBuilder<bool>(
              valueListenable: _isSaving,
              builder: (context, isSaving, child) {
                return SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: isSaving ? null : _save,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryOrange,
                      padding: EdgeInsets.symmetric(vertical: context.h(14)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      disabledBackgroundColor: AppColors.primaryOrange
                          .withValues(alpha: 0.5),
                    ),
                    child: isSaving
                        ? SizedBox(
                            width: context.w(20),
                            height: context.w(20),
                            child: const CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : Text(
                            'Save Changes',
                            style: TextStyle(
                              fontSize: context.sp(16),
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
