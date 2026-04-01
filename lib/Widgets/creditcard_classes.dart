// تنسيق رقم البطاقة: 0000 0000 0000 0000
import 'package:flutter/services.dart';

class CardNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    var text = newValue.text.replaceAll(' ', '');
    var newString = "";
    for (int i = 0; i < text.length; i++) {
      newString += text[i];
      if ((i + 1) % 4 == 0 && i != text.length - 1) newString += " ";
    }
    return newValue.copyWith(
      text: newString,
      selection: TextSelection.collapsed(offset: newString.length),
    );
  }
}

// تنسيق التاريخ: MM/YY
class CardDateFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    var text = newValue.text.replaceAll('/', '');
    if (text.length > 4) text = text.substring(0, 4);
    var newString = "";
    for (int i = 0; i < text.length; i++) {
      newString += text[i];
      if (i == 1 && text.length > 2) newString += "/";
    }
    return newValue.copyWith(
      text: newString,
      selection: TextSelection.collapsed(offset: newString.length),
    );
  }
}
