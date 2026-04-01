import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healthcareapp_try1/API/user_service.dart';
// ignore: depend_on_referenced_packages
import 'package:stream_transform/stream_transform.dart';
import 'package:healthcareapp_try1/Bloc/User_Bloc/NurseBloc/nurse_event.dart';
import 'package:healthcareapp_try1/Bloc/User_Bloc/NurseBloc/nurse_state.dart';

EventTransformer<E> debounce<E>(Duration duration) {
  return (events, mapper) => events.debounce(duration).switchMap(mapper);
}

class NursesBloc extends Bloc<NursesEvent, NursesState> {
  final UserService _nurseService;

  String? _currentName;
  String? _currentCity;

  NursesBloc({required UserService nurseService})
    : _nurseService = nurseService,
      super(NursesInitial()) {
    on<FetchNurses>(_onFetchNurses);
    on<LoadMoreNurses>(_onLoadMoreNurses);
    on<RefreshNurses>(_onRefreshNurses); // 👈 تأكد أن السطر ده موجود هنا
    on<FilterNurses>(
      _onFilterNurses,
      transformer: debounce(const Duration(milliseconds: 500)),
    );
  }

  // دالة الـ Refresh: بتطلب الصفحة الأولى تانى بنفس الفلاتر الحالية
  Future<void> _onRefreshNurses(
    RefreshNurses event,
    Emitter<NursesState> emit,
  ) async {
    try {
      final result = await _nurseService.getNurses(
        page: 1,
        name: _currentName,
        city: _currentCity,
      );
      emit(
        NursesLoaded(
          allNurses: result.items,
          filteredNurses: result.items,
          hasNextPage: result.hasNextPage,
          currentPage: 1,
        ),
      );
    } catch (e) {
      emit(NursesError(e.toString()));
    }
  }

  // ... باقي الدوال (FetchNurses, FilterNurses, LoadMoreNurses) اللي كتبناها في الرد السابق

  Future<void> _onFetchNurses(
    FetchNurses event,
    Emitter<NursesState> emit,
  ) async {
    emit(NursesLoading());
    try {
      final result = await _nurseService.getNurses(page: 1);
      emit(
        NursesLoaded(
          allNurses: result.items,
          filteredNurses: result.items,
          hasNextPage: result.hasNextPage,
          currentPage: 1,
        ),
      );
    } catch (e) {
      emit(NursesError(e.toString()));
    }
  }

  Future<void> _onFilterNurses(
    FilterNurses event,
    Emitter<NursesState> emit,
  ) async {
    _currentName = event.name;
    _currentCity = event.cityName;
    try {
      final result = await _nurseService.getNurses(
        page: 1,
        name: _currentName,
        city: _currentCity,
      );
      emit(
        NursesLoaded(
          allNurses: result.items,
          filteredNurses: result.items,
          hasNextPage: result.hasNextPage,
          currentPage: 1,
        ),
      );
    } catch (e) {
      emit(NursesError(e.toString()));
    }
  }

  Future<void> _onLoadMoreNurses(
    LoadMoreNurses event,
    Emitter<NursesState> emit,
  ) async {
    final currentState = state;
    if (currentState is! NursesLoaded ||
        !currentState.hasNextPage ||
        currentState.isLoadingMore) {
      return;
    }

    emit(currentState.copyWith(isLoadingMore: true));
    try {
      final result = await _nurseService.getNurses(
        page: currentState.currentPage + 1,
        name: _currentName,
        city: _currentCity,
      );

      emit(
        currentState.copyWith(
          allNurses: [...currentState.allNurses, ...result.items],
          filteredNurses: [...currentState.filteredNurses, ...result.items],
          hasNextPage: result.hasNextPage,
          currentPage: currentState.currentPage + 1,
          isLoadingMore: false,
        ),
      );
    } catch (e) {
      emit(currentState.copyWith(isLoadingMore: false));
    }
  }
}
