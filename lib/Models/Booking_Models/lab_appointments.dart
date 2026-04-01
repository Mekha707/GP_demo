// import 'package:healthcareapp_try1/Models/Booking_Models/test_model.dart';
// import 'package:healthcareapp_try1/Models/Users_Models/lab_model.dart';

// enum AppointmentStatus { pending, confirmed, completed, cancelled }

// class LabAppointmentModel {
//   final String id;
//   final String patientId;
//   final String labId;
//   final String testId; // المعرف الخاص بالتحليل المختار
//   final DateTime appointmentDate;
//   final double totalFee;
//   final String? notes;
//   final String? address; // لخدمة الزيارة المنزلية
//   final AppointmentStatus status;
//   final DateTime createdAt;

//   // اختياري: يمكنك تضمين الموديلات الكاملة لعرض بياناتهم في شاشة الحجز
//   final LabModel? lab;
//   final TestModel? test;

//   LabAppointmentModel({
//     required this.id,
//     required this.patientId,
//     required this.labId,
//     required this.testId,
//     required this.appointmentDate,
//     required this.totalFee,
//     this.notes,
//     this.address,
//     this.status = AppointmentStatus.pending,
//     required this.createdAt,
//     this.lab,
//     this.test,
//   });

//   factory LabAppointmentModel.fromJson(Map<String, dynamic> json) {
//     return LabAppointmentModel(
//       id: json['Id'],
//       patientId: json['PatientId'],
//       labId: json['LabId'],
//       testId: json['TestId'],
//       // تحويل النص القادم من السيرفر إلى DateTime
//       appointmentDate: DateTime.parse(json['AppointmentDate']),
//       totalFee: (json['TotalFee'] as num?)?.toDouble() ?? 0.0,
//       notes: json['Notes'],
//       address: json['Address'],
//       status: _parseStatus(json['Status']),
//       createdAt: DateTime.parse(json['CreatedAt']),
//       // إذا أرسل السيرفر بيانات المعمل والتحليل مدمجة
//       lab: json['Lab'] != null ? LabModel.fromJson(json['Lab']) : null,
//       test: json['Test'] != null ? TestModel.fromJson(json['Test']) : null,
//     );
//   }

//   static AppointmentStatus _parseStatus(dynamic status) {
//     // منطق لتحويل القيمة (سواء كانت int أو String) إلى Enum
//     if (status == 1 || status == "confirmed") {
//       return AppointmentStatus.confirmed;
//     }
//     if (status == 2 || status == "completed") {
//       return AppointmentStatus.completed;
//     }
//     if (status == 3 || status == "cancelled") {
//       return AppointmentStatus.cancelled;
//     }
//     return AppointmentStatus.pending;
//   }
// }
