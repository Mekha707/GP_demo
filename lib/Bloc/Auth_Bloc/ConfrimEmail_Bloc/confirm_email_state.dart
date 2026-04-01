enum ConfirmEmailStatus { initial, loading, success, error }

class ConfirmEmailState {
  final ConfirmEmailStatus status;
  final String errorMessage;
  final String successMessage;

  const ConfirmEmailState({
    this.status = ConfirmEmailStatus.initial,
    this.errorMessage = '',
    this.successMessage = '',
  });

  ConfirmEmailState copyWith({
    ConfirmEmailStatus? status,
    String? errorMessage,
    String? successMessage,
  }) {
    return ConfirmEmailState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      successMessage: successMessage ?? this.successMessage,
    );
  }
}
