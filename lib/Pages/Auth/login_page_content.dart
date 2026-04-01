import 'package:flutter/material.dart';
import 'package:healthcareapp_try1/Buttons/Icons_heart_stet.dart';

class LoginContent extends StatelessWidget {
  final VoidCallback onSwitch;
  const LoginContent({super.key, required this.onSwitch});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: SingleChildScrollView(
        // للحماية من الـ Overflow
        child: Column(
          children: [
            const Iconheartstet(),
            const SizedBox(height: 10),
            const Text(
              'HealthCare Management System',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            // ... حقول الإدخال الخاصة بك هنا ...
            TextButton(
              onPressed: onSwitch, // ينقلنا للتسجيل
              child: const Text("Don't have an account? Sign Up"),
            ),
          ],
        ),
      ),
    );
  }
}
