import 'package:equatable/equatable.dart';

abstract class DoctorsEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchDoctors extends DoctorsEvent {}

class LoadMoreDoctors extends DoctorsEvent {}

class RefreshDoctors extends DoctorsEvent {}

class FilterDoctors extends DoctorsEvent {
  final String? name;
  final String? specialtyId;
  final String? cityName;
  final String? serviceType;

  FilterDoctors({this.name, this.specialtyId, this.cityName, this.serviceType});
}
