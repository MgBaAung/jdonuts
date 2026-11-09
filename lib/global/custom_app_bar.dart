import 'package:jdonutscodetest/global/color_constant.dart';
import 'package:jdonutscodetest/global/enumeration.dart';
import 'package:jdonutscodetest/global/extension/num_extension.dart';
import 'package:jdonutscodetest/global/size_constant.dart';
import 'package:flutter/material.dart';

class CustomHeaderAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final Widget content;
  final bool showShadow;
  final Color appBarColor;
  final Color appBgColor;
  final Color secondColor;
  final bool isProfile;
  final AppNavTab index;
  const CustomHeaderAppBar({
    super.key,
    required this.content,
    required this.isProfile,
    this.showShadow = false,
    this.appBgColor = Colors.white,
    this.secondColor = const Color(0xFFED1C24),
    this.appBarColor = const Color(0xFFF9FBF9),
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: !isProfile && index != AppNavTab.order ? appBarColor : null,
      decoration: isProfile && index == AppNavTab.home
          ? BoxDecoration(
              color: ColorConstant.whiteColor,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(SizeConstant.s4),
                bottomRight: Radius.circular(SizeConstant.s4),
              ),
            )
          : null,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: MediaQuery.of(context).padding.top,
            color: const Color(0xFF5BBA47),
          ),
          index == AppNavTab.order ? 0.boxHeight : 2.boxHeight,
          isProfile
              ? Container(height: 6, color: secondColor)
              : SizedBox.shrink(),
          Container(
            decoration: BoxDecoration(
              color: index == AppNavTab.order
                  ? ColorConstant.whiteColor
                  : appBgColor,
              borderRadius: isProfile || index == AppNavTab.order
                  ? BorderRadius.only(
                      bottomLeft: Radius.circular(SizeConstant.s5),
                      bottomRight: Radius.circular(SizeConstant.s5),
                    )
                  : null,
            ),
            padding: index == AppNavTab.order
                ? 0.allSpacing
                : const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: SafeArea(top: false, child: content),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize =>
      Size.fromHeight((isProfile || index == AppNavTab.order) ? 209 : 130);
}
