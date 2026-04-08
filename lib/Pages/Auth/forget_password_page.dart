// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healthcareapp_try1/API/auth_service.dart';
import 'package:healthcareapp_try1/Bloc/Auth_Bloc/Forget_Password.dart/forget_password_bloc.dart';
import 'package:healthcareapp_try1/Bloc/Auth_Bloc/Forget_Password.dart/forget_password_event.dart';
import 'package:healthcareapp_try1/Bloc/Auth_Bloc/Forget_Password.dart/forget_password_state.dart';
import 'package:healthcareapp_try1/Buttons/buttons.dart';
import 'package:healthcareapp_try1/Buttons/icons_heart_stet.dart';
import 'package:healthcareapp_try1/Pages/Auth/FormFields_Login_Register.dart';
import 'package:healthcareapp_try1/Pages/Auth/verify_otp_page.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return BlocProvider(
      create: (context) => ForgotPasswordBloc(AuthService()),
      child: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                const Color(0xffc4edff).withOpacity(0.2),
                Colors.white,
                const Color(0xffc4edff).withOpacity(0.2),
              ],
            ),
          ),
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: size.height),
              child: Center(
                child: Container(
                  width: size.width * 0.7,
                  padding: EdgeInsets.all(20),
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
                  child: BlocConsumer<ForgotPasswordBloc, ForgotPasswordState>(
                    listener: (context, state) {
                      if (state.status == ForgotPasswordStatus.success) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(state.successMessage),
                            backgroundColor: Colors.green,
                          ),
                        );

                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                VerifyOtpPage(email: emailController.text),
                          ),
                        );
                      } else if (state.status == ForgotPasswordStatus.error) {
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
                            Iconheartstet(),
                            SizedBox(height: 10),
                            Text(
                              'HealthCare Management System',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Cotta',
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Forgot Password',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey.shade700,
                                fontFamily: 'Agency',
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Enter your email to receive a reset link',
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey.shade700,
                                fontFamily: 'Agency',
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 10),

                            // Email
                            BuiltEmailField(emailController: emailController),
                            SizedBox(height: 20),

                            // Submit Button
                            state.status == ForgotPasswordStatus.loading
                                ? const CircularProgressIndicator()
                                : SizedBox(
                                    width: double.infinity,
                                    child: ButtonOfAuth(
                                      buttonText: "Send Reset Link",
                                      buttoncolor: Color(0xFF2D6CDF),
                                      fontcolor: Colors.white,
                                      onPressed: () {
                                        if (_formKey.currentState!.validate()) {
                                          context
                                              .read<ForgotPasswordBloc>()
                                              .add(
                                                ForgotPasswordSubmitted(
                                                  email: emailController.text,
                                                ),
                                              );
                                        }
                                      },
                                    ),
                                  ),
                            SizedBox(height: 10),

                            // Back To Login
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
