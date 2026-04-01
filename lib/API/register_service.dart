import 'package:dio/dio.dart';

class RegisterService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl:
          'https://healthcare-try1.free.beeceptor.com', // استبدله برابط السيرفر الخاص بك
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );

  RegisterService() {
    _dio.interceptors.add(
      LogInterceptor(requestBody: true, responseBody: true),
    );
  }

  Future<Response> registerUser(Map<String, dynamic> data) async {
    try {
      // إرسال البيانات كـ POST request
      final response = await _dio.post('/register', data: data);
      return response;
    } on DioException catch (e) {
      // استخراج رسالة الخطأ من السيرفر إذا وجدت
      String errorMessage = e.response?.data['message'] ?? "Connection Error";
      throw errorMessage;
    }
  }
}
