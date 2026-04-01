class DetailsService<T> {
  final T? value;
  final bool isSuccess;
  final DetailsServiceError? error;

  DetailsService({this.value, required this.isSuccess, this.error});

  factory DetailsService.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJsonT,
  ) {
    return DetailsService(
      value: json['value'] != null ? fromJsonT(json['value']) : null,
      isSuccess: json['isSuccess'] ?? false,
      error: json['error'] != null
          ? DetailsServiceError.fromJson(json['error'])
          : null,
    );
  }
}

class DetailsServiceError {
  final String code;
  final String description;
  final int? statusCode;

  DetailsServiceError({
    required this.code,
    required this.description,
    this.statusCode,
  });

  factory DetailsServiceError.fromJson(Map<String, dynamic> json) {
    return DetailsServiceError(
      code: json['code'] ?? '',
      description: json['description'] ?? '',
      statusCode: json['statusCode'],
    );
  }
}
