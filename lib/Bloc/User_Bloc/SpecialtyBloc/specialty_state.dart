import 'package:healthcareapp_try1/Models/Users_Models/specialty_model.dart';

abstract class SpecialtyState {}

class SpecialtyInitial extends SpecialtyState {}

class SpecialtyLoading extends SpecialtyState {}

class SpecialtyLoaded extends SpecialtyState {
  final List<Specialty> specialties;
  SpecialtyLoaded(this.specialties);
}

class SpecialtyError extends SpecialtyState {
  final String message;
  SpecialtyError(this.message);
}
