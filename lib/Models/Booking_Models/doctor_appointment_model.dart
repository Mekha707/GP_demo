class DoctorAppointmentModel {
  final String id;
  final String doctorId;
  final String patientId;
  final String slotId;
  final double fee;
  final int paymentType; // مثلاً 1 للكاش، 2 للفيزا
  final bool isDeleted;
  final DateTime appointmentDate; // يتم جلبه من الـ Slot المختارة

  DoctorAppointmentModel({
    required this.id,
    required this.doctorId,
    required this.patientId,
    required this.slotId,
    required this.fee,
    required this.paymentType,
    this.isDeleted = false,
    required this.appointmentDate,
  });

  factory DoctorAppointmentModel.fromJson(Map<String, dynamic> json) {
    return DoctorAppointmentModel(
      id: json['Id'],
      doctorId: json['DoctorId'],
      patientId: json['PatientId'],
      slotId: json['DoctorSlotId'],
      fee: (json['Fee'] as num?)?.toDouble() ?? 0.0,
      paymentType: json['PaymentType'] ?? 1,
      appointmentDate: DateTime.parse(json['AppointmentDate']),
    );
  }
}
