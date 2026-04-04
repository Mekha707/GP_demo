import 'package:healthcareapp_try1/Models/Booking_Models/test_model.dart';
import 'package:healthcareapp_try1/Models/Users_Models/working_days.dart';
import 'package:healthcareapp_try1/Pages/Booking/healtcare_provider.dart';

class LabDetailsModel extends HealthcareProvider {
  @override
  final String id;
  @override
  final String name;
  final String bio;
  final String city;
  final String address;
  final String phoneNumber;
  @override
  final double rating;
  final double homeVisitFee;
  @override
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
    // 1. الدخول لمستوى الـ value لأن البيانات الحقيقية جواه
    final data = json['value'] ?? json;

    return LabDetailsModel(
      // استخدمنا data['...'] بدل json['...']
      addressUrl: data['addressUrl'],
      openingTime: data['openingTime'] ?? '',
      closingTime: data['closingTime'] ?? '',

      // تأمين الـ workingDays لو السيرفر بعتها null
      workingDays: data['workingDays'] != null
          ? WorkingDays.fromJson(data['workingDays'])
          : WorkingDays(
              isSaturdayOpen: false,
              isSundayOpen: false,
              isMondayOpen: false,
              isTuesdayOpen: false,
              isWednesdayOpen: false,
              isThursdayOpen: false,
              isFridayOpen: false,
            ),

      id: data['id'] ?? '',
      name: data['name'] ?? '',
      bio: data['bio'] ?? '',
      city: data['city'] ?? '',
      address: data['address'] ?? '',
      phoneNumber: data['phoneNumber'] ?? '',

      // تأمين الـ Double casting عشان الأرقام متضربش (as num? ثم toDouble)
      rating: (data['rating'] as num? ?? 0.0).toDouble(),
      homeVisitFee: (data['homeVisitFee'] as num? ?? 0.0).toDouble(),

      profilePictureUrl: data['profilePictureUrl'] ?? '',

      // تأمين الـ List عشان لو مفيش تحاليل ميرميش Exception
      tests:
          (data['tests'] as List?)?.map((e) => Test.fromJson(e)).toList() ?? [],
    );
  }

  @override
  String get location => addressUrl ?? address;

  @override
  double get mainFee => homeVisitFee;

  @override
  String get providerType => "Lab";

  @override
  // ignore: recursive_getters
  int get ratingsCount => ratingsCount;

  @override
  String get subTitle => bio;
}
