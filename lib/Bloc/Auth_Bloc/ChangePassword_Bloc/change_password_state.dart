enum ChangePasswordStatus { initial, loading, success, error }

class ChangePasswordState {
  final ChangePasswordStatus status;
  final String errorMessage;
  final String successMessage;

  const ChangePasswordState({
    this.status = ChangePasswordStatus.initial,
    this.errorMessage = '',
    this.successMessage = '',
  });

  ChangePasswordState copyWith({
    ChangePasswordStatus? status,
    String? errorMessage,
    String? successMessage,
  }) {
    return ChangePasswordState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      successMessage: successMessage ?? this.successMessage,
    );
  }
}
