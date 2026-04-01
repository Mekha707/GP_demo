import 'package:equatable/equatable.dart';
import 'package:healthcareapp_try1/Models/Auth_Models/login_response_model.dart';

abstract class LoginState extends Equatable {
  const LoginState();
  @override
  List<Object?> get props => [];
}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {
  final LoginResponse user; // ✅ مش email بس
  const LoginSuccess({required this.user});

  @override
  List<Object?> get props => [user];
}

class LoginFailure extends LoginState {
  final String error;
  const LoginFailure({required this.error});

  @override
  List<Object?> get props => [error];
}
