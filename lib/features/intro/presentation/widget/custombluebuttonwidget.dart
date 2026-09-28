/*import 'package:flutter/material.dart';
import '../../../../core/utils/size_extension.dart';
import '../../../../../core/resources/colors.dart';

//used in onboard-1, onboard-2, onboard-3
class CustomBottomButton extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;
  final double? top; // ← new
  final double? left; // ← new

  const CustomBottomButton({
    super.key,
    required this.title,
    required this.onPressed,
    this.top,
    this.left,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top ?? context.h(716), // use default if not provided
      left: left ?? context.w(20),
      child: SizedBox(
        width: context.w(335),
        height: context.h(56),
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryBlue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: Text(
            title,
            style: TextStyle(
              fontFamily: 'SF UI Display',
              fontWeight: FontWeight.w600,
              fontSize: context.sp(16),
              height: 20 / 16,
              color: AppColors.white,
            ),
          ),
        ),
      ),
    );
  }
}*/
import 'package:flutter/material.dart';
import '../../../../core/utils/size_extension.dart';
import '../../../../../core/resources/colors.dart';

/// Used in onboard-1, onboard-2, onboard-3, signup, signin
class CustomBottomButton extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;
  final bool isLoading;
  final double? top;
  final double? left;

  const CustomBottomButton({
    super.key,
    required this.title,
    required this.onPressed,
    this.isLoading = false,
    this.top,
    this.left,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top ?? context.h(716),
      left: left ?? context.w(20),
      child: SizedBox(
        width: context.w(335),
        height: context.h(56),
        child: ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: isLoading ? Colors.grey : AppColors.primaryBlue,
            disabledBackgroundColor: Colors.grey,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: isLoading
              ? SizedBox(
                  width: context.w(22),
                  height: context.w(22),
                  child: const CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : Text(
                  title,
                  style: TextStyle(
                    fontFamily: 'SF UI Display',
                    fontWeight: FontWeight.w600,
                    fontSize: context.sp(16),
                    height: 20 / 16,
                    color: AppColors.white,
                  ),
                ),
        ),
      ),
    );
  }
}
