// import 'package:dio/dio.dart';
// import 'package:healthcareapp_try1/Models/Logic/paginated_list.dart';
// import 'package:healthcareapp_try1/Models/Users_Models/doctor_model.dart';

// ignore_for_file: avoid_print

import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:healthcareapp_try1/API/details_service.dart';
import 'package:healthcareapp_try1/Models/Booking_Models/test_model.dart';
import 'package:healthcareapp_try1/Models/DetailsModel.dart/doctor_details_model.dart';
import 'package:healthcareapp_try1/Models/DetailsModel.dart/lab_details_model.dart';
import 'package:healthcareapp_try1/Models/DetailsModel.dart/nurse_details_model.dart';
import 'package:healthcareapp_try1/Models/DetailsModel.dart/review_model.dart';
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
    return handleResponse(apiResponse);
  }

  Future<PaginatedList<ReviewModel>> getDoctorReviews(
    String doctorId, {
    int page = 1,
  }) async {
    try {
      final response = await _dio.get(
        'api/Reviews', // تأكدي أن هذا هو المسار الصحيح بدون / في البداية إذا كان الـ BaseUrl ينتهي بـ /
        queryParameters: {
          'TargetId': doctorId, // تغيير الاسم ليتطابق مع الـ API Request
          'TargetType':
              'Doctor', // أو القيمة المطلوبة في الـ API (مثل "1" أو "Doctor")
          'pageNumber': page,
          'pageSize': 10,
        },
      );

      return PaginatedList<ReviewModel>.fromJson(
        response.data,
        (itemJson) => ReviewModel.fromJson(itemJson),
      );
    } on DioException catch (e) {
      log("Dio Error: ${e.response?.statusCode} - ${e.response?.data}");
      throw "فشل تحميل التقييمات";
    }
  }

  // Future<void> bookDoctorAppointment({
  //   required String doctorId,
  //   required String doctorSlotId,
  //   required String appointmentType,
  //   required String token,
  //   String? notes,
  //   String? address,
  // }) async {
  //   try {
  //     await _dio.post(
  //       'api/doctor-appointments',
  //       data: {
  //         'doctorId': doctorId,
  //         'doctorSlotId': doctorSlotId,
  //         'appointmentType': appointmentType,
  //         'notes': notes,
  //         'address': address,
  //       },
  //       options: Options(headers: {'Authorization': 'Bearer $token'}),
  //     );
  //   } on DioException catch (e) {
  //     throw _handleError(e);
  //   }
  // }

  Future<void> bookDoctorAppointment({
    required String doctorId,
    required String doctorSlotId,
    required String appointmentType,
    required String token,
    String? notes,
    String? address,
  }) async {
    try {
      final Map<String, dynamic> data = {
        'doctorId': doctorId,
        'doctorSlotId': doctorSlotId,
        'appointmentType': appointmentType,
      };

      // ضيف notes بس لو موجودة
      if (notes != null && notes.isNotEmpty) {
        data['notes'] = notes;
      }

      // ضيف address بس لو النوع محتاجه
      if (appointmentType == "HomeVisit" &&
          address != null &&
          address.isNotEmpty) {
        data['address'] = address;
      }

      await _dio.post(
        'api/doctor-appointments',
        data: data,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
    } on DioException catch (e) {
      throw _handleError(e);
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

  Future<NurseDetailsModel> getNurseById(String nurseId) async {
    final response = await _dio.get('api/nurses/$nurseId');

    final apiResponse = DetailsService.fromJson(
      response.data as Map<String, dynamic>,
      NurseDetailsModel.fromJson,
    );

    return handleResponse(apiResponse);
  }

  Future<PaginatedList<ReviewModel>> getNurseReviews(
    String nurseId, {
    int page = 1,
  }) async {
    try {
      final response = await _dio.get(
        'api/Reviews', // تأكدي أن هذا هو المسار الصحيح بدون / في البداية إذا كان الـ BaseUrl ينتهي بـ /
        queryParameters: {
          'TargetId': nurseId, // تغيير الاسم ليتطابق مع الـ API Request
          'TargetType':
              'Nurse', // أو القيمة المطلوبة في الـ API (مثل "1" أو "Nurse")
          'pageNumber': page,
          'pageSize': 10,
        },
      );

      return PaginatedList<ReviewModel>.fromJson(
        response.data,
        (itemJson) => ReviewModel.fromJson(itemJson),
      );
    } on DioException catch (e) {
      log("Dio Error: ${e.response?.statusCode} - ${e.response?.data}");
      throw "فشل تحميل التقييمات";
    }
  }

  Future<void> bookNurseAppointment({
    required String nurseId,
    required String shiftId,
    required String serviceType,
    required String token,
    required String address,
    String? notes,
    int? hours,
    String? startTime,
  }) async {
    try {
      final data = {
        "nurseId": nurseId,
        "shiftId": shiftId,
        "notes": notes ?? "",
        "startTime": startTime,
        "address": address.trim(),
        "serviceType": serviceType,
        "hours": hours ?? 1,
      };

      print("REQUEST DATA: $data"); // 👈 مهم جدًا

      final response = await _dio.post(
        'api/nurse-appointments',
        data: data, // 👈 شيلنا request
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  // --- Lab Methods ---
  Future<List<LabModel>> getLabs({
    int page = 1,
    String? name,
    String? location,
    List<String>? testIds,
  }) async {
    try {
      final Map<String, dynamic> queryParams = {
        'Page': page, // لاحظ استخدمت Page كابيتال زي الـ Doctors
        'PageSize': 10,
      };

      if (name != null && name.isNotEmpty) {
        queryParams['Search'] = name; // السيرفر بيحب كلمة Search غالباً
      }
      if (location != null && location.isNotEmpty) {
        queryParams['City'] = location;
      }

      // جربي تبعتيها بدون [] أولاً لو السيرفر Standard
      if (testIds != null && testIds.isNotEmpty) {
        queryParams['TestIds'] = testIds;
      }

      final response = await _dio.get(
        'api/Labs', // L كابيتال لتوحيد الشكل مع Doctors و Nurses
        queryParameters: queryParams,
      );

      // التأكد من استخراج القائمة بشكل صحيح
      if (response.data is List) {
        return (response.data as List)
            .map((json) => LabModel.fromJson(json))
            .toList();
      } else if (response.data is Map && response.data['data'] != null) {
        return (response.data['data'] as List)
            .map((json) => LabModel.fromJson(json))
            .toList();
      } else {
        // لو السيرفر باعت Pagination زي الدكاترة
        return (response.data['items'] as List)
            .map((json) => LabModel.fromJson(json))
            .toList();
      }
    } on DioException catch (e) {
      log("Labs API Error: ${e.response?.statusCode} - ${e.response?.data}");
      throw _handleError(e);
    }
  }

  Future<LabDetailsModel> getLabById(String id) async {
    try {
      final response = await _dio.get('api/Labs/$id');
      // نرسل الـ response.data كاملاً لأن الـ factory مجهز لاستقباله
      return LabDetailsModel.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<PaginatedList<ReviewModel>> getLabReviews(
    String labId, {
    int page = 1,
  }) async {
    try {
      final response = await _dio.get(
        'api/Reviews', // تأكدي أن هذا هو المسار الصحيح بدون / في البداية إذا كان الـ BaseUrl ينتهي بـ /
        queryParameters: {
          'TargetId': labId, // تغيير الاسم ليتطابق مع الـ API Request
          'TargetType':
              'Lab', // أو القيمة المطلوبة في الـ API (مثل "1" أو "Lab")
          'pageNumber': page,
          'pageSize': 10,
        },
      );

      return PaginatedList<ReviewModel>.fromJson(
        response.data,
        (itemJson) => ReviewModel.fromJson(itemJson),
      );
    } on DioException catch (e) {
      log("Dio Error: ${e.response?.statusCode} - ${e.response?.data}");
      throw "Unable to Load Reviews";
    }
  }

  Future<void> bookLabAppointment({
    required String labId,
    required String date,
    required String appointmentType,
    required List<String> labTestsIds,
    required String token,
    String? startTime,
    String? notes,
    String? address,
  }) async {
    try {
      final data = {
        'labId': labId,
        'date': date,
        'appointmentType': appointmentType,
        'startTime': startTime,
        'labTestsIds': labTestsIds,
      };

      if (notes != null && notes.isNotEmpty) {
        data['notes'] = notes;
      }

      // 👇 المهم هنا
      if (appointmentType == "HomeVisit") {
        if (address == null || address.trim().isEmpty) {
          throw Exception("Address is required for Home Visit");
        }
        data['address'] = address.trim();
      }

      await _dio.post(
        'api/lab-appointments',
        data: data,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
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

  T handleResponse<T>(DetailsService<T> response) {
    if (response.isSuccess && response.value != null) {
      return response.value!;
    } else {
      throw Exception(response.error?.description ?? 'Unknown error');
    }
  }

  // --- Specialty Methods ---

  Future<List<Specialty>> getAllSpecialties() async {
    final response = await _dio.get('api/Specialties'); // تأكد من المسار الصح
    return (response.data as List)
        .map((json) => Specialty.fromJson(json))
        .toList();
  }

  Future<List<Test>> fetchTests() async {
    try {
      final response = await _dio.get(
        'api/Tests',
      ); // تأكد من المسار الصحيح حسب الـ API عندك

      if (response.statusCode == 200) {
        // بما أن الـ Dio بيعمل jsonDecode تلقائياً، الـ response.data هيكون List
        List<dynamic> data = response.data;
        return data.map((json) => Test.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load tests');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
