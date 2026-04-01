class Nurse {
  final String id;
  final String name;
  final String city;
  final double visitFee;
  final double hourPrice;
  final double rating;
  final int ratingsCount;
  final String profilePictureUrl;

  Nurse({
    required this.id,
    required this.name,
    required this.city,
    required this.visitFee,
    required this.hourPrice,
    required this.rating,
    required this.ratingsCount,
    required this.profilePictureUrl,
  });

  factory Nurse.fromJson(Map<String, dynamic> json) {
    return Nurse(
      id: json['id'] as String,
      name: json['name'] as String,
      city: json['city'] as String,
      visitFee: (json['visitFee'] as num).toDouble(),
      hourPrice: (json['hourPrice'] as num).toDouble(),
      rating: (json['rating'] as num).toDouble(),
      ratingsCount: json['ratingsCount'] as int,
      profilePictureUrl: json['profilePictureUrl'] as String,
    );
  }
}
