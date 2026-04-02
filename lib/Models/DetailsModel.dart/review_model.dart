class ReviewModel {
  final String id;
  final String patientName;
  final int rating;
  final String comment;
  final DateTime date;
  final bool isUpdated;

  ReviewModel({
    required this.id,
    required this.patientName,
    required this.rating,
    required this.comment,
    required this.date,
    required this.isUpdated,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      id: json['id']?.toString() ?? '', // تحويل لـ String للأمان
      patientName: json['patientName'] ?? 'مريض',
      rating: (json['rating'] ?? 0).toInt(), // التأكد أنه Int
      comment: json['comment'] ?? '',
      date: json['date'] != null
          ? DateTime.parse(json['date'])
          : DateTime.now(), // قيمة افتراضية لو التاريخ null
      isUpdated: json['isUpdated'] ?? false,
    );
  }
}
