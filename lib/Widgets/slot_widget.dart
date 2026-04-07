// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:healthcareapp_try1/Models/Logic/day_schedule.dart';
import 'package:healthcareapp_try1/Models/Logic/time_slot.dart';

class SlotsSection extends StatefulWidget {
  final List<DaySchedule> slots;
  final bool isNurse;
  final bool isLab;
  final bool showChips;
  final void Function(String hour)? onHourSelected;
  final void Function(DaySchedule day, TimeSlot slot) onSlotSelected;

  const SlotsSection({
    super.key,
    required this.slots,
    required this.onSlotSelected,
    this.onHourSelected,
    this.isNurse = false,
    this.isLab = false,
    this.showChips = false,
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
        if (widget.showChips && _selectedSlotId != null) _buildHourChips(),
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

  Widget _buildSlotsGrid() {
    final day = _currentDay;
    if (day == null) return const SizedBox();

    // لو الممرض، نظهر فقط slots الغير محجوزة
    final visibleSlots = day.slots;

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

    // ✅ لو nurse نتعامل مع كل الـ slots كأنها غير محجوزة
    final isBooked = (widget.isNurse) ? false : slot.isBooked;

    String formatTime(String time) =>
        time.length >= 5 ? time.substring(0, 5) : time;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedSlotId = isSelected ? null : slot.id;
          _selectedHour = null;
        });
        final day = _currentDay;
        if (!isSelected && day != null) {
          widget.onSlotSelected(day, slot);
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isBooked
              ? Colors.grey.shade100
              : isSelected
              ? const Color(0xFF0861dd)
              : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isBooked
                ? Colors.grey.shade300
                : isSelected
                ? const Color(0xFF0861dd)
                : Colors.grey.shade300,
            width: isSelected ? 2 : 0.8,
          ),
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
                color: isBooked
                    ? Colors.grey.shade400
                    : isSelected
                    ? Colors.white
                    : Colors.black87,
                decoration: isBooked ? TextDecoration.lineThrough : null,
                decorationColor: Colors.grey.shade400,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              formatTime(slot.endTime),
              style: TextStyle(
                fontSize: 11,
                color: isBooked
                    ? Colors.grey.shade400
                    : isSelected
                    ? Colors.white70
                    : Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 5),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
              decoration: BoxDecoration(
                color: isBooked
                    ? Colors.red.shade100
                    : isSelected
                    ? Colors.white24
                    : const Color(0xFFE1F5EE),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    isBooked
                        ? Icons.block
                        : isSelected
                        ? Icons.check
                        : Icons.circle,
                    size: 7,
                    color: isBooked
                        ? Colors.red.shade400
                        : isSelected
                        ? Colors.white
                        : const Color(0xFF0F6E56),
                  ),
                  const SizedBox(width: 3),
                  Text(
                    isBooked
                        ? 'Booked'
                        : isSelected
                        ? 'Selected'
                        : 'Free',
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Agency',
                      color: isBooked
                          ? Colors.red.shade400
                          : isSelected
                          ? Colors.white
                          : const Color(0xFF0F6E56),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHourChips() {
    final day = _currentDay;
    if (day == null || _selectedSlotId == null) return const SizedBox.shrink();

    // محاولة الحصول على الـ selectedSlot بطريقة null-safe
    TimeSlot? selectedSlot;
    try {
      selectedSlot = day.slots.firstWhere((s) => s.id == _selectedSlotId);
    } catch (e) {
      selectedSlot = null;
    }

    if (selectedSlot == null) return const SizedBox.shrink();

    // توليد قائمة الساعات
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
            height: 45,
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
                    widget.onSlotSelected(day, selectedSlot!);
                    widget.onHourSelected?.call(hour);
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
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

  // Widget _buildHourChips() {
  //   final day = _currentDay;
  //   if (day == null || _selectedSlotId == null) return const SizedBox.shrink();

  //   TimeSlot? selectedSlot;
  //   try {
  //     selectedSlot = day.slots.firstWhere((s) => s.id == _selectedSlotId);
  //   } catch (e) {
  //     selectedSlot = null;
  //   }

  //   if (selectedSlot == null) return const SizedBox.shrink();

  //   final hours = _generateHoursList(
  //     selectedSlot.startTime,
  //     selectedSlot.endTime,
  //   );

  //   final isSlotBooked = selectedSlot.isBooked; // ✅ تحقق إذا الـ slot محجوز

  //   return Padding(
  //     padding: const EdgeInsets.symmetric(vertical: 20),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         const Padding(
  //           padding: EdgeInsets.symmetric(horizontal: 16),
  //           child: Text(
  //             "Select Exact Hour",
  //             style: TextStyle(
  //               fontSize: 15,
  //               fontWeight: FontWeight.bold,
  //               fontFamily: 'Agency',
  //               color: Colors.black87,
  //             ),
  //           ),
  //         ),
  //         const SizedBox(height: 12),
  //         SizedBox(
  //           height: 45,
  //           child: ListView.separated(
  //             scrollDirection: Axis.horizontal,
  //             padding: const EdgeInsets.symmetric(horizontal: 16),
  //             itemCount: hours.length,
  //             separatorBuilder: (_, __) => const SizedBox(width: 10),
  //             itemBuilder: (context, index) {
  //               final hour = hours[index];
  //               final isHourSelected = _selectedHour == hour;

  //               return GestureDetector(
  //                 onTap: isSlotBooked
  //                     ? null // منع الضغط لو الـ slot محجوز
  //                     : () {
  //                         setState(() {
  //                           _selectedHour = hour;
  //                         });
  //                         widget.onSlotSelected(day, selectedSlot!);
  //                         widget.onHourSelected?.call(hour);
  //                       },
  //                 child: AnimatedContainer(
  //                   duration: const Duration(milliseconds: 200),
  //                   padding: const EdgeInsets.symmetric(horizontal: 20),
  //                   alignment: Alignment.center,
  //                   decoration: BoxDecoration(
  //                     color: isSlotBooked
  //                         ? Colors.grey.shade200
  //                         : isHourSelected
  //                         ? const Color(0xFF0861dd)
  //                         : Colors.white,
  //                     borderRadius: BorderRadius.circular(25),
  //                     border: Border.all(
  //                       color: isSlotBooked
  //                           ? Colors.grey.shade300
  //                           : isHourSelected
  //                           ? const Color(0xFF0861dd)
  //                           : Colors.grey.shade300,
  //                       width: 1,
  //                     ),
  //                   ),
  //                   child: Text(
  //                     hour,
  //                     style: TextStyle(
  //                       fontFamily: 'Agency',
  //                       fontSize: 14,
  //                       fontWeight: isHourSelected
  //                           ? FontWeight.bold
  //                           : FontWeight.normal,
  //                       color: isSlotBooked
  //                           ? Colors.grey.shade500
  //                           : isHourSelected
  //                           ? Colors.white
  //                           : Colors.black87,
  //                       decoration: isSlotBooked
  //                           ? TextDecoration.lineThrough
  //                           : null, // ✅ strike-through للساعات المحجوزة
  //                       decorationColor: isSlotBooked
  //                           ? Colors.grey.shade500
  //                           : null,
  //                     ),
  //                   ),
  //                 ),
  //               );
  //             },
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

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
