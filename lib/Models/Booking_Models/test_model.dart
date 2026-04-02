class Test {
  final String id;
  final String name;
  final String description;
  final String preRequisites;
  final double price;
  final bool isAvailableAtHome;

  Test({
    required this.id,
    required this.name,
    required this.description,
    required this.preRequisites,
    required this.price,
    required this.isAvailableAtHome,
  });

  factory Test.fromJson(Map<String, dynamic> json) {
    return Test(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      preRequisites: json['preRequisites'],
      price: (json['price'] as num).toDouble(),
      isAvailableAtHome: json['isAvailableAtHome'],
    );
  }
}
