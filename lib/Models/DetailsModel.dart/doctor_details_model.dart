import 'package:healthcareapp_try1/Models/Logic/day_schedule.dart';

class DoctorDetailsModel {
  final String id;
  final String name;
  final String specialtyId;
  final String specialtyName;
  final String title;
  final String bio;
  final String city;
  final String address;
  final String? addressUrl;
  final String gender;
  final double rating;
  final int ratingsCount;
  final double clinicFee;
  final double homeFee;
  final double onlineFee;
  final bool allowHomeVisit;
  final bool allowOnlineConsultation;
  final String profilePictureUrl;
  final List<DaySchedule> slots;

  DoctorDetailsModel({
    required this.id,
    required this.name,
    required this.specialtyId,
    required this.specialtyName,
    required this.title,
    required this.bio,
    required this.city,
    required this.address,
    this.addressUrl,
    required this.gender,
    required this.rating,
    required this.ratingsCount,
    required this.clinicFee,
    required this.homeFee,
    required this.onlineFee,
    required this.allowHomeVisit,
    required this.allowOnlineConsultation,
    required this.profilePictureUrl,
    required this.slots,
  });

  factory DoctorDetailsModel.fromJson(Map<String, dynamic> json) {
    return DoctorDetailsModel(
      id: json['id'],
      name: json['name'],
      specialtyId: json['specialtyId'],
      specialtyName: json['specialtyName'],
      title: json['title'],
      bio: json['bio'],
      city: json['city'],
      address: json['address'],
      addressUrl: json['addressUrl'],
      gender: json['gender'],
      rating: (json['rating'] as num).toDouble(),
      ratingsCount: json['ratingsCount'],
      clinicFee: (json['clinicFee'] as num).toDouble(),
      homeFee: (json['homeFee'] as num).toDouble(),
      onlineFee: (json['onlineFee'] as num).toDouble(),
      allowHomeVisit: json['allowHomeVisit'],
      allowOnlineConsultation: json['allowOnlineConsultation'],
      profilePictureUrl: json['profilePictureUrl'],
      slots: (json['slots'] as List)
          .map((e) => DaySchedule.fromJson(e))
          .toList(),
    );
  }
}
