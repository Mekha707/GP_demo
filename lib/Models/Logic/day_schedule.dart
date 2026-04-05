//
import 'package:healthcareapp_try1/Models/Logic/time_slot.dart';

class DaySchedule {
  final String date;
  final String day;
  final List<TimeSlot> slots;

  DaySchedule({required this.date, required this.day, required this.slots});
  factory DaySchedule.fromJson(Map<String, dynamic> json) {
    final rawSlots = (json['slots'] ?? json['shifts']) as List?;

    return DaySchedule(
      date: json['date'] ?? '',
      day: json['day'] ?? '',
      slots: rawSlots?.map((e) => TimeSlot.fromJson(e)).toList() ?? [],
    );
  }
}
