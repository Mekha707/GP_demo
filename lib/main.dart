// ignore_for_file: unused_local_variable

import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healthcareapp_try1/API/auth_service.dart';
import 'package:healthcareapp_try1/API/profile_service.dart';
import 'package:healthcareapp_try1/API/user_service.dart';
import 'package:healthcareapp_try1/Bloc/Auth_Bloc/CityCubit/city_cubit.dart';
import 'package:healthcareapp_try1/Bloc/Auth_Bloc/LoginBloc/login_bloc.dart';
import 'package:healthcareapp_try1/Bloc/Auth_Bloc/Patient_Profile.dart/patient_profile_cubit.dart';
import 'package:healthcareapp_try1/Bloc/Auth_Bloc/RegisterationBloc/register_bloc.dart';
import 'package:healthcareapp_try1/Bloc/DetailsBoc/universal_details_cubit.dart';
import 'package:healthcareapp_try1/Bloc/MyBookingBloc/mybooking_cubit.dart';
import 'package:healthcareapp_try1/Bloc/NavigationBloc/navigation_bloc.dart';
import 'package:healthcareapp_try1/Bloc/User_Bloc/DoctorBloc/doctor_bloc.dart';
import 'package:healthcareapp_try1/Bloc/User_Bloc/LabBloc/lab_bloc.dart';
import 'package:healthcareapp_try1/Bloc/User_Bloc/NurseBloc/nurse_bloc.dart';
import 'package:healthcareapp_try1/Bloc/User_Bloc/SpecialtyBloc/specialty_bloc.dart';
import 'package:healthcareapp_try1/Bloc/User_Bloc/SpecialtyBloc/specialty_event.dart';
import 'package:healthcareapp_try1/Bloc/User_Bloc/Tests_Bloc/test_bloc.dart';
import 'package:healthcareapp_try1/Pages/Auth/change_password_page.dart';
import 'package:healthcareapp_try1/Pages/Auth/forget_password_page.dart';
import 'package:healthcareapp_try1/Pages/Auth/login_page.dart';
import 'package:healthcareapp_try1/Pages/Auth/register_step1.dart';
import 'package:healthcareapp_try1/Pages/Auth/register_step2.dart';
import 'package:healthcareapp_try1/Pages/Booking/booking_page.dart';
import 'package:healthcareapp_try1/Pages/Home/home_page1.dart';
import 'package:healthcareapp_try1/Pages/Home/splash_page.dart';
import 'package:healthcareapp_try1/Widgets/slide_route.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  // قراءة الحالة، وإذا كانت null نعتبرها false
  bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

  final authService = AuthService();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<RegisterBloc>(
          create: (context) => RegisterBloc(authService),
        ),
        BlocProvider<LoginBloc>(create: (context) => LoginBloc(authService)),
        BlocProvider<NavigationBloc>(create: (context) => NavigationBloc()),
        BlocProvider<DoctorsBloc>(
          create: (context) => DoctorsBloc(UserService()),
        ),
        BlocProvider<LabsBloc>(create: (context) => LabsBloc(UserService())),
        BlocProvider<AppointmentsCubit>(
          create: (context) => AppointmentsCubit(ProfileService()),
        ),

        BlocProvider(
          create: (context) =>
              ProfileCubit(AuthService()), // تأكد من تمرير الـ Service الصحيح
        ),
        BlocProvider(
          create: (context) => NursesBloc(nurseService: UserService()),
        ),
        BlocProvider(
          create: (context) =>
              SpecialtyBloc(UserService())..add(LoadSpecialties()),
        ),
        BlocProvider(create: (context) => CitiesCubit(authService)),
        BlocProvider(
          create: (context) => HealthcareDetailsCubit(UserService()),
        ),
        BlocProvider(create: (context) => TestBloc(UserService())),
        RepositoryProvider<UserService>(create: (_) => UserService()),
      ],
      child: MainApp(isLoggedIn: isLoggedIn),
    ),
  );
}

class MainApp extends StatefulWidget {
  final bool isLoggedIn; // تعريف المتغير
  const MainApp({super.key, required this.isLoggedIn});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  final _appLinks = AppLinks();
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    _appLinks.uriLinkStream.listen((uri) {
      if (uri.host == 'confirm-email') {
        final userId = uri.queryParameters['userId'];
        final token = uri.queryParameters['token'];
        navigatorKey.currentState?.pushReplacementNamed(
          'VerifyEmail',
          arguments: {'email': '', 'token': token},
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.black, // جعل شريط النظام شفاف
        systemNavigationBarIconBrightness:
            Brightness.dark, // لون الأيقونات (أندرويد)
      ),
    );

    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case 'Login':
            return slideLeft2Right(LoginPage());
          case 'Register1':
            return slideRight2Left(RegisterStep1());
          case 'Register2':
            return slideRight2Left(RegisterStep2());
          case 'Home':
            return slideRight2Left(HomePage());
          case 'BookingPage':
            return slideRight2Left(BookingPage());
          case 'ForgotPassword':
            return slideRight2Left(ForgotPasswordPage());
          case 'ChangePassword':
            return slideRight2Left(ChangePasswordPage());
          case '/':
            return slideRight2Left(SplashScreen(isLoggedIn: widget.isLoggedIn));
          default:
            return slideRight2Left(LoginPage());
        }
      },

      initialRoute: 'Home',
    );
  }
}
