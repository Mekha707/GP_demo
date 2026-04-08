// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healthcareapp_try1/API/auth_service.dart';
import 'package:healthcareapp_try1/Bloc/Auth_Bloc/ConfrimEmail_Bloc/confirm_email_bloc.dart';
import 'package:healthcareapp_try1/Bloc/Auth_Bloc/ConfrimEmail_Bloc/confirm_email_event.dart';
import 'package:healthcareapp_try1/Bloc/Auth_Bloc/ConfrimEmail_Bloc/confirm_email_state.dart';
import 'package:healthcareapp_try1/Buttons/buttons.dart';
import 'package:healthcareapp_try1/Buttons/icons_heart_stet.dart';
import 'package:pinput/pinput.dart';

class ConfirmEmailPage extends StatefulWidget {
  const ConfirmEmailPage({super.key, required this.email});
  final String email;
  @override
  State<ConfirmEmailPage> createState() => _ConfirmEmailPageState();
}

class _ConfirmEmailPageState extends State<ConfirmEmailPage> {
  final TextEditingController pinController = TextEditingController();
  String _pin = '';
  // داخل StatefulWidget في صفحة VerifyEmail

  @override
  void initState() {
    super.initState();
    log("Email has arrived succesfully  ${widget.email}");
  }

  @override
  void dispose() {
    pinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    // تأكد من القيمة في الـ Console

    // إعدادات التصميم الافتراضية لحقول إدخال الرمز (Pinput)
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: const TextStyle(
        fontSize: 22,
        color: Color.fromRGBO(30, 60, 87, 1),
        fontWeight: FontWeight.w600,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: const Color(0xff0861dd), width: 2),
      borderRadius: BorderRadius.circular(10),
    );

    final submittedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: const Color(0xFF2D6CDF)),
      borderRadius: BorderRadius.circular(10),
      color: const Color(0xFF2D6CDF).withOpacity(0.05),
    );

    return BlocProvider(
      create: (context) => ConfirmEmailBloc(AuthService()),
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
                  child: BlocConsumer<ConfirmEmailBloc, ConfirmEmailState>(
                    listener: (context, state) {
                      if (state.status == ConfirmEmailStatus.success) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Email successfully confirmed'),
                            backgroundColor: Colors.green,
                          ),
                        );
                        Future.delayed(const Duration(seconds: 2), () {
                          Navigator.pushReplacementNamed(context, 'Login');
                        });
                      } else if (state.status == ConfirmEmailStatus.error) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(state.errorMessage),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                    builder: (context, state) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Iconheartstet(),
                          const SizedBox(height: 10),
                          const Text(
                            'HealthCare Management System',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            'Confirm Email',
                            style: TextStyle(
                              fontSize: 18,
                              fontFamily: 'Agency',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          // عرض البريد الإلكتروني المستلم بشكل واضح
                          Text(
                            'Enter the 6-digit code sent to your email',
                            style: TextStyle(
                              fontSize: 12,
                              fontFamily: 'Agency',
                              color: Colors.grey.shade800,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 25),

                          // حقل إدخال الرمز OTP
                          Pinput(
                            length: 6,
                            controller: pinController,
                            defaultPinTheme: defaultPinTheme,
                            focusedPinTheme: focusedPinTheme,
                            submittedPinTheme: submittedPinTheme,
                            onChanged: (pin) => _pin = pin,
                            onCompleted: (pin) => _pin = pin,
                          ),
                          const SizedBox(height: 5),

                          // زر إعادة إرسال الرمز
                          TextButton(
                            onPressed: () async {
                              try {
                                await AuthService().resendConfirmationEmail(
                                  widget.email,
                                );
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'The code has been successfully resent',
                                    ),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(e.toString()),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            },
                            child: const Text(
                              "Didn't receive the code? Resend it.",
                              style: TextStyle(
                                color: Color(0xff0861dd),
                                fontSize: 12,
                                fontFamily: 'Agency',
                              ),
                            ),
                          ),
                          const SizedBox(height: 5),

                          // زر التأكيد مع حالة التحميل
                          state.status == ConfirmEmailStatus.loading
                              ? const CircularProgressIndicator(
                                  color: Color(0xFF2D6CDF),
                                )
                              : SizedBox(
                                  width: double.infinity,
                                  child: ButtonOfAuth(
                                    buttonText: "Confirm",
                                    buttoncolor: const Color(0xFF2D6CDF),
                                    fontcolor: Colors.white,
                                    onPressed: () {
                                      if (_pin.length == 6) {
                                        context.read<ConfirmEmailBloc>().add(
                                          ConfirmEmailSubmitted(
                                            email: widget.email,
                                            otp: _pin,
                                          ),
                                        );
                                      } else {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              'Please enter the 6-digit code',
                                            ),
                                          ),
                                        );
                                      }
                                    },
                                  ),
                                ),
                          const SizedBox(height: 10),

                          // زر العودة لتسجيل الدخول
                          ButtonOfAuth(
                            buttonText: "Back To Login",
                            fontcolor: Colors.black,
                            buttoncolor: Colors.grey.shade200,
                            onPressed: () {
                              Navigator.pushReplacementNamed(context, 'Login');
                            },
                          ),
                        ],
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
