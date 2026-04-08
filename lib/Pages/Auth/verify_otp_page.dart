// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healthcareapp_try1/API/auth_service.dart';
import 'package:healthcareapp_try1/Bloc/Auth_Bloc/Reset_Password/reset_password_bloc.dart';
import 'package:healthcareapp_try1/Bloc/Auth_Bloc/Reset_Password/reset_password_event.dart';
import 'package:healthcareapp_try1/Bloc/Auth_Bloc/Reset_Password/reset_password_state.dart';
import 'package:healthcareapp_try1/Buttons/buttons.dart';
import 'package:healthcareapp_try1/Buttons/icons_heart_stet.dart';
import 'package:healthcareapp_try1/Pages/Auth/reset_password._page.dart';
import 'package:pinput/pinput.dart';

class VerifyOtpPage extends StatefulWidget {
  const VerifyOtpPage({super.key, required this.email});
  final String email;

  @override
  State<VerifyOtpPage> createState() => _VerifyOtpPageState();
}

class _VerifyOtpPageState extends State<VerifyOtpPage> {
  String _pin = '';

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

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
                      if (state.status == ResetPasswordStatus.otpVerified) {
                        // ✅ روح لـ ResetPassword وبعت email + otp

                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ResetPasswordPage(
                              email: widget.email,
                              otp: state.verifiedOtp,
                            ),
                          ),
                        );
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
                      return Column(
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
                            'Verify OTP',
                            style: TextStyle(
                              fontSize: 16,
                              fontFamily: 'Agency',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
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

                          Pinput(
                            length: 6,
                            defaultPinTheme: defaultPinTheme,
                            focusedPinTheme: focusedPinTheme,
                            submittedPinTheme: submittedPinTheme,
                            onChanged: (pin) => _pin = pin,
                            onCompleted: (pin) => _pin = pin,
                          ),
                          const SizedBox(height: 25),

                          state.status == ResetPasswordStatus.loading
                              ? const CircularProgressIndicator(
                                  color: Color(0xFF2D6CDF),
                                )
                              : SizedBox(
                                  width: double.infinity,
                                  child: ButtonOfAuth(
                                    buttonText: "Verify",
                                    buttoncolor: const Color(0xFF2D6CDF),
                                    fontcolor: Colors.white,
                                    onPressed: () {
                                      if (_pin.length != 6) {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              'Please enter the 6-digit code',
                                            ),
                                          ),
                                        );
                                        return;
                                      }
                                      context.read<ResetPasswordBloc>().add(
                                        VerifyOtpSubmitted(
                                          email: widget.email,
                                          otp: _pin,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                          const SizedBox(height: 10),

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
