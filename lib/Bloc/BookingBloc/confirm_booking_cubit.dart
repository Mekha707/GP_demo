// Bloc/BookingBloc/doctor_booking_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healthcareapp_try1/API/user_service.dart';

abstract class BookingState {}

class BookingInitial extends BookingState {}

class BookingLoading extends BookingState {}

class BookingSuccess extends BookingState {}

class BookingError extends BookingState {
  final String message;
  BookingError(this.message);
}

class BookingCubit extends Cubit<BookingState> {
  final UserService userService;
  BookingCubit(this.userService) : super(BookingInitial());

  Future<void> confirmBooking({
    required String providerId,
    required String slotId,
    required String appointmentType,
    required String token,
    required String providerType,
    String? notes,
    String? address,
    int? hours,
    String? startTime,
    // ✅ للـ lab
    List<String>? labTestsIds,
    String? date,
  }) async {
    emit(BookingLoading());
    try {
      if (providerType == "Doctor") {
        await userService.bookDoctorAppointment(
          doctorId: providerId,
          doctorSlotId: slotId,
          appointmentType: appointmentType,
          token: token,
          notes: notes,
          address: address,
        );
      } else if (providerType == "Nurse") {
        await userService.bookNurseAppointment(
          nurseId: providerId,
          shiftId: slotId,
          serviceType: appointmentType,
          address: address ?? '',
          token: token,
          notes: notes,
          hours: hours,
          startTime: startTime,
        );
      } else if (providerType == "Lab") {
        await userService.bookLabAppointment(
          labId: providerId,
          date: date ?? '',
          appointmentType: appointmentType,
          labTestsIds: labTestsIds ?? [],
          token: token,
          startTime: startTime,
          notes: notes,
          address: address,
        );
      }
      emit(BookingSuccess());
    } catch (e) {
      emit(BookingError(e.toString()));
    }
  }
}
