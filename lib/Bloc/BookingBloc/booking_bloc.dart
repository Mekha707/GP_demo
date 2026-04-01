// ignore_for_file: avoid_print

import 'package:flutter_bloc/flutter_bloc.dart';

// States
abstract class BookingState {}

class BookingInitial extends BookingState {}

class BookingLoading
    extends BookingState {} // تظهر عند الضغط على زر تأكيد الحجز

class BookingSuccess extends BookingState {
  final String message;
  BookingSuccess(this.message);
}

class BookingError extends BookingState {
  final String errorMessage;
  BookingError(this.errorMessage);
}

// Events
abstract class BookingEvent {}

class ConfirmBookingEvent extends BookingEvent {
  final String staffId;
  final DateTime selectedDate;
  final String? selectedTime;
  final String serviceType; // مثلاً: Clinic, Home, Online
  final String paymentMethod; // الحقل الجديد: Cash, Card, أو Wallet

  ConfirmBookingEvent({
    required this.staffId,
    required this.selectedDate,
    required this.serviceType,
    required this.selectedTime,
    required this.paymentMethod, // مطلوب الآن
  });
}

// Bloc
class BookingBloc extends Bloc<BookingEvent, BookingState> {
  BookingBloc() : super(BookingInitial()) {
    on<ConfirmBookingEvent>((event, emit) async {
      emit(BookingLoading()); // ابدأ التحميل

      try {
        // محاكاة تأخير الشبكة (Network Latency)
        await Future.delayed(const Duration(seconds: 2));

        // 2. منطق إضافي في حالة الدفع بالبطاقة
        if (event.paymentMethod == "Card") {
          // هنا يمكن إضافة تشفير البيانات أو التأكد من نجاح عملية السحب الوهمية
          print("Processing Credit Card Payment for: ${event.staffId}");
        }

        // هنا تضع كود الـ API الفعلي لإرسال البيانات
        bool isSuccess = true; // نفترض أن العملية نجحت

        if (isSuccess) {
          emit(
            BookingSuccess(
              "تم حجز موعدك بنجاح في ${event.selectedDate.toLocal()}",
            ),
          );
          // ignore: dead_code
        } else {
          emit(BookingError("عذراً، الموعد غير متاح حالياً."));
        }
      } catch (e) {
        emit(BookingError("حدث خطأ غير متوقع: ${e.toString()}"));
      }
    });
  }
}
