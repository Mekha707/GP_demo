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
  final UserService _userService;

  ReviewsCubit(this._userService) : super(ReviewsInitial());

  // أضفنا parameter الـ type لتحديد الوجهة
  Future<void> fetchReviews(String id, String type, {int page = 1}) async {
    emit(ReviewsLoading());
    try {
      PaginatedList<ReviewModel> result;

      // اختيار الدالة المناسبة بناءً على النوع القادم من الصفحة
      if (type == "Nurse") {
        result = await _userService.getNurseReviews(id, page: page);
      } else if (type == "Doctor") {
        result = await _userService.getDoctorReviews(id, page: page);
      } else {
        result = await _userService.getLabReviews(id, page: page);
      }

      emit(ReviewsLoaded(result));
    } catch (e) {
      emit(ReviewsError(e.toString()));
    }
  }
}
