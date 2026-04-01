// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class ScheduleTimedateWidget extends StatefulWidget {
  const ScheduleTimedateWidget({
    super.key,
    required this.showSchedule,
    required this.availableDates,
    required this.timeSlots,
    required this.onDateSelected,
    required this.onTimeSelected,
  });

  final bool showSchedule;
  final List<DateTime> availableDates;
  final List<String> timeSlots;
  final Function(DateTime) onDateSelected;
  final Function(String) onTimeSelected;

  @override
  State<ScheduleTimedateWidget> createState() => _ScheduleTimedateWidgetState();
}

class _ScheduleTimedateWidgetState extends State<ScheduleTimedateWidget> {
  DateTime? _localSelectedDate;
  String? _localSelectedTime;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 400),
      transitionBuilder: (Widget child, Animation<double> animation) {
        return SizeTransition(
          sizeFactor: animation,
          axisAlignment: -1.0, // يبدأ التمدد من الأعلى للأسفل
          child: FadeTransition(opacity: animation, child: child),
        );
      },
      child: widget.showSchedule
          ? Container(
              key: const ValueKey("content"),
              padding: const EdgeInsets.all(16),
              decoration: _cardDecoration(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Select Appointment Date",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      fontFamily: 'Agency',
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Select your preferred day and time slot",
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                      fontFamily: 'Agency',
                    ),
                  ),
                  const SizedBox(height: 15),

                  // --- الجزء الأول: اختيار التاريخ ---
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                          childAspectRatio: 1.8,
                        ),
                    itemCount: widget.availableDates.length,
                    itemBuilder: (context, index) {
                      DateTime date = widget.availableDates[index];
                      bool isSelected =
                          _localSelectedDate?.year == date.year &&
                          _localSelectedDate?.month == date.month &&
                          _localSelectedDate?.day == date.day;
                      return _buildSelectableTile(
                        title: _getDayName(date.weekday),
                        subtitle: "${_getMonthName(date.month)} ${date.day}",
                        isSelected: isSelected,
                        onTap: () {
                          setState(() {
                            _localSelectedDate = date;
                            _localSelectedTime =
                                null; // تصفير الوقت عند تغيير التاريخ
                          });
                          widget.onDateSelected(date);
                        },
                      );
                    },
                  ),

                  // --- الجزء الثاني: اختيار الوقت (يظهر فقط عند اختيار تاريخ) ---
                  if (_localSelectedDate != null) ...[
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 15),
                      child: Divider(),
                    ),
                    const Text(
                      "Available Slots",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Agency',
                      ),
                    ),
                    const SizedBox(height: 15),

                    // منطق عرض الساعات أو رسالة "لا يوجد مواعيد"
                    widget.timeSlots.isEmpty
                        ? Container(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            width: double.infinity,
                            alignment: Alignment.center,
                            child: Column(
                              children: [
                                Icon(
                                  Icons.event_busy,
                                  color: Colors.grey[400],
                                  size: 40,
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  "No slots available for this date",
                                  style: TextStyle(
                                    color: Colors.redAccent,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  crossAxisSpacing: 8,
                                  mainAxisSpacing: 8,
                                  childAspectRatio: 2.8,
                                ),
                            itemCount: widget.timeSlots.length,
                            itemBuilder: (context, index) {
                              String time = widget.timeSlots[index];
                              bool isSelected = _localSelectedTime == time;
                              return _buildSelectableTile(
                                title: time,
                                isSelected: isSelected,
                                onTap: () {
                                  setState(() => _localSelectedTime = time);
                                  widget.onTimeSelected(time);
                                },
                              );
                            },
                          ),
                  ],
                ],
              ),
            )
          : const SizedBox.shrink(),
    );
  }

  // --- مكوّن المربع القابل للاختيار ---
  Widget _buildSelectableTile({
    required String title,
    String? subtitle,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xff0861dd) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? const Color(0xff0861dd) : Colors.grey[200]!,
            width: 1.5,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                color: isSelected ? Colors.white : const Color(0xff0861dd),
              ),
            ),
            if (subtitle != null)
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 11,
                  color: isSelected ? Colors.white70 : Colors.grey[600],
                ),
              ),
          ],
        ),
      ),
    );
  }

  String _getDayName(int weekday) {
    const days = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];
    return days[weekday - 1];
  }

  String _getMonthName(int month) {
    const months = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec",
    ];
    return months[month - 1];
  }

  BoxDecoration _cardDecoration() => BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(20),
    border: Border.all(color: Colors.grey[200]!),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.02),
        blurRadius: 10,
        offset: const Offset(0, 5),
      ),
    ],
  );
}
