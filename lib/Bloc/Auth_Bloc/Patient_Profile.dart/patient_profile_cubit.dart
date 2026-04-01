// profile_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healthcareapp_try1/API/auth_service.dart';
import 'package:healthcareapp_try1/Bloc/Auth_Bloc/Patient_Profile.dart/patient_profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final AuthService authService;

  ProfileCubit(this.authService) : super(ProfileInitial());

  Future<void> getProfile() async {
    emit(ProfileLoading());
    try {
      final profile = await authService.getPatientProfile();
      emit(ProfileSuccess(profile));
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }

  Future<void> updateProfile({
    required String userId,
    required String name,
    required String phoneNumber,
    required String address,
    String? addressUrl,
    required String city,
    double? weight,
  }) async {
    emit(ProfileUpdating());

    try {
      await authService.updatePatientProfile(
        userId: userId,
        name: name,
        phoneNumber: phoneNumber,
        address: address,
        addressUrl: addressUrl,
        city: city,
        weight: weight,
      );

      emit(ProfileUpdated());

      // نجيب البيانات الجديدة بعد التحديث
      await getProfile();
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }
}
