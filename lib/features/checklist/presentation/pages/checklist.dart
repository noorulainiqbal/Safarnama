import 'package:flutter/material.dart';
import '../../../../l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:project/features/route/presentation/widget/app_bar_icon_widget.dart';
import '../../../../core/utils/size_extension.dart';
import '../../../../../core/resources/assets.dart';
import '../../../../../core/resources/colors.dart';
import '../provider/checklist_provider.dart';
import '../widget/checklist_card_widget.dart';

class ChecklistPage extends StatefulWidget {
  const ChecklistPage({super.key});

  @override
  State<ChecklistPage> createState() => _ChecklistPageState();
}

class _ChecklistPageState extends State<ChecklistPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ChecklistProvider>().loadChecklist();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ChecklistProvider>();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _topBar(context),
            SizedBox(height: context.h(30)),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: context.w(20)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _sectionHeader(
                      context,
                      title: AppLocalizations.of(context)!.essentialItems,
                      onAdd: provider.addEssentialItem,
                    ),
                    SizedBox(height: context.h(16)),
                    ChecklistCardWidget(items: provider.essentialItems),

                    SizedBox(height: context.h(32)),

                    _sectionHeader(
                      context,
                      title: AppLocalizations.of(context)!.rainyEssentials,
                      icon: Icons.cloud_outlined,
                      onAdd: provider.addRainyItem,
                    ),
                    SizedBox(height: context.h(16)),
                    ChecklistCardWidget(items: provider.rainyItems),

                    SizedBox(height: context.h(24)),
                    _progressCard(context, provider),
                    SizedBox(height: context.h(40)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _topBar(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: context.h(56),
        left: context.w(20),
        right: context.w(20),
      ),
      child: SizedBox(
        width: context.w(335),
        height: context.h(44),
        child: Row(
          children: [
            AppBarIconWidget(
              icon: MyAssets.backicon,
              onTap: () => Navigator.pop(context),
            ),
            Expanded(
              child: Center(
                child: Text(
                  AppLocalizations.of(context)!.checklistTitle,
                  style: TextStyle(
                    fontFamily: "SF UI Display",
                    fontWeight: FontWeight.w600,
                    fontSize: context.sp(18),
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ),
            SizedBox(width: context.w(44)),
          ],
        ),
      ),
    );
  }

  Widget _sectionHeader(
    BuildContext context, {
    required String title,
    IconData? icon,
    required VoidCallback onAdd,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            if (icon != null)
              Icon(icon, size: context.sp(24), color: AppColors.primaryOrange),
            if (icon != null) SizedBox(width: context.w(8)),
            Text(
              title,
              style: TextStyle(
                fontFamily: 'SF UI Display',
                fontWeight: FontWeight.w600,
                fontSize: context.sp(20),
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
        GestureDetector(
          onTap: onAdd,
          child: Container(
            width: context.w(36),
            height: context.h(36),
            decoration: BoxDecoration(
              color: AppColors.primaryOrange,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(Icons.add, color: Colors.white),
          ),
        ),
      ],
    );
  }

  Widget _progressCard(BuildContext context, ChecklistProvider provider) {
    return Container(
      padding: EdgeInsets.all(context.w(20)),
      decoration: BoxDecoration(
        color: AppColors.primaryOrange,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(Icons.check_circle_outline, color: Colors.white, size: 28),
          SizedBox(width: context.w(16)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context)!.checklistProgress,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: context.sp(16),
                    color: Colors.white,
                  ),
                ),
                Text(
                  AppLocalizations.of(
                    context,
                  )!.itemsChecked(provider.checkedItems, provider.totalItems),
                  style: TextStyle(
                    fontSize: context.sp(13),
                    color: Colors.white.withValues(alpha: .9),
                  ),
                ),
              ],
            ),
          ),
          Text(
            '${provider.progressPercent}%',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: context.sp(24),
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
