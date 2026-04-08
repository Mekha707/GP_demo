// ignore_for_file: deprecated_member_use, use_super_parameters, library_private_types_in_public_api

import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomRadioGroup extends StatefulWidget {
  final List<String> tabs;
  final double width;
  final Color backgroundColor;
  final Color selectedColor;
  final Color textColor;
  final Function(int) onSelectionChange;

  const CustomRadioGroup({
    Key? key,
    required this.tabs,
    required this.onSelectionChange,
    this.width = 300.0,
    this.backgroundColor = const Color(0xFFEEEEEE),
    this.selectedColor = Colors.white,
    this.textColor = const Color(0xFF334155),
  }) : super(key: key);

  @override
  _CustomRadioGroupState createState() => _CustomRadioGroupState();
}

class _CustomRadioGroupState extends State<CustomRadioGroup> {
  int _selectedValue = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: CupertinoSlidingSegmentedControl<int>(
        backgroundColor: widget.backgroundColor,
        thumbColor: widget.selectedColor,
        groupValue: _selectedValue,
        children: {
          for (int i = 0; i < widget.tabs.length; i++)
            i: _buildTab(widget.tabs[i], i == _selectedValue),
        },
        onValueChanged: (value) {
          if (value != null) {
            setState(() => _selectedValue = value);
            widget.onSelectionChange(value);
          }
        },
      ),
    );
  }

  Widget _buildTab(String text, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          color: widget.textColor,
          fontFamily: 'Agency',
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
    );
  }
}
