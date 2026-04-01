abstract class ResetPasswordEvent {}

// خطوة 1 - verify OTP
class VerifyOtpSubmitted extends ResetPasswordEvent {
  final String email;
  final String otp;
  VerifyOtpSubmitted({required this.email, required this.otp});
}

// خطوة 2 - reset password
class ResetPasswordSubmitted extends ResetPasswordEvent {
  final String email;
  final String otp;
  final String newPassword;
  ResetPasswordSubmitted({
    required this.email,
    required this.otp,
    required this.newPassword,
  });
}
