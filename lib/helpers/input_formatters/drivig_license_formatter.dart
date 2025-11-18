import 'package:flutter/services.dart';

class LicenseInputFormatter extends TextInputFormatter {
  final int maxLength;
  LicenseInputFormatter({this.maxLength = 18});

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String text = newValue.text.toUpperCase(); // Optional: convert to uppercase
    if (text.length > maxLength) {
      text = text.substring(0, maxLength);
    }
    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}
