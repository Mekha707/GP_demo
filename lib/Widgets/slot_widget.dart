// widgets/slots_section.dart
// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:healthcareapp_try1/Models/Logic/day_schedule.dart';
import 'package:healthcareapp_try1/Models/Logic/time_slot.dart';

class SlotsSection extends StatefulWidget {
  final List<DaySchedule> slots;
  final bool isNurse;
  final void Function(DaySchedule day, TimeSlot slot) onSlotSelected;

  const SlotsSection({
    super.key,
    required this.slots,
    required this.onSlotSelected,
    this.isNurse = false,
  });

  @override
  State<SlotsSection> createState() => _SlotsSectionState();
}

class _SlotsSectionState extends State<SlotsSection> {
  int _selectedDayIndex = 0;
  String? _selectedSlotId;
  String? _selectedHour; // لتخزين الساعة المختارة من الـ Dropdown

  DaySchedule? get _currentDay =>
      widget.slots.isEmpty ? null : widget.slots[_selectedDayIndex];

  @override
  Widget build(BuildContext context) {
    if (widget.slots.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text(
            'No available slots',
            style: TextStyle(color: Colors.grey.shade800, fontFamily: 'Agency'),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDaysRow(),
        const SizedBox(height: 16),
        _buildSlotsLabel(),
        _buildSlotsGrid(),
        if (widget.isNurse && _selectedSlotId != null) _buildHourChips(),
      ],
    );
  }

