import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healthcareapp_try1/API/auth_service.dart';
import 'confirm_email_event.dart';
import 'confirm_email_state.dart';

class ConfirmEmailBloc extends Bloc<ConfirmEmailEvent, ConfirmEmailState> {
  final AuthService authService;

  ConfirmEmailBloc(this.authService) : super(const ConfirmEmailState()) {
    on<ConfirmEmailSubmitted>(_onConfirmEmailSubmitted);
  }

  Future<void> _onConfirmEmailSubmitted(
    ConfirmEmailSubmitted event,
    Emitter<ConfirmEmailState> emit,
  ) async {
    emit(state.copyWith(status: ConfirmEmailStatus.loading));
    try {
      await authService.confirmEmail(event.email, event.otp);
      emit(
        state.copyWith(
          status: ConfirmEmailStatus.success,
          successMessage: 'Email confirmed successfully!',
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: ConfirmEmailStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
