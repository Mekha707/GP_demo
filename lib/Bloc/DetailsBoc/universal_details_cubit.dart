import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healthcareapp_try1/API/user_service.dart';

class HealthcareDetailsCubit extends Cubit<HealthcareDetailsState> {
  final UserService _userService;

  HealthcareDetailsCubit(this._userService) : super(DetailsLoading());

  // دالة واحدة تستقبل الـ ID والنوع
  Future<void> loadProviderDetails(String id, String type) async {
    emit(DetailsLoading());
    try {
      dynamic data;
      // نختار الـ API المناسب بناءً على النوع
      if (type == "Doctor") {
        data = await _userService.getDoctorById(id);
      } else if (type == "Nurse") {
        data = await _userService.getNurseById(id);
      } else if (type == "Lab") {
        data = await _userService.getLabById(id);
      }

      emit(DetailsLoaded(providerData: data));
    } catch (e) {
      emit(DetailsError(message: e.toString()));
    }
  }
}

abstract class HealthcareDetailsState {}

class DetailsLoading extends HealthcareDetailsState {}

class DetailsLoaded extends HealthcareDetailsState {
  final dynamic providerData; // ستحمل DoctorModel أو NurseModel أو LabModel
  DetailsLoaded({required this.providerData});
}

class DetailsError extends HealthcareDetailsState {
  final String message;
  DetailsError({required this.message});
}
