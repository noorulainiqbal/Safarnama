import 'package:flutter/material.dart';
import '../../../../core/utils/size_extension.dart';
import '../../../../core/resources/colors.dart';

class SettingsDividerWidget extends StatelessWidget {
  const SettingsDividerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: context.w(68)),
      child: Divider(height: 1, thickness: 1, color: AppColors.backgroundGrey),
    );
  }
}
