import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../app_theme.dart';
import '../color_constant.dart';

extension TextstyleExtension on TextStyle {
  TextStyle titleLargeStyle(Color color, FontWeight fontWeight) {
    return AppTheme.customTheme.textTheme.titleLarge!.copyWith(
      color: color,
      fontWeight: fontWeight,
    );
  }

  TextStyle titleMediumStyle(
    Color color,
    FontWeight fontWeight, {
    double? fontSiz,
  }) {
    return AppTheme.customTheme.textTheme.titleMedium!.copyWith(
      color: color,
      fontWeight: fontWeight,
      fontSize: fontSiz,
    );
  }

  TextStyle titleSmallStyle(
    Color color,
    FontWeight fontWeight, {
    double? fontSize,
  }) {
    return AppTheme.customTheme.textTheme.bodyMedium!.copyWith(
      color: color,
      fontWeight: fontWeight,
      fontSize: fontSize,
    );
  }

  TextStyle labelSmallStyle(
    Color color,
    FontWeight fontWeight, {
    TextDecoration decoration = TextDecoration.none,
  }) {
    return AppTheme.customTheme.textTheme.bodySmall!.copyWith(
      color: color,
      fontWeight: fontWeight,
      decoration: decoration,
      decorationColor: ColorConstant.greyColor,
    );
  }

  TextStyle labelLargeStyle(Color color, FontWeight fontWeight) {
    return AppTheme.customTheme.textTheme.labelLarge!.copyWith(
      color: color,
      fontWeight: fontWeight,
    );
  }

  TextStyle regularStyle(Color color, FontWeight fontWeight) {
    return AppTheme.customTheme.textTheme.bodyLarge!.copyWith(
      color: color,
      fontWeight: fontWeight,
    );
  }

  TextStyle headerLineSmall(
    Color color,
    FontWeight fontWeight, {
    double fontSize = 20,
  }) {
    return AppTheme.customTheme.textTheme.headlineSmall!.copyWith(
      color: color,
      fontWeight: fontWeight,
      fontSize: fontSize,
    );
  }
}

extension TypographyExtension on BuildContext {
  TextTheme get txt => Theme.of(this).textTheme;

  static const List<String> myanmarFallback = [
    'Pyidaungsu',
    'Noto Sans Myanmar',
  ];

  TextStyle light({
    double fSize = 12,
    Color color = ColorConstant.blcakColor,
  }) => GoogleFonts.outfit(
    fontSize: fSize.fSize,
    fontWeight: FontWeight.w300,
    color: color,
    letterSpacing: 0,
    //fontFamilyFallback: myanmarFallback, // Vivo ဖုန်းများအတွက်
  ).copyWith(fontFamilyFallback: myanmarFallback);

  TextStyle regular({
    required double fSize,
    Color color = ColorConstant.blcakColor,
  }) => GoogleFonts.outfit(
    fontSize: fSize.fSize,
    fontWeight: FontWeight.w400,
    color: color,
    letterSpacing: 0,
    //fontFamilyFallback: myanmarFallback,
  ).copyWith(fontFamilyFallback: myanmarFallback);

  TextStyle medium({
    double fSize = 16,
    Color color = ColorConstant.blcakColor,
  }) => GoogleFonts.outfit(
    fontSize: fSize.fSize,
    fontWeight: FontWeight.w500,
    color: color,
    letterSpacing: 0,
    // fontFamilyFallback: myanmarFallback,
  ).copyWith(fontFamilyFallback: myanmarFallback);

  TextStyle semibold({
    double fSize = 16,
    Color color = ColorConstant.blcakColor,
  }) => GoogleFonts.outfit(
    fontSize: fSize.fSize,
    fontWeight: FontWeight.w600,
    color: color,
    letterSpacing: 0,
    //fontFamilyFallback: myanmarFallback,
  ).copyWith(fontFamilyFallback: myanmarFallback);

  TextStyle bold({double fSize = 16, Color color = ColorConstant.blcakColor}) =>
      GoogleFonts.outfit(
        fontSize: fSize.fSize,
        fontWeight: FontWeight.w700,
        color: color,
        letterSpacing: 0,
        //fontFamilyFallback: myanmarFallback,
      ).copyWith(fontFamilyFallback: myanmarFallback);
}

// extension TypographyExtension on BuildContext {
//   TextTheme get txt => Theme.of(this).textTheme;

//   TextStyle light({
//     double fSize = 12,
//     Color color = ColorConstant.blcakColor,
//   }) => TextStyle(
//     fontSize: fSize.fSize,
//     fontWeight: FontWeight.w300,
//     color: color,
//     fontFamily: ColorConstant.fontFamily,
//   );

//   TextStyle regular({
//     double fSize = 12,
//     Color color = ColorConstant.blcakColor,
//   }) => TextStyle(
//     fontSize: fSize.fSize,
//     fontWeight: FontWeight.w400,
//     color: color,
//     fontFamily: ColorConstant.fontFamily,
//   );

//   TextStyle medium({
//     double fSize = 16,
//     Color color = ColorConstant.blcakColor,
//   }) => TextStyle(
//     fontSize: fSize.fSize,
//     fontWeight: FontWeight.w500,
//     color: color,
//     fontFamily: ColorConstant.fontFamily,
//   );

//   TextStyle semibold({
//     double fSize = 16,
//     Color color = ColorConstant.blcakColor,
//   }) => TextStyle(
//     fontSize: fSize.fSize,
//     fontWeight: FontWeight.w600,
//     color: color,
//     fontFamily: ColorConstant.fontFamily,
//   );

//   TextStyle bold({double fSize = 16, Color color = ColorConstant.blcakColor}) =>
//       TextStyle(
//         fontSize: fSize.fSize,
//         fontWeight: FontWeight.w700,
//         color: color,
//         fontFamily: ColorConstant.fontFamily,
//       );
// }
