import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healthcareapp_try1/API/user_service.dart';
import 'package:healthcareapp_try1/Bloc/DetailsBoc/doctor_details_cubit.dart';

class DoctorDetailsPage extends StatelessWidget {
  final String doctorId;
  const DoctorDetailsPage({super.key, required this.doctorId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DoctorDetailsCubit(
        context
            .read<UserService>(), // ← لو بتستخدم get_it أو RepositoryProvider
      )..loadDoctor(doctorId),
      child: const _DoctorDetailsView(),
    );
  }
}

class _DoctorDetailsView extends StatelessWidget {
  const _DoctorDetailsView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Doctor Details')),
      body: BlocBuilder<DoctorDetailsCubit, DoctorDetailsState>(
        builder: (context, state) {
          if (state is DoctorDetailsLoading) {
            return const Center(child: CircularProgressIndicator());
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
            final doctor = state.doctor;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(doctor.name),
                  Text(doctor.specialtyName),
                  // ... باقي الـ UI
                ],
              ),
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}
