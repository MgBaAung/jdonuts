import 'package:jdonutscodetest/global/color_constant.dart';
import 'package:jdonutscodetest/global/extension/text_extension.dart';
import 'package:jdonutscodetest/global/size_constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextFormField extends StatefulWidget {
  final TextEditingController? textEditingController;
  final ValueChanged<String?>? onChangedFunction;
  final ValueChanged<String?>? submitFunction;
  final FormFieldValidator<String?>? validator;
  final String? label;
  final String? hintText;
  final TextInputType? inputType;
  final FocusNode? focusNode;
  final bool autoFocus;
  final bool? readOnly;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final bool obscureText;
  final VoidCallback? onTapFunction;
  final Color? fillColor;
  final EdgeInsets? contentPadding;
  final String? helperTxt;
  final Function(PointerDownEvent)? onTapOutSideEvent;
  final List<TextInputFormatter>? inputFormatter;
  final double? borderRadius;
  final int? maxLines;
  final int? maxLength;
  const CustomTextFormField({
    super.key,
    this.borderRadius,
    required this.textEditingController,
    this.onChangedFunction,
    this.submitFunction,
    this.validator,
    this.label,
    this.hintText,
    this.inputType,
    this.focusNode,
    this.autoFocus = false,
    this.readOnly = false,
    this.suffixIcon,
    this.prefixIcon,
    this.obscureText = false,
    this.onTapFunction,
    this.fillColor,
    this.contentPadding,
    this.helperTxt,
    this.onTapOutSideEvent,
    this.inputFormatter,
    this.maxLines,
    this.maxLength,
  });

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          style: context.regular(fSize: SizeConstant.f1),
          autofocus: widget.autoFocus,
          focusNode: widget.focusNode,
          readOnly: widget.readOnly ?? false,
          controller: widget.textEditingController,
          cursorColor: ColorConstant.primaryMainColor,
          cursorErrorColor: Colors.red,
          // cursorHeight: AppConstant.s1,
          keyboardType: widget.inputType,
          enableSuggestions: false,
          obscureText: widget.obscureText,
          inputFormatters: widget.inputFormatter,
          maxLines: widget.maxLines ?? 1,
          maxLength: widget.maxLength,
          //style: TextStyle().titleSmallStyle(Colors.black, FontWeight.w400),
          decoration: InputDecoration(
            filled: true,
            border: OutlineInputBorder(
              borderSide: BorderSide(color: ColorConstant.borderStoke),
              borderRadius: BorderRadius.circular(
                widget.borderRadius ?? SizeConstant.s2,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: ColorConstant.primaryMainColor),
              borderRadius: BorderRadius.circular(
                widget.borderRadius ?? SizeConstant.s2,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: ColorConstant.borderStoke),
              borderRadius: BorderRadius.circular(
                widget.borderRadius ?? SizeConstant.s2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red),
              borderRadius: BorderRadius.circular(
                widget.borderRadius ?? SizeConstant.s2,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: ColorConstant.secondaryColor),
              borderRadius: BorderRadius.circular(
                widget.borderRadius ?? SizeConstant.s2,
              ),
            ),
            isDense: true,
            hintText: widget.hintText ?? "",
            helperText: widget.helperTxt,
            contentPadding:
                widget.contentPadding ??
                EdgeInsets.symmetric(
                  vertical: SizeConstant.s1,
                  horizontal: SizeConstant.s2,
                ),
            hintStyle: context.regular(
              fSize: SizeConstant.f1,
              color: Colors.black.withValues(alpha: 0.3),
            ),
            prefixIcon: widget.prefixIcon,
            prefixIconColor: Colors.black,
            suffixIcon: widget.suffixIcon,
            suffixIconColor: Colors.black,
            fillColor: widget.fillColor ?? Colors.white,
          ),
         
          validator: widget.validator,
          onChanged: widget.onChangedFunction,
          onFieldSubmitted: widget.submitFunction,
          onTap: widget.onTapFunction,
          onTapOutside:
              widget.onTapOutSideEvent ??
              (value) {
                FocusManager.instance.primaryFocus?.unfocus();
              },
          onEditingComplete: () {
            FocusManager.instance.primaryFocus?.unfocus();
          },
        ),
      ],
    );
  }
}
