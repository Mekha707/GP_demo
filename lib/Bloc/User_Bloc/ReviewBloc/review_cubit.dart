import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healthcareapp_try1/API/user_service.dart';
import 'package:healthcareapp_try1/Models/DetailsModel.dart/review_model.dart';
import 'package:healthcareapp_try1/Models/Logic/paginated_list.dart';

abstract class ReviewsState {}

class ReviewsInitial extends ReviewsState {}

class ReviewsLoading extends ReviewsState {}

class ReviewsLoaded extends ReviewsState {
  final PaginatedList<ReviewModel> reviewsData;
  ReviewsLoaded(this.reviewsData);
}

class ReviewsError extends ReviewsState {
  final String message;
  ReviewsError(this.message);
}

class ReviewsCubit extends Cubit<ReviewsState> {
  final UserService _userService; // أو الريبوزيتوري الخاص بكِ

  ReviewsCubit(this._userService) : super(ReviewsInitial());

  Future<void> fetchReviews(String doctorId, {int page = 1}) async {
    emit(ReviewsLoading());
    try {
      final result = await _userService.getDoctorReviews(doctorId);
      emit(ReviewsLoaded(result));
    } catch (e) {
      emit(ReviewsError(e.toString()));
    }
  }
}
