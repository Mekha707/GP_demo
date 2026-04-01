import 'package:equatable/equatable.dart';
import 'package:healthcareapp_try1/Models/Users_Models/doctor_model.dart';

abstract class DoctorsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class DoctorsInitial extends DoctorsState {}

class DoctorsLoading extends DoctorsState {}

class DoctorsLoaded extends DoctorsState {
  final List<Doctor> allDoctors; // كل الداتا الجاية من الـ API
  final List<Doctor> filteredDoctors; // اللي بيتعرض بعد الفلترة
  final bool hasNextPage;
  final int currentPage;
  final bool isLoadingMore;

  DoctorsLoaded({
    required this.allDoctors,
    required this.filteredDoctors,
    required this.hasNextPage,
    required this.currentPage,
    this.isLoadingMore = false,
  });

  DoctorsLoaded copyWith({
    List<Doctor>? allDoctors,
    List<Doctor>? filteredDoctors,
    bool? hasNextPage,
    int? currentPage,
    bool? isLoadingMore,
  }) {
    return DoctorsLoaded(
      allDoctors: allDoctors ?? this.allDoctors,
      filteredDoctors: filteredDoctors ?? this.filteredDoctors,
      hasNextPage: hasNextPage ?? this.hasNextPage,
      currentPage: currentPage ?? this.currentPage,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }

  @override
  List<Object?> get props => [
    allDoctors,
    filteredDoctors,
    hasNextPage,
    currentPage,
    isLoadingMore,
  ];
}

class DoctorsError extends DoctorsState {
  final String message;

  DoctorsError(this.message);

  @override
  List<Object?> get props => [message];
}
