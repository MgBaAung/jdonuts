import 'package:flutter/services.dart';

class PhNoFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String input = newValue.text;
    if (input.startsWith('+')) {
      input = '+${input.substring(1).replaceAll(RegExp(r'\D'), '')}';
    } else {
      input = input.replaceAll(RegExp(r'\D'), '');
    }
    final allowedPrefixes = ['0', '09', '+', '+9', '+95', '+959'];

    final isTypingAllowed =
        input.isEmpty ||
        allowedPrefixes.any((prefix) => input.startsWith(prefix));

    if (!isTypingAllowed) {
      return oldValue;
    }

    if (input.startsWith("09") && input.length > 11) {
      input = input.substring(0, 11);
    } else if (input.startsWith("+959") && input.length > 13) {
      input = input.substring(0, 13);
    } else if (input.length > 13) {
      input = input.substring(0, 13);
    }

    return TextEditingValue(
      text: input,
      selection: TextSelection.collapsed(offset: input.length),
    );
  }
}
