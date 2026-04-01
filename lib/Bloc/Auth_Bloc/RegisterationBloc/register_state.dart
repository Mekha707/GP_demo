import 'package:flutter/material.dart';

enum RegisterStatus { initial, loading, success, error }

class RegisterState {
  final Map<String, bool> passwordRequirements;
  // بيانات المستخدم
  final String? userId;
  final String name;
  final String email;
  final String phoneNumber;
  final String password;
  final String gender;
  final DateTime dateOfBirth;

  // حالة الواجهة (UI State)
  final bool isPasswordVisible;
  final double passwordStrength; // من 0.0 إلى 1.0
  final String strengthText;
  final Color strengthColor;

  // حالة العملية
  final RegisterStatus status;
  final String? errorMessage;
  final String? successMessage;

  final String city;
  final String address;
  final String? addressurl;

  final List<String> selectedDiseases;
  final String? otherMedicalConditions;
  final double? weight;
  final String? diabetes; // 'Yes' / 'No'
  final String? bloodPressure; // 'Yes' / 'No'

  RegisterState({
    this.userId,
    this.name = '',
    this.email = '',
    this.phoneNumber = '',
    this.password = '',
    this.gender = "Male",
    DateTime? dateOfBirth,
    this.isPasswordVisible = false,
    this.passwordStrength = 0.0,
    this.strengthText = '',
    this.strengthColor = Colors.red,
    this.status = RegisterStatus.initial,
    this.errorMessage,
    this.successMessage,
    this.city = '',
    this.address = '',
    this.otherMedicalConditions,
    this.selectedDiseases = const [],
    this.weight,
    this.bloodPressure = 'No',
    this.diabetes = 'No',
    this.addressurl,
    // في الـ Constructor الخاص بـ RegisterState
    this.passwordRequirements = const {
      'min': false,
      'upper': false,
      'num': false,
      'special': false,
    },
  }) : dateOfBirth = dateOfBirth ?? DateTime(2000, 1, 1);

  // دالة copyWith لتحديث أجزاء من الحالة دون فقدان الباقي
  RegisterState copyWith({
    String? userId,
    String? name,
    String? email,
    String? phoneNumber,
    String? password,
    String? gender,
    DateTime? dateOfBirth,
    bool? isPasswordVisible,
    double? passwordStrength,
    String? strengthText,
    Color? strengthColor,
    RegisterStatus? status,
    String? errorMessage,
    String? successMessage,
    String? city,
    String? address,
    String? addressurl,
    double? weight,
    String? otherMedicalConditions,
    List<String>? selectedDiseases,
    Map<String, bool>? passwordRequirements,
    String? diabetes,
    String? bloodPressure,
  }) {
    return RegisterState(
      userId: userId ?? this.userId,
      name: name ?? this.name,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      password: password ?? this.password,
      gender: gender ?? this.gender,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
      passwordStrength: passwordStrength ?? this.passwordStrength,
      strengthText: strengthText ?? this.strengthText,
      strengthColor: strengthColor ?? this.strengthColor,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage, // ✅ fix
      successMessage: successMessage ?? this.successMessage, // ✅ fix
      city: city ?? this.city, // تأكد من إضافة هذا السطر
      address: address ?? this.address, // تأكد من إضافة هذا السطر
      otherMedicalConditions:
          otherMedicalConditions ?? this.otherMedicalConditions,
      weight: weight ?? this.weight,
      selectedDiseases: selectedDiseases ?? this.selectedDiseases,
      diabetes: diabetes ?? this.diabetes,
      bloodPressure: bloodPressure ?? this.bloodPressure,
      addressurl: addressurl ?? this.addressurl,
      passwordRequirements:
          passwordRequirements ??
          this.passwordRequirements, // تمرير القيمة الجديدة هنا
    );
  }

  // أضف الـ method دي جوه الـ class
  RegisterState copyWithNullUrl() {
    return RegisterState(
      userId: userId,
      name: name,
      email: email,
      phoneNumber: phoneNumber,
      password: password,
      gender: gender,
      dateOfBirth: dateOfBirth,
      isPasswordVisible: isPasswordVisible,
      passwordStrength: passwordStrength,
      strengthText: strengthText,
      strengthColor: strengthColor,
      status: status,
      errorMessage: errorMessage,
      successMessage: successMessage,
      city: city,
      address: address,
      addressurl: null, // ✅ null صريح
      otherMedicalConditions: otherMedicalConditions,
      weight: weight,
      selectedDiseases: selectedDiseases,
      diabetes: diabetes,
      bloodPressure: bloodPressure,
      passwordRequirements: passwordRequirements,
    );
  }
}
