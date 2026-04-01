// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class MagicCheckbox extends StatelessWidget {
  final String label;
  final bool isChecked;
  final List<Color> gradientColors;
  final ValueChanged<bool> onChanged;

  const MagicCheckbox({
    super.key,
    required this.label,
    required this.isChecked,
    required this.gradientColors,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!isChecked),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // الـ Liquid Box
            AnimatedRotation(
              turns: isChecked ? 8 / 360 : 0,
              duration: const Duration(milliseconds: 600),
              curve: Curves.elasticOut,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 600),
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.white.withOpacity(0.1),
                  border: Border.all(color: Colors.white.withOpacity(0.2)),
                  boxShadow: isChecked
                      ? [
                          BoxShadow(
                            color: gradientColors[0].withOpacity(0.5),
                            blurRadius: 20,
                            spreadRadius: 2,
                          ),
                        ]
                      : [],
                ),
                clipBehavior: Clip.antiAlias, // لقص السائل داخل الحواف
                child: Stack(
                  children: [
                    // السائل المتصاعد (Liquid Fill)
                    AnimatedPositioned(
                      duration: const Duration(milliseconds: 800),
                      curve: Curves.elasticOut,
                      bottom: isChecked ? 0 : -40,
                      left: 0,
                      right: 0,
                      height: 40,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: gradientColors,
                            begin: Alignment.bottomLeft,
                            end: Alignment.topRight,
                          ),
                        ),
                      ),
                    ),
                    // لمعة صغيرة (Sparkle)
                    if (isChecked)
                      const Center(
                        child: Icon(Icons.star, color: Colors.white, size: 15),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 15),
            // النص المتوهج
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 400),
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
                shadows: isChecked
                    ? [Shadow(color: gradientColors[0], blurRadius: 15)]
                    : [],
              ),
              child: Text(label),
            ),
          ],
        ),
      ),
    );
  }
}
