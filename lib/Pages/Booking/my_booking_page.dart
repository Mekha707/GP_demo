// ignore_for_file: deprecated_member_use, unnecessary_import, no_leading_underscores_for_local_identifiers, use_build_context_synchronously

import "package:flutter/cupertino.dart";
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healthcareapp_try1/Bloc/MyBookingBloc/mybooking_cubit.dart';
import 'package:healthcareapp_try1/Bloc/MyBookingBloc/mybooking_state.dart';
import 'package:healthcareapp_try1/Models/Booking_Models/appointment_model.dart';
import 'package:healthcareapp_try1/Widgets/custom_tab_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyBookingPage extends StatefulWidget {
  const MyBookingPage({super.key});

  @override
  State<MyBookingPage> createState() => _MyBookingPageState();
}

class _MyBookingPageState extends State<MyBookingPage> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    // جلب التوكن من الـ Storage (مثال باستخدام SharedPreferences)
    final prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token') ?? "";

    context.read<AppointmentsCubit>().getAllUserAppointments(token);
  }

  // الـ Header الأزرق
  Widget _buildHeader() {
    return Container(
      height: 120,
      padding: const EdgeInsets.only(top: 40),
      width: double.infinity,
      color: const Color(0xff0861dd),
      child: const Center(
        child: Text(
          'My Bookings',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
            fontFamily: 'Cotta',
          ),
        ),
      ),
    );
  }

  Widget _buildList(List<AppointmentModel> list, Color statusColor) {
    // ... (نفس كود الـ Empty List والـ RefreshIndicator)
    if (list.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.calendar_today_outlined,
              size: 60,
              color: Colors.grey.shade300,
            ),
            const SizedBox(height: 15),
            Text(
              "No bookings found",
              style: TextStyle(color: Colors.grey.shade500, fontSize: 16),
            ),
          ],
        ),
      );
    }
    return ListView.builder(
      itemCount: list.length,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
      itemBuilder: (context, index) {
        final item = list[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: statusColor.withOpacity(0.3),
              width: 1.5,
            ), // الـ Border الملون
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    // صورة البروفايل مع Border بلون الحالة
                    Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: statusColor.withOpacity(0.2),
                          width: 2,
                        ),
                      ),
                      child: CircleAvatar(
                        radius: 28,
                        backgroundImage: NetworkImage(item.providerImage),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                item.providerName,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              // Tag الحالة
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: statusColor, // خلفية الحالة مصمتة
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  item.status,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Agency',
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Icon(
                                item.type == "Doctor"
                                    ? Icons.medical_services_outlined
                                    : item.type == "Nurse"
                                    ? Icons.person_outline
                                    : Icons
                                          .biotech_outlined, // أيقونة معمل للـ Lab
                                size: 14,
                                color: Colors.grey.shade800,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                "${item.type} - ${item.specialty ?? 'General'}", // بيعرض النوع والتخصص مع بعض
                                style: TextStyle(
                                  color: Colors.grey.shade800,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'Agency',
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Icon(
                                Icons.event_available,
                                size: 14,
                                color: statusColor,
                              ), // أيقونة بلون الحالة
                              const SizedBox(width: 4),
                              Text(
                                item.date,
                                style: const TextStyle(fontSize: 12),
                              ),
                              const SizedBox(width: 12),
                              Icon(
                                Icons.schedule,
                                size: 14,
                                color: statusColor,
                              ), // أيقونة بلون الحالة
                              const SizedBox(width: 4),
                              Text(
                                item.time,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontFamily: 'Agency',
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // الجزء السفلي الرمادي
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(18),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Total: ${item.price} EGP",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Agency',
                      ),
                    ),

                    // ... داخل الجزء السفلي الرمادي
                    Row(
                      children: [
                        Icon(
                          item.serviceType == "HomeVisit"
                              ? Icons.home_outlined
                              : item.serviceType == "OnSiteVisit"
                              ? Icons
                                    .location_city_outlined // أيقونة للمركز أو العيادة
                              : Icons.videocam_outlined, // أيقونة للـ Online
                          size: 16,
                          color: statusColor,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          item.serviceType,
                          style: TextStyle(
                            color: statusColor,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Agency',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: Column(
        children: [
          _buildHeader(),
          const SizedBox(height: 20),
          CustomRadioGroup(
            tabs: const ['Upcoming', 'Pending', 'Completed', 'Cancelled'],
            onSelectionChange: (index) => setState(() => _currentIndex = index),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: BlocBuilder<AppointmentsCubit, AppointmentsState>(
              builder: (context, state) {
                if (state is AppointmentsLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is AppointmentsError) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Text(
                        state.errMessage,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }
                if (state is AppointmentsSuccess) {
                  final List<AppointmentModel> all = state.data;

                  final pages = [
                    _buildList(
                      all.where((e) => e.status == "Confirmed").toList(),
                      const Color(0xff0861dd),
                    ),
                    _buildList(
                      all.where((e) => e.status == "Pending").toList(),
                      Colors.purple,
                    ),
                    _buildList(
                      all
                          .where(
                            (e) =>
                                (e.status == "Completed" ||
                                e.status == "ResultsDone"),
                          )
                          .toList(),
                      Colors.green,
                    ),
                    _buildList(
                      all.where((e) => e.status == "Cancelled").toList(),
                      Colors.red,
                    ),
                  ];

                  return AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: pages[_currentIndex],
                  );
                }
                return const SizedBox();
              },
            ),
          ),
        ],
      ),
    );
  }
}



  // Widget _buildList(List<AppointmentModel> list, Color statusColor) {
  //   if (list.isEmpty) {
  //     return Center(
  //       child: Column(
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         children: [
  //           Icon(
  //             Icons.calendar_today_outlined,
  //             size: 60,
  //             color: Colors.grey.shade300,
  //           ),
  //           const SizedBox(height: 15),
  //           Text(
  //             "No bookings found",
  //             style: TextStyle(color: Colors.grey.shade500, fontSize: 16),
  //           ),
  //         ],
  //       ),
  //     );
  //   }

  //   return RefreshIndicator(
  //     onRefresh: () async {
  //       final prefs = await SharedPreferences.getInstance();
  //       String token = prefs.getString('token') ?? "";
  //       await context.read<AppointmentsCubit>().getAllUserAppointments(token);
  //     },
  //     child: ListView.builder(
  //       itemCount: list.length,
  //       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
  //       itemBuilder: (context, index) {
  //         final item = list[index];
  //         return Container(
  //           margin: const EdgeInsets.only(bottom: 16),
  //           decoration: BoxDecoration(
  //             color: Colors.white,
  //             borderRadius: BorderRadius.circular(20),
  //             boxShadow: [
  //               BoxShadow(
  //                 color: Colors.black.withOpacity(0.04),
  //                 blurRadius: 10,
  //                 offset: const Offset(0, 4),
  //               ),
  //             ],
  //           ),
  //           child: Padding(
  //             padding: const EdgeInsets.all(16.0),
  //             child: Column(
  //               children: [
  //                 Row(
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                   children: [
  //                     // Provider Image with Border
  //                     Container(
  //                       decoration: BoxDecoration(
  //                         shape: BoxShape.circle,
  //                         border: Border.all(
  //                           color: Colors.blue.shade50,
  //                           width: 2,
  //                         ),
  //                       ),
  //                       child: CircleAvatar(
  //                         radius: 30,
  //                         backgroundColor: Colors.grey.shade100,
  //                         backgroundImage: NetworkImage(item.providerImage),
  //                       ),
  //                     ),
  //                     const SizedBox(width: 15),
  //                     // Information
  //                     Expanded(
  //                       child: Column(
  //                         crossAxisAlignment: CrossAxisAlignment.start,
  //                         children: [
  //                           Row(
  //                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                             children: [
  //                               Text(
  //                                 item.providerName,
  //                                 style: const TextStyle(
  //                                   fontWeight: FontWeight.bold,
  //                                   fontSize: 17,
  //                                 ),
  //                               ),
  //                               // Status Tag
  //                               Container(
  //                                 padding: const EdgeInsets.symmetric(
  //                                   horizontal: 10,
  //                                   vertical: 4,
  //                                 ),
  //                                 decoration: BoxDecoration(
  //                                   color: statusColor.withOpacity(0.1),
  //                                   borderRadius: BorderRadius.circular(8),
  //                                 ),
  //                                 child: Text(
  //                                   item.status,
  //                                   style: TextStyle(
  //                                     color: statusColor,
  //                                     fontSize: 12,
  //                                     fontWeight: FontWeight.bold,
  //                                   ),
  //                                 ),
  //                               ),
  //                             ],
  //                           ),
  //                           Text(
  //                             item.specialty ?? item.type,
  //                             style: TextStyle(
  //                               color: Colors.grey.shade600,
  //                               fontSize: 14,
  //                             ),
  //                           ),
  //                           const Divider(height: 25),
  //                           Row(
  //                             children: [
  //                               Icon(
  //                                 Icons.calendar_month_outlined,
  //                                 size: 16,
  //                                 color: Colors.blue.shade700,
  //                               ),
  //                               const SizedBox(width: 5),
  //                               Text(
  //                                 item.date,
  //                                 style: const TextStyle(
  //                                   fontSize: 13,
  //                                   fontWeight: FontWeight.w500,
  //                                 ),
  //                               ),
  //                               const SizedBox(width: 15),
  //                               Icon(
  //                                 Icons.access_time_rounded,
  //                                 size: 16,
  //                                 color: Colors.blue.shade700,
  //                               ),
  //                               const SizedBox(width: 5),
  //                               Text(
  //                                 item.time,
  //                                 style: const TextStyle(
  //                                   fontSize: 13,
  //                                   fontWeight: FontWeight.w500,
  //                                 ),
  //                               ),
  //                             ],
  //                           ),
  //                         ],
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //                 const SizedBox(height: 15),
  //                 // Bottom Section: Price & Action
  //                 Container(
  //                   padding: const EdgeInsets.symmetric(
  //                     horizontal: 12,
  //                     vertical: 10,
  //                   ),
  //                   decoration: BoxDecoration(
  //                     color: Colors.grey.shade50,
  //                     borderRadius: BorderRadius.circular(12),
  //                   ),
  //                   child: Row(
  //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                     children: [
  //                       Row(
  //                         children: [
  //                           const Text(
  //                             "Total Price: ",
  //                             style: TextStyle(
  //                               color: Colors.grey,
  //                               fontSize: 13,
  //                             ),
  //                           ),
  //                           Text(
  //                             "${item.price} EGP",
  //                             style: const TextStyle(
  //                               fontWeight: FontWeight.bold,
  //                               color: Colors.black,
  //                             ),
  //                           ),
  //                         ],
  //                       ),
  //                       Text(
  //                         item.serviceType, // "HomeVisit" or "Online"
  //                         style: TextStyle(
  //                           color: Colors.blue.shade800,
  //                           fontWeight: FontWeight.w600,
  //                           fontSize: 13,
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //         );
  //       },
  //     ),
  //   );
  // }
