import 'package:healthcareapp_try1/Models/Logic/day_schedule.dart';

class NurseDetailsModel {
  final String id;
  final String name;
  final String bio;
  final String city;
  final String phoneNumber;
  final String gender; // الـ Gender في الـ C# غالباً Enum بيرجع String أو Int
  final double rating;
  final int ratingsCount;
  final double hourPrice;
  final double homeVisitFee;
  final String profilePictureUrl;
  final List<DaySchedule> slots; // سنقوم بربطها بـ Shifts من الـ JSON

  NurseDetailsModel({
    required this.id,
    required this.name,
    required this.bio,
    required this.city,
    required this.phoneNumber,
    required this.gender,
    required this.rating,
    required this.ratingsCount,
    required this.hourPrice,
    required this.homeVisitFee,
    required this.profilePictureUrl,
    required this.slots,
  });

  factory NurseDetailsModel.fromJson(Map<String, dynamic> json) {
    return NurseDetailsModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      bio: json['bio'] ?? '',
      city: json['city'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      gender: json['gender']?.toString() ?? '',
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      ratingsCount: json['ratingsCount'] ?? 0,
      hourPrice: (json['hourPrice'] as num?)?.toDouble() ?? 0.0,
      homeVisitFee: (json['homeVisitFee'] as num?)?.toDouble() ?? 0.0,
      profilePictureUrl: json['profilePictureUrl'] ?? '',

      // مهم جداً: الـ API يرسل 'shifts' وليس 'slots'
      slots:
          (json['shifts'] as List?)
              ?.map((e) => DaySchedule.fromJson(e))
              .toList() ??
          [],
    );
  }
}
