import 'package:flutter/material.dart';
import 'package:jdonutscodetest/global/app_theme.dart';

import '../color_constant.dart';
import '../size_constant.dart';
import 'num_extension.dart';
import 'text_extension.dart';

extension Dialog on BuildContext {
  void showLoading() {
    showDialog(
      context: this,
      builder: (_) {
        return PopScope(
          canPop: false,
          child: Center(
            child: SizedBox(
              width: 30,
              height: 30,
              child: CircularProgressIndicator(
                strokeWidth: 5,
                color: ColorConstant.primaryMainColor,
              ),
            ),
          ),
        );
      },
    );
  }

  void hideLoading() {
    if (Navigator.of(this, rootNavigator: true).canPop()) {
      Navigator.of(this, rootNavigator: true).pop();
    }
  }

  Future<T?> showContentDialog<T>({required Widget child}) {
    return showDialog<T>(
      context: this,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return PopScope(
          canPop: false,
          child: AlertDialog(
            contentPadding: 0.allSpacing,
            insetPadding: 10.allSpacing,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(SizeConstant.s2),
            ),
            content: Builder(
              builder: (context) {
                final mediaQuery = MediaQuery.of(context);
                return Container(
                  margin: [0, 16].symmetricPadding,
                  width: mediaQuery.size.width,
                  child: child,
                );
              },
            ),
          ),
        );
      },
    );
  }

  Future<T?> showNoticeBox<T>({
    required String titleText,
    required String contentText,
    List<Widget>? actions,
    bool canPop = true,
    Color titleColor = ColorConstant.blcakColor,
    VoidCallback? onPress,
    Widget? contentView,
  }) {
    return showDialog(
      context: this,
      barrierDismissible: false,
      builder: (dialogContext) {
        return PopScope(
          canPop: canPop,
          child: AlertDialog(
            backgroundColor: ColorConstant.whiteColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(SizeConstant.s2),
            ),
            contentPadding: EdgeInsets.fromLTRB(
              16,
              10,
              10,
              actions == null ? 0 : 10,
            ),
            content:
                contentView ??
                SizedBox(
                  width: 300.v,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            titleText,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: dialogContext.medium(
                              fSize: 18,
                              color: titleColor,
                            ),
                          ),
                          actions != null
                              ? SizedBox.shrink()
                              : IconButton(
                                  onPressed:
                                      onPress ??
                                      () => Navigator.of(dialogContext).pop(),
                                  icon: const Icon(
                                    Icons.close,
                                    color: Colors.black,
                                    size: 20,
                                  ),
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                ),
                        ],
                      ),
                      actions != null ? 10.boxHeight : 0.boxHeight,
                      Text(
                        contentText,
                        style: dialogContext.regular(
                          fSize: 14,
                          color: ColorConstant.greyColor,
                        ),
                      ),
                      SizeConstant.s1.boxHeight,
                      actions == null
                          ? SizedBox.shrink()
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: actions
                                  .map((w) => Expanded(child: w))
                                  .toList(),
                            ),
                    ],
                  ),
                ),
          ),
        );
      },
    );
  }
}
