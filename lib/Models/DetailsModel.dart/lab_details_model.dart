import 'package:healthcareapp_try1/Models/Booking_Models/test_model.dart';
import 'package:healthcareapp_try1/Models/Users_Models/working_days.dart';

class LabDetailsModel {
  final String id;
  final String name;
  final String bio;
  final String city;
  final String address;
  final String phoneNumber;
  final double rating;
  final double homeVisitFee;
  final String profilePictureUrl;
  final List<Test> tests;
  final String? addressUrl;
  final String openingTime;
  final String closingTime;
  final WorkingDays workingDays;

  LabDetailsModel({
    this.addressUrl,
    required this.openingTime,
    required this.closingTime,
    required this.workingDays,
    required this.id,
    required this.name,
    required this.bio,
    required this.city,
    required this.address,
    required this.phoneNumber,
    required this.rating,
    required this.homeVisitFee,
    required this.profilePictureUrl,
    required this.tests,
  });

  factory LabDetailsModel.fromJson(Map<String, dynamic> json) {
    return LabDetailsModel(
      addressUrl: json['addressUrl'],
      openingTime: json['openingTime'],
      closingTime: json['closingTime'],
      workingDays: WorkingDays.fromJson(json['workingDays']),
      id: json['id'],
      name: json['name'],
      bio: json['bio'],
      city: json['city'],
      address: json['address'],
      phoneNumber: json['phoneNumber'],
      rating: (json['rating'] as num).toDouble(),
      homeVisitFee: (json['homeVisitFee'] as num).toDouble(),
      profilePictureUrl: json['profilePictureUrl'],
      tests: (json['tests'] as List).map((e) => Test.fromJson(e)).toList(),
    );
  }
}
