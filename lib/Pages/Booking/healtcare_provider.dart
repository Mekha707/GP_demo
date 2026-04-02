abstract class HealthcareProvider {
  String get id;
  String get name;
  String get subTitle; // لتمثيل الـ Specialty للطبيب أو الـ City للممرض
  String get location; // لتمثيل الـ Address أو الـ City
  double get mainFee; // السعر الأساسي (Fee للطبيب و VisitFee للممرض)
  double get rating;
  int get ratingsCount;
  String get profilePictureUrl;
  String get providerType; // "Doctor" أو "Nurse"
}
