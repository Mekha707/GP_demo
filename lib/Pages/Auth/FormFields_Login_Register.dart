// ignore_for_file: file_names

import 'package:flutter/material.dart';

class BuiltEmailField extends StatelessWidget {
  const BuiltEmailField({
    super.key,
    required this.emailController,
    this.onChanged,
  });

  final TextEditingController emailController;
  final Function(String)? onChanged; // تعريف نوع المعامل

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your email';
        }

        // Simple email validation

        if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
          return 'Please enter a valid email';
        }
        return null;
      },
      style: TextStyle(fontSize: 14, color: Colors.black),
      controller: emailController,
      onChanged: onChanged,
      keyboardType: TextInputType.emailAddress, // مهم جداً للـ User Experience
      decoration: InputDecoration(
        labelText: "Email",
        labelStyle: TextStyle(
          color: Colors.grey.shade700,
          fontSize: 14,
          fontFamily: 'Agency',
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade400),
          borderRadius: BorderRadius.circular(15),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xff0861dd), width: 2),
          borderRadius: BorderRadius.circular(15),
        ),
        errorBorder: OutlineInputBorder(
          // شكل الحقل لما يحصل خطأ
          borderSide: const BorderSide(color: Color(0xffd51934), width: 1),
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
  }
}

class BuiltPasswordField extends StatefulWidget {
  const BuiltPasswordField({super.key, required this.passwordController});

  final TextEditingController passwordController;

  @override
  State<BuiltPasswordField> createState() => _BuiltPasswordFieldState();
}

class _BuiltPasswordFieldState extends State<BuiltPasswordField> {
  bool _isObscured = true;

  @override
  Widget build(BuildContext context) {
    // استخدام MediaQuery هنا اختياري لو حابب تغير حجم الخط بناءً على الشاشة
    double fontSize = MediaQuery.of(context).size.width > 600 ? 18 : 14;

    return TextFormField(
      controller: widget.passwordController,
      obscureText: _isObscured,
      keyboardType: TextInputType.visiblePassword, // يحسن تجربة المستخدم
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your password';
        }
        if (value.length < 8) {
          return 'Password must be at least 8 ';
        }
        return null;
      },
      decoration: InputDecoration(
        // إضافة Padding داخلي يخلي شكل الحقل Responsive ومنظم أكتر
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 15,
        ),
        suffixIcon: IconButton(
          icon: Icon(
            _isObscured ? Icons.visibility : Icons.visibility_off,
            color: Color(0xff0861dd),
          ),
          onPressed: () {
            setState(() {
              _isObscured = !_isObscured;
            });
          },
        ),
        labelText: "Password",
        labelStyle: TextStyle(
          color: Colors.grey.shade700,
          fontSize: fontSize,
          fontFamily: 'Agency',
        ), // hintText: "Enter your password",
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade400),
          borderRadius: BorderRadius.circular(15),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xff0861dd), width: 2),
          borderRadius: BorderRadius.circular(15),
        ),
        errorBorder: OutlineInputBorder(
          // شكل الحقل لما يحصل خطأ
          borderSide: const BorderSide(color: Color(0xffd51934), width: 1),
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
  }
}
