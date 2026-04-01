// import 'package:dio/dio.dart';
// import 'package:healthcareapp_try1/Models/Logic/paginated_list.dart';
// import 'package:healthcareapp_try1/Models/Users_Models/doctor_model.dart';

import 'package:dio/dio.dart';
import 'package:healthcareapp_try1/API/details_service.dart';
import 'package:healthcareapp_try1/Models/DetailsModel.dart/doctor_details_model.dart';
import 'package:healthcareapp_try1/Models/Logic/paginated_list.dart';
import 'package:healthcareapp_try1/Models/Users_Models/doctor_model.dart';
import 'package:healthcareapp_try1/Models/Users_Models/nurse_model.dart';
import 'package:healthcareapp_try1/Models/Users_Models/lab_model.dart';
import 'package:healthcareapp_try1/Models/Users_Models/specialty_model.dart';

class UserService {
  // استخدام الـ Singleton لضمان وجود نسخة واحدة من Dio في التطبيق كله
  static final UserService _instance = UserService._internal();
  factory UserService() => _instance;

  late final Dio _dio;

  UserService._internal() {
    _dio = Dio(
      BaseOptions(
        baseUrl: 'https://unalterably-unasphalted-felton.ngrok-free.dev/',
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {'Content-Type': 'application/json'},
      ),
    );

    // إضافة الـ Interceptors (Logging & Auth)
    _dio.interceptors.add(
      LogInterceptor(requestBody: true, responseBody: true),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          // هنا ممكن تضيف الـ Token مستقبلاً
          handler.next(options);
        },
        onError: (DioException e, handler) {
          handler.next(e);
        },
      ),
    );
  }

  // --- Doctor Methods ---
  Future<PaginatedList<Doctor>> getDoctors({
    int page = 1,
    String? name, // سيتم إرساله كـ Search
    String? specialtyId, // سيتم إرساله كـ SpecialityId (UUID)
    String? location, // سيتم إرساله كـ City
    String? serviceType, // سيتم إرساله كـ AppointmentType
  }) async {
    try {
      final Map<String, dynamic> queryParams = {
        'Page': page, // السيرفر مستني Page مش pageNumber
        'PageSize': 10,
      };

      // الربط مع الـ Documentation الجديد:
      if (name != null && name.isNotEmpty) {
        queryParams['Search'] = name;
      }

      if (specialtyId != null && specialtyId.isNotEmpty) {
        queryParams['SpecialityId'] = specialtyId;
      }

      if (location != null && location.isNotEmpty) {
        queryParams['City'] = location;
      }

      if (serviceType != null) {
        queryParams['AppointmentType'] = serviceType.toString();
      }

      final response = await _dio.get(
        'api/Doctors',
        queryParameters: queryParams,
      );

      return PaginatedList.fromJson(
        response.data as Map<String, dynamic>,
        Doctor.fromJson,
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<DoctorDetailsModel> getDoctorById(String doctorId) async {
    final response = await _dio.get('api/doctors/$doctorId');

    final apiResponse = DetailsService.fromJson(
      response.data as Map<String, dynamic>,
      DoctorDetailsModel.fromJson,
    );

    if (apiResponse.isSuccess && apiResponse.value != null) {
      return apiResponse.value!;
    } else {
      throw Exception(
        apiResponse.error?.description ?? 'فشل تحميل بيانات الدكتور',
      );
    }
  }

  // --- Nurse Methods ---
  Future<PaginatedList<Nurse>> getNurses({
    int page = 1,
    String? name,
    String? city,
  }) async {
    try {
      final Map<String, dynamic> queryParams = {'Page': page, 'PageSize': 10};

      if (name != null && name.isNotEmpty) queryParams['Search'] = name;
      if (city != null && city.isNotEmpty) queryParams['City'] = city;

      final response = await _dio.get(
        'api/Nurses', // تأكد من المسار الصحيح حسب الـ API عندك
        queryParameters: queryParams,
      );

      // تحويل الـ Response لـ PaginatedList ليدعم الـ Bloc
      return PaginatedList.fromJson(
        response.data as Map<String, dynamic>,
        Nurse.fromJson,
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // --- Lab Methods ---
  Future<PaginatedList<LabModel>> getLabs({int page = 1}) async {
    try {
      final response = await _dio.get(
        'api/labs',
        queryParameters: {'pageNumber': page},
      );
      return PaginatedList.fromJson(
        response.data as Map<String, dynamic>,
        LabModel.fromJson,
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // --- Error Handling (مكان واحد لكل الخدمات) ---
  Exception _handleError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
        return Exception('انتهت مهلة الاتصال، تحقق من الإنترنت');
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        final message = e.response?.data?['message'] ?? 'حدث خطأ من السيرفر';
        return Exception('خطأ $statusCode: $message');
      case DioExceptionType.connectionError:
        return Exception('لا يوجد اتصال بالإنترنت');
      default:
        return Exception('حدث خطأ غير متوقع');
    }
  }

  // --- Specialty Methods ---

  Future<List<Specialty>> getAllSpecialties() async {
    final response = await _dio.get('api/Specialties'); // تأكد من المسار الصح
    return (response.data as List)
        .map((json) => Specialty.fromJson(json))
        .toList();
  }
}
