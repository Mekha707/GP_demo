import 'dart:math' as math;
import 'package:flutter/material.dart';

class CustomSpinner extends StatefulWidget {
  final double size;
  final Color color;

  const CustomSpinner({super.key, this.size = 50.0, this.color = Colors.black});

  @override
  State<CustomSpinner> createState() => _CustomSpinnerState();
}

class _CustomSpinnerState extends State<CustomSpinner>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(); // تكرار الأنميشن للأبد
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: Stack(
        alignment: Alignment.center,
        children: List.generate(10, (index) {
          // حساب الزاوية لكل نقطة (36 درجة زي الـ CSS)
          final double rotation = (index + 1) * 36.0;

          return AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              // محاكاة الـ Delay والـ Keyframes
              // بنستخدم Sine wave عشان نحاكي التمدد والانكماش (Translation)
              double delay = (index + 1) * 0.1;
              double progress = (_controller.value - delay) % 1.0;
              double pulse = math.sin(progress * math.pi);

              // الـ Translation اللي في الـ CSS
              double translationMultiplier = 1.0 + (pulse * 0.5);

              return Transform.rotate(
                angle: rotation * (math.pi / 180),
                child: Transform.translate(
                  offset: Offset(0, -widget.size * 0.3 * translationMultiplier),
                  child: Container(
                    width: widget.size * 0.08,
                    height: widget.size * 0.15,
                    decoration: BoxDecoration(
                      color: widget.color,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
              );
            },
          );
        }),
      ),
    );
  }
}
