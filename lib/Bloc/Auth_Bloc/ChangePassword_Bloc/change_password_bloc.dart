import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healthcareapp_try1/API/auth_service.dart';
import 'package:healthcareapp_try1/Bloc/Auth_Bloc/ChangePassword_Bloc/change_password_event.dart';
import 'package:healthcareapp_try1/Bloc/Auth_Bloc/ChangePassword_Bloc/change_password_state.dart';

class ChangePasswordBloc
    extends Bloc<ChangePasswordEvent, ChangePasswordState> {
  final AuthService authService;

  ChangePasswordBloc(this.authService) : super(const ChangePasswordState()) {
    on<ChangePasswordSubmitted>(_onChangePasswordSubmitted);
  }

  Future<void> _onChangePasswordSubmitted(
    ChangePasswordSubmitted event,
    Emitter<ChangePasswordState> emit,
  ) async {
    emit(state.copyWith(status: ChangePasswordStatus.loading));

    try {
      // ✅ لاحظ هنا: لم نعد بحاجة لجلب userId يدويًا في الـ Bloc
      // لأن AuthService.changePassword يقوم بذلك داخليًا الآن.
      await authService.changePassword(
        event.currentPassword,
        event.newPassword,
      );

      emit(
        state.copyWith(
          status: ChangePasswordStatus.success,
          successMessage: 'تم تغيير كلمة المرور بنجاح!',
        ),
      );
    } catch (e) {
      // هنا e ستكون هي الرسالة التي استخرجناها بـ _extractError
      emit(
        state.copyWith(
          status: ChangePasswordStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
