// ignore_for_file: avoid_print

import 'package:dio/dio.dart';
import 'package:healthcareapp_try1/Models/Auth_Models/login_response_model.dart';
import 'package:healthcareapp_try1/Models/Auth_Models/patient_profile_model.dart';
import 'package:healthcareapp_try1/Models/Auth_Models/register_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final Dio _dio = Dio(
    BaseOptions(
      // Link Server from Hytham
      baseUrl: "https://unalterably-unasphalted-felton.ngrok-free.dev",
      connectTimeout: const Duration(
        seconds: 15,
      ), // زيادة الوقت قليلاً للشبكات الضعيفة
      receiveTimeout: const Duration(seconds: 15),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'ngrok-skip-browser-warning': 'true',
      },
    ),
  );
  AuthService() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final prefs = await SharedPreferences.getInstance();
          final token = prefs.getString('token');
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
      ),
    );
    _dio.interceptors.add(
      LogInterceptor(requestBody: true, responseBody: true),
    );
  }

  // ✅ Helper لاستخراج رسالة الخطأ من أي شكل response
  String _extractError(dynamic data, String fallback) {
    if (data is! Map) return fallback;

    if (data['message'] != null) return data['message'].toString();
    if (data['title'] != null) return data['title'].toString();
    if (data['errors'] != null) {
      final errors = data['errors'];
      if (errors is Map && errors.isNotEmpty) {
        final firstValue = errors.values.first;
        if (firstValue is List && firstValue.isNotEmpty) {
          return firstValue.first.toString();
        }
        return firstValue.toString();
      }
    }
    return fallback;
  }

  Future<LoginResponse> login(String email, String password) async {
    try {
      final response = await _dio.post(
        '/api/auth/login',
        data: {"email": email, "password": password},
      );
      if (response.statusCode == 200) {
        final user = LoginResponse.fromJson(response.data);

        // ✅ تخزين في مكان واحد بس
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', user.token);
        await prefs.setString('userId', user.id);
        await prefs.setString('userEmail', user.email);
        await prefs.setString('userName', user.name);
        await prefs.setString('userRole', user.role);
        print("تم حفظ البيانات بنجاح!");

        return user;
      }
      throw "فشل تسجيل الدخول";
    } on DioException catch (e) {
      // هنا بنرمي الخطأ اللي جاي من السيرفر عشان الـ Bloc يستقبله
      throw _extractError(e.response?.data, "حدث خطأ ما أثناء تسجيل الدخول");
    }
  }

  // أضف هذه الدالة داخل كلاس AuthService
  Future<String> register(RegisterModel userModel) async {
    try {
      final response = await _dio.post(
        '/api/auth/register',
        data: userModel.toJson(),
      );

      final data = response.data;
      if (data is Map && data.containsKey('userId')) {
        return data['userId'].toString();
      }

      // لو السيرفر مش بيرجع userId (بيرجع success بس)
      return '';
    } on DioException catch (e) {
      throw _extractError(
        e.response?.data,
        "فشل تسجيل الحساب، تأكد من البيانات",
      );
    }
  }

  Future<void> forgotPassword(String email) async {
    try {
      await _dio.post(
        '/api/auth/forgot-password',
        data: {'email': email}, // ✅ email بس
      );
    } on DioException catch (e) {
      throw _extractError(
        e.response?.data,
        "فشل إرسال الإيميل، تأكد من الايميل",
      );
    }
  }

  Future<void> confirmEmail(String email, String otp) async {
    try {
      await _dio.post(
        '/api/auth/confirm-email',
        data: {'email': email, 'otp': otp},
      );
    } on DioException catch (e) {
      throw _extractError(e.response?.data, "كود التحقق غير صحيح");
    }
  }

  Future<void> verifyResetOtp({
    required String email,
    required String otp,
  }) async {
    try {
      await _dio.post(
        '/api/auth/verify-reset-otp',
        data: {'email': email, 'otp': otp},
      );
    } on DioException catch (e) {
      throw _extractError(e.response?.data, "كود التحقق غير صحيح");
    }
  }

  Future<void> resetPassword({
    required String email,
    required String otp,
    required String newPassword,
  }) async {
    try {
      await _dio.post(
        '/api/auth/reset-password',
        data: {'email': email, 'otp': otp, 'newPassword': newPassword},
      );
    } on DioException catch (e) {
      throw _extractError(e.response?.data, "فشل تغيير كلمة المرور");
    }
  }

  Future<void> resendConfirmationEmail(String email) async {
    try {
      await _dio.post(
        '/api/auth/resend-confirmation-email',
        data: {'email': email},
      );
    } on DioException catch (e) {
      throw _extractError(e.response?.data, "فشل إعادة إرسال الكود");
    }
  }

  Future<void> changePassword(
    String currentPassword,
    String newPassword,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');
    final String? userId = prefs.getString('userId');

    // تأكد أن التوكن موجود قبل محاولة الطلب
    if (token == null || userId == null) {
      throw "يرجى تسجيل الدخول أولاً";
    }

    try {
      await _dio.post(
        '/api/auth/change-password', // تم تعديل المسار ليستخدم الـ baseUrl تلقائياً
        data: {
          'userId': userId,
          'currentPassword': currentPassword,
          'newPassword': newPassword,
        },
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
    } on DioException catch (e) {
      throw _extractError(e.response?.data, "فشل تغيير كلمة المرور");
    } catch (e) {
      throw "حدث خطأ غير متوقع";
    }
  }

  Future<PatientProfile> getPatientProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');

    if (token == null) {
      throw Exception("Authentication token not found.");
    }

    try {
      final response = await _dio.get(
        "/api/patients/profile",
      ); // ✅ مش محتاج headers هنا

      if (response.statusCode == 200) {
        return PatientProfile.fromJson(response.data);
      } else {
        throw Exception("Unexpected error: ${response.statusCode}");
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw "An unknown error occurred: $e";
    }
  }

  Future<void> updatePatientProfile({
    required String userId,
    required String name,
    required String phoneNumber,
    required String address,
    String? addressUrl,
    required String city,
    double? weight,
  }) async {
    final formData = FormData.fromMap({
      "UserId": userId,
      "Name": name,
      "PhoneNumber": phoneNumber,
      "Address": address,
      "City": city,
      if (addressUrl != null && addressUrl.isNotEmpty) "AddressUrl": addressUrl,
      if (weight != null) "Weight": weight.toString(),
    });

    await _dio.put(
      "/api/patients/profile",
      data: formData,
      options: Options(contentType: "multipart/form-data"),
    );
  }

  Future<List<String>> getCities() async {
    try {
      final response = await _dio.get('/api/Locations/cities');
      final List data = response.data;
      return data.map((e) => e.toString()).toList();
    } on DioException catch (e) {
      throw _extractError(e.response?.data, "فشل تحميل المحافظات");
    }
  }

  String _handleDioError(DioException e) {
    if (e.response != null) {
      // إذا كان الخطأ قادم من السيرفر (مثل 401 أو 404)
      if (e.response?.statusCode == 401) {
        return "Session expired. Please login again.";
      }
      if (e.response?.statusCode == 403) {
        return "You don't have permission to access this.";
      }
      return e.response?.data['message'] ??
          "Server error: ${e.response?.statusCode}";
    } else {
      // أخطاء الاتصال (Timeout أو لا يوجد إنترنت)
      if (e.type == DioExceptionType.connectionTimeout) {
        return "Connection timeout";
      }
      if (e.type == DioExceptionType.receiveTimeout) {
        return "Server is taking too long to respond";
      }
      return "No Internet Connection";
    }
  }
}

