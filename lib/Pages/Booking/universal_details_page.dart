// ignore_for_file: deprecated_member_use, file_names, avoid_print, dead_code, unnecessary_null_comparison, unnecessary_to_list_in_spreads

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:healthcareapp_try1/Models/Booking_Models/test_model.dart';
import 'package:healthcareapp_try1/Models/DetailsModel.dart/doctor_details_model.dart';
import 'package:healthcareapp_try1/Models/DetailsModel.dart/nurse_details_model.dart';
import 'package:healthcareapp_try1/Models/Users_Models/lab_model.dart';
import 'package:healthcareapp_try1/Models/Users_Models/nurse_model.dart';
import 'package:healthcareapp_try1/Pages/Booking/univrsal_payment_page.dart';
import 'package:intl/intl.dart';
import 'package:healthcareapp_try1/API/user_service.dart';
import 'package:healthcareapp_try1/Bloc/DetailsBoc/universal_details_cubit.dart';
import 'package:healthcareapp_try1/Bloc/User_Bloc/ReviewBloc/review_cubit.dart';
import 'package:healthcareapp_try1/Buttons/buttons.dart';
import 'package:healthcareapp_try1/Models/DetailsModel.dart/lab_details_model.dart';
import 'package:healthcareapp_try1/Models/DetailsModel.dart/review_model.dart';
import 'package:healthcareapp_try1/Models/Users_Models/doctor_model.dart';
import 'package:healthcareapp_try1/Models/Users_Models/working_days.dart';
import 'package:healthcareapp_try1/Pages/Booking/healtcare_provider.dart';
import 'package:healthcareapp_try1/Widgets/custom_loader1.dart';
import 'package:healthcareapp_try1/Widgets/location_open_map.dart';
import 'package:healthcareapp_try1/Widgets/slot_widget.dart';
import 'package:healthcareapp_try1/core/string_extension.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProviderDetailsPage extends StatelessWidget {
  final HealthcareProvider provider;

  const ProviderDetailsPage({super.key, required this.provider});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) =>
              HealthcareDetailsCubit(context.read<UserService>())
                ..loadProviderDetails(provider.id, provider.providerType),
        ),
        BlocProvider(
          create: (_) => ReviewsCubit(context.read<UserService>())
            ..fetchReviews(
              provider.id,
              provider.providerType,
            ), // تشغيل جلب المراجعات فوراً
        ),
      ],
      child: _ProviderDetailsView(provider: provider),
    );
  }
}

class _ProviderDetailsView extends StatefulWidget {
  final HealthcareProvider provider;
  const _ProviderDetailsView({required this.provider});

  @override
  State<_ProviderDetailsView> createState() => _ProviderDetailsViewState();
}

class _ProviderDetailsViewState extends State<_ProviderDetailsView> {
  DateTime? selectedDate;

  String? selectedTime;
  String? selectedExactHour;
  String selectedService = "";
  String? selectedSlotId;

  Map<String, String> selectedTests = {}; // قائمة لتخزين التحاليل المختارة
  IconData _getProviderIcon({required bool isReady, required bool hasService}) {
    final type = widget.provider.providerType;

    if (isReady) return FontAwesomeIcons.circleCheck;

    switch (type) {
      case "Doctor":
        return hasService
            ? FontAwesomeIcons.calendarCheck
            : FontAwesomeIcons.userDoctor;

      case "Nurse":
        return hasService
            ? FontAwesomeIcons.calendarCheck
            : FontAwesomeIcons.userNurse;

      case "Lab":
        return hasService
            ? FontAwesomeIcons.calendarCheck
            : FontAwesomeIcons.flask;

      default:
        return FontAwesomeIcons.handPointer;
    }
  }

  bool get isTimeSelected => selectedDate != null && selectedTime != null;
  final ScrollController _scrollController = ScrollController();
  bool get canProceed {
    if (widget.provider.providerType == "Lab") {
      return selectedService.isNotEmpty &&
          selectedTests.isNotEmpty &&
          selectedDate != null &&
          selectedTime != null;
    } else {
      // Doctor or Nurse
      return selectedDate != null && selectedTime != null;
    }
  }

