import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healthcareapp_try1/API/profile_service.dart';
import 'package:healthcareapp_try1/Bloc/MyBookingBloc/mybooking_state.dart';
import 'package:healthcareapp_try1/Models/Booking_Models/appointment_model.dart';

class AppointmentsCubit extends Cubit<AppointmentsState> {
  final ProfileService appointmentService;

  AppointmentsCubit(this.appointmentService) : super(AppointmentsInitial());

  Future<void> getAllUserAppointments(String token) async {
    emit(AppointmentsLoading());
    try {
      // بننادي على الـ function الجديدة اللي لسه ضايفينها في السيرفس
      final List<AppointmentModel> result = await appointmentService
          .getPatientHistory(token);

      // تأكد إن AppointmentsSuccess بتقبل List<AppointmentModel>
      emit(AppointmentsSuccess(result));
    } catch (e) {
      emit(AppointmentsError("حدث خطأ أثناء جلب البيانات: ${e.toString()}"));
    }
  }
}
