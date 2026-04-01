import 'package:healthcareapp_try1/Models/Users_Models/nurse_model.dart';

abstract class NursesState {}

class NursesInitial extends NursesState {}

class NursesLoading extends NursesState {}

class NursesError extends NursesState {
  final String message;
  NursesError(this.message);
}

class NursesLoaded extends NursesState {
  final List<Nurse> allNurses;
  final List<Nurse> filteredNurses;
  final bool hasNextPage;
  final int currentPage;
  final bool isLoadingMore;

  NursesLoaded({
    required this.allNurses,
    required this.filteredNurses,
    required this.hasNextPage,
    required this.currentPage,
    this.isLoadingMore = false,
  });

  NursesLoaded copyWith({
    List<Nurse>? allNurses,
    List<Nurse>? filteredNurses,
    bool? hasNextPage,
    int? currentPage,
    bool? isLoadingMore,
  }) {
    return NursesLoaded(
      allNurses: allNurses ?? this.allNurses,
      filteredNurses: filteredNurses ?? this.filteredNurses,
      hasNextPage: hasNextPage ?? this.hasNextPage,
      currentPage: currentPage ?? this.currentPage,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }
}
