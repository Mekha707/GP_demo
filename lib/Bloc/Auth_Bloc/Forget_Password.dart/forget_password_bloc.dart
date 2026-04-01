import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healthcareapp_try1/API/auth_service.dart';
import 'forget_password_event.dart';
import 'forget_password_state.dart';

class ForgotPasswordBloc
    extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {
  final AuthService authService;

  ForgotPasswordBloc(this.authService) : super(const ForgotPasswordState()) {
    on<ForgotPasswordSubmitted>(_onForgotPasswordSubmitted);
  }

  Future<void> _onForgotPasswordSubmitted(
    ForgotPasswordSubmitted event,
    Emitter<ForgotPasswordState> emit,
  ) async {
    emit(state.copyWith(status: ForgotPasswordStatus.loading));
    try {
      await authService.forgotPassword(event.email);
      emit(
        state.copyWith(
          status: ForgotPasswordStatus.success,
          successMessage: 'Reset link sent! Check your email.',
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: ForgotPasswordStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
