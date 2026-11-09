// Enum case names mirror identifiers used in starter app data.
// ignore_for_file: constant_identifier_names

import 'package:jdonutscodetest/global/color_constant.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

enum DropDown { All, name, revenue }

enum AppNavTab {
  home,
  order,
  wallet,
  profile;

  bool get showShadow => this == AppNavTab.profile;
  bool get isProfile => this == AppNavTab.home;
  Color get secondColor => this == AppNavTab.profile
      ? ColorConstant.primaryMainColor
      : ColorConstant.secondaryColor;

  Color get appBgColor => this == AppNavTab.home
      ? ColorConstant.whiteColor
      : this == AppNavTab.profile
      ? ColorConstant.backgroundColor
      : ColorConstant.primaryMainColor;

  Color get appBarColor => ColorConstant.primaryMainColor;

  Color get activeColor => ColorConstant.primaryMainColor;

  Color get inactiveColor => ColorConstant.greyColor;
}

enum PricingStatus {
  up,
  down;

  static PricingStatus fromString(String status) {
    return PricingStatus.values.firstWhere(
      (e) => e.name == status.toLowerCase(),
      orElse: () => PricingStatus.up,
    );
  }

  IconData get icon {
    switch (this) {
      case PricingStatus.up:
        return Icons.arrow_upward;
      case PricingStatus.down:
        return Icons.arrow_downward;
    }
  }

  Color get color {
    switch (this) {
      case PricingStatus.up:
        return ColorConstant.secondaryColor;
      case PricingStatus.down:
        return ColorConstant.primaryMainColor;
    }
  }
}

enum LanguageEnum {
  myanmar(code: "my", countryCode: "MM", name: "Myanmar"),
  english(code: "en", countryCode: "US", name: "English");

  const LanguageEnum({
    required this.code,
    required this.countryCode,
    required this.name,
  });

  final String code;
  final String countryCode;
  final String name;

  Locale get locale => Locale(code, countryCode);
}

enum DeviceType { mobile, tablet, desktop }

enum FeatStatus { Recommended }

enum NoError { delete, cache, endpoint, parsing }

enum OrderStatus {
  pending(Colors.orange, LucideIcons.loaderCircle),
  rejected(Colors.red, LucideIcons.x),
  accepted(Colors.green, Icons.check_circle_outline),
  approved(Colors.green, LucideIcons.check),

  confirmed(Colors.green, Icons.verified_outlined);

  final Color color;
  final IconData icon;

  const OrderStatus(this.color, this.icon);
}

extension OrderStatusExtension on OrderStatus {
  Color get color {
    switch (this) {
      case OrderStatus.pending:
        return Colors.orange;
      case OrderStatus.rejected:
        return ColorConstant.secondaryColor;
      case OrderStatus.accepted:
        return ColorConstant.primaryMainColor;
      case OrderStatus.confirmed:
        return ColorConstant.primaryMainColor;
      case OrderStatus.approved:
        return ColorConstant.primaryMainColor;
    }
  }

  Color get icon {
    switch (this) {
      case OrderStatus.pending:
        return Colors.orange;
      case OrderStatus.rejected:
        return ColorConstant.secondaryColor;
      case OrderStatus.accepted:
        return ColorConstant.primaryMainColor;
      case OrderStatus.confirmed:
        return ColorConstant.primaryMainColor;
      case OrderStatus.approved:
        return ColorConstant.primaryMainColor;
    }
  }
}

// How to handle String input from an API:
OrderStatus getStatusFromString(String statusStr) {
  return OrderStatus.values.firstWhere(
    (e) => e.name.toLowerCase() == statusStr.toLowerCase(),
    orElse: () => OrderStatus.rejected, // Default fallback
  );
}

enum TransactionEnum {
  ADJUSTMENT(label: "Discount", icon: LucideIcons.circlePercent),
  PURCHASE(label: "Purchased", icon: LucideIcons.shoppingCart),
  REFUND(label: "Refund", icon: LucideIcons.rotateCw),
  TOPUP(label: "Top up", icon: LucideIcons.banknoteArrowUp);

  final String label;
  final IconData icon;

  const TransactionEnum({required this.label, required this.icon});
}

TransactionEnum getTransactionStatus(String statusStr) {
  return TransactionEnum.values.firstWhere(
    (e) => e.name.toLowerCase() == statusStr.toLowerCase(),
    orElse: () => TransactionEnum.TOPUP, // Default fallback
  );
}

enum Direction {
  In(color: Colors.green, icon: "+"),
  Out(color: Colors.red, icon: "-");

  final Color color;
  final String icon;
  const Direction({required this.color, required this.icon});
}

Direction getDirectionStatus(String statusStr) {
  return Direction.values.firstWhere(
    (e) => e.name.toLowerCase() == statusStr.toLowerCase(),
    orElse: () => Direction.Out, // Default fallback
  );
}
