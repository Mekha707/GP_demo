// ignore_for_file: deprecated_member_use

import 'dart:math';
import 'package:flutter/material.dart';

class FlipRadioButton<T> extends StatefulWidget {
  final T value;
  final T groupValue;
  final ValueChanged<T> onChanged;
  final String labelA;
  final String labelB;

  const FlipRadioButton({
    super.key,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    this.labelA = "A",
    this.labelB = "B",
  });

  @override
  State<FlipRadioButton<T>> createState() => _FlipRadioButtonState<T>();
}

class _FlipRadioButtonState<T> extends State<FlipRadioButton<T>>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  bool get isSelected => widget.value == widget.groupValue;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    // ابدأ من الحالة الصح
    if (isSelected) {
      _controller.value = 0.0;
    } else {
      _controller.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(FlipRadioButton<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    // لما يتغير الـ groupValue، شغّل الـ animation
    if (oldWidget.groupValue != widget.groupValue) {
      if (isSelected) {
        _controller.reverse(); // يرجع لـ 0 (selected = indigo)
      } else {
        _controller.forward(); // يروح لـ 1 (not selected = grey)
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => widget.onChanged(widget.value),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                final angle = _animation.value * pi;
                final isFirstHalf = angle < (pi / 2);

                final color = Color.lerp(
                  Color(0xff131ab9),
                  Colors.grey.shade200,
                  _animation.value,
                )!;

                final frontcolor = Color.lerp(
                  Colors.white,
                  Colors.grey.shade600,
                  _animation.value,
                )!;

                return Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, 0.002)
                    ..rotateY(angle),
                  child: Container(
                    width: 85,
                    height: 40,
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(50),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.4),
                          blurRadius: 6,
                          offset: Offset(isSelected ? -4 : 4, 4),
                        ),
                      ],
                    ),
                    child: Center(
                      child: isFirstHalf
                          ? Text(
                              widget.labelA,
                              style: TextStyle(
                                color: frontcolor,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          : Transform(
                              alignment: Alignment.center,
                              transform: Matrix4.identity()..rotateY(pi),
                              child: Text(
                                widget.labelB,
                                style: TextStyle(
                                  color: frontcolor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(width: 15),
          ],
        ),
      ),
    );
  }
}
