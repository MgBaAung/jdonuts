import 'package:jdonutscodetest/global/custom_text_field.dart';
import 'package:jdonutscodetest/global/extension/date_time_extension.dart';
import 'package:jdonutscodetest/global/extension/text_extension.dart';
import 'package:flutter/material.dart';

class DatePickerWidget extends StatelessWidget {
  final TextEditingController controller;
  final String? hintText;
  final String? label;
  final Function(String?)? validator;
  const DatePickerWidget({
    super.key,
    required this.controller,
    this.hintText,
    this.label,
    this.validator,
  });
  Future<void> showDatePickerDialog(BuildContext context) async {
    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: controller.text.isEmpty
          ? DateTime.now()
          : DateTime.parse(controller.text),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Colors.black,
                textStyle: TextStyle().titleSmallStyle(
                  Colors.black,
                  FontWeight.w400,
                ),
              ),
            ),
            datePickerTheme: DatePickerThemeData(
              headerForegroundColor: Colors.black,
              dayStyle: TextStyle().titleSmallStyle(
                Colors.black,
                FontWeight.w400,
              ),
              weekdayStyle: TextStyle().titleSmallStyle(
                Colors.black,
                FontWeight.bold,
              ),
              yearStyle: TextStyle().titleSmallStyle(
                Colors.black,
                FontWeight.w400,
              ),
              backgroundColor: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (selectedDate != null) {
      controller.text = selectedDate.formattedDate();
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomTextFormField(
      textEditingController: controller,
      hintText: hintText ?? "",
      label: label ?? "",
      readOnly: true,
      validator: (value) => validator!(value),
      onTapFunction: () => showDatePickerDialog(context),
      helperTxt: "",
      suffixIcon: IconButton(
        icon: Icon(Icons.date_range),
        onPressed: () => showDatePickerDialog(context),
      ),
    );
  }
}
