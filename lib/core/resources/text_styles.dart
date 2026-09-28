import 'package:flutter/material.dart';
import '../utils/size_extension.dart';

// Uses SFUIDisplay* fonts — make sure these are declared in pubspec.yaml
class AppTextStyles {
  // Semibold
  static TextStyle semibold(BuildContext context, double size) {
    return TextStyle(
      fontFamily: 'SFUIDisplaySemibold',
      fontWeight: FontWeight.w600,
      fontSize: context.sp(size),
      height: (size + 4) / size,
      color: Colors.black,
    );
  }

  // Medium
  static TextStyle medium(BuildContext context, double size) {
    return TextStyle(
      fontFamily: 'SFUIDisplayMedium',
      fontWeight: FontWeight.w500,
      fontSize: context.sp(size),
      height: (size + 4) / size,
      color: Colors.black,
    );
  }

  // Regular
  static TextStyle regular(BuildContext context, double size) {
    return TextStyle(
      fontFamily: 'SFUIDisplayRegular',
      fontWeight: FontWeight.w400,
      fontSize: context.sp(size),
      height: (size + 6) / size,
      color: Colors.black,
    );
  }
}