  double get totalTestsPrice {
    double total = 0.0;
    final state = context.read<HealthcareDetailsCubit>().state;

    if (state is DetailsLoaded && state.providerData is LabDetailsModel) {
      final labData = state.providerData as LabDetailsModel;
      final allTests = labData.tests;

      // 1. حساب مجموع التحاليل المختارة
      for (var testId in selectedTests.values) {
        final test = allTests.firstWhere((t) => t.id == testId);
        total += (test.price ?? 0).toDouble();
      }

      // 2. إضافة سعر الزيارة المنزلية إذا كانت هي الخدمة المختارة
      if (selectedService == "Home Visit") {
        // تأكد أن موديل LabDetailsModel يحتوي على حقل homeVisitPrice أو ما يشابهه
        total += (labData.homeVisitFee).toDouble();
      }
    }
    return total;
  }

  double getSelectedServiceFee(dynamic data) {
    if (widget.provider.providerType == "Doctor") {
      final doctorDetails = data as DoctorDetailsModel;

      switch (selectedService) {
        case "Clinic Visit":
          return doctorDetails.clinicFee;
        case "Home Visit":
          return doctorDetails.homeFee;
        case "Online":
          return doctorDetails.onlineFee;
        default:
          return 0;
      }
    } else if (widget.provider.providerType == "Nurse") {
      final nurseDetails = data as NurseDetailsModel; // ✅ التصحيح هنا

      switch (selectedService) {
        case "Home Visit":
          return nurseDetails.homeVisitFee;
        case "Hourly Rate":
          return nurseDetails.hourPrice;
        default:
          return 0;
      }
    } else if (widget.provider.providerType == "Lab") {
      final labDetails = data as LabDetailsModel;

      double total = 0;

      for (var testId in selectedTests.values) {
        final test = labDetails.tests.firstWhere((t) => t.id == testId);
        total += (test.price ?? 0).toDouble();
      }

      if (selectedService == "Home Visit") {
        total += (labDetails.homeVisitFee).toDouble();
      }

      return total;
    }

    return 0;
  }

  double getLabTotalFee(LabDetailsModel labData) {
    double total = 0.0;

    // سعر الخدمة المختارة (Home Visit مثلا)
    total += (selectedService == "Home Visit" ? labData.homeVisitFee : 0);

    // سعر التحاليل المختارة
    for (var testId in selectedTests.values) {
      final test = labData.tests.firstWhere((t) => t.id == testId);
      total += (test.price ?? 0).toDouble();
    }

    return total;
  }

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

