import 'package:healthcareapp_try1/Pages/Booking/healtcare_provider.dart';

class LabModel extends HealthcareProvider {
  @override
  final String id;
  @override
  final String name;
  final String address;
  @override
  final double rating;
  @override
  final int ratingsCount;
  @override
  final String profilePictureUrl;
  final List<String>? matchedTestsNames;
  final int? matchedTestsCount;
  final int? totalRequestedTests;

  LabModel({
    required this.id,
    required this.name,
    required this.address,
    required this.rating,
    required this.ratingsCount,
    required this.profilePictureUrl,
    this.matchedTestsCount,
    this.totalRequestedTests,
    this.matchedTestsNames,
  });

  factory LabModel.fromJson(Map<String, dynamic> json) {
    return LabModel(
      id: json['id'],
      name: json['name'],
      address: json['address'],
      rating: (json['rating'] as num).toDouble(),
      ratingsCount: json['ratingsCount'],
      profilePictureUrl: json['profilePictureUrl'],
      matchedTestsNames: List<String>.from(json['matchedTestsNames'] ?? []),
      // استقبال القيم الجديدة من الـ JSON ✅
      matchedTestsCount: json['matchedTestsCount'] ?? 0,
      totalRequestedTests: json['totalRequestedTests'] ?? 0,
    );
  }

  @override
  String get location => address;

  @override
  double get mainFee => 0.0;

  @override
  String get providerType => "Lab";

  @override
  String get subTitle => "";
}
