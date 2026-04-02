import 'package:healthcareapp_try1/Pages/Booking/healtcare_provider.dart';

class Doctor extends HealthcareProvider {
  @override
  final String id;
  @override
  final String name;
  final String specialty;
  final String title;
  final String address;
  final double fee;
  @override
  final double rating;
  @override
  final int ratingsCount;
  final bool allowHome;
  final bool allowOnline;
  @override
  final String profilePictureUrl;

  // تطبيق الـ Interface (Mapping)
  @override
  String get subTitle => "$specialty - $title";
  @override
  String get location => address;
  @override
  double get mainFee => fee;
  @override
  String get providerType => "Doctor";

  Doctor({
    required this.id,
    required this.name,
    required this.specialty,
    required this.title,
    required this.address,
    required this.fee,
    required this.rating,
    required this.ratingsCount,
    required this.allowHome,
    required this.allowOnline,
    required this.profilePictureUrl,
  });

  factory Doctor.fromJson(Map<String, dynamic> json) {
    return Doctor(
      id: json['id'] as String,
      name: json['name'] as String,
      specialty: json['specialty'] as String,
      title: json['title'] as String,
      address: json['address'] as String,
      fee: (json['fee'] as num).toDouble(),
      rating: (json['rating'] as num).toDouble(),
      ratingsCount: json['ratingsCount'] as int,
      allowHome: json['allowHome'] as bool,
      allowOnline: json['allowOnline'] as bool,
      profilePictureUrl: json['profilePictureUrl'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'specialty': specialty,
    'title': title,
    'address': address,
    'fee': fee,
    'rating': rating,
    'ratingsCount': ratingsCount,
    'allowHome': allowHome,
    'allowOnline': allowOnline,
    'profilePictureUrl': profilePictureUrl,
  };
}
