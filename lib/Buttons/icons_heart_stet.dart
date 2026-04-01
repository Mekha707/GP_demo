// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Iconheartstet extends StatelessWidget {
  final double topPadding; // المسافة العلوية
  final double spacing; // المسافة بين الأيقونتين
  final double iconSize; // حجم الأيقونة
  final bool useImageAsset; // هل نستخدم صورة للسماعة؟

  const Iconheartstet({
    super.key,
    this.topPadding = 20.0,
    this.spacing = 10.0,
    this.iconSize = 30.0,
    this.useImageAsset = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          FontAwesomeIcons.solidHeart,
          color: Color(0xffd51934),
          size: iconSize,
        ),
        SizedBox(width: spacing),
        Icon(FontAwesomeIcons.stethoscope, color: Color(0xff0861dd), size: 30),
      ],
    );
  }
}

class IconHeartStet2 extends StatelessWidget {
  const IconHeartStet2({
    super.key,
    required this.topPadding,
    required this.spacing,
    required this.iconSize,
    required this.useImageAsset,
  });
  final double topPadding; // المسافة العلوية
  final double spacing; // المسافة بين الأيقونتين
  final double iconSize; // حجم الأيقونة
  final bool useImageAsset;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.favorite, color: Color(0xFFD51934), size: 30),

          SizedBox(width: 5),
          Image.asset(
            'assets/icons/stethoscope-Login.png',
            height: 23,
            width: 23,
          ),
        ],
      ),
    );
  }
}
