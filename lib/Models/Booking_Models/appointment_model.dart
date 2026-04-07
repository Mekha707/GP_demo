class AppointmentModel {
  final String id;
  final String providerName;
  final String providerImage;
  final String type;
  final String date;
  final String time;
  final String status;
  final double price;
  final String serviceType;
  final String scheduledAt;
  final String? specialty;

  AppointmentModel({
    required this.id,
    required this.providerName,
    required this.providerImage,
    required this.type,
    required this.date,
    required this.time,
    required this.status,
    required this.price,
    required this.serviceType,
    required this.scheduledAt,
    this.specialty,
  });

  factory AppointmentModel.fromJson(Map<String, dynamic> json) {
    return AppointmentModel(
      id: json['id'],
      providerName: json['providerName'],
      providerImage: json['providerImage'],
      type: json['type'],
      date: json['date'],
      time: json['time'],
      status: json['status'] ?? 'Pending',
      price: (json['price'] as num).toDouble(),
      serviceType: json['serviceType'],
      scheduledAt: json['scheduledAt'],
      specialty: json['specialty'],
    );
  }
}

class AllAppointmentsResponse {
  final List<AppointmentModel> doctorAppointments;
  final List<AppointmentModel> nurseAppointments;
  final List<AppointmentModel> labAppointments;

  AllAppointmentsResponse({
    required this.doctorAppointments,
    required this.nurseAppointments,
    required this.labAppointments,
  });

  factory AllAppointmentsResponse.fromJson(Map<String, dynamic> json) {
    return AllAppointmentsResponse(
      doctorAppointments: (json['doctorAppointments'] as List)
          .map((i) => AppointmentModel.fromJson(i))
          .toList(),
      nurseAppointments: (json['nurseAppointments'] as List)
          .map((i) => AppointmentModel.fromJson(i))
          .toList(),
      labAppointments: (json['labAppointments'] as List)
          .map((i) => AppointmentModel.fromJson(i))
          .toList(),
    );
  }
}
