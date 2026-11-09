import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

extension NumExtension on num {
  SizedBox get boxHeight => SizedBox(height: toDouble());
  SizedBox get boxWidth => SizedBox(width: toDouble());

  EdgeInsets get allSpacing => EdgeInsets.all(toDouble());

  EdgeInsets get leftSpacing => EdgeInsets.only(left: toDouble());
  EdgeInsets get rightSpacing => EdgeInsets.only(right: toDouble());

  EdgeInsets get topSpacing => EdgeInsets.only(top: toDouble());
  EdgeInsets get bottomSpacing => EdgeInsets.only(bottom: toDouble());

  String toMoneyFormat() {
    return NumberFormat("#,##0").format(this);
  }
}

extension SymmetricExtension on List<num> {
  EdgeInsets get symmetricPadding {
    if (length != 2) {
      throw ArgumentError(
        "List must contain exactly 2 elements: [vertical, horizontal]",
      );
    }

    return EdgeInsets.symmetric(
      vertical: this[0].toDouble(),
      horizontal: this[1].toDouble(),
    );
  }
}
