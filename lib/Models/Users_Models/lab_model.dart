class LabModel {
  final String id;
  final String name;
  final String address;
  final double rating;
  final int ratingsCount;
  final String profilePictureUrl;

  LabModel({
    required this.id,
    required this.name,
    required this.address,
    required this.rating,
    required this.ratingsCount,
    required this.profilePictureUrl,
  });

  factory LabModel.fromJson(Map<String, dynamic> json) {
    return LabModel(
      id: json['id'],
      name: json['name'],
      address: json['address'],
      rating: (json['rating'] as num).toDouble(),
      ratingsCount: json['ratingsCount'],
      profilePictureUrl: json['profilePictureUrl'],
    );
  }
}
