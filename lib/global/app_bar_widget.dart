import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_theme.dart';
import 'color_constant.dart';
import 'extension/text_extension.dart';
import 'navigation_service.dart';
import 'size_constant.dart';

AppBar customAppbar({
  required String title,
  required BuildContext context,
  Color? bgColor,
  Color? textColor,
  Color? iconColor,
  SystemUiOverlayStyle? systemStyle,
  List<Widget>? actions,
  void Function()? onPressed,
}) {
  return AppBar(
    backgroundColor: bgColor,
    title: Text(
      title,
      style: context.semibold(
        color: textColor ?? ColorConstant.whiteColor,
        fSize: 20,
      ),
    ),
    centerTitle: false,
    systemOverlayStyle:
        systemStyle ??
        SystemUiOverlayStyle(
          systemStatusBarContrastEnforced: true,
          statusBarColor: ColorConstant.primaryMainColor,
          statusBarIconBrightness: Brightness.light,
        ),
    titleSpacing: 0,
    automaticallyImplyLeading: false,
    leading: IconButton(
      onPressed:
          onPressed ??
          () {
            NavigationService.instance.goBack();
          },
      icon: Icon(
        Icons.arrow_back_ios,
        color: iconColor ?? ColorConstant.whiteColor,
        size: SizeConstant.s4.fSize,
      ),
    ),
    actions: actions,
  );
}
