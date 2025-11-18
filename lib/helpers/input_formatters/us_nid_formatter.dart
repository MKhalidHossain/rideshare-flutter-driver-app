import 'package:flutter/services.dart';

class UsNidInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    var text = newValue.text.replaceAll('-', '');

    // Limit digits to max 9
    if (text.length > 9) {
      text = text.substring(0, 9);
    }

    // SSN format: 123-45-6789  (3-2-4)
    if (text.length <= 9) {
      if (text.length >= 6) {
        text = "${text.substring(0, 3)}-${text.substring(3, 5)}-${text.substring(5)}";
      } else if (text.length >= 4) {
        text = "${text.substring(0, 2)}-${text.substring(2)}";
      }
    }

    // EIN format: 12-3456789 (2-7)
    if (text.length == 9 && oldValue.text.contains('-') == false) {
      text = "${text.substring(0, 2)}-${text.substring(2)}";
    }

    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}
