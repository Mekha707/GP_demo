// ignore_for_file: deprecated_member_use, unused_element, must_be_immutable

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:healthcareapp_try1/API/user_service.dart';
import 'package:healthcareapp_try1/Bloc/DetailsBoc/doctor_details_cubit.dart';
import 'package:healthcareapp_try1/Bloc/User_Bloc/ReviewBloc/review_cubit.dart';
import 'package:healthcareapp_try1/Buttons/buttons.dart';
import 'package:healthcareapp_try1/Models/DetailsModel.dart/review_model.dart';
import 'package:healthcareapp_try1/Widgets/custom_loader1.dart';
import 'package:healthcareapp_try1/Widgets/location_open_map.dart';
import 'package:healthcareapp_try1/Widgets/slot_widget.dart';
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
    return MultiBlocProvider(
      // استبدال BlocProvider بـ MultiBlocProvider
      providers: [
        BlocProvider(
          create: (_) =>
              DoctorDetailsCubit(context.read<UserService>())
                ..loadDoctor(doctorId),
        ),
        BlocProvider(
          create: (_) =>
              ReviewsCubit(context.read<UserService>())
                ..fetchReviews(doctorId), // تشغيل جلب المراجعات فوراً
        ),
      ],
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

  bool get isTimeSelected => selectedDate != null && selectedTime != null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],

      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return FadeTransition(
                  opacity: animation,
                  child: ScaleTransition(scale: animation, child: child),
                );
              },
              child: _buildGuidanceBar(
                key: ValueKey(
                  '${selectedService}_${selectedDate}_$selectedTime',
                ),
              ),
            ),
          ),
        ),
      ),

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

                        const SizedBox(height: 15),
                        _buildSectionTitle("Available Services"),
                        const SizedBox(height: 15),
                        _buildFeesSection(context),
                        const SizedBox(height: 10),

                        // Slots Section (تظهر فقط بعد اختيار الخدمة)
                        selectedService == ""
                            ? SizedBox(height: 10)
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildSectionTitle("Select Appointment Time"),
                                  const SizedBox(height: 5),

                                  SlotsSection(
                                    slots: state.doctor.slots,
                                    onSlotSelected: (day, slot) {
                                      setState(() {
                                        String newDate = day.date;

                                        if (selectedDate != null &&
                                            selectedDate.toString().split(
                                                  ' ',
                                                )[0] !=
                                                newDate) {
                                          selectedTime =
                                              null; // نلغي الوقت القديم فوراً
                                        }
                                        selectedDate = DateTime.parse(newDate);
                                        selectedTime = slot.startTime;
                                      });
                                    },
                                  ),
                                  const SizedBox(height: 5),
                                ],
                              ),

                        SizedBox(height: 10),

                        // Confirm Button
                        ButtonOfAuth(
                          onPressed: isTimeSelected
                              ? () {}
                              : null, // يكون الزر غير مفعل (Disabled) حتى يختار الوقت
                          fontcolor: Colors.white,
                          buttoncolor: isTimeSelected
                              ? Colors.green
                              : Colors.grey, // يتحول للأخضر مع الـ Bar
                          buttonText: isTimeSelected
                              ? "Continue to payment"
                              : "Select Time First",
                        ),

                        const SizedBox(height: 20),
                        _buildSectionTitle("Patient Reviews"),
                        const SizedBox(height: 10),

                        BlocBuilder<ReviewsCubit, ReviewsState>(
                          builder: (context, state) {
                            if (state is ReviewsLoading) {
                              return const Center(
                                child: CustomSpinner(
                                  color: Color(0xff0861dd),
                                  size: 30,
                                ),
                              );
                            } else if (state is ReviewsError) {
                              return Center(
                                child: Text(
                                  state.message,
                                  style: const TextStyle(color: Colors.red),
                                ),
                              );
                            } else if (state is ReviewsLoaded) {
                              final reviews = state.reviewsData.items;

                              if (reviews.isEmpty) {
                                return _buildEmptyState(
                                  "No reviews for this doctor yet.",
                                );
                              }

                              return ListView.separated(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: reviews.length,
                                separatorBuilder: (context, index) =>
                                    const SizedBox(height: 12),
                                itemBuilder: (context, index) {
                                  final review = reviews[index];
                                  return _buildReviewCard(review);
                                },
                              );
                            }
                            return const SizedBox();
                          },
                        ),
                        const SizedBox(height: 30),
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

  Widget _buildReviewCard(ReviewModel review) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                review.patientName,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  fontFamily: 'Cotta',
                ),
              ),
              // عرض النجوم
              Row(
                children: List.generate(5, (index) {
                  return Icon(
                    index < review.rating ? Icons.star : Icons.star_border,
                    color: Colors.amber,
                    size: 16,
                  );
                }),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            review.comment,
            style: TextStyle(
              color: Colors.grey[700],
              height: 1.4,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            // تنسيق بسيط للتاريخ (يمكنك استخدام intl لجعله أفضل)
            "${review.date.day}/${review.date.month}/${review.date.year}",
            style: TextStyle(color: Colors.grey[400], fontSize: 11),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(String message) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Center(
        child: Text(
          message,
          style: TextStyle(color: Colors.grey[500], fontSize: 14),
        ),
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

    return Row(
      children: [
        _buildFeeCard(
          "Clinic Visit",
          doctor.clinicFee,
          FontAwesomeIcons.hospital,
        ),
        SizedBox(width: 10),

        // خيارات الطبيب الإضافية
        if (doctor.allowHomeVisit) ...[
          _buildFeeCard("Home Visit", doctor.homeFee, FontAwesomeIcons.home),
          SizedBox(width: 10),
        ],

        if (doctor.allowOnlineConsultation) ...[
          _buildFeeCard("Online", doctor.onlineFee, FontAwesomeIcons.video),
        ],
      ],
    );
  }

  Widget _buildFeeCard(String type, double amount, IconData icon) {
    bool isSelected = selectedService == type; // هل هذه البطاقة مختارة؟

    return Expanded(
      child: GestureDetector(
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
              color: isSelected
                  ? const Color(0xff0861dd)
                  : Colors.grey.shade200,
              width: isSelected ? 2 : 1,
            ),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xff0861dd).withOpacity(0.2)
                      : Colors.grey.shade200,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: isSelected
                      ? const Color(0xff0861dd)
                      : Colors.grey.shade800,
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  type,
                  style: TextStyle(
                    fontWeight: isSelected
                        ? FontWeight.bold
                        : FontWeight.normal,
                    color: isSelected ? const Color(0xff0861dd) : Colors.black,
                    fontFamily: 'Agency',
                  ),
                ),
              ),
              Text(
                "$amount EGP",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: isSelected ? Colors.green : Colors.grey.shade800,
                  fontFamily: 'Agency',
                ),
              ),
              const SizedBox(width: 10),
            ],
          ),
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

  Widget _buildGuidanceBar({Key? key}) {
    // تحديد الحالة الحالية
    bool hasService = selectedService.isNotEmpty;
    bool hasTime = (selectedDate != null && selectedTime != null);

    // تحديد الألوان بناءً على الحالة
    Color mainColor = hasTime
        ? Colors
              .green // حالة التأكيد
        : (hasService ? Colors.indigoAccent : Colors.orangeAccent);

    return AnimatedContainer(
      key: key,
      duration: const Duration(milliseconds: 400),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: mainColor.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: mainColor.withOpacity(0.3), width: 1.5),
      ),
      child: Row(
        children: [
          // الأيقونة تتغير حسب الحالة
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: Icon(
              hasTime
                  ? Icons.check_circle
                  : (hasService ? Icons.calendar_month : Icons.touch_app),
              key: ValueKey(hasTime ? 3 : (hasService ? 2 : 1)),
              color: mainColor,
              size: 28,
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  hasTime
                      ? "Step 3: Ready to Book!"
                      : (hasService
                            ? "Step 2: Pick Time"
                            : "Step 1: Select Service"),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: mainColor,
                    fontFamily: 'Agency',
                  ),
                ),
                Text(
                  hasTime
                      ? "All set! Click 'Continue to payment' to confirm."
                      : (hasService
                            ? "Great choice! Now pick a slot."
                            : "Choose visit type to see availability"),
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade700,
                    fontFamily: 'Agency',
                  ),
                ),
              ],
            ),
          ),
          // البروجرس بار (يتحول لعلامة صح عند الانتهاء)
          SizedBox(
            height: 35,
            width: 35,
            child: hasTime
                ? Icon(Icons.celebration, color: Colors.green)
                : CircularProgressIndicator(
                    value: hasService ? 0.7 : 0.3,
                    backgroundColor: Colors.grey.shade200,
                    color: mainColor,
                    strokeWidth: 3,
                  ),
          ),
        ],
      ),
    );
  }
}
