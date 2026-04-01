class TimeSlot {
  final String id;
  final String startTime;
  final String endTime;
  final bool isBooked;

  TimeSlot({
    required this.id,
    required this.startTime,
    required this.endTime,
    required this.isBooked,
  });

  factory TimeSlot.fromJson(Map<String, dynamic> json) {
    return TimeSlot(
      id: json['id'],
      startTime: json['startTime'],
      endTime: json['endTime'],
      isBooked: json['isBooked'],
    );
  }
}
