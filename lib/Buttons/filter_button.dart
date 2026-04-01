// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class CustomFilterButton extends StatelessWidget {
  final bool isSelected;
  final VoidCallback onTap;
  final String activeText;
  final String inactiveText;
  final Color activeColor;

  const CustomFilterButton({
    super.key,
    required this.isSelected,
    required this.onTap,
    this.activeText = "Clear Filter",
    this.inactiveText = "Filter Doctors",
    required this.activeColor,
  });

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: GestureDetector(
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            height: 50,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              // تغيير اللون بناءً على حالة التحديد
              color: isSelected
                  ? activeColor.withOpacity(0.5)
                  : const Color(0xFFFFFFFF),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: isSelected ? activeColor : const Color(0xFFD1D1D1),
                  offset: isSelected ? const Offset(0, 2) : const Offset(0, 5),
                ),
                const BoxShadow(color: Colors.white, offset: Offset(0, -1)),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  isSelected ? Icons.filter_alt_off : Icons.filter_alt_outlined,
                  color: isSelected ? Colors.white : const Color(0xFF242424),
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  isSelected ? activeText : inactiveText,
                  style: TextStyle(
                    color: isSelected ? Colors.white : const Color(0xFF242424),
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    letterSpacing: 1.1,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
