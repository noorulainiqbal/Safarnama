import 'package:flutter/material.dart';

extension SizeExtention on BuildContext {
  static const double figmaWidth = 375; // Example: iPhone 12 width
  static const double figmaHeight = 812; // Example: iPhone 12 height

  double get screenWidth => MediaQuery.of(this).size.width;
  double get screenHeight => MediaQuery.of(this).size.height;

  double w(double value) => (value / figmaWidth) * screenWidth;
  double h(double value) => (value / figmaHeight) * screenHeight;

  double sp(double value) => (value / figmaWidth) * screenWidth;
}
