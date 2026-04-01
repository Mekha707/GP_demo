// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:healthcareapp_try1/Bloc/NavigationBloc/navigation_bloc.dart';
import 'package:healthcareapp_try1/Buttons/buttons.dart';
import 'package:healthcareapp_try1/Models/Users_Models/specialty_model.dart';
import 'package:healthcareapp_try1/Widgets/home_content_ourservices_card.dart';
import 'package:healthcareapp_try1/Widgets/homecontent_ai_powerd_magic.dart';
import 'package:healthcareapp_try1/Widgets/specialty_card.dart';

class HomePageContent extends StatefulWidget {
  const HomePageContent({super.key});

  @override
  State<HomePageContent> createState() => _HomepageContentState();
}

class _HomepageContentState extends State<HomePageContent> {
  // 2. داخل الـ Widget الخاص بك
  // داخل كلاس _SearchForDoctorState
  List<Specialty> specialties = [
    Specialty(
      id: "019cc30c-c8b9-71a2-a5b2-8d1bd91da326", // Cardiology ID
      name: "Cardiology",
      icon: Icons.favorite,
      color: const Color(0xffe7000b),
    ),
    Specialty(
      id: "019cc30d-some-uuid-for-neurology",
      name: "Neurology",
      icon: FontAwesomeIcons.brain,
      color: const Color(0xff9a16fa),
    ),
    Specialty(
      id: "019cc30e-some-uuid-for-pediatrics",
      name: "Pediatrics",
      icon: Icons.child_care,
      color: const Color(0xff0861dd),
    ),
    Specialty(
      id: "019cc30f-some-uuid-for-orthopedics",
      name: "Orthopedics",
      icon: FontAwesomeIcons.bone,
      color: const Color(0xffe58017),
    ),
    Specialty(
      id: "019cc310-some-uuid-for-ophthalmology",
      name: "Ophtmalmology",
      icon: Icons.remove_red_eye_outlined,
      color: const Color(0xff00a63e),
    ),
    Specialty(
      id: "019cc311-some-uuid-for-general",
      name: "General",
      icon: FontAwesomeIcons.stethoscope,
      color: const Color(0xff5642f7),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final bool isTablet = size.width > 600;

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      // body: BlocBuilder<DoctorCubit, DoctorState>(
      //   builder: (context, state) {
      //     // 1. حالة التحميل
      //     if (state.isLoading) {
      //       return const Center(child: CircularProgressIndicator());
      //     }

      //     // 2. حالة الخطأ
      //     if (state.errorMessage != null) {
      //       return Center(child: Text("Error: ${state.errorMessage}"));
      //     }

      // 3. عرض المحتوى عند نجاح جلب البيانات
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.all(size.width * 0.05),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start, // جعل المحاذاة لليسار/البداية
            children: [
              // الكارت البنفسجي (نفس كودك السابق مع تحسينات بسيطة)
              _buildMainBanner(context, isTablet, size),

              const SizedBox(height: 30),
              // Browse By Specialty
              _buildSectionHeader("Browse By Specialty", isTablet, null),
              const SizedBox(height: 20),
              _buildSpecialtyGrid(),

              // AI Symptom
              _buildAISymptomCheckerCard(size),
              const SizedBox(height: 30),

              // Top Doctors
              _buildSectionHeader("Top Doctors", isTablet, () {
                context.read<NavigationBloc>().add(TabChanged(1));
              }),
              _buildSubText("Consult with our expert healthcare professionals"),
              const SizedBox(height: 15),
              // _buildDoctorsList(state.doctors),

              // Our Services
              _buildSectionHeader("0ur Services", isTablet, null),
              _buildSubText("Comprehensive healthcare solutions for you"),
              const SizedBox(height: 15),
              _buildServicesList(),
            ],
          ),
        ),
      ),
    );
  }

  // --- Widgets فرعية لتنظيم الكود ---

  Widget _buildMainBanner(BuildContext context, bool isTablet, Size size) {
    return Center(
      child: Container(
        width: size.width > 800 ? 800 : double.infinity,
        padding: EdgeInsets.all(isTablet ? 30.0 : 20.0),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xff0861dd), Color(0xff7012ce)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Your Health, Our Priority",
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontFamily: 'Cotta',
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Access quality healthcare from the comfort of your home. Book appointments, consult with specialists, and get AI-powered health insights.",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontFamily: 'Agency',
                fontSize: isTablet ? 22 : 17,
              ),
            ),
            const SizedBox(height: 20),
            HomeContentPurpuleCardButton(
              icon: Icons.calendar_today_rounded,
              buttonText: 'Book Appointment',
              foreColor: const Color(0xff0861dd),
              backColor: Colors.white,
              onpressed: () =>
                  context.read<NavigationBloc>().add(TabChanged(1)),
            ),
            SizedBox(height: 10),
            HomeContentPurpuleCardButton(
              icon: FontAwesomeIcons.robot,
              buttonText: 'Try AI Sympotom Checker ',
              foreColor: const Color(0xff0861dd),
              backColor: Colors.white,
              onpressed: () =>
                  context.read<NavigationBloc>().add(TabChanged(2)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(
    String title,
    bool isTablet,
    VoidCallback? onSeeAll,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: isTablet ? 22 : 18,
            fontWeight: FontWeight.bold,
            fontFamily: 'Cotta',
          ),
        ),
        if (onSeeAll != null)
          TextButton(
            onPressed: onSeeAll,
            child: const Text(
              "See All",
              style: TextStyle(
                color: Color(0xff0861dd),
                fontWeight: FontWeight.bold,
                fontFamily: 'Agency',
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildSubText(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 14,
        color: Colors.grey.shade600,
        fontFamily: 'Agency',
      ),
    );
  }

  Widget _buildSpecialtyGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: specialties.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 15,
        mainAxisSpacing: 15,
        childAspectRatio: 0.9,
      ),
      itemBuilder: (context, index) => SpecialtyCard(
        icon: specialties[index].icon,
        specialtyName: specialties[index].name,
        iconColor: specialties[index].color,
        backGroundColor: specialties[index].color.withOpacity(0.1),
      ),
    );
  }

  // // ignore: unused_element
  // Widget _buildDoctorsList(List doctors) {
  //   return SizedBox(
  //     height: 200,
  //     child: ListView.builder(
  //       scrollDirection: Axis.horizontal,
  //       itemCount: doctors.length,
  //       itemBuilder: (context, index) {
  //         return MedicalStaffCard(medicalstaff: doctors[index]);
  //       },
  //     ),
  //   );
  // }

  Widget _buildAISymptomCheckerCard(Size size) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xfff2f5fe),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xff0861dd).withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(FontAwesomeIcons.robot, color: Color(0xff0861dd)),
              SizedBox(width: 15),
              Text(
                "AI Symptom Checker",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Cotta',
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          HomeContentAIPowerdmagicWithText(
            magicText: 'Instant symptom analysis',
          ),
          SizedBox(height: 8),
          HomeContentAIPowerdmagicWithText(
            magicText: 'Recommended specialists',
          ),
          SizedBox(height: 8),
          HomeContentAIPowerdmagicWithText(magicText: '24/7 availability'),
          SizedBox(height: 8),

          const SizedBox(height: 15),
          HomeContentPurpuleCardButton(
            icon: Icons.bolt,
            buttonText: "Check Now",
            onpressed: () {
              context.read<NavigationBloc>().add(TabChanged(2));
            },
            foreColor: Colors.white,
            backColor: const Color(0xff0861dd),
          ),
        ],
      ),
    );
  }

  Widget _buildServicesList() {
    return Column(
      children: [
        HomeContentOurServiceCard(
          iconColor: const Color(0xff0861dd),
          title: "Easy Booking",
          description: "Book appointments with top doctors instantly.",
          icon: FontAwesomeIcons.calendar,
          onpressed: () {
            context.read<NavigationBloc>().add(TabChanged(1));
          },
        ),
        const SizedBox(height: 10),
        HomeContentOurServiceCard(
          iconColor: const Color(0xffd100ff),
          title: "AI Health Assistant",
          description: "24/7 AI-powered health insights.",
          icon: FontAwesomeIcons.robot,
          onpressed: () {
            context.read<NavigationBloc>().add(TabChanged(2));
          },
        ),
        const SizedBox(height: 10),
        HomeContentOurServiceCard(
          iconColor: Colors.lightGreen,
          title: "Health Community",
          description:
              "Connect with healthcare professionals and get expert advice on health topics.",
          icon: FontAwesomeIcons.message,
          onpressed: () {
            context.read<NavigationBloc>().add(TabChanged(3));
          },
        ),
      ],
    );
  }
}
