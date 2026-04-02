// widgets/slots_section.dart
import 'package:flutter/material.dart';
import 'package:healthcareapp_try1/Models/Logic/day_schedule.dart';
import 'package:healthcareapp_try1/Models/Logic/time_slot.dart';

class SlotsSection extends StatefulWidget {
  final List<DaySchedule> slots;
  final void Function(DaySchedule day, TimeSlot slot) onSlotSelected;

  const SlotsSection({
    super.key,
    required this.slots,
    required this.onSlotSelected,
  });

  @override
  State<SlotsSection> createState() => _SlotsSectionState();
}

class _SlotsSectionState extends State<SlotsSection> {
  int _selectedDayIndex = 0;
  String? _selectedSlotId;

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

    if (day.slots.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text(
            'No available slots for this day',
            style: TextStyle(color: Colors.grey.shade800, fontFamily: 'Agency'),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          childAspectRatio: 1.1,
        ),
        itemCount: day.slots.length,
        itemBuilder: (context, index) => _buildSlotCard(day.slots[index]),
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
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
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
}
