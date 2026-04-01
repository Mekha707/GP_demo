class RegisterModel {
  final String name;
  final DateTime dateOfBirth;
  final String city;
  final String address;
  final String? addressURL;
  final String gender;
  final String email;
  final String password;
  final String confirmPassword;
  final String phoneNumber;
  final double? weight;

  // الحالات الطبية
  final bool hasDiabetes;
  final bool hasBloodPressure;
  final bool hasAsthma;
  final bool hasHeartDisease;
  final bool hasKidneyDisease;
  final bool hasArthritis;
  final bool hasCancer;
  final bool hasLiverDisease;
  final bool hasHighCholesterol;
  final String? otherMedicalConditions;

  RegisterModel({
    this.addressURL,
    required this.name,
    required this.email,
    required this.password,
    required this.confirmPassword,
    required this.phoneNumber,
    required this.gender,
    required this.city,
    required this.address,
    required this.dateOfBirth,
    this.weight,
    required this.hasDiabetes,
    required this.hasBloodPressure,
    required this.hasAsthma,
    required this.hasHeartDisease,
    required this.hasKidneyDisease,
    required this.hasArthritis,
    required this.hasCancer,
    required this.hasLiverDisease,
    required this.hasHighCholesterol,
    this.otherMedicalConditions,
  });

  // تحويل الكائن لـ JSON
  Map<String, dynamic> toJson() {
    final data = {
      "name": name,
      "email": email,
      "password": password,
      "confirmPassword": confirmPassword,
      "phoneNumber": phoneNumber,
      "gender": gender,
      "city": city,
      "address": address,
      "dateOfBirth": dateOfBirth.toIso8601String().split('T')[0],
      if (weight != null) "weight": weight,
      "diseases": {
        "hasDiabetes": hasDiabetes,
        "hasBloodPressure": hasBloodPressure,
        "hasAsthma": hasAsthma,
        "hasHeartDisease": hasHeartDisease,
        "hasKidneyDisease": hasKidneyDisease,
        "hasArthritis": hasArthritis,
        "hasCancer": hasCancer,
        "hasLiverDisease": hasLiverDisease,
        "hasHighCholesterol": hasHighCholesterol,
        if (otherMedicalConditions != null)
          "otherMedicalConditions": otherMedicalConditions,
      },
      "callbackUrl": "https://healthcare.com",
      if (addressURL != null) "addressURL": addressURL,
    };
    return data;
  }

  // تحويل JSON لكائن
  factory RegisterModel.fromJson(Map<String, dynamic> json) {
    final diseases = json["diseases"] ?? {};
    return RegisterModel(
      name: json["name"],
      email: json["email"],
      password: json["password"],
      confirmPassword: json["confirmPassword"],
      phoneNumber: json["phoneNumber"],
      gender: json["gender"],
      city: json["city"],
      address: json["address"],
      dateOfBirth: DateTime.parse(json["dateOfBirth"]),
      weight: json["weight"] != null
          ? (json["weight"] as num).toDouble()
          : null,
      hasDiabetes: diseases["hasDiabetes"] ?? false,
      hasBloodPressure: diseases["hasBloodPressure"] ?? false,
      hasAsthma: diseases["hasAsthma"] ?? false,
      hasHeartDisease: diseases["hasHeartDisease"] ?? false,
      hasKidneyDisease: diseases["hasKidneyDisease"] ?? false,
      hasArthritis: diseases["hasArthritis"] ?? false,
      hasCancer: diseases["hasCancer"] ?? false,
      hasLiverDisease: diseases["hasLiverDisease"] ?? false,
      hasHighCholesterol: diseases["hasHighCholesterol"] ?? false,
      otherMedicalConditions: diseases["otherMedicalConditions"],
      addressURL: json["addressURL"],
    );
  }
}
