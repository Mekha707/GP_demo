import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healthcareapp_try1/Bloc/NavigationBloc/navigation_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthServiceLogout {
  static Future<void> logout(BuildContext context) async {
    context.read<NavigationBloc>().add(TabChanged(0));

    // 1️⃣ مسح بيانات تسجيل الدخول
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
    // أو:
    // await prefs.clear();

    // 2️⃣ توجيه المستخدم لصفحة تسجيل الدخول
    if (context.mounted) {
      Navigator.pushNamedAndRemoveUntil(context, 'LoginPage', (route) => false);
    }
  }
}
