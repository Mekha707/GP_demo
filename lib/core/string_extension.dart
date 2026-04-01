import 'dart:ui';

extension StringHelpers on String {
  // دالة للتحقق هل النص يحتوي على حروف عربية أم لا
  bool get isArabic {
    return RegExp(r'[\u0600-\u06FF]').hasMatch(this);
  }

  // خاصية لتحديد اتجاه النص
  TextDirection get getDirection =>
      isArabic ? TextDirection.rtl : TextDirection.ltr;

  // خاصية لتحديد محاذاة النص
  TextAlign get getTextAlign => isArabic ? TextAlign.right : TextAlign.left;
}
