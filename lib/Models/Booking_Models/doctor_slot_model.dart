class DoctorSlotModel {
  final String id;
  final String doctorId;
  final DateTime startDate; // التاريخ والوقت (مثلاً 2026-02-10 14:00)
  final int durationInMinutes; // مدة الكشف (مثلاً 30 دقيقة)
  final bool isBooked; // هل هذا الموعد تم حجزه أم لا يزال متاحاً؟

  DoctorSlotModel({
    required this.id,
    required this.doctorId,
    required this.startDate,
    required this.durationInMinutes,
    required this.isBooked,
  });

  factory DoctorSlotModel.fromJson(Map<String, dynamic> json) {
    return DoctorSlotModel(
      id: json['Id'],
      doctorId: json['DoctorId'],
      startDate: DateTime.parse(json['StartDate']),
      durationInMinutes: json['DurationInMinutes'] ?? 30,
      isBooked: json['IsBooked'] ?? false,
    );
  }
}
