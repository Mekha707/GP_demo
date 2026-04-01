class TestModel {
  final String id;
  final String name;
  final String? description;
  final String? unit; // الوحدة القياسية للنتيجة (مثلاً mg/dL)
  final String? prerequisites; // الشروط (مثلاً "صيام 12 ساعة")

  TestModel({
    required this.id,
    required this.name,
    this.description,
    this.unit,
    this.prerequisites,
  });

  factory TestModel.fromJson(Map<String, dynamic> json) {
    return TestModel(
      id: json['Id'],
      name: json['Name'] ?? '',
      description: json['Description'],
      unit: json['Unit'],
      prerequisites: json['Prerequisites'],
    );
  }
}
