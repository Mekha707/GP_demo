import 'package:healthcareapp_try1/Models/Booking_Models/message_model.dart';

class ChatModel {
  final String id;
  final String doctorId;
  final String patientId;
  final DateTime createdAt;
  final MessageModel? lastMessage; // لعرض آخر رسالة في قائمة المحادثات

  ChatModel({
    required this.id,
    required this.doctorId,
    required this.patientId,
    required this.createdAt,
    this.lastMessage,
  });

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(
      id: json['Id'],
      doctorId: json['DoctorId'],
      patientId: json['PatientId'],
      createdAt: DateTime.parse(json['CreatedAt']),
      lastMessage: json['LastMessage'] != null
          ? MessageModel.fromJson(json['LastMessage'])
          : null,
    );
  }
}
