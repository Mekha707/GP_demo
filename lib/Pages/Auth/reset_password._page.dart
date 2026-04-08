// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healthcareapp_try1/API/auth_service.dart';
import 'package:healthcareapp_try1/Bloc/Auth_Bloc/Reset_Password/reset_password_bloc.dart';
import 'package:healthcareapp_try1/Bloc/Auth_Bloc/Reset_Password/reset_password_event.dart';
import 'package:healthcareapp_try1/Bloc/Auth_Bloc/Reset_Password/reset_password_state.dart';
import 'package:healthcareapp_try1/Buttons/buttons.dart';
import 'package:healthcareapp_try1/Buttons/icons_heart_stet.dart';
import 'package:healthcareapp_try1/Widgets/password_Filed.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key, required this.email, required this.otp});
  final String email;
  final String otp;

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return BlocProvider(
      create: (context) => ResetPasswordBloc(AuthService()),
      child: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                const Color(0xffc4edff),
                Colors.white,
                Colors.white,
                const Color(0xffc4edff),
              ],
            ),
          ),
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: size.height),
              child: Center(
                child: Container(
                  width: size.width * 0.7,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.blueGrey[100]!),
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: BlocConsumer<ResetPasswordBloc, ResetPasswordState>(
                    listener: (context, state) {
                      if (state.status == ResetPasswordStatus.success) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Password reset successfully! ✓'),
                            backgroundColor: Colors.green,
                          ),
                        );
                        Navigator.pushReplacementNamed(context, 'Login');
                      } else if (state.status == ResetPasswordStatus.error) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(state.errorMessage),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                    builder: (context, state) {
                      return Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Iconheartstet(),
                            const SizedBox(height: 10),
                            const Text(
                              'HealthCare Management System',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                fontFamily: 'Cotta',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              'Set New Password',
                              style: TextStyle(
                                fontSize: 16,
                                fontFamily: 'Agency',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Enter your new password',
                              style: TextStyle(
                                fontSize: 11,
                                fontFamily: 'Agency',
                                color: Colors.grey.shade600,
                              ),
                            ),
                            const SizedBox(height: 20),

                            PasswordField(controller: passwordController),
                            const SizedBox(height: 15),

                            TextFormField(
                              controller: confirmPasswordController,
                              obscureText: true,
                              decoration: InputDecoration(
                                labelText: 'Confirm New Password',
                                labelStyle: TextStyle(fontFamily: 'Agency'),
                                prefixIcon: const Icon(
                                  Icons.lock_outline,
                                  color: Color(0xff0861dd),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: const BorderSide(
                                    color: Color(0xff0861dd),
                                    width: 2,
                                  ),
                                ),
                              ),
                              validator: (val) {
                                if (val == null || val.isEmpty) {
                                  return 'Required field';
                                }
                                if (val != passwordController.text) {
                                  return 'Passwords do not match';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),

                            state.status == ResetPasswordStatus.loading
                                ? const CircularProgressIndicator(
                                    color: Color(0xFF2D6CDF),
                                  )
                                : SizedBox(
                                    width: double.infinity,
                                    child: ButtonOfAuth(
                                      buttonText: "Reset Password",
                                      buttoncolor: const Color(0xFF2D6CDF),
                                      fontcolor: Colors.white,
                                      onPressed: () {
                                        if (_formKey.currentState!.validate()) {
                                          context.read<ResetPasswordBloc>().add(
                                            ResetPasswordSubmitted(
                                              email: widget.email,
                                              otp: widget.otp,
                                              newPassword:
                                                  passwordController.text,
                                            ),
                                          );
                                        }
                                      },
                                    ),
                                  ),
                            const SizedBox(height: 10),

                            ButtonOfAuth(
                              buttonText: "Back To Login",
                              fontcolor: Colors.black,
                              buttoncolor: Colors.grey.shade200,
                              onPressed: () {
                                Navigator.pushReplacementNamed(
                                  context,
                                  'Login',
                                );
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
