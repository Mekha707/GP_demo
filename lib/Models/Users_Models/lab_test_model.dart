import 'package:healthcareapp_try1/Models/Booking_Models/test_model.dart';

class LabTestModel {
  final String id;
  final String name;
  final double price;
  final String resultDuration; // مثلاً "24 Hours" أو "2 Days"
  final bool isAvailableAtHome;
  final String? description; // اختياري: وصف بسيط للتحليل

  // هنا في حاجة المفروض تتعمل
  final TestModel? test; // تفاصيل التحليل نفسه

  LabTestModel({
    required this.isAvailableAtHome,
    required this.test,
    required this.id,
    required this.name,
    required this.price,
    required this.resultDuration,
    this.description,
  });

  factory LabTestModel.fromJson(Map<String, dynamic> json) {
    final testData = TestModel.fromJson(json['Test'] ?? {});

    return LabTestModel(
      id: json['Id'],
      price: (json['Price'] as num?)?.toDouble() ?? 0.0,
      isAvailableAtHome: json['IsAvailableAtHome'] ?? false,
      test: TestModel.fromJson(json['Test'] ?? {}),
      name: json['Name'] ?? testData.name ?? 'Unknown Test',
      resultDuration:
          json['ResultDuration'] ??
          '24 Hours', // نفترض أن الـ API سيرسل بيانات التحليل مدمجة
    );
  }
}
