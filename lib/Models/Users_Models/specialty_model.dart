import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Specialty {
  final String id;
  final String name;
  final IconData icon;
  final Color color;

  Specialty({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
  });

  // Factory لبناء الكائن من الـ API Response
  factory Specialty.fromJson(Map<String, dynamic> json) {
    final String name = json['name'] ?? '';

    // ربط الاسم بالأيقونة واللون يدوياً
    return Specialty(
      id: json['id'] ?? '',
      name: name,
      icon: _getIconForSpecialty(name),
      color: _getColorForSpecialty(name),
    );
  }

  static IconData _getIconForSpecialty(String name) {
    switch (name.toLowerCase()) {
      case 'cardiology':
        return Icons.favorite;
      case 'neurology':
        return FontAwesomeIcons.brain;
      case 'pediatrics':
        return Icons.child_care;
      case 'orthopedics':
        return FontAwesomeIcons.bone;
      case 'ophthalmology':
        return Icons.remove_red_eye_outlined;
      default:
        return FontAwesomeIcons.stethoscope;
    }
  }

  static Color _getColorForSpecialty(String name) {
    switch (name.toLowerCase()) {
      case 'cardiology':
        return const Color(0xffe7000b);
      case 'neurology':
        return const Color(0xff9a16fa);
      case 'pediatrics':
        return const Color(0xff0861dd);
      case 'orthopedics':
        return const Color(0xffe58017);
      default:
        return const Color(0xff5642f7);
    }
  }
}
