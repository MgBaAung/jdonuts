import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void changeStatus({
  Color color = Colors.transparent,
  Brightness brightness = Brightness.light,
}) {
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: color,
      statusBarIconBrightness: brightness,
      statusBarBrightness: Brightness.light,
    ),
  );
}

// StatusModel statusMethod({
//   required LastOwnerHistory date,
//   required int status,
// }) {
//   DateTime startDate = DateTime.parse(date.startDate ?? "");

//   bool isFuture = startDate.isAfter(DateTime.now());

//   if (isFuture) {
//     return StatusModel(name: "Coming Soon", color: Color(0xFFFF7824));
//   } else if (status == 2 && !isFuture) {
//     return StatusModel(name: "Active", color: ColorConstant.primaryMainColor);
//   } else {
//     return StatusModel(name: "Inactive", color: ColorConstant.secondaryColor);
//   }
// }

class StatusModel {
  final Color color;
  final String name;

  StatusModel({required this.color, required this.name});
}
