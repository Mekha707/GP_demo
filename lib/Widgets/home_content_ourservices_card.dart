//

// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class HomeContentOurServiceCard extends StatefulWidget {
  const HomeContentOurServiceCard({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    required this.iconColor,
    required this.onpressed,
  });

  final IconData icon;
  final String title;
  final String description;
  final Color iconColor;
  final VoidCallback onpressed;

  @override
  State<HomeContentOurServiceCard> createState() =>
      _HomeContentOurServiceCardState();
}

class _HomeContentOurServiceCardState extends State<HomeContentOurServiceCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onpressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
        width: 500,
        height: 160, // زدنا الطول قليلاً ليستوعب الإزاحة
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          // تغيير الضل عند الـ Hover
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
          // إطار خفيف يتلون عند الـ Hover
          border: Border.all(color: Colors.grey[300]!, width: 1),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // أيقونة تتغير قليلاً عند الـ Hover (اختياري)
              AnimatedScale(
                scale: 1.0,
                duration: const Duration(milliseconds: 250),
                child: Icon(widget.icon, color: widget.iconColor, size: 40),
              ),
              const SizedBox(height: 10),
              Text(
                widget.title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Cotta',
                ),
              ),
              const SizedBox(height: 5),
              Text(
                widget.description,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[700],
                  fontFamily: 'Agency',
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
