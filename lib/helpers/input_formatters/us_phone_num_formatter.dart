import 'package:flutter/services.dart';

class UsPhoneInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String digits = newValue.text.replaceAll(RegExp(r'\D'), '');
    if (digits.length > 10) digits = digits.substring(0, 10);

    String formatted = digits;
    if (digits.length >= 6) {
      formatted = "(${digits.substring(0, 3)}) ${digits.substring(3, 6)}-${digits.substring(6)}";
    } else if (digits.length >= 4) {
      formatted = "(${digits.substring(0, 3)}) ${digits.substring(3)}";
    } else if (digits.length >= 1) {
      formatted = "(${digits.substring(0)}";
    }

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