  Widget _buildDaysRow() {
    return SizedBox(
      height: 72,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: widget.slots.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final day = widget.slots[index];
          final isActive = index == _selectedDayIndex;
          final dayNumber = day.date.split('-').last; // "2025-04-10" → "10"

          return GestureDetector(
            onTap: () => setState(() {
              _selectedDayIndex = index;
              _selectedSlotId = null;
            }),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: isActive ? const Color(0xFF0861dd) : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isActive
                      ? const Color(0xFF0861dd)
                      : Colors.grey.shade300,
                  width: 0.8,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    day.day,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      color: isActive ? Colors.white : Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    dayNumber,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: isActive ? Colors.white : Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSlotsLabel() {
    final day = _currentDay;
    if (day == null) return const SizedBox();
    final available = day.slots.where((s) => !s.isBooked).length;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Text(
        '$available Available',
        style: TextStyle(
          fontSize: 14,
          color: Colors.grey.shade800,
          fontWeight: FontWeight.w500,
          fontFamily: 'Agency',
        ),
      ),
    );
  }

  // Widget _buildSlotsGrid() {
  //   final day = _currentDay;
  //   if (day == null) return const SizedBox();

  //   final visibleSlots = widget.isNurse
  //       ? day.slots.where((s) => !s.isBooked).toList()
  //       : day.slots;

  //   if (visibleSlots.isEmpty) {
  //     return Center(
  //       child: Padding(
  //         padding: EdgeInsets.all(24),
  //         child: Text(
  //           widget.isNurse ? 'No available slots' : 'No slots for this day',
  //           style: TextStyle(color: Colors.grey.shade800, fontFamily: 'Agency'),
  //         ),
  //       ),
  //     );
  //   }

  //   return Padding(
  //     padding: const EdgeInsets.symmetric(horizontal: 16),
  //     child: GridView.builder(
  //       shrinkWrap: true,
  //       physics: const NeverScrollableScrollPhysics(),
  //       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
  //         crossAxisCount: 3,
  //         crossAxisSpacing: 8,
  //         mainAxisSpacing: 8,
  //         childAspectRatio: 1.1,
  //       ),
  //       itemCount: visibleSlots.length,
  //       itemBuilder: (context, index) => _buildSlotCard(visibleSlots[index]),
  //     ),
  //   );
  // }

  Widget _buildSlotsGrid() {
    final day = _currentDay;
    if (day == null) return const SizedBox();

    final visibleSlots = widget.isNurse
        ? day.slots.where((s) => !s.isBooked).toList()
        : day.slots;

    if (visibleSlots.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            widget.isNurse ? 'No available slots' : 'No slots for this day',
            style: TextStyle(color: Colors.grey.shade800, fontFamily: 'Agency'),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.builder(
        // ✅ أضف هذا السطر لضمان تحديث الـ Grid فور تغيير اليوم
        key: ValueKey('day_index_$_selectedDayIndex'),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          childAspectRatio: 1.1,
        ),
        itemCount: visibleSlots.length,
        itemBuilder: (context, index) => _buildSlotCard(visibleSlots[index]),
      ),
    );
  }

  Widget _buildSlotCard(TimeSlot slot) {
    final isSelected = slot.id == _selectedSlotId;
    final isBooked = slot.isBooked;

    String formatTime(String time) {
      return time.length >= 5 ? time.substring(0, 5) : time;
    }

    Color bgColor;
    Color borderColor;
    Color timeColor;
    Color subColor;

    if (isBooked) {
      bgColor = Colors.grey.shade200;
      borderColor = Colors.grey.shade200;
      timeColor = Colors.grey;
      subColor = Colors.grey.shade400;
    } else if (isSelected) {
      bgColor = const Color(0xFF0861dd);
      borderColor = const Color(0xFF0861dd);
      timeColor = Colors.white;
      subColor = Colors.white70;
    } else {
      bgColor = Colors.white;
      borderColor = Colors.grey.shade300;
      timeColor = Colors.black87;
      subColor = Colors.grey.shade600;
    }

    return GestureDetector(
      onTap: isBooked
          ? null
          : () {
              setState(() {
                _selectedSlotId = isSelected ? null : slot.id;
                _selectedHour = null; // ✅ مهم جداً عشان يصفر الساعة القديمة
              });
              final day = _currentDay;
              if (!isSelected && day != null) {
                widget.onSlotSelected(day, slot); // ✅ non-nullable
              }
            },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: borderColor, width: 0.8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              formatTime(slot.startTime),
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: timeColor,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              formatTime(slot.endTime),
              style: TextStyle(fontSize: 11, color: subColor),
            ),
            const SizedBox(height: 5),
            widget.isNurse
                ? SizedBox(height: 10)
                : Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: isBooked
                          ? const Color(0xFFFCEBEB)
                          : isSelected
                          ? Colors.white24
                          : const Color(0xFFE1F5EE),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      isBooked
                          ? 'Booked'
                          : isSelected
                          ? '✓ Selected'
                          : 'Available',
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Agency',
                        color: isBooked
                            ? const Color(0xFFA32D2D)
                            : isSelected
                            ? Colors.white
                            : const Color(0xFF0F6E56),
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildHourChips() {
    final day = _currentDay;
    final selectedSlot = day?.slots.firstWhere((s) => s.id == _selectedSlotId);

    if (selectedSlot == null) return const SizedBox.shrink();

    // توليد قائمة الساعات (استخدم الميثود اللي عملناها قبل كده)
    final hours = _generateHoursList(
      selectedSlot.startTime,
      selectedSlot.endTime,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              "Select Exact Hour",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                fontFamily: 'Agency',
                color: Colors.black87,
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 45, // طول الـ Chip
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: hours.length,
              separatorBuilder: (_, __) => const SizedBox(width: 10),
              itemBuilder: (context, index) {
                final hour = hours[index];
                final isHourSelected = _selectedHour == hour;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedHour = hour;
                    });
                    // إبلاغ الـ Parent بالاختيار
                    widget.onSlotSelected(day!, selectedSlot);
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      // تغيير الـ Background بناءً على الاختيار
                      color: isHourSelected
                          ? const Color(0xFF0861dd)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(
                        color: isHourSelected
                            ? const Color(0xFF0861dd)
                            : Colors.grey.shade300,
                        width: 1,
                      ),
                      boxShadow: isHourSelected
                          ? [
                              BoxShadow(
                                color: const Color(0xFF0861dd).withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ]
                          : [],
                    ),
                    child: Text(
                      hour,
                      style: TextStyle(
                        fontFamily: 'Agency',
                        fontSize: 14,
                        fontWeight: isHourSelected
                            ? FontWeight.bold
                            : FontWeight.normal,
                        color: isHourSelected ? Colors.white : Colors.black87,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  List<String> _generateHoursList(String start, String end) {
    try {
      // بفرض إن الوقت جاي بصيغة "09:00" أو "14:30"
      int startHour = int.parse(start.split(':')[0]);
      int endHour = int.parse(end.split(':')[0]);

      List<String> hours = [];
      for (int i = startHour; i < endHour; i++) {
        // تنسيق الساعة لشكل مقروء (مثلاً 09:00)
        String formattedHour = "${i.toString().padLeft(2, '0')}:00";
        hours.add(formattedHour);
      }
      return hours;
    } catch (e) {
      return ["Select Time"]; // Fallback في حالة وجود خطأ في الداتا
    }
  }
}
