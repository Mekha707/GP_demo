// ignore_for_file: override_on_non_overriding_member

import 'package:healthcareapp_try1/Pages/Booking/healtcare_provider.dart';

class Nurse extends HealthcareProvider {
  @override
  final String id;
  @override
  final String name;
  final String city;
  final double visitFee;
  final double hourPrice;
  @override
  final double rating;
  @override
  final int ratingsCount;
  @override
  final String profilePictureUrl;

  @override
  String get subTitle => "Nursing Services";
  @override
  String get location => city;
  @override
  double get mainFee => visitFee;
  @override
  String get providerType => "Nurse";

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
