// cities_state.dart

// ignore_for_file: avoid_print

// States
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healthcareapp_try1/API/auth_service.dart';

abstract class CitiesState {}

class CitiesInitial extends CitiesState {}

class CitiesLoading extends CitiesState {}

class CitiesSuccess extends CitiesState {
  final List<String> cities;
  CitiesSuccess(this.cities);
}

class CitiesError extends CitiesState {
  final String message;
  CitiesError(this.message);
}

// Cubit
class CitiesCubit extends Cubit<CitiesState> {
  final AuthService authService;

  CitiesCubit(this.authService) : super(CitiesInitial());

  void getCities() async {
    emit(CitiesLoading());
    try {
      final cities = await authService.getCities();
      print("Cities fetched: ${cities.length}"); // للتأكد
      emit(CitiesSuccess(cities));
    } catch (e) {
      emit(CitiesError(e.toString()));
    }
  }
}
