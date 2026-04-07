import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:healthcareapp_try1/API/logout_service.dart';
import 'package:healthcareapp_try1/Bloc/Auth_Bloc/Patient_Profile.dart/patient_profile_cubit.dart';
import 'package:healthcareapp_try1/Bloc/Auth_Bloc/Patient_Profile.dart/patient_profile_state.dart';
import 'package:healthcareapp_try1/Bloc/NavigationBloc/navigation_bloc.dart';
// استيراد الـ Bloc الجديد والصفحة

import 'package:healthcareapp_try1/Buttons/icons_heart_stet.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:healthcareapp_try1/Pages/Auth/change_password_page.dart';
import 'package:healthcareapp_try1/Pages/Booking/booking_page.dart';
import 'package:healthcareapp_try1/Pages/Booking/my_booking_page.dart';
import 'package:healthcareapp_try1/Pages/Home/ambulance_page.dart';
import 'package:healthcareapp_try1/Pages/Home/homepage_content.dart';
import 'package:healthcareapp_try1/Pages/Home/profile_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isNavigating = false;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final bool isTablet = size.width > 600;

    final List<Widget> pages = [
      HomePageContent(),
      BookingPage(),
      const Center(child: Text("AI Medical Assistant")),
      const Center(child: Text("Health Community")),
      AmbulancePage(),
    ];

    // نستخدم MultiBlocListener إذا كان لديك مستمعين كثر، أو BlocListener واحد هنا
    return BlocListener<ProfileCubit, ProfileState>(
      listener: (context, state) async {
        if (state is ProfileLoading) {
          if (!_isNavigating) {
            // ✅ بس لو مش بنتنقل
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (_) => const Center(child: CircularProgressIndicator()),
            );
          }
        } else if (state is ProfileSuccess) {
          if (_isNavigating) return; // ✅ لو بالفعل بنتنقل، اتجاهل
          _isNavigating = true;

          if (Navigator.canPop(context)) Navigator.pop(context); // اقفل loading

          final updated = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => PatientProfilePage(profile: state.profile),
            ),
          );

          _isNavigating = false; // ✅ خلاص رجعنا

          if (updated == true && context.mounted) {
            context.read<ProfileCubit>().getProfile();
          }
        } else if (state is ProfileError) {
          if (Navigator.canPop(context)) Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        }
      },
      child: BlocBuilder<NavigationBloc, NavigationState>(
        builder: (context, state) {
          return Scaffold(
            extendBody: true,
            backgroundColor: Colors.grey[50],
            appBar: AppBar(
              backgroundColor: Colors.grey[100],
              animateColor: true,
              scrolledUnderElevation: 0,
              automaticallyImplyLeading: false,
              elevation: 0,
              toolbarHeight: isTablet ? 80 : 70,
              title: Row(
                children: [
                  const Iconheartstet(),
                  SizedBox(width: size.width * 0.03),
                  Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(
                      "HealthCare",
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: "Cotta",
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              // أضفت زر لفتح الـ Drawer لأنك استخدمت endDrawer
              actions: [
                Builder(
                  builder: (context) => IconButton(
                    icon: const Icon(Icons.menu, color: Colors.black),
                    onPressed: () => Scaffold.of(context).openEndDrawer(),
                  ),
                ),
              ],
            ),
            endDrawer: Drawer(
              backgroundColor: Colors.grey.shade100,
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  SizedBox(
                    height: 85,
                    child: DrawerHeader(
                      decoration: BoxDecoration(color: Color(0xff0861dd)),
                      child: Center(
                        child: Text(
                          "Settings",
                          style: TextStyle(
                            color: Colors.grey.shade100,
                            fontFamily: 'Cotta',
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.person_outline,
                      color: Colors.grey.shade700,
                    ),
                    title: Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Text(
                        "Profile",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade700,
                          fontFamily: 'Agency',
                        ),
                      ),
                    ),
                    onTap: () {
                      // 1. نقفل الـ Drawer
                      Navigator.pop(context);
                      log("Testing Profile Click...");

                      // 2. نطلب البيانات من الـ Bloc (سيتم التقاط الحالة في الـ Listener بالأعلى)
                      context.read<ProfileCubit>().getProfile();
                    },
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.calendar_month,
                      color: Colors.grey.shade700,
                    ),
                    title: Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Text(
                        "My Booking",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade700,
                          fontFamily: 'Agency',
                        ),
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => MyBookingPage()),
                      );
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.chat, color: Colors.grey.shade700),
                    title: Text(
                      "My Conversations",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade700,
                        fontFamily: 'Agency',
                      ),
                    ),
                    onTap: () {},
                  ),
                  ListTile(
                    leading: Icon(Icons.lock, color: Colors.grey.shade700),
                    title: Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        "Change Password",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade700,
                          fontFamily: 'Agency',
                        ),
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ChangePasswordPage(),
                        ),
                      );
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.logout, color: Colors.grey.shade700),
                    title: Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        "Logout",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade700,
                          fontFamily: 'Agency',
                        ),
                      ),
                    ),
                    onTap: () async {
                      context.read<NavigationBloc>().add(TabChanged(0));
                      await AuthServiceLogout.logout(context);
                    },
                  ),
                ],
              ),
            ),
            body: SafeArea(
              bottom: false,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: pages[state.selectedIndex],
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return FadeTransition(opacity: animation, child: child);
                },
              ),
            ),
            bottomNavigationBar: CurvedNavigationBar(
              index: state.selectedIndex,
              backgroundColor: Colors.transparent,
              color: const Color(0xff0861dd),
              buttonBackgroundColor: const Color(0xff0861dd),
              height: isTablet ? 75 : 50,
              items: const <Widget>[
                Icon(Icons.home, color: Colors.white),
                Icon(Icons.calendar_today_rounded, color: Colors.white),
                Icon(Icons.smart_toy_sharp, color: Colors.white),
                Icon(Icons.supervised_user_circle_sharp, color: Colors.white),
                Icon(FontAwesomeIcons.truckMedical, color: Colors.white),
              ],
              onTap: (index) {
                context.read<NavigationBloc>().add(TabChanged(index));
              },
            ),
          );
        },
      ),
    );
  }
}
