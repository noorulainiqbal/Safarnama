import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/utils/size_extension.dart';
import '../../../../../core/resources/colors.dart';
import '../../../../../core/resources/assets.dart';

class CheckEmailDialog extends StatefulWidget {
  const CheckEmailDialog({super.key});

  @override
  State<CheckEmailDialog> createState() => _CheckEmailDialogState();
}

class _CheckEmailDialogState extends State<CheckEmailDialog> {
  @override
  void initState() {
    super.initState();
    // Close the dialog automatically after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted && Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.transparent,
      insetPadding: EdgeInsets.zero,
      child: Center(
        child: Container(
          width: context.w(335),
          height: context.h(196),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: context.w(44),
                height: context.h(44),
                decoration: BoxDecoration(
                  color: AppColors.underlineOrange,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: SvgPicture.asset(
                    MyAssets.popupemail,
                    width: context.w(26),
                    height: context.h(26),
                    colorFilter: const ColorFilter.mode(
                      AppColors.white,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
              SizedBox(height: context.h(20)),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: context.w(39)),
                child: Column(
                  children: [
                    Text(
                      'Check your email',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'SF UI Display',
                        fontWeight: FontWeight.w600,
                        fontSize: context.sp(18),
                        height: 24 / 18,
                        color: AppColors.signinemailcolor,
                      ),
                    ),
                    SizedBox(height: context.h(8)),
                    Text(
                      'We have sent password recovery instruction to your email',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'SF UI Display',
                        fontWeight: FontWeight.w400,
                        fontSize: context.sp(16),
                        height: 20 / 16,
                        color: AppColors.subtitleGrey,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
