import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healthcareapp_try1/API/auth_service.dart';
import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthService authService; // تعريف السيرفس

  LoginBloc(this.authService) : super(LoginInitial()) {
    // داخل login_bloc.dart

    on<LoginSubmitted>((event, emit) async {
      emit(LoginLoading());
      try {
        // AuthService هي اللي بتخزن، الـ Bloc بس بيستقبل النتيجة
        final user = await authService.login(event.email, event.password);
        emit(LoginSuccess(user: user));
      } catch (e) {
        emit(LoginFailure(error: e.toString()));
      }
    });
  }
}
