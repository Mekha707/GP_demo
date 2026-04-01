import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healthcareapp_try1/API/user_service.dart';
import 'package:healthcareapp_try1/Bloc/User_Bloc/SpecialtyBloc/specialty_event.dart';
import 'package:healthcareapp_try1/Bloc/User_Bloc/SpecialtyBloc/specialty_state.dart';

class SpecialtyBloc extends Bloc<SpecialtyEvent, SpecialtyState> {
  final UserService _apiService;

  SpecialtyBloc(this._apiService) : super(SpecialtyInitial()) {
    on<LoadSpecialties>((event, emit) async {
      emit(SpecialtyLoading());
      try {
        final specialties = await _apiService.getAllSpecialties();
        emit(SpecialtyLoaded(specialties));
      } catch (e) {
        emit(SpecialtyError(e.toString()));
      }
    });
  }
}
