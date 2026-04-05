// ignore_for_file: unused_catch_clause, avoid_print

import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healthcareapp_try1/API/user_service.dart';
import 'package:healthcareapp_try1/Bloc/User_Bloc/LabBloc/lab_event.dart';
import 'package:healthcareapp_try1/Bloc/User_Bloc/LabBloc/lab_state.dart';
import 'package:healthcareapp_try1/Models/Users_Models/lab_model.dart';

class LabsBloc extends Bloc<LabsEvent, LabsState> {
  final UserService _labService;
  int _currentPage = 1;

  LabsBloc(this._labService) : super(LabsInitial()) {
    on<FetchLabs>(_onFetch);
    on<LoadMoreLabs>(_onLoadMore);
    on<RefreshLabs>(_onRefresh);
    on<FilterLabs>(_onFilter);
  }

  Future<void> _onFetch(FetchLabs event, Emitter<LabsState> emit) async {
    emit(LabsLoading());
    _currentPage = 1;

    try {
      // الـ result هنا نوعه List<LabModel> مش Object
      final List<LabModel> result = await _labService.getLabs(
        page: _currentPage,
      );

      emit(
        LabsLoaded(
          allLabs: result, // استخدم result مباشرة
          filteredLabs: result, // استخدم result مباشرة
          // بما إنها قائمة مباشرة، ممكن تحدد الـ hasNextPage بناءً على طول القائمة
          // مثلاً لو الـ API بيبعت 10 في الصفحة:
          hasNextPage: result.length >= 10,
        ),
      );
    } on DioException catch (e) {
      emit(LabsError(_handleDioError(e)));
    } catch (e) {
      emit(LabsError('حدث خطأ غير متوقع'));
    }
  }

  Future<void> _onLoadMore(LoadMoreLabs event, Emitter<LabsState> emit) async {
    final current = state;
    if (current is! LabsLoaded ||
        !current.hasNextPage ||
        current.isLoadingMore) {
      return;
    }

    emit(current.copyWith(isLoadingMore: true));
    _currentPage++;

    try {
      // تعديل هنا كمان: شيل .items
      final result = await _labService.getLabs(page: _currentPage);

      final updatedAll = [
        ...current.allLabs,
        ...result,
      ]; // دمج القائمة الجديدة مباشرة

      emit(
        current.copyWith(
          allLabs: updatedAll,
          filteredLabs: updatedAll,
          hasNextPage: result.length >= 10, // تحديث الحالة
          isLoadingMore: false,
        ),
      );
    } on DioException catch (e) {
      _currentPage--;
      emit(current.copyWith(isLoadingMore: false));
    }
  }

  Future<void> _onRefresh(RefreshLabs event, Emitter<LabsState> emit) async {
    _currentPage = 1;

    try {
      final result = await _labService.getLabs(page: _currentPage);
      emit(
        LabsLoaded(
          allLabs: result,
          filteredLabs: result,
          hasNextPage: result.length >= 10,
        ),
      );
    } on DioException catch (e) {
      emit(LabsError(_handleDioError(e)));
    }
  }

  Future<void> _onFilter(FilterLabs event, Emitter<LabsState> emit) async {
    emit(LabsLoading());
    try {
      final List<LabModel> labs = await _labService.getLabs(
        page: 1,
        name: event.name,
        location: event.location,
        testIds: event.testIds,
      );

      emit(
        LabsLoaded(
          allLabs: labs,
          filteredLabs: labs,
          hasNextPage: labs.length >= 10,
        ),
      );
    } catch (e) {
      // السطر ده هيخليكي تشوفي المشكلة الحقيقية في الـ Debug Console
      print("Filter Error Details: $e");
      emit(LabsError("فشل البحث: $e"));
    }
  }

  String _handleDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
        return 'انتهت مهلة الاتصال';
      case DioExceptionType.connectionError:
        return 'تحقق من الاتصال بالإنترنت';
      default:
        return 'فشل تحميل البيانات: ${e.response?.statusCode}';
    }
  }
}
