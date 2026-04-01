abstract class ConfirmEmailEvent {}

class ConfirmEmailSubmitted extends ConfirmEmailEvent {
  final String email;
  final String otp;

  ConfirmEmailSubmitted({required this.email, required this.otp});
}
