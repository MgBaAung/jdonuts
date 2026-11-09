import 'package:jdonutscodetest/global/color_constant.dart';
import 'package:jdonutscodetest/global/enumeration.dart';
// These constants keep the design token names used throughout the starter app.
// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

const primaryColorScheme = ColorScheme.light(
  primary: Color(0xFF5BBA47),
  primaryContainer: Color(0XFF1F1F1F),
  secondaryContainer: Color(0xFFED1C24),
  error: Colors.red,
  errorContainer: Color(0XFF545F70),
  onError: Color(0XFF3B82F6),
  onPrimary: Color(0XFF121212),
  onPrimaryContainer: Color(0XFFB8B8B8),
);

class AppTheme {
  static ThemeData get customTheme => ThemeData(
    visualDensity: VisualDensity.standard,
    colorScheme: primaryColorScheme,
    textTheme: GoogleFonts.outfitTextTheme(),
    primaryTextTheme: GoogleFonts.outfitTextTheme(),
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: Color(0xFF0A10C2),
    ),
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: ColorConstant.backgroundColor,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColorScheme.primary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        visualDensity: const VisualDensity(vertical: -4, horizontal: -4),
        padding: EdgeInsets.zero,
      ),
    ),
    radioTheme: RadioThemeData(
      fillColor: WidgetStateColor.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return primaryColorScheme.primary;
        }
        return primaryColorScheme.onPrimaryContainer;
      }),
      visualDensity: const VisualDensity(vertical: -4, horizontal: -4),
    ),
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateColor.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return primaryColorScheme.primary;
        }
        return ColorConstant.whiteColor;
      }),
      checkColor: WidgetStateColor.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return Colors.white;
        }
        return Colors.white;
      }),
      side: BorderSide(
        width: 1.5,
        color: ColorConstant.greyColor.withValues(alpha: 0.4),
      ),
      visualDensity: const VisualDensity(vertical: -4, horizontal: -4),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: ColorConstant.greyColor,
    ),
    switchTheme: SwitchThemeData(
      overlayColor: WidgetStateProperty.all(const Color(0xFFEBEBEB)),
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return Colors.white;
        }
        return const Color(0xFF080808);
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return ColorConstant.primaryMainColor;
        }
        return const Color(0xFFEBEBEB);
      }),
      trackOutlineColor: const WidgetStatePropertyAll(Colors.transparent),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: ColorConstant.primaryMainColor,
      surfaceTintColor: ColorConstant.primaryMainColor,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: ColorConstant.primaryMainColor,
        systemStatusBarContrastEnforced: true,
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: ColorConstant.greyColor,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    ),
    tabBarTheme: TabBarThemeData(
      dividerColor: Colors.transparent,
      labelColor: ColorConstant.primaryMainColor,
      indicatorColor: ColorConstant.primaryMainColor,
      indicatorSize: TabBarIndicatorSize.tab,
    ),
    dividerTheme: DividerThemeData(
      thickness: 1,
      space: 1,
      color: ColorConstant.greyColor,
    ),
    bottomSheetTheme: const BottomSheetThemeData(backgroundColor: Colors.white),
  );
}

const num FIGMA_DESIGN_WIDTH = 430;
const num FIGMA_DESIGN_HEIGHT = 932;
const num FIGMA_DESIGN_STATUS_BAR = 44;

typedef ResponsiveBuild =
    Widget Function(
      BuildContext context,
      Orientation orientation,
      DeviceType deviceType,
    );

class Sizer extends StatelessWidget {
  const Sizer({super.key, required this.builder});
  final ResponsiveBuild builder;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return OrientationBuilder(
          builder: (context, orientation) {
            SizeUtils.setScreenSize(constraints, orientation);
            return builder(context, orientation, SizeUtils.deviceType);
          },
        );
      },
    );
  }
}

class SizeUtils {
  static BoxConstraints boxConstraints = const BoxConstraints();

  static Orientation orientation = Orientation.portrait;

  static DeviceType deviceType = DeviceType.mobile;

  static double height = FIGMA_DESIGN_HEIGHT.toDouble();

  static double width = FIGMA_DESIGN_WIDTH.toDouble();

  static double responsiveHeight = FIGMA_DESIGN_HEIGHT.toDouble();

  static double responsiveWidth = FIGMA_DESIGN_WIDTH.toDouble();

  static void setScreenSize(
    BoxConstraints constraints,
    Orientation currentOrientation,
  ) {
    boxConstraints = constraints;
    orientation = currentOrientation;

    if (orientation == Orientation.portrait) {
      width = boxConstraints.maxWidth.isNonZero(
        defaultValue: FIGMA_DESIGN_WIDTH,
      );
      height = boxConstraints.maxHeight.isNonZero(
        defaultValue: FIGMA_DESIGN_HEIGHT,
      );
      responsiveHeight = height;
      responsiveWidth = width;
    } else {
      width = boxConstraints.maxWidth.isNonZero(
        defaultValue: FIGMA_DESIGN_HEIGHT,
      );
      height = boxConstraints.maxHeight.isNonZero(
        defaultValue: FIGMA_DESIGN_WIDTH,
      );

      responsiveHeight = height * 0.8;
      responsiveWidth = width * 0.8;
    }

    if (width >= 900) {
      deviceType = DeviceType.desktop;
    } else if (width >= 600) {
      deviceType = DeviceType.tablet;
    } else {
      deviceType = DeviceType.mobile;
      if (orientation == Orientation.landscape) {
        responsiveHeight *= 0.8;
        responsiveWidth *= 0.8;
      }
    }
  }
}

extension ResponsiveExtension on num {
  /// This method is used to get device viewport width.
  double get _width => SizeUtils.width;

  /// This method is used to get device viewport height.
  double get _height => SizeUtils.height;

  double get _responsiveWidth => SizeUtils.responsiveWidth;

  /// This method is used to get device viewport height.
  double get _responsiveHeight => SizeUtils.responsiveHeight;

  /// This method is used to set padding/margin (for the left and Right side) &
  /// width of the screen or widget according to the Viewport width.
  double get h => ((this * _width) / FIGMA_DESIGN_WIDTH);

  double get rWidth => ((this * _responsiveWidth) / FIGMA_DESIGN_WIDTH);

  /// This method is used to set padding/margin (for the top and bottom side) &
  /// height of the screen or widget according to the Viewport height.
  double get v =>
      (this * _height) / (FIGMA_DESIGN_HEIGHT - FIGMA_DESIGN_STATUS_BAR);

  double get rHeight =>
      (this * _responsiveHeight) /
      (FIGMA_DESIGN_HEIGHT - FIGMA_DESIGN_STATUS_BAR);

  /// This method is used to set smallest px in image height and width
  double get adaptSize {
    var height = v;
    var width = h;
    return height < width ? height.toDoubleValue() : width.toDoubleValue();
  }

  double get rspAdaptSize {
    var height = rHeight;
    var width = rWidth;
    return height < width ? height.toDoubleValue() : width.toDoubleValue();
  }

  /// This method is used to set text font size according to Viewport
  double get fSize => adaptSize.clamp(this * 0.9, this * 1.3);

  SizedBox get height => SizedBox(height: toDouble());

  SizedBox get width => SizedBox(width: toDouble());
}

extension FormatExtension on double {
  /// Return a [double] value with formatted according to provided fractionDigits
  double toDoubleValue({int fractionDigits = 2}) {
    return double.parse(toStringAsFixed(fractionDigits));
  }

  double isNonZero({num defaultValue = 0.0}) {
    return this > 0 ? this : defaultValue.toDouble();
  }
}
