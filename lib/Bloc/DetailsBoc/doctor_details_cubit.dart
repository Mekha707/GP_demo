// Events
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:healthcareapp_try1/API/user_service.dart';
import 'package:healthcareapp_try1/Models/DetailsModel.dart/doctor_details_model.dart';

abstract class DoctorDetailsState {}

class DoctorDetailsInitial extends DoctorDetailsState {}

class DoctorDetailsLoading extends DoctorDetailsState {}

class DoctorDetailsLoaded extends DoctorDetailsState {
  final DoctorDetailsModel doctor;
  DoctorDetailsLoaded(this.doctor);
}

class DoctorDetailsError extends DoctorDetailsState {
  final String message;
  DoctorDetailsError(this.message);
}

// Cubit

class DoctorDetailsCubit extends Cubit<DoctorDetailsState> {
  final UserService _doctorService;

  DoctorDetailsCubit(this._doctorService) : super(DoctorDetailsInitial());

  Future<void> loadDoctor(String doctorId) async {
    emit(DoctorDetailsLoading());
    try {
      final doctor = await _doctorService.getDoctorById(doctorId);
      emit(DoctorDetailsLoaded(doctor));
    } on DioException catch (e) {
      emit(DoctorDetailsError(e.message ?? 'فشل تحميل البيانات'));
    } catch (e) {
      emit(DoctorDetailsError('حدث خطأ غير متوقع'));
    }
  }
}
