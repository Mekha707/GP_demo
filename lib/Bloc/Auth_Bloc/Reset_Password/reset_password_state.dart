enum ResetPasswordStatus { initial, loading, otpVerified, success, error }

class ResetPasswordState {
  final ResetPasswordStatus status;
  final String errorMessage;
  final String successMessage;
  final String verifiedOtp;

  const ResetPasswordState({
    this.status = ResetPasswordStatus.initial,
    this.errorMessage = '',
    this.successMessage = '',
    this.verifiedOtp = '',
  });

  ResetPasswordState copyWith({
    ResetPasswordStatus? status,
    String? errorMessage,
    String? successMessage,
    String? verifiedOtp,
  }) {
    return ResetPasswordState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      successMessage: successMessage ?? this.successMessage,
      verifiedOtp: verifiedOtp ?? this.verifiedOtp,
    );
  }
}
