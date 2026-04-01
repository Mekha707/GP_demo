// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healthcareapp_try1/Bloc/User_Bloc/DoctorBloc/doctor_bloc.dart';
import 'package:healthcareapp_try1/Bloc/User_Bloc/DoctorBloc/doctor_event.dart';
import 'package:healthcareapp_try1/Bloc/User_Bloc/DoctorBloc/doctor_state.dart';
import 'package:healthcareapp_try1/Buttons/buttons.dart';
import 'package:healthcareapp_try1/Buttons/filter_button.dart';
import 'package:healthcareapp_try1/Models/Users_Models/enums.dart';
import 'package:healthcareapp_try1/Widgets/custom_loader1.dart';
import 'package:healthcareapp_try1/Widgets/medical_staff_cards.dart';
import 'package:healthcareapp_try1/Widgets/search_for_medical_staff.dart';

class DoctorPage extends StatefulWidget {
  const DoctorPage({super.key});

  @override
  State<DoctorPage> createState() => _DoctorPage();
}

class _DoctorPage extends State<DoctorPage> {
  final ScrollController _scrollController = ScrollController();
  bool isFilterd = false;
  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);

    // ✅ أضيف السطر ده
    context.read<DoctorsBloc>().add(FetchDoctors());
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final atBottom =
        _scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200;
    if (atBottom) {
      context.read<DoctorsBloc>().add(LoadMoreDoctors());
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DoctorsBloc, DoctorsState>(
      listener: (context, state) {},
      builder: (context, state) {
        if (state is DoctorsLoading) {
          return const Center(
            child: CustomSpinner(size: 40, color: Color(0xff0861dd)),
          );
        }

        if (state is DoctorsError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  state.message,
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'ElMessiri',
                    color: Color(0xff0861dd),
                  ),
                ),
                const SizedBox(height: 12),

                ButtonOfAuth(
                  onPressed: () =>
                      context.read<DoctorsBloc>().add(FetchDoctors()),
                  fontcolor: Colors.grey.shade100,
                  buttoncolor: Color(0xff0861dd),
                  buttonText: "Try Again",
                ),
              ],
            ),
          );
        }

        if (state is DoctorsLoaded) {
          return RefreshIndicator(
            onRefresh: () async {
              context.read<DoctorsBloc>().add(RefreshDoctors());
            },
            child: CustomScrollView(
              controller: _scrollController,
              slivers: [
                CustomFilterButton(
                  isSelected: isFilterd,
                  onTap: () {
                    setState(() {
                      isFilterd = !isFilterd;
                    });
                  },
                  activeColor: Color(0xff0861dd),
                ),

                SliverAnimatedOpacity(
                  opacity: isFilterd ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 800),
                  sliver: isFilterd
                      ? SliverToBoxAdapter(
                          child: SearchForDoctor(
                            bookingType: BookingType.clinic,
                            onFilterChanged:
                                (name, specialty, location, serviceType) {
                                  context.read<DoctorsBloc>().add(
                                    FilterDoctors(
                                      name: name,
                                      specialtyId: specialty?.id,
                                      cityName: specialty == null ? null : name,
                                      serviceType: serviceType.toString(),
                                    ),
                                  );
                                },
                          ),
                        )
                      : const SliverToBoxAdapter(child: SizedBox.shrink()),
                ),

                SliverToBoxAdapter(child: SizedBox(height: 10)),
                state.filteredDoctors.isEmpty
                    ? const SliverFillRemaining(
                        child: Center(
                          child: Text('No doctors found matching your search.'),
                        ),
                      )
                    : SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            if (index == state.filteredDoctors.length) {
                              return const Center(
                                child: Padding(
                                  padding: EdgeInsets.all(16),
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            }
                            final doctor = state.filteredDoctors[index];

                            return DoctorCard(doctor: doctor);
                          },
                          childCount:
                              state.filteredDoctors.length +
                              (state.isLoadingMore ? 1 : 0),
                        ),
                      ),
                const SliverToBoxAdapter(child: SizedBox(height: 150)),
              ],
            ),
          );
        }

        return const SizedBox();
      },
    );
  }
}
