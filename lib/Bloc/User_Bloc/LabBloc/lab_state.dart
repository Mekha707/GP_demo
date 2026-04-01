// import 'package:healthcareapp_try1/Models/Users_Models/lab_model.dart';

// abstract class LabsState {}

// class LabsInitial extends LabsState {}

// class LabsLoading extends LabsState {}

// class LabsLoaded extends LabsState {
//   final List<LabModel> labs;
//   final bool hasNextPage;
//   final bool isLoadingMore;

//   LabsLoaded({
//     required this.labs,
//     required this.hasNextPage,
//     this.isLoadingMore = false,
//   });

//   LabsLoaded copyWith({
//     List<LabModel>? labs,
//     bool? hasNextPage,
//     bool? isLoadingMore,
//   }) {
//     return LabsLoaded(
//       labs: labs ?? this.labs,
//       hasNextPage: hasNextPage ?? this.hasNextPage,
//       isLoadingMore: isLoadingMore ?? this.isLoadingMore,
//     );
//   }
// }

// class LabsError extends LabsState {
//   final String message;
//   LabsError(this.message);
// }

import 'package:healthcareapp_try1/Models/Users_Models/lab_model.dart';

abstract class LabsState {}

class LabsInitial extends LabsState {}

class LabsLoading extends LabsState {}

class LabsLoaded extends LabsState {
  final List<LabModel> allLabs;
  final List<LabModel> filteredLabs;
  final bool hasNextPage;
  final bool isLoadingMore;

  LabsLoaded({
    required this.allLabs,
    required this.filteredLabs,
    required this.hasNextPage,
    this.isLoadingMore = false,
  });

  LabsLoaded copyWith({
    List<LabModel>? allLabs,
    List<LabModel>? filteredLabs,
    bool? hasNextPage,
    bool? isLoadingMore,
  }) {
    return LabsLoaded(
      allLabs: allLabs ?? this.allLabs,
      filteredLabs: filteredLabs ?? this.filteredLabs,
      hasNextPage: hasNextPage ?? this.hasNextPage,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }
}

class LabsError extends LabsState {
  final String message;
  LabsError(this.message);
}
