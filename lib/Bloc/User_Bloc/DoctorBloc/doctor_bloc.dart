import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healthcareapp_try1/API/user_service.dart';
import 'package:healthcareapp_try1/Bloc/User_Bloc/DoctorBloc/doctor_event.dart';
import 'package:healthcareapp_try1/Bloc/User_Bloc/DoctorBloc/doctor_state.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart'; // 👈 السطر ده مهم جداً

// ... الـ imports كما هي

class DoctorsBloc extends Bloc<DoctorsEvent, DoctorsState> {
  final UserService _apiService;
  int _currentPage = 1;

  // حفظ الفلاتر الحالية لضمان استمراريتها عند الـ Pagination
  String? _activeFilterName;
  String? _activeFilterSpecialtyId;
  String? _activeFilterLocation;
  String? _activeFilterServiceType;

  DoctorsBloc(this._apiService) : super(DoctorsInitial()) {
    on<FetchDoctors>(_onFetch);
    on<LoadMoreDoctors>(_onLoadMore);
    on<RefreshDoctors>(_onRefresh);
    on<FilterDoctors>(_onFilter, transformer: restartable());
  }

  Future<void> _onFetch(FetchDoctors event, Emitter<DoctorsState> emit) async {
    emit(DoctorsLoading());
    _currentPage = 1;
    _clearFilters(); // تصفير الفلاتر عند البداية من جديد

    try {
      final result = await _apiService.getDoctors(page: _currentPage);
      emit(
        DoctorsLoaded(
          allDoctors: result.items,
          filteredDoctors: result.items,
          hasNextPage: result.hasNextPage,
          currentPage: _currentPage,
        ),
      );
    } catch (e) {
      emit(DoctorsError(e.toString()));
    }
  }

  Future<void> _onFilter(
    FilterDoctors event,
    Emitter<DoctorsState> emit,
  ) async {
    // 1. تحديث المتغيرات الداخلية فوراً بالقيم الجديدة القادمة من الـ UI
    _activeFilterName = event.name;
    _activeFilterSpecialtyId = event.specialtyId;
    _activeFilterLocation = event.cityName;
    _activeFilterServiceType = event.serviceType;
    _currentPage = 1; // إعادة تصغير الصفحة لأول صفحة في البحث

    // اختياري: إظهار لودر خفيف أو البدء في طلب البيانات مباشرة
    // emit(DoctorsLoading());

    try {
      final result = await _apiService.getDoctors(
        page: _currentPage,
        name: _activeFilterName,
        specialtyId: event.specialtyId,
        location: _activeFilterLocation,
        serviceType: _activeFilterServiceType != null
            ? (_activeFilterServiceType!)
            : null,
      );

      emit(
        DoctorsLoaded(
          allDoctors: result.items,
          filteredDoctors: result.items,
          hasNextPage: result.hasNextPage,
          currentPage: _currentPage,
        ),
      );
    } catch (e) {
      emit(DoctorsError("Search Error: ${e.toString()}"));
    }
  }

  Future<void> _onLoadMore(
    LoadMoreDoctors event,
    Emitter<DoctorsState> emit,
  ) async {
    final current = state;
    if (current is! DoctorsLoaded ||
        !current.hasNextPage ||
        current.isLoadingMore) {
      return;
    }

    emit(current.copyWith(isLoadingMore: true));
    _currentPage++;

    try {
      final result = await _apiService.getDoctors(
        page: _currentPage,
        // ✅ نرسل كل الفلاتر النشطة حالياً عشان الـ Pagination يكمل صح
        name: _activeFilterName,
        specialtyId: _activeFilterSpecialtyId,
        location: _activeFilterLocation,
        serviceType: _activeFilterServiceType != null
            ? (_activeFilterServiceType!)
            : null,
      );

      final updatedItems = [...current.allDoctors, ...result.items];

      emit(
        current.copyWith(
          allDoctors: updatedItems,
          filteredDoctors: updatedItems,
          hasNextPage: result.hasNextPage,
          currentPage: _currentPage,
          isLoadingMore: false,
        ),
      );
    } catch (e) {
      _currentPage--;
      emit(current.copyWith(isLoadingMore: false));
    }
  }

  Future<void> _onRefresh(
    RefreshDoctors event,
    Emitter<DoctorsState> emit,
  ) async {
    add(FetchDoctors());
  }

  void _clearFilters() {
    _activeFilterName = null;
    _activeFilterSpecialtyId = null;
    _activeFilterLocation = null;
    _activeFilterServiceType = null;
  }
}
