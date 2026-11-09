import 'package:jdonutscodetest/global/app_theme.dart';
import 'package:jdonutscodetest/global/color_constant.dart';
import 'package:jdonutscodetest/global/extension/context_extension.dart';
import 'package:jdonutscodetest/global/extension/num_extension.dart';
import 'package:jdonutscodetest/global/extension/text_extension.dart';
import 'package:jdonutscodetest/global/size_constant.dart';
import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  final String btnLabel;
  final VoidCallback onPressedFun;
  final Color? bgColor;
  final Color? btnTextColor;
  final Color? borderColor;
  final double? fSize;
  final double? radius;
  final double? elevation;
  const CustomElevatedButton({
    super.key,
    required this.btnLabel,
    required this.onPressedFun,
    this.bgColor,
    this.btnTextColor,
    this.borderColor,
    this.fSize,
    this.radius,
    this.elevation,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final baseHeight =
            context.screenHeight * (context.isMobile ? 0.055 : 0.055);

        return ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: 40,
            maxHeight: baseHeight < 40 ? 40 : baseHeight,
          ),
          child: ElevatedButton(
            onPressed: onPressedFun,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xff50c9df),
              disabledBackgroundColor: const Color(0xffbcecf3),
              foregroundColor: Colors.white,
              shape: const StadiumBorder(),
            ),
            child: Center(
              child: Text(
                btnLabel,
                style: context.medium(
                  fSize: fSize ?? 10,
                  color: btnTextColor ?? ColorConstant.whiteColor,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class IconButtonText extends StatelessWidget {
  final IconData prefixIcon;
  final IconData trailIcon;
  final String title;
  final VoidCallback onPressedFun;

  const IconButtonText({
    super.key,
    required this.prefixIcon,
    required this.trailIcon,
    required this.title,
    required this.onPressedFun,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressedFun,
      child: Container(
        height: 50.fSize,
        width: double.infinity,
        padding: [0, 15].symmetricPadding,
        decoration: BoxDecoration(
          color: ColorConstant.whiteColor,
          borderRadius: BorderRadius.circular(SizeConstant.s2),
        ),
        child: Row(
          children: [
            Icon(prefixIcon, color: ColorConstant.primaryMainColor),
            10.boxWidth,
            Text(title, style: context.medium(fSize: 16)),
            Spacer(),
            Icon(trailIcon, color: ColorConstant.primaryMainColor, size: 20),
          ],
        ),
      ),
    );
  }
}
