import 'package:intl/intl.dart';

extension DatetimeExtension on DateTime {
  String formattedDate() {
    return DateFormat('yyyy-MM-dd').format(this);
  }

  String formattedYM() {
    return "${year.toString().padLeft(4, '0')}-${month.toString().padLeft(2, '0')}";
  }
}
