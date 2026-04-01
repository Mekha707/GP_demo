// ignore_for_file: use_super_parameters

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healthcareapp_try1/Bloc/Auth_Bloc/RegisterationBloc/register_bloc.dart';
import 'package:healthcareapp_try1/Bloc/Auth_Bloc/RegisterationBloc/register_event.dart';
import 'package:healthcareapp_try1/Bloc/Auth_Bloc/RegisterationBloc/register_state.dart';

class PasswordField extends StatefulWidget {
  // حولناها لـ StatefulWidget للتحكم في الرؤية محلياً
  final TextEditingController controller;
  final bool showReq;
  final String label;

  const PasswordField({
    Key? key,
    required this.controller,
    this.showReq = true,
    this.label = "Password",
  }) : super(key: key);

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _isObscure = true; // تحكم محلي في الرؤية بعيداً عن الـ Bloc

  @override
  Widget build(BuildContext context) {
    // نستخدم BlocBuilder فقط إذا كان showReq مفعلاً (لأننا نحتاج الـ Bloc لحساب القوة)
    if (widget.showReq) {
      return BlocBuilder<RegisterBloc, RegisterState>(
        builder: (context, state) {
          return Column(
            children: [
              _buildTextField(),
              const SizedBox(height: 12),
              _buildStrengthIndicator(state),
            ],
          );
        },
      );
    } else {
      // إذا كان الحقل للباسورد الحالي (لا يحتاج متطلبات)
      return _buildTextField();
    }
  }

  Widget _buildTextField() {
    return TextFormField(
      controller: widget.controller,
      obscureText: _isObscure,
      onChanged: (val) {
        if (widget.showReq) {
          context.read<RegisterBloc>().add(PasswordChanged(val));
        }
      },
      validator: (val) {
        if (val == null || val.isEmpty) return "Field is required";
        if (widget.showReq && val.length < 8) return "Password too short";
        return null;
      },
      decoration: InputDecoration(
        labelText: widget.label,
        labelStyle: TextStyle(
          color: Colors.grey.shade700,
          fontSize: 14,
          fontFamily: 'Agency',
        ),
        prefixIcon: const Icon(Icons.lock_outline, color: Color(0xff0861dd)),
        suffixIcon: IconButton(
          icon: Icon(_isObscure ? Icons.visibility_off : Icons.visibility),
          onPressed: () => setState(() => _isObscure = !_isObscure),
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
      ),
    );
  }

  Widget _buildStrengthIndicator(RegisterState state) {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: state.passwordStrength,
            minHeight: 6,
            color: state.strengthColor,
            backgroundColor: Colors.grey[300],
          ),
        ),

        // ... باقي أكواد الـ _buildReqItem التي لديك في الكود الأصلي ...
        SizedBox(height: 8),
        _buildReqItem(
          "8+ Characters",
          state.passwordRequirements['min'] ?? false,
        ),
        SizedBox(height: 4),
        _buildReqItem(
          "Uppercase Letter",
          state.passwordRequirements['upper'] ?? false,
        ),

        SizedBox(height: 4),
        _buildReqItem("Number", state.passwordRequirements['num'] ?? false),

        SizedBox(height: 4),
        _buildReqItem(
          "Special Character",
          state.passwordRequirements['special'] ?? false,
        ),
      ],
    );
  }

  Widget _buildReqItem(String text, bool isValid) {
    final Color color = isValid ? Colors.green : Colors.red;
    return Row(
      children: [
        // أنيميشن لتغيير الأيقونة واللون
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: Icon(
            isValid ? Icons.check_circle : Icons.cancel,
            key: ValueKey(isValid), // ضروري لكي يعرف الأنيميشن أن الحالة تغيرت
            color: color,
            size: 16,
          ),
        ),
        const SizedBox(width: 8),
        // أنيميشن لتغيير لون النص بسلاسة
        AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 300),
          style: TextStyle(
            color: color,
            fontSize: 13,
            fontWeight: isValid ? FontWeight.bold : FontWeight.normal,
            fontFamily: 'Agency',
          ),
          child: Text(text),
        ),
      ],
    );
  }
}
