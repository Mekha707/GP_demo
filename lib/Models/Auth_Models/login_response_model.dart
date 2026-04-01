class LoginResponse {
  final String id;
  final String token;
  final String email;
  final String name;
  final String role;
  final String refreshtoken;

  LoginResponse({
    required this.name,
    required this.role,
    required this.refreshtoken,
    required this.id,
    required this.token,
    required this.email,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      id: json['id'],
      token: json['token'],
      email: json['email'],
      name: json['name'],
      role: json['role'],
      refreshtoken: json['refreshToken'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'email': email,
    'name': name,
    'role': role,
    'token': token,
    'refreshToken': refreshtoken,
  };
}
