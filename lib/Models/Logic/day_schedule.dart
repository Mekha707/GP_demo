//
import 'package:healthcareapp_try1/Models/Logic/time_slot.dart';

class DaySchedule {
  final String date;
  final String day;
  final List<TimeSlot> slots;

  DaySchedule({required this.date, required this.day, required this.slots});

  factory DaySchedule.fromJson(Map<String, dynamic> json) {
    return DaySchedule(
      // 1. استخدام ?? '' للحماية من الـ Null في النصوص
      date: json['date'] ?? '',
      day: json['day'] ?? '',

      slots:
          (json['shifts'] as List?)
              ?.map((e) => TimeSlot.fromJson(e))
              .toList() ??
          [],
    );
  }
}
