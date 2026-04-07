import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:healthcareapp_try1/API/auth_service.dart';
import 'package:healthcareapp_try1/Models/Auth_Models/register_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'register_event.dart';
import 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final AuthService authService;

  RegisterBloc(this.authService) : super(RegisterState()) {
    // 1. تغيير البيانات الشخصية
    on<PersonalInfoChanged>((event, emit) {
      emit(
        state.copyWith(
          name: event.name ?? state.name,
          email: event.email ?? state.email,
          phoneNumber: event.phoneNumber ?? state.phoneNumber,
          address: event.address ?? state.address,
          city: event.city ?? state.city,
        ),
      );
    });

    // 2. تغيير النوع Male/Female
    on<GenderChanged>((event, emit) {
      emit(state.copyWith(gender: event.gender));
    });

    // 3. تغيير تاريخ الميلاد
    on<BirthdayChanged>((event, emit) {
      emit(state.copyWith(dateOfBirth: event.dateOfBirth));
    });

    // 4. تغيير الوزن
    on<WeightChanged>((event, emit) {
      emit(state.copyWith(weight: event.weight));
    });

    on<DiabetesChanged>((event, emit) {
      emit(state.copyWith(diabetes: event.value));
    });

    on<BloodPressureChanged>((event, emit) {
      emit(state.copyWith(bloodPressure: event.value));
    });

    // أضف ده جوه الـ constructor بعد أي on<> تاني
    on<LocationChanged>((event, emit) {
      emit(state.copyWith(addressurl: event.addressUrl));
    });

    on<LocationCleared>((event, emit) {
      emit(state.copyWithNullUrl()); // هنعملها في الـ state
    });

    // 5. تغيير الباسورد وحساب القوة
    on<PasswordChanged>((event, emit) {
      final password = event.password;

      final requirements = {
        'min': password.length >= 8,
        'upper': password.contains(RegExp(r'[A-Z]')),
        'num': password.contains(RegExp(r'[0-9]')),
        'special': password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>!]')),
      };

      int completed = requirements.values.where((v) => v).length;
      double strengthValue = completed / 4;
      Color color;
      String text;

      if (completed <= 1) {
        color = Colors.red;
        text = "Weak";
      } else if (completed <= 3) {
        color = Colors.orange;
        text = "Medium";
      } else {
        color = Colors.green;
        text = "Strong";
      }

      emit(
        state.copyWith(
          password: password,
          passwordRequirements: requirements,
          passwordStrength: strengthValue,
          strengthColor: color,
          strengthText: text,
        ),
      );
    });

    // 6. فتح/إغلاق العين في حقل الباسورد
    on<TogglePasswordVisibility>((event, emit) {
      emit(state.copyWith(isPasswordVisible: !state.isPasswordVisible));
    });

    // 7. تبديل الأمراض المزمنة
    on<ChronicDiseaseToggled>((event, emit) {
      final updated = List<String>.from(state.selectedDiseases);
      if (updated.contains(event.disease)) {
        updated.remove(event.disease);
      } else {
        updated.add(event.disease);
      }
      emit(state.copyWith(selectedDiseases: updated));
    });

    // 8. إرسال البيانات للسيرفر
    on<RegisterSubmitted>((event, emit) async {
      emit(state.copyWith(status: RegisterStatus.loading));

      final userModel = RegisterModel(
        name: state.name,
        email: state.email,
        password: state.password,
        confirmPassword: state.password,
        phoneNumber: state.phoneNumber,
        gender: state.gender,
        city: state.city,
        address: state.address,
        addressURL: state.addressurl,
        dateOfBirth: state.dateOfBirth,
        weight: state.weight,
        hasDiabetes: state.diabetes == 'Yes',
        hasBloodPressure: state.bloodPressure == 'Yes',
        hasAsthma: state.selectedDiseases.contains('Asthma'),
        hasHeartDisease: state.selectedDiseases.contains('Heart'),
        hasKidneyDisease: state.selectedDiseases.contains('Kidney'),
        hasArthritis: state.selectedDiseases.contains('Arthritis'),
        hasCancer: state.selectedDiseases.contains('Cancer'),
        hasLiverDisease: state.selectedDiseases.contains('Liver'),
        hasHighCholesterol: state.selectedDiseases.contains('HighCholesterol'),
        otherMedicalConditions: event.otherMedicalConditions,
      );
      try {
        // هنا الـ register بترجع String (userId) علطول
        final String receivedId = await authService.register(userModel);

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('user_id', receivedId);
        await prefs.setString('address', state.address); // ✅ أضف السطر ده
        await prefs.setString('city', state.city);

        // لو السطر اللي فوق نجح وما رماش Exception، يبقى العملية تمت بنجاح
        emit(
          state.copyWith(
            status: RegisterStatus.success,
            userId: receivedId, // تخزين الـ ID الراجع
            successMessage: "Welcome!",
          ),
        );
      } catch (e) {
        // الـ catch هنا هتمسك الرسالة اللي عملنا لها throw في الـ Service
        emit(
          state.copyWith(
            status: RegisterStatus.error,
            errorMessage: e.toString(),
          ),
        );
      }
    });
  }
}
