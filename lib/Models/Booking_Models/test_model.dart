class Test {
  final String id;
  final String name;
  final String description;
  final String preRequisites;
  final double? price; // ممكن يكون null لو السيرفر ما بعتش السعر
  final bool? isAvailableAtHome; // ممكن يكون null لو السيرفر ما بعت

  Test({
    this.price,
    this.isAvailableAtHome,
    required this.id,
    required this.name,
    required this.description,
    required this.preRequisites,
  });

  factory Test.fromJson(Map<String, dynamic> json) {
    return Test(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      preRequisites: json['preRequisites'],
      price:
          (json['price'] as num?)?.toDouble() ??
          0.0, // تحويل السعر إلى double، وإذا كان null نستخدم 0.0
      isAvailableAtHome:
          json['isAvailableAtHome'] ?? false, // إذا كان null نستخدم false
    );
  }
}
