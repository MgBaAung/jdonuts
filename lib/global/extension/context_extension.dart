import 'package:flutter/material.dart';

extension MediaQueryValues on BuildContext {
  double get screenWidth => MediaQuery.of(this).size.width;
  double get screenHeight => MediaQuery.of(this).size.height;
  bool get isMobile => screenWidth < 600;
  bool get isTablet => screenWidth >= 600 && screenWidth < 1200;

  double scaledFont(double baseSize) {
    double width = MediaQuery.of(this).size.width;
    double scaleFactor = width / 375;
    double scaledSize = (baseSize * scaleFactor).clamp(
      baseSize,
      baseSize * 1.5,
    );

    return MediaQuery.textScalerOf(this).scale(scaledSize);
  }

  bool isLangMM() {
    return  true;
  }
}
