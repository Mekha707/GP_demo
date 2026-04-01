class UpdateProfileModel {
  final String userId;
  final String name;
  final String phoneNumber;
  final String address;
  final String? addressUrl;
  final String city;
  final double? weight;

  UpdateProfileModel({
    required this.userId,
    required this.name,
    required this.phoneNumber,
    required this.address,
    this.addressUrl,
    required this.city,
    this.weight,
  });

  Map<String, dynamic> toJson() {
    return {
      "userId": userId,
      "name": name,
      "phoneNumber": phoneNumber,
      "address": address,
      "addressUrl": addressUrl,
      "city": city,
      "weight": weight,
    };
  }
}
