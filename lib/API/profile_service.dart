import 'package:dio/dio.dart';
import 'package:healthcareapp_try1/Models/Auth_Models/update_profile_model.dart';

class ProfileService {
  final Dio dio = Dio();

  Future<void> updateProfile(UpdateProfileModel model) async {
    await dio.put(
      "https://unalterably-unasphalted-felton.ngrok-free.dev",
      data: model.toJson(),
    );
  }
}
