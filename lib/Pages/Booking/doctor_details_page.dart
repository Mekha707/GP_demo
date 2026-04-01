// ignore_for_file: deprecated_member_use, unused_element, must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healthcareapp_try1/API/user_service.dart';
import 'package:healthcareapp_try1/Bloc/DetailsBoc/doctor_details_cubit.dart';
import 'package:healthcareapp_try1/Widgets/custom_loader1.dart';
import 'package:healthcareapp_try1/Widgets/location_open_map.dart';
import 'package:healthcareapp_try1/core/string_extension.dart';

class DoctorDetailsPage extends StatelessWidget {
  final String doctorId;
  final UserService doctorService;
  const DoctorDetailsPage({
    super.key,
    required this.doctorId,
    required this.doctorService,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DoctorDetailsCubit(
        context
            .read<UserService>(), // ← لو بتستخدم get_it أو RepositoryProvider
      )..loadDoctor(doctorId),
      child: _DoctorDetailsView(),
    );
  }
}

class _DoctorDetailsView extends StatefulWidget {
  @override
  State<_DoctorDetailsView> createState() => _DoctorDetailsViewState();
}

class _DoctorDetailsViewState extends State<_DoctorDetailsView> {
  DateTime? selectedDate;

  String? selectedTime;

  String selectedService = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: BlocBuilder<DoctorDetailsCubit, DoctorDetailsState>(
        builder: (context, state) {
          if (state is DoctorDetailsLoading) {
            return const Center(
              child: CustomSpinner(color: Color(0xff0861dd), size: 40),
            );
          }

          if (state is DoctorDetailsError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.message),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () {
                      // retrigger من الـ cubit
                    },
                    child: const Text('Try Again'),
                  ),
                ],
              ),
            );
          }

          if (state is DoctorDetailsLoaded) {
            // final doctor = state.doctor;
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(context),

                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 16),
                        _buildBasicInfo(context),
                        const SizedBox(height: 10),
                        _buildSectionTitle("Clinic Location"),
                        const SizedBox(height: 5),
                        LocationTileWidget(address: state.doctor.address),
                        const SizedBox(height: 10),
                        _buildSectionTitle("About"),
                        _buildBioContainer(state.doctor.bio),
                        const SizedBox(height: 25),
                        _buildSectionTitle("Available Services"),
                        const SizedBox(height: 15),
                        _buildFeesSection(context),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }

          return const SizedBox();
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final doctor = context.select((DoctorDetailsCubit cubit) {
      final state = cubit.state;
      if (state is DoctorDetailsLoaded) {
        return state.doctor;
      }
      return null;
    });
    return Stack(
      children: [
        SizedBox(
          height: 350,
          width: double.infinity,
          child: doctor != null
              ? Image.network(
                  doctor.profilePictureUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    color: Colors.blue.shade50,
                    child: const Icon(
                      Icons.person,
                      size: 100,
                      color: Colors.blue,
                    ),
                  ),
                  loadingBuilder: (_, child, progress) {
                    if (progress == null) return child;
                    return Container(
                      color: Colors.blue.shade50,
                      child: const Center(
                        child: CustomSpinner(
                          color: Color(0xff0861dd),
                          size: 40,
                        ),
                      ),
                    );
                  },
                )
              : Container(
                  color: Colors.blue.shade50,
                  child: const Icon(
                    Icons.person,
                    size: 100,
                    color: Colors.blue,
                  ),
                ),
        ),
        Container(
          height: 350,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.center,
              colors: [Colors.black.withOpacity(0.4), Colors.transparent],
            ),
          ),
        ),
        SafeArea(
          child: IconButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.black54),
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ],
    );
  }

  Widget _buildBasicInfo(BuildContext context) {
    final doctor = context.select((DoctorDetailsCubit cubit) {
      final state = cubit.state;
      if (state is DoctorDetailsLoaded) {
        return state.doctor;
      }
      return null;
    });
    if (doctor == null) return const SizedBox();
    return Container(
      padding: const EdgeInsets.all(16),
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: Color(0xff0861dd).withOpacity(0.3)),
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: double.infinity,
            child: Text(
              doctor.name,
              textDirection: doctor.name.getDirection, // يمين أو شمال حسب اللغة
              textAlign: doctor.name.getTextAlign,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                fontFamily: doctor.name.isArabic ? 'ElMessiri' : 'Cotta',
              ),
            ),
          ),
          const SizedBox(height: 5),
          SizedBox(
            width: double.infinity,
            child: Text(
              doctor.specialtyName,
              textDirection:
                  doctor.specialtyName.getDirection, // يمين أو شمال حسب اللغة
              textAlign: doctor.specialtyName.getTextAlign,
              style: TextStyle(
                fontSize: 16,
                color: Colors.blue[700],
                fontWeight: FontWeight.w600,
                fontFamily: 'Agency',
              ),
            ),
          ),

          SizedBox(
            width: double.infinity,
            child: Text(
              doctor.title,
              textDirection:
                  doctor.title.getDirection, // يمين أو شمال حسب اللغة
              textAlign: doctor.title.getTextAlign,
              style: TextStyle(
                color: Colors.grey[700],
                fontFamily: doctor.title.isArabic ? 'ElMessiri' : 'Agency',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeesSection(BuildContext context) {
    final doctor = context.select((DoctorDetailsCubit cubit) {
      final state = cubit.state;
      if (state is DoctorDetailsLoaded) {
        return state.doctor;
      }
      return null;
    });

    if (doctor == null) return const SizedBox();

    return Column(
      children: [
        // خيارات الطبيب الإضافية
        if (doctor.allowHomeVisit)
          _buildFeeCard("Doctor Home Visit", doctor.homeFee, Icons.home),
        if (doctor.allowOnlineConsultation)
          _buildFeeCard(
            "Online Consultation",
            doctor.onlineFee,
            Icons.videocam,
          ),
      ],
    );
  }

  Widget _buildFeeCard(String type, double amount, IconData icon) {
    bool isSelected = selectedService == type; // هل هذه البطاقة مختارة؟

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedService = type;
          selectedTime = null;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xff0861dd).withOpacity(0.05)
              : Colors.white,
          border: Border.all(
            color: isSelected ? const Color(0xff0861dd) : Colors.grey.shade200,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected
                  ? const Color(0xff0861dd)
                  : Colors.grey.shade800,
            ),
            const SizedBox(width: 15),
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                type,
                style: TextStyle(
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected ? const Color(0xff0861dd) : Colors.black,
                  fontFamily: 'Agency',
                ),
              ),
            ),
            const Spacer(),
            Text(
              "$amount EGP",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.green : Colors.grey.shade800,
                fontFamily: 'Agency',
              ),
            ),
            const SizedBox(width: 10),
          ],
        ),
      ),
    );
  }

  Widget _buildBioContainer(String bio) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xff0861dd).withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Text(
        bio,
        textDirection: bio.getDirection,
        textAlign: bio.getTextAlign,
        style: TextStyle(
          color: Colors.grey[800],
          height: 1.5,
          fontFamily: bio.isArabic ? 'ElMessiri' : 'Agency',
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) => Text(
    title,
    style: const TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
      fontFamily: 'Cotta',
    ),
  );
}
