// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healthcareapp_try1/API/auth_service.dart';
import 'package:healthcareapp_try1/Bloc/Auth_Bloc/ChangePassword_Bloc/change_password_bloc.dart';
import 'package:healthcareapp_try1/Bloc/Auth_Bloc/ChangePassword_Bloc/change_password_event.dart';
import 'package:healthcareapp_try1/Bloc/Auth_Bloc/ChangePassword_Bloc/change_password_state.dart';
import 'package:healthcareapp_try1/Buttons/buttons.dart';
import 'package:healthcareapp_try1/Buttons/icons_heart_stet.dart';
import 'package:healthcareapp_try1/Widgets/password_Filed.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final TextEditingController currentPasswordController =
      TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return BlocProvider(
      create: (context) => ChangePasswordBloc(AuthService()),
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
                  child: BlocConsumer<ChangePasswordBloc, ChangePasswordState>(
                    listener: (context, state) {
                      if (state.status == ChangePasswordStatus.success) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Password changed successfully! ✓'),
                            backgroundColor: Colors.green,
                            duration: Duration(
                              seconds: 1,
                            ), // تقليل المدة قليلاً
                          ),
                        );
                        Future.delayed(const Duration(milliseconds: 1500), () {
                          if (mounted) {
                            Navigator.of(context).pop();
                          }
                        });
                      } else if (state.status == ChangePasswordStatus.error) {
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
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Cotta',
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Change Password',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey.shade700,
                                fontFamily: 'Agency',
                              ),
                            ),
                            const SizedBox(height: 20),

                            // Current Password
                            PasswordField(
                              controller: currentPasswordController,
                              showReq: false,
                              label: "Current ",
                            ),
                            const SizedBox(height: 10),

                            // New Password
                            PasswordField(
                              controller: newPasswordController,
                              label: "New ",
                            ),
                            const SizedBox(height: 15),

                            // Confirm New Password
                            PasswordField(
                              controller: confirmPasswordController,
                              label: "Confirm ",
                              showReq: false,
                            ),
                            const SizedBox(height: 20),

                            state.status == ChangePasswordStatus.loading
                                ? const CircularProgressIndicator(
                                    color: Color(0xFF2D6CDF),
                                  )
                                : SizedBox(
                                    width: double.infinity,
                                    child: ButtonOfAuth(
                                      buttonText: "Change Password",
                                      buttoncolor: const Color(0xFF2D6CDF),
                                      fontcolor: Colors.white,
                                      onPressed: () {
                                        if (_formKey.currentState!.validate()) {
                                          context
                                              .read<ChangePasswordBloc>()
                                              .add(
                                                ChangePasswordSubmitted(
                                                  currentPassword:
                                                      currentPasswordController
                                                          .text,
                                                  newPassword:
                                                      newPasswordController
                                                          .text,
                                                ),
                                              );
                                        }
                                      },
                                    ),
                                  ),
                            const SizedBox(height: 10),

                            ButtonOfAuth(
                              buttonText: "Cancel",
                              fontcolor: Colors.black,
                              buttoncolor: Colors.grey.shade200,
                              onPressed: () => Navigator.pop(context),
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
