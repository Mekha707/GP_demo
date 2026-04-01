import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healthcareapp_try1/API/auth_service.dart';
import 'reset_password_event.dart';
import 'reset_password_state.dart';

class ResetPasswordBloc extends Bloc<ResetPasswordEvent, ResetPasswordState> {
  final AuthService authService;

  ResetPasswordBloc(this.authService) : super(const ResetPasswordState()) {
    on<VerifyOtpSubmitted>(_onVerifyOtpSubmitted);
    on<ResetPasswordSubmitted>(_onResetPasswordSubmitted);
  }

  Future<void> _onVerifyOtpSubmitted(
    VerifyOtpSubmitted event,
    Emitter<ResetPasswordState> emit,
  ) async {
    emit(state.copyWith(status: ResetPasswordStatus.loading));
    try {
      await authService.verifyResetOtp(email: event.email, otp: event.otp);
      emit(
        state.copyWith(
          status: ResetPasswordStatus.otpVerified,
          verifiedOtp: event.otp,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: ResetPasswordStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onResetPasswordSubmitted(
    ResetPasswordSubmitted event,
    Emitter<ResetPasswordState> emit,
  ) async {
    emit(state.copyWith(status: ResetPasswordStatus.loading));
    try {
      await authService.resetPassword(
        email: event.email,
        otp: event.otp,
        newPassword: event.newPassword,
      );
      emit(
        state.copyWith(
          status: ResetPasswordStatus.success,
          successMessage: 'Password reset successfully!',
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: ResetPasswordStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
