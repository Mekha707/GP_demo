import 'package:healthcareapp_try1/Models/Booking_Models/appointment_model.dart';

abstract class AppointmentsState {}

class AppointmentsInitial extends AppointmentsState {}

class AppointmentsLoading extends AppointmentsState {}

class AppointmentsSuccess extends AppointmentsState {
  final List<AppointmentModel> data; // خليها List بدل AllAppointmentsResponse
  AppointmentsSuccess(this.data);
}

// في ملف mybooking_state.dart
class AppointmentsError extends AppointmentsState {
  final String errMessage;
  AppointmentsError(this.errMessage);
}
