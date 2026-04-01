abstract class RegisterEvent {}

// تغيير الاسم، البريد، الهاتف، العنوان، المدينة
class PersonalInfoChanged extends RegisterEvent {
  final String? name;
  final String? email;
  final String? phoneNumber;
  final String? address;
  final String? city;

  PersonalInfoChanged({
    this.name,
    this.email,
    this.phoneNumber,
    this.address,
    this.city,
  });
}

// تغيير النوع Male/Female
class GenderChanged extends RegisterEvent {
  final String gender;
  GenderChanged(this.gender);
}

// تغيير تاريخ الميلاد
class BirthdayChanged extends RegisterEvent {
  final DateTime dateOfBirth;
  BirthdayChanged(this.dateOfBirth);
}

// تغيير الباسورد
class PasswordChanged extends RegisterEvent {
  final String password;
  PasswordChanged(this.password);
}

class WeightChanged extends RegisterEvent {
  final double weight;
  WeightChanged(this.weight);
}

class ChronicDiseaseToggled extends RegisterEvent {
  final String disease;
  ChronicDiseaseToggled(this.disease);
}

// فتح/إغلاق العين في حقل الباسورد
class TogglePasswordVisibility extends RegisterEvent {}

// إرسال البيانات للسيرفر
// إرسال البيانات مع إمكانية تمرير مرض آخر (Others)
class RegisterSubmitted extends RegisterEvent {
  final String? otherMedicalConditions;

  RegisterSubmitted({this.otherMedicalConditions});
}

class RegisterSubmitEvent extends RegisterEvent {}

// register_event.dart

// تغيير حالة السكري نعم/لا
class DiabetesChanged extends RegisterEvent {
  final String value; // "Yes" أو "No"
  DiabetesChanged(this.value);
}

// تغيير حالة ضغط الدم نعم/لا
class BloodPressureChanged extends RegisterEvent {
  final String value; // "Yes" أو "No"
  BloodPressureChanged(this.value);
}

class LocationChanged extends RegisterEvent {
  final String addressUrl;
  LocationChanged(this.addressUrl);
}

class LocationCleared extends RegisterEvent {}
