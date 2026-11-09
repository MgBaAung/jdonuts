// Attendance enum values are persisted as uppercase backend identifiers.
// ignore_for_file: constant_identifier_names

import 'package:intl/intl.dart';

import '../enumeration.dart';

extension StringExtension on String {
  String formattedDate() {
    try {
      DateTime dateTime = DateTime.parse(this);
      return DateFormat("yyyy-MM-dd").format(dateTime);
    } catch (e) {
      return this;
    }
  }

  String changeDMYTFormat() {
    try {
      DateTime dateTime = DateTime.parse(this).toLocal();

      return DateFormat("dd MMM yyyy hh:mm a").format(dateTime);
    } catch (e) {
      return this;
    }
  }

  String changeEDMYFormat() {
    try {
      var inputFormat = DateFormat('yyyy-MM-dd');
      final date = inputFormat.parse(this);
      final output = DateFormat('EEEE,dd MMMM, yyyy');
      return output.format(date);
    } catch (e) {
      return this;
    }
  }

  String changeDMYFormat() {
    try {
      final inputFormat = DateFormat('yyyy-MM-dd');
      final date = inputFormat.parse(this);
      final outputFormat = DateFormat('dd MMM, yyyy');
      return outputFormat.format(date);
    } catch (e) {
      return this;
    }
  }

  String get safeDecodedPath {
    final encodingPattern = RegExp(r'%[0-9A-Fa-f]{2}');
    return encodingPattern.hasMatch(this) ? Uri.decodeComponent(this) : this;
  }

  bool get isValidPhoneNo {
    final pattern = RegExp(r'^(?:\+?95|0)?9\d{7,9}$');
    return pattern.hasMatch(this);
  }

  String toCustomFormat() {
    try {
      return "${substring(0, 4)} ${substring(4, 8)} ${substring(8, 12)} ${substring(12, 16)}";
    } catch (e) {
      return this;
    }
  }

  String toRefFormat() {
    try {
      return "${substring(0, 3)} ${substring(3, 5)} ${substring(5, 9)} ${substring(9)}";
    } catch (e) {
      return this;
    }
  }

  String toInitials() {
    if (trim().isEmpty) return "??";

    List<String> nameParts = trim().split(RegExp(r'\s+'));

    if (nameParts.length > 1) {
      return (nameParts[0][0] + nameParts[1][0]).toUpperCase();
    } else {
      return nameParts[0].length > 1
          ? nameParts[0].substring(0, 2).toUpperCase()
          : nameParts[0][0].toUpperCase();
    }
  }

  String firstUpper() {
    if (isEmpty) return this;
    return "${this[0].toUpperCase()}${substring(1)}";
  }

  String splitCommon() {
    try {
      if (contains(',')) {
        return split(',').first.trim();
      }
      return this;
    } catch (e) {
      return this;
    }
  }

  LanguageEnum changeLnEnum() {
    try {
      if (LanguageEnum.english.code == this) {
        return LanguageEnum.english;
      } else {
        return LanguageEnum.myanmar;
      }
    } catch (e) {
      return LanguageEnum.english;
    }
  }

  String toCapitalized() {
    if (isEmpty) return this;
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }

  String toTitleCase() {
    if (isEmpty) return this;
    return split(' ').map((word) => word.toCapitalized()).join(' ');
  }

  String attendanceStatus() {
    if (this == "TIME_IN") {
      return "Check Out";
    }

    return "Check In";
  }

  String get extractNumber {
    final regExp = RegExp(r'[0-9,]+');
    final match = regExp.firstMatch(this);
    return match != null ? match.group(0)! : "";
  }

  String toTimeAgo() {
    try {
      DateTime dateTime = DateTime.parse(this).toLocal();
      DateTime now = DateTime.now();
      Duration diff = now.difference(dateTime);

      if (diff.inDays >= 365) {
        int years = (diff.inDays / 365).floor();
        return "$years year${years > 1 ? 's' : ''} ago";
      } else if (diff.inDays >= 30) {
        int months = (diff.inDays / 30).floor();
        return "$months month${months > 1 ? 's' : ''} ago";
      } else if (diff.inDays >= 1) {
        return "${diff.inDays} day${diff.inDays > 1 ? 's' : ''} ago";
      } else if (diff.inHours >= 1) {
        return "${diff.inHours} hour${diff.inHours > 1 ? 's' : ''} ago";
      } else if (diff.inMinutes >= 1) {
        return "${diff.inMinutes} minute${diff.inMinutes > 1 ? 's' : ''} ago";
      } else {
        return "Just now";
      }
    } catch (e) {
      return "";
    }
  }

  String capitalize() {
    if (isEmpty) return this;
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}

String getInitials(String? name) {
  if (name == null || name.isEmpty) return "?";

  List<String> nameParts = name.trim().split(" ");
  if (nameParts.length > 1) {
    return (nameParts[0][0] + nameParts[1][0]).toUpperCase();
  } else {
    return nameParts[0][0].toUpperCase();
  }
}

enum Attendance { TIME_IN, TIME_OUT }
