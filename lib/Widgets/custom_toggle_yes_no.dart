// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // ضروري للاهتزاز

class CustomAnimatedToggle extends StatefulWidget {
  final bool initialValue;
  final ValueChanged<bool> onSelectionChange;

  const CustomAnimatedToggle({
    super.key,
    required this.initialValue,
    required this.onSelectionChange,
  });

  @override
  State<CustomAnimatedToggle> createState() => _CustomAnimatedToggleState();
}

class _CustomAnimatedToggleState extends State<CustomAnimatedToggle> {
  late bool isChecked = true;
  bool isPressing = false; // لمحاكاة تأثير الـ :active في CSS

  @override
  void initState() {
    super.initState();
    isChecked = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    // القيمة هنا تعتمد على هل المستخدم اختار Yes (Checked) أم لا
    final bool isYes = isChecked;

    return GestureDetector(
      onTap: () {
        setState(() => isChecked = !isChecked);
        // --- إضافة الاهتزاز هنا ---
        HapticFeedback.lightImpact();
        widget.onSelectionChange(isChecked);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: 74,
        height: 36,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          // الخلفية: أزرق فاتح لـ Yes، أحمر فاتح لـ No
          color: isYes
              ? const Color(0xFF2D6CDF).withOpacity(0.2)
              : const Color(0xFFFCEBEB),
        ),
        child: Stack(
          children: [
            AnimatedAlign(
              duration: const Duration(milliseconds: 800),
              curve: const Cubic(0.18, 0.89, 0.32, 1.28),
              // اليسار لـ Yes، اليمين لـ No (أو العكس حسب رغبتك)
              alignment: isYes ? Alignment.centerRight : Alignment.centerLeft,
              child: Container(
                width: 28,
                height: 28,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isYes ? Colors.blue : Colors.red, // لون الزر نفسه
                ),
                alignment: Alignment.center,
                child: Text(
                  isYes ? "Yes" : "No", // اختصار أو كلمة كاملة
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
