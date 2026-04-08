// ignore_for_file: deprecated_member_use, avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healthcareapp_try1/Bloc/Auth_Bloc/LoginBloc/login_bloc.dart';
import 'package:healthcareapp_try1/Bloc/Auth_Bloc/LoginBloc/login_event.dart';
import 'package:healthcareapp_try1/Buttons/buttons.dart';
import 'package:healthcareapp_try1/Buttons/icons_heart_stet.dart';
import 'package:healthcareapp_try1/Pages/Auth/FormFields_Login_Register.dart';

import '../../Bloc/Auth_Bloc/LoginBloc/login_state.dart';
// import 'package:healthcareapp_try1/Buttons/buttons.dart';
// import 'package:healthcareapp_try1/Widgets/FormFields_Login_Register.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
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
              const Color(0xffc4edff).withOpacity(0.2),
            ],
          ),
        ),

        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: size.height),
            child: Center(
              // Login Conatiner
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
                child: BlocConsumer<LoginBloc, LoginState>(
                  listener: (context, state) {
                    if (state is LoginSuccess) {
                      // في حال النجاح ننتقل للصفحة الرئيسية
                      Navigator.pushReplacementNamed(context, 'Home');
                    } else if (state is LoginFailure) {
                      // في حال الفشل نظهر رسالة خطأ
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(state.error),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  builder: (context, state) {
                    return Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Iconheartstet(),
                          SizedBox(height: 10),
                          // Texts
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
                            'Login to your account',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey.shade700,
                              fontFamily: 'Agency',
                            ),
                          ),
                          SizedBox(height: 10),

                          // Email
                          BuiltEmailField(emailController: emailController),
                          SizedBox(height: 10),

                          // Password
                          BuiltPasswordField(
                            passwordController: passwordController,
                          ),
                          SizedBox(height: 10),

                          // Forget Password & Sign Up Row
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              //Register
                              Align(
                                alignment: Alignment.topCenter,
                                child: TextButton(
                                  onPressed: () {
                                    Navigator.pushNamed(context, 'Register1');
                                  },
                                  child: Text(
                                    "Sign Up",
                                    style: TextStyle(
                                      color: Color(0xff0861dd),
                                      fontSize: 13,
                                      fontFamily: 'Agency',
                                    ),
                                  ),
                                ),
                              ),

                              // FORGET PASSWORD ?
                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                  onPressed: () {
                                    Navigator.pushNamed(
                                      context,
                                      'ForgotPassword',
                                    );
                                  },
                                  child: Text(
                                    "Forget Password ?",
                                    style: TextStyle(
                                      color: Color(0xff0861dd),
                                      fontSize: 12,
                                      fontFamily: 'Agency',
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20),

                          // Login
                          state is LoginLoading
                              ? const CircularProgressIndicator() // إظهار تحميل عند الضغط
                              : SizedBox(
                                  width: double.infinity,
                                  child: ButtonOfAuth(
                                    buttonText: "Login",
                                    buttoncolor: Color(0xFF2D6CDF),
                                    fontcolor: Colors.white,
                                    onPressed: () {
                                      if (_formKey.currentState!.validate()) {
                                        context.read<LoginBloc>().add(
                                          LoginSubmitted(
                                            email: emailController.text,
                                            password: passwordController.text,
                                          ),
                                        );
                                      } else {
                                        // If the form is invalid, display a snackbar or error message
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              'Please fix the errors in red',
                                            ),
                                          ),
                                        );
                                      }
                                    },
                                  ),
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
    );
  }
}
