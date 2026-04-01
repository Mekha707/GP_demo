// ignore_for_file: unused_catch_clause

import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healthcareapp_try1/API/user_service.dart';
import 'package:healthcareapp_try1/Bloc/User_Bloc/LabBloc/lab_event.dart';
import 'package:healthcareapp_try1/Bloc/User_Bloc/LabBloc/lab_state.dart';

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
      final result = await _labService.getLabs(page: _currentPage);
      emit(
        LabsLoaded(
          allLabs: result.items,
          filteredLabs: result.items,
          hasNextPage: result.hasNextPage,
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
      final result = await _labService.getLabs(page: _currentPage);
      final updatedAll = [...current.allLabs, ...result.items];
      emit(
        current.copyWith(
          allLabs: updatedAll,
          filteredLabs: updatedAll,
          hasNextPage: result.hasNextPage,
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
          allLabs: result.items,
          filteredLabs: result.items,
          hasNextPage: result.hasNextPage,
        ),
      );
    } on DioException catch (e) {
      emit(LabsError(_handleDioError(e)));
    }
  }

  void _onFilter(FilterLabs event, Emitter<LabsState> emit) {
    final current = state;
    if (current is! LabsLoaded) return;

    final filtered = current.allLabs.where((lab) {
      final matchName =
          event.name == null ||
          event.name!.isEmpty ||
          lab.name.toLowerCase().contains(event.name!.toLowerCase());

      final matchLocation =
          event.location == null ||
          event.location!.isEmpty ||
          lab.address.toLowerCase().contains(event.location!.toLowerCase());

      return matchName && matchLocation;
    }).toList();

    emit(current.copyWith(filteredLabs: filtered));
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