      body: BlocBuilder<HealthcareDetailsCubit, HealthcareDetailsState>(
        builder: (context, state) {
          if (state is DetailsLoading) {
            return const Center(
              child: CustomSpinner(color: Colors.grey, size: 40),
            );
          }

          if (state is DetailsError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.message),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () {
                      context
                          .read<HealthcareDetailsCubit>()
                          .loadProviderDetails(
                            widget.provider.id,
                            widget.provider.providerType,
                          );
                    },
                    child: const Text('Try Again'),
                  ),
                ],
              ),
            );
          }

          if (state is DetailsLoaded) {
            final data = state.providerData;
            if (data is DoctorDetailsModel || data is NurseDetailsModel) {
              print("SLOTS: ${data.slots}");
            }
            print("TYPE: ${widget.provider.providerType}");
            print("SERVICE: $selectedService");
            return SingleChildScrollView(
              controller: _scrollController,
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
                        LocationTileWidget(address: widget.provider.location),

                        const SizedBox(height: 10),
                        _buildSectionTitle("About"),
                        _buildBioContainer(
                          data.bio ?? "No description available",
                        ),
                        const SizedBox(height: 15),

                        if (widget.provider.providerType == "Lab") ...[
                          _buildWorkingDaysSection(
                            data.workingDays,
                            data.openingTime,
                            data.closingTime,
                          ),
                        ],

                        const SizedBox(height: 15),
                        _buildSectionTitle("Available Services"),
                        const SizedBox(height: 15),
                        _buildFeesSection(context, data),
                        const SizedBox(height: 10),
                        // ------------------------------------------
                        if (widget.provider.providerType == "Lab" &&
                            selectedService.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Text(
                              "Selected Service: $selectedService",
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.blue,
                                fontFamily: 'Agency',
                              ),
                            ),
                          ),

                        if (selectedService != "" &&
                            widget.provider.providerType != "Lab" &&
                            (data is DoctorDetailsModel ||
                                data is NurseDetailsModel)) ...[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildSectionTitle("Select Appointment Time"),
                              const SizedBox(height: 5),
                              SlotsSection(
                                slots: data.slots,
                                isNurse:
                                    widget.provider.providerType == "Nurse",
                                isLab: widget.provider.providerType == "Lab",
                                showChips: widget.provider.providerType == "Lab"
                                    ? (selectedService.isNotEmpty &&
                                          selectedTests.isNotEmpty)
                                    : true,
                                onSlotSelected: (day, slot) {
                                  setState(() {
                                    selectedDate = DateTime.parse(day.date);
                                    selectedTime = slot.startTime;
                                    selectedSlotId = slot.id;
                                  });
                                },
                                onHourSelected: (hour) {
                                  // ✅ جديد
                                  setState(() {
                                    selectedExactHour = hour;
                                  });
                                },
                              ),
                            ],
                          ),
                        ],

                        // --- الجزء الجديد الخاص بالتحاليل (Tests) ---
                        if (widget.provider.providerType == "Lab" &&
                            data is LabDetailsModel)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 10),
                              _buildSectionTitle("Available Tests"),
                              _buildTestsList(
                                data.tests,
                              ), // سنقوم بإنشاء هذا التابع الآن
                            ],
                          ),
                        const SizedBox(height: 10),

                        if (widget.provider.providerType == "Lab" &&
                            selectedTests.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Text(
                              "Selected Tests: ${selectedTests.length} item(s)",
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.teal,
                                fontFamily: 'Agency',
                              ),
                            ),
                          ),
                        const SizedBox(height: 15),

                        if (widget.provider.providerType == "Lab" &&
                            data is LabDetailsModel) ...[
                          _buildSectionTitle("Select Appointment Date"),
                          const SizedBox(height: 10),

                          // عرض الأيام المتاحة
                          SizedBox(
                            height: 80,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              children: _generateAvailableDays(data.workingDays)
                                  .map((date) {
                                    bool isSelected =
                                        selectedDate?.day == date.day;
                                    return GestureDetector(
                                      onTap: () =>
                                          setState(() => selectedDate = date),
                                      child: Container(
                                        width: 70,
                                        margin: const EdgeInsets.only(
                                          right: 10,
                                        ),
                                        decoration: BoxDecoration(
                                          color: isSelected
                                              ? Colors.teal
                                              : Colors.white,
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          border: Border.all(
                                            color: Colors.teal.withOpacity(0.2),
                                          ),
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              DateFormat('EEE').format(date),
                                              style: TextStyle(
                                                color: isSelected
                                                    ? Colors.white
                                                    : Colors.grey,
                                              ),
                                            ),
                                            Text(
                                              date.day.toString(),
                                              style: TextStyle(
                                                color: isSelected
                                                    ? Colors.white
                                                    : Colors.black,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  })
                                  .toList(),
                            ),
                          ),

                          if (selectedDate != null) ...[
                            const SizedBox(height: 20),
                            _buildSectionTitle("Available Times"),
                            const SizedBox(height: 10),

                            // عرض الساعات المتاحة
                            // Wrap(
                            //   spacing: 8,
                            //   runSpacing: 8,
                            //   children:
                            //       _generateTimeSlots(
                            //         data.openingTime,
                            //         data.closingTime,
                            //         selectedDate,
                            //       ).map((time) {
                            //         bool isSelected = selectedTime == time;
                            //         return ChoiceChip(
                            //           label: Text(time),
                            //           selected: isSelected,
                            //           backgroundColor: Colors.amber,
                            //           selectedColor: Colors.teal,
                            //           disabledColor: Colors.grey.shade200,
                            //           onSelected: (selected) {
                            //             setState(() {
                            //               selectedTime = time;
                            //               selectedExactHour = time;
                            //             });
                            //           },
                            //           labelStyle: TextStyle(
                            //             color: isSelected
                            //                 ? Colors.white
                            //                 : Colors.black,
                            //           ),
                            //         );
                            //       }).toList(),
                            // ),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children:
                                  _generateTimeSlots(
                                    data.openingTime,
                                    data.closingTime,
                                    selectedDate,
                                  ).map((time) {
                                    bool isSelected = selectedTime == time;
                                    return ChoiceChip(
                                      label: Text(time),
                                      selected: isSelected,
                                      // 1. لون الخلفية في الحالة العادية (غير مختار)
                                      backgroundColor: Colors.white,

                                      // 2. لون الخلفية عند الاختيار
                                      selectedColor: Colors.teal,

                                      // 3. إزالة الظل أو اللون الرمادي الزائد (عشان اللون يظهر صريح)
                                      pressElevation: 0,

                                      // 4. التحكم في الحواف والبوردر
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        side: BorderSide(
                                          color: isSelected
                                              ? Colors.teal
                                              : Colors.grey.shade300,
                                          width: 1,
                                        ),
                                      ),

                                      onSelected: (selected) {
                                        setState(() {
                                          selectedTime = time;
                                          selectedExactHour = time;
                                        });
                                      },
                                      labelStyle: TextStyle(
                                        color: isSelected
                                            ? Colors.white
                                            : Colors.black,
                                        fontFamily: 'Agency',
                                        fontWeight: isSelected
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                      ),
                                    );
                                  }).toList(),
                            ),
                          ],
                        ],

                        SizedBox(height: 15),
                        // --- الجزء الخاص بعرض ملخص الاختيارات والأسعار ---
                        if (widget.provider.providerType == "Lab" &&
                            data is LabDetailsModel) ...[
                          const SizedBox(height: 15),

                          // 1. عرض الخدمة المختارة وسعرها
                          if (selectedService.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Service: $selectedService",
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.blue,
                                      fontFamily: 'Agency',
                                    ),
                                  ),
                                  Text(
                                    selectedService == "Home Visit"
                                        ? "\$${(data.homeVisitFee).toStringAsFixed(2)}"
                                        : "Free", // أو السعر الافتراضي للعيادة
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                          // 2. عرض التحاليل المختارة وأسعارها (تفصيلي)
                          if (selectedTests.isNotEmpty) ...[
                            const Divider(height: 20),
                            ...selectedTests.entries.map((entry) {
                              // البحث عن سعر التحليل من القائمة الأصلية
                              final test = data.tests.firstWhere(
                                (t) => t.id == entry.value,
                              );
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 2,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Test: ${entry.key}",
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.teal,
                                        fontFamily: 'Agency',
                                      ),
                                    ),
                                    Text(
                                      "\$${(test.price ?? 0).toStringAsFixed(2)}",
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.teal,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),

                            const Divider(height: 20),

                            // 3. السعر الإجمالي النهائي
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Total Amount (${selectedTests.length} tests)",
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Agency',
                                  ),
                                ),
                                Text(
                                  "\$${totalTestsPrice.toStringAsFixed(2)}",
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.orangeAccent,
                                    fontFamily: 'Agency',
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],

                        SizedBox(height: 10),

                        // Confirm Button
                        // داخل الـ build الخاص بالـ ButtonOfAuth
                        ButtonOfAuth(
                          onPressed: canProceed
                              ? () async {
                                  final detailsState = context
                                      .read<HealthcareDetailsCubit>()
                                      .state;
                                  if (detailsState is! DetailsLoaded) return;

                                  // جيب الـ token من SharedPreferences
                                  final prefs =
                                      await SharedPreferences.getInstance();
                                  final token = prefs.getString('token') ?? '';
                                  final selectedNamesList = selectedTests.keys
                                      .toList();

                                  // جيب الـ slotId
                                  // ignore: unused_local_variable
                                  String slotId = "";
                                  if (detailsState.providerData
                                      is DoctorDetailsModel) {
                                    final allDays =
                                        (detailsState.providerData
                                                as DoctorDetailsModel)
                                            .slots;
                                    for (final day in allDays) {
                                      for (final slot in day.slots) {
                                        if (slot.startTime == selectedTime) {
                                          slotId = slot.id;
                                          break;
                                        }
                                      }
                                    }
                                  } else if (detailsState.providerData
                                      is NurseDetailsModel) {
                                    final allDays =
                                        (detailsState.providerData
                                                as NurseDetailsModel)
                                            .slots;
                                    for (final day in allDays) {
                                      for (final slot in day.slots) {
                                        if (slot.startTime == selectedTime) {
                                          slotId = slot.id;
                                          break;
                                        }
                                      }
                                    }
                                  }

                                  if (!context.mounted) return;

                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => BookingConfirmationPage(
                                        provider: widget.provider,
                                        selectedService: selectedService,
                                        selectedDate: selectedDate!,
                                        selectedTime:
                                            selectedExactHour ?? selectedTime!,
                                        slotId: selectedSlotId ?? '',
                                        totalFee:
                                            (widget.provider.providerType ==
                                                "Lab"
                                            ? getLabTotalFee(
                                                detailsState.providerData
                                                    as LabDetailsModel,
                                              )
                                            : getSelectedServiceFee(
                                                detailsState.providerData,
                                              )),
                                        token: token,
                                        labTestsNames: selectedNamesList,
                                        labTestsIds: selectedTests.values
                                            .toList(),
                                        providerType:
                                            widget.provider.providerType,
                                      ),
                                    ),
                                  );
                                }
                              : null,
                          buttoncolor: canProceed ? Colors.green : Colors.grey,
                          buttonText: canProceed
                              ? "Continue to booking"
                              : "Select Service/Time",
                          fontcolor: Colors.white,
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
                                  "No reviews for this ${widget.provider.providerType.toLowerCase()} yet.",
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

  Widget _buildTestsList(List<Test> tests) {
    if (tests.isEmpty) return _buildEmptyState("No specific tests listed.");

    final bool isHomeVisitSelected = selectedService.toLowerCase().contains(
      "home",
    );

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: tests.length,
      separatorBuilder: (context, index) =>
          const SizedBox(height: 10), // مسافة بين الكروت
      itemBuilder: (context, index) {
        final test = tests[index];
        final isSelected = selectedTests.containsKey(test.name);
        final bool isDisabled =
            isHomeVisitSelected && (test.isAvailableAtHome == false);

        return GestureDetector(
          onTap: isDisabled
              ? () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        "${test.name} is not available for Home Visit",
                      ),
                    ),
                  );
                }
              : () {
                  setState(() {
                    if (isSelected) {
                      selectedTests.remove(test.name);
                    } else {
                      selectedTests[test.name] = test.id;
                    }
                  });
                },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDisabled
                  ? Colors.grey.shade200
                  : (isSelected ? Colors.teal.withOpacity(0.1) : Colors.white),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: isSelected ? Colors.teal : Colors.grey.shade200,
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Row(
              children: [
                // أيقونة الحالة (Checkbox)
                Icon(
                  isSelected ? Icons.check_box : Icons.check_box_outline_blank,
                  color: isDisabled ? Colors.grey : Colors.teal,
                ),
                const SizedBox(width: 12),

                // تفاصيل التحليل
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        test.name,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isDisabled ? Colors.grey : Colors.black87,
                          fontFamily: 'Agency',
                          decoration: isDisabled
                              ? TextDecoration.lineThrough
                              : null,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        test.preRequisites,
                        maxLines: 2,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: isDisabled ? Colors.grey : Colors.black87,
                        ),
                      ),
                      if (isDisabled)
                        const Text(
                          "Available in Clinic only",
                          style: TextStyle(color: Colors.red, fontSize: 12),
                        ),
                    ],
                  ),
                ),

                // السعر
                Text(
                  "${test.price} EGP",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: isDisabled ? Colors.grey : Colors.teal.shade700,
                    fontFamily: 'Agency',
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildWorkingDaysSection(
    WorkingDays workingDays,
    String opening, // نتوقع تنسيق "09:00"
    String closing, // نتوقع تنسيق "22:00"
  ) {
    final String todayName = DateFormat('EEEE').format(DateTime.now());
    final bool isNowOpen = _isCurrentlyOpen(
      _checkIfOpenToday(workingDays, todayName),
      opening,
      closing,
    );

    final days = [
      {'name': 'Saturday', 'isOpen': workingDays.isSaturdayOpen},
      {'name': 'Sunday', 'isOpen': workingDays.isSundayOpen},
      {'name': 'Monday', 'isOpen': workingDays.isMondayOpen},
      {'name': 'Tuesday', 'isOpen': workingDays.isTuesdayOpen},
      {'name': 'Wednesday', 'isOpen': workingDays.isWednesdayOpen},
      {'name': 'Thursday', 'isOpen': workingDays.isThursdayOpen},
      {'name': 'Friday', 'isOpen': workingDays.isFridayOpen},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildSectionTitle("Working Hours"),
            // Badge "Open Now"
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: isNowOpen
                    ? Colors.green.withOpacity(0.1)
                    : Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 4,
                    backgroundColor: isNowOpen ? Colors.green : Colors.red,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    isNowOpen ? "Open Now" : "Closed Now",
                    style: TextStyle(
                      color: isNowOpen
                          ? Colors.green.shade700
                          : Colors.red.shade700,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade100),
          ),
          child: Column(
            children: days.map((day) {
              final bool isOpen = day['isOpen'] as bool;
              final String name = day['name'] as String;
              final bool isToday = name == todayName;

              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: isToday
                      ? Colors.teal.withOpacity(0.1) // 👈 الأزرق الفاتح
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        fontWeight: isToday
                            ? FontWeight.bold
                            : FontWeight.normal,
                        fontFamily: 'Agency',
                        color: isToday ? Colors.teal : Colors.black87,
                      ),
                    ),
                    const Spacer(),
                    isOpen
                        ? Text(
                            "${_formatTime(opening)} - ${_formatTime(closing)}",
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          )
                        : const Text(
                            "Closed",
                            style: TextStyle(
                              color: Colors.red,
                              fontFamily: 'Agency',
                            ),
                          ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  bool _checkIfOpenToday(WorkingDays workingDays, String day) {
    switch (day) {
      case 'Saturday':
        return workingDays.isSaturdayOpen;
      case 'Sunday':
        return workingDays.isSundayOpen;
      case 'Monday':
        return workingDays.isMondayOpen;
      case 'Tuesday':
        return workingDays.isTuesdayOpen;
      case 'Wednesday':
        return workingDays.isWednesdayOpen;
      case 'Thursday':
        return workingDays.isThursdayOpen;
      case 'Friday':
        return workingDays.isFridayOpen;
      default:
        return false;
    }
  }

  bool _isCurrentlyOpen(bool isOpenToday, String opening, String closing) {
    if (!isOpenToday) return false;

    try {
      final now = DateTime.now();
      // تحويل الوقت الحالي لشكل HH:mm للمقارنة
      final String currentTimeString = DateFormat('HH:mm').format(now);

      // المقارنة المباشرة بين النصوص تعمل بشكل ممتاز في تنسيق 24 ساعة
      // مثال: "14:30" هي بعد "09:00" وقبل "22:00"
      return currentTimeString.compareTo(opening) >= 0 &&
          currentTimeString.compareTo(closing) <= 0;
    } catch (e) {
      return false;
    }
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
              fontFamily: 'ElMessiri',
            ),
          ),
          const SizedBox(height: 8),
          Text(
            DateFormat('dd MMM yyyy').format(review.date),
            style: TextStyle(
              color: Colors.grey[700],
              fontSize: 11,
              fontFamily: 'Agency',
            ),
          ),
        ],
      ),
    );
  }

  List<DateTime> _generateAvailableDays(WorkingDays workingDays) {
    List<DateTime> availableDays = [];
    DateTime now = DateTime.now();

    for (int i = 0; i < 7; i++) {
      DateTime date = now.add(Duration(days: i));
      String dayName = DateFormat('EEEE').format(date);

      if (_checkIfOpenToday(workingDays, dayName)) {
        availableDays.add(date);
      }
    }
    return availableDays;
  }

  List<String> _generateTimeSlots(
    String opening,
    String closing,
    DateTime? selectedDate,
  ) {
    List<String> slots = [];
    final format = DateFormat("HH:mm");
    DateTime start = format.parse(opening);
    DateTime end = format.parse(closing);

    // الوقت الحالي
    DateTime now = DateTime.now();
    bool isToday =
        selectedDate != null &&
        selectedDate.year == now.year &&
        selectedDate.month == now.month &&
        selectedDate.day == now.day;

    while (start.isBefore(end)) {
      String timeString = DateFormat("h:mm a").format(start);

      if (isToday) {
        // تحويل الساعة الحالية من الـ Loop لـ DateTime كامل للمقارنة
        DateTime slotDateTime = DateTime(
          now.year,
          now.month,
          now.day,
          start.hour,
          start.minute,
        );

        // لا تضف الساعة إذا كانت قبل الوقت الحالي
        if (slotDateTime.isAfter(now)) {
          slots.add(timeString);
        }
      } else {
        // إذا كان يوم مستقبلي، أضف كل الساعات
        slots.add(timeString);
      }

      start = start.add(const Duration(minutes: 30));
    }
    return slots;
  }

  // دالة مساعدة بسيطة للتحقق من يوم اليوم

  Widget _buildHeader(BuildContext context) {
    final providerData = context.select((HealthcareDetailsCubit cubit) {
      final state = cubit.state;
      if (state is DetailsLoaded) {
        return state.providerData;
      }
      return null;
    });
    return Stack(
      children: [
        SizedBox(
          height: 350,
          width: double.infinity,
          child: providerData != null
              ? Image.network(
                  providerData.profilePictureUrl,
                  fit: BoxFit.cover,
                  cacheWidth: 800,
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
              widget.provider.name,
              textDirection:
                  widget.provider.name.getDirection, // يمين أو شمال حسب اللغة
              textAlign: widget.provider.name.getTextAlign,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                fontFamily: widget.provider.name.isArabic
                    ? 'ElMessiri'
                    : 'Cotta',
              ),
            ),
          ),
          const SizedBox(height: 5),
          SizedBox(
            width: double.infinity,
            child: Text(
              widget.provider.subTitle,
              textDirection: widget
                  .provider
                  .subTitle
                  .getDirection, // يمين أو شمال حسب اللغة
              textAlign: widget.provider.subTitle.getTextAlign,
              style: TextStyle(
                fontSize: 16,
                color: Colors.blue[700],
                fontWeight: FontWeight.w600,
                fontFamily: 'Agency',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeesSection(BuildContext context, dynamic data) {
    List<Widget> feeCards = [];
    final provider = widget.provider;

    if (provider is Doctor) {
      final doctorDetails = data is DoctorDetailsModel ? data : null;

      feeCards.add(
        _buildFeeCard(
          "Clinic Visit",
          doctorDetails?.clinicFee ?? provider.mainFee,
          FontAwesomeIcons.hospital,
          data,
        ),
      );

      if (doctorDetails?.allowHomeVisit == true) {
        feeCards.add(const SizedBox(width: 10));
        feeCards.add(
          _buildFeeCard(
            "Home Visit",
            doctorDetails?.homeFee,
            FontAwesomeIcons.house,
            data,
          ),
        );
      }

      if (doctorDetails?.allowOnlineConsultation == true) {
        feeCards.add(const SizedBox(width: 10));
        feeCards.add(
          _buildFeeCard(
            "Online",
            doctorDetails?.onlineFee,
            FontAwesomeIcons.video,
            data,
          ),
        );
      }
    } else if (provider is Nurse) {
      feeCards.add(
        _buildFeeCard(
          "Home Visit",
          provider.visitFee,
          FontAwesomeIcons.house,
          data,
        ),
      );

      feeCards.add(const SizedBox(width: 10));
      feeCards.add(
        _buildFeeCard(
          "Hourly Rate",
          provider.hourPrice,
          FontAwesomeIcons.clock,
          data,
        ),
      );
    } else if (provider is LabModel) {
      final labDetails = data as LabDetailsModel;

      if (labDetails.homeVisitFee != null) {
        feeCards.add(
          _buildFeeCard(
            "Home Visit",
            labDetails.homeVisitFee,
            FontAwesomeIcons.house,
            data,
          ),
        );
      }

      feeCards.add(const SizedBox(width: 10));
      feeCards.add(
        _buildFeeCard("Lab Visit", null, FontAwesomeIcons.flask, data),
      );
    } else {
      feeCards.add(
        _buildFeeCard("Service", null, FontAwesomeIcons.handPointer, data),
      );
    }

    return Row(children: feeCards);
  }

  Widget _buildFeeCard(
    String type,
    double? amount,
    IconData icon,
    dynamic data,
  ) {
    bool isSelected = selectedService == type;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedService = type;
            selectedTime = null;
            selectedDate = null;

            if (type == "Home Visit" && data is LabDetailsModel) {
              selectedTests.removeWhere((testName, _) {
                final test = data.tests.firstWhere(
                  (t) => t.name == testName,
                  orElse: () => data.tests.first,
                );
                return test.isAvailableAtHome == false;
              });
            }
          });

          // ⬇️ دي الحركة السحرية
          Future.delayed(const Duration(milliseconds: 300), () {
            if (_scrollController.hasClients) {
              _scrollController.animateTo(
                _scrollController.position.maxScrollExtent,
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOut,
              );
            }
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
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
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: isSelected
                    ? const Color(0xff0861dd)
                    : Colors.grey.shade800,
              ),
              const SizedBox(height: 8),
              Text(
                type,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected ? const Color(0xff0861dd) : Colors.black,
                  fontFamily: 'Agency',
                ),
              ),
              if (amount != null) ...[
                Text(
                  "$amount EGP",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: isSelected ? Colors.green : Colors.grey.shade800,
                    fontFamily: 'Agency',
                  ),
                ),
              ] else if (isSelected) ...[
                const SizedBox(height: 4),
                const Text(
                  "Selected",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.blue,
                    fontFamily: 'Agency',
                  ),
                ),
              ] else ...[
                SizedBox(height: 16),
              ],
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
    bool isLab = widget.provider.providerType == "Lab";
    bool hasService = selectedService.isNotEmpty;
    bool hasTests = selectedTests.isNotEmpty;
    bool hasTime = (selectedDate != null && selectedTime != null);

    // تحديث منطق الجاهزية: المعمل الآن يحتاج (خدمة + تحاليل + وقت)
    bool isReady = isLab
        ? (hasService && hasTests && hasTime)
        : (hasService && hasTime);

    Color mainColor = _getProviderColor(isReady, hasService, hasTests);
    Color stepColor = isReady ? Colors.green : mainColor;

    String title;
    String subTitle;
    double progressValue;

    if (isLab) {
      // --- تدفق خطوات المعمل الجديد (4 خطوات) ---
      if (isReady) {
        title = "Step 4: Ready to Book!";
        subTitle = "All set! Click 'Continue to booking'.";
        progressValue = 1.0;
      } else if (hasService && hasTests) {
        title = "Step 3: Select Time & Date";
        subTitle = "Pick a suitable date for your tests.";
        progressValue = 0.75;
        stepColor = Colors.orange;
      } else if (hasService) {
        title = "Step 2: Select Tests";
        subTitle = "Now pick the medical tests you need.";
        progressValue = 0.50;
      } else {
        title = "Step 1: Select Visit Type";
        subTitle = "Choose Lab or Home visit to start.";
        progressValue = 0.25;
      }
    } else {
      // --- تدفق الخطوات لغير المعامل (دكتور/ممرض) كما هو ---
      if (isReady) {
        title = "Step 3: Ready to Book!";
        subTitle = "All set! Confirm your appointment.";
        progressValue = 1.0;
      } else if (hasService) {
        title = "Step 2: Pick Time";
        subTitle = "Great! Now choose a suitable time slot.";
        progressValue = 0.66;
      } else {
        title = "Step 1: Select Service";
        subTitle = "Choose service type to see availability.";
        progressValue = 0.33;
      }
    }

    return AnimatedContainer(
      key: key,
      duration: const Duration(milliseconds: 400),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isReady
            ? Colors.green.withOpacity(0.08)
            : stepColor.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isReady
              ? Colors.green.withOpacity(0.3)
              : stepColor.withOpacity(0.3),
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: FaIcon(
              isReady
                  ? FontAwesomeIcons.circleCheck
                  : _getProviderIcon(isReady: isReady, hasService: hasService),
              key: ValueKey(isReady || title == "Step 3: Select Time & Date"),
              color: stepColor,
              size: 26,
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: isReady ? Colors.green : stepColor,
                    fontFamily: 'Agency',
                  ),
                ),
                Text(
                  subTitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade700,
                    fontFamily: 'Agency',
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 35,
            width: 35,
            child: isReady
                ? const Icon(Icons.celebration, color: Colors.green)
                : CircularProgressIndicator(
                    value: progressValue,
                    backgroundColor: Colors.grey.shade200,
                    color: stepColor,
                    strokeWidth: 3,
                  ),
          ),
        ],
      ),
    );
  }

  // 2. دالة لتحويل الوقت من 24 ساعة إلى شكل جذاب (14:00 -> 02:00 PM)
  String _formatTime(String time24h) {
    try {
      final date = DateFormat("HH:mm").parse(time24h);
      return DateFormat("h:mm a").format(date);
    } catch (e) {
      return time24h; // في حال الخطأ نرجع النص الأصلي
    }
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

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Color _getProviderColor(bool isReady, bool hasService, bool hasTests) {
    if (isReady) return Colors.green;
    if (hasService) return Colors.blue;
    if (hasService && hasTests) return Colors.orange;
    return const Color(0xff0861dd); // اللون الأساسي للتطبيق
  }
}
