class PatientProfile {
  final String id;
  final String name;
  final String gender;
  final String email;
  final String phoneNumber;
  final String address;
  final String? addressUrl;
  final String city;
  final String dateOfBirth;
  final bool hasDiabetes;
  final bool hasBloodPressure;
  final bool hasAsthma;
  final bool hasHeartDisease;
  final bool hasKidneyDisease;
  final bool hasArthritis;
  final bool hasCancer;
  final bool hasHighCholesterol;
  final String? otherMedicalConditions;
  final double? weight;

  PatientProfile({
    required this.id,
    required this.name,
    required this.gender,
    required this.email,
    required this.phoneNumber,
    required this.address,
    this.addressUrl,
    required this.city,
    required this.dateOfBirth,
    required this.hasDiabetes,
    required this.hasBloodPressure,
    required this.hasAsthma,
    required this.hasHeartDisease,
    required this.hasKidneyDisease,
    required this.hasArthritis,
    required this.hasCancer,
    required this.hasHighCholesterol,
    this.otherMedicalConditions,
    this.weight,
  });

  factory PatientProfile.fromJson(Map<String, dynamic> json) => PatientProfile(
    id: json['id'],
    name: json['name'],
    gender: json['gender'].toString(), // enum جاي كـ string
    email: json['email'],
    phoneNumber: json['phoneNumber'],
    address: json['address'],
    addressUrl: json['addressUrl'],
    city: json['city'],
    dateOfBirth: json['dateOfBirth'],
    hasDiabetes: json['hasDiabetes'] ?? false,
    hasBloodPressure: json['hasBloodPressure'] ?? false,
    hasAsthma: json['hasAsthma'] ?? false,
    hasHeartDisease: json['hasHeartDisease'] ?? false,
    hasKidneyDisease: json['hasKidneyDisease'] ?? false,
    hasArthritis: json['hasArthritis'] ?? false,
    hasCancer: json['hasCancer'] ?? false,
    hasHighCholesterol: json['hasHighCholesterol'] ?? false,
    otherMedicalConditions: json['otherMedicalConditions'],
    weight: json['weight'] != null ? (json['weight'] as num).toDouble() : null,
  );
}
