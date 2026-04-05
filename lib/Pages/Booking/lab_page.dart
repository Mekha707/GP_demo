// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:healthcareapp_try1/API/lab_service.dart';
// import 'package:healthcareapp_try1/Bloc/User_Bloc/LabBloc/lab_bloc.dart';
// import 'package:healthcareapp_try1/Bloc/User_Bloc/LabBloc/lab_state.dart';
// import 'package:healthcareapp_try1/Buttons/buttons.dart';
// import 'package:healthcareapp_try1/Models/Users_Models/lab_model.dart';
// import 'package:healthcareapp_try1/Widgets/custom_loader1.dart';

// class LabsScreen extends StatelessWidget {
//   const LabsScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (_) => LabsCubit(
//         LabService(
//           Dio(
//             BaseOptions(
//               baseUrl: 'https://unalterably-unasphalted-felton.ngrok-free.dev/',
//               connectTimeout: const Duration(seconds: 10),
//               receiveTimeout: const Duration(seconds: 10),
//             ),
//           ),
//         ),
//       )..loadLabs(),
//       child: const _LabsView(),
//     );
//   }
// }

// class _LabsView extends StatelessWidget {
//   const _LabsView();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: BlocBuilder<LabsCubit, LabsState>(
//         builder: (context, state) {
//           if (state is LabsLoading) {
//             return const Center(
//               child: CustomSpinner(color: Colors.teal, size: 40),
//             );
//           }

//           if (state is LabsError) {
//             return Center(
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Text(state.message),
//                   const SizedBox(height: 12),
//                   ButtonOfAuth(
//                     onPressed: () => context.read<LabsCubit>().loadLabs(),
//                     fontcolor: Colors.white,
//                     buttoncolor: Colors.teal,
//                     buttonText: "Try Again",
//                   ),
//                 ],
//               ),
//             );
//           }

//           if (state is LabsLoaded) {
//             return RefreshIndicator(
//               onRefresh: () => context.read<LabsCubit>().loadLabs(),
//               child: ListView.builder(
//                 itemCount: state.labs.length + (state.hasNextPage ? 1 : 0),
//                 itemBuilder: (context, index) {
//                   if (index == state.labs.length) {
//                     if (!state.isLoadingMore) {
//                       WidgetsBinding.instance.addPostFrameCallback((_) {
//                         context.read<LabsCubit>().loadMore();
//                       });
//                     }
//                     return const Padding(
//                       padding: EdgeInsets.all(16),
//                       child: Center(
//                         child: CustomSpinner(color: Colors.teal, size: 40),
//                       ),
//                     );
//                   }
//                   return LabCard(lab: state.labs[index]);
//                 },
//               ),
//             );
//           }

//           return const SizedBox.shrink();
//         },
//       ),
//     );
//   }
// }

// class LabCard extends StatelessWidget {
//   final LabModel lab;
//   const LabCard({super.key, required this.lab});

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//       child: ListTile(
//         leading: CircleAvatar(
//           backgroundImage: NetworkImage(lab.profilePictureUrl),
//         ),
//         title: Text(lab.name),
//         subtitle: Text(lab.address),
//         trailing: lab.ratingsCount > 0
//             ? Row(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   const Icon(Icons.star, size: 16, color: Colors.amber),
//                   const SizedBox(width: 4),
//                   Text(lab.rating.toStringAsFixed(1)),
//                 ],
//               )
//             : const Text('No Rating Yet', style: TextStyle(fontSize: 12)),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healthcareapp_try1/Bloc/User_Bloc/LabBloc/lab_bloc.dart';
import 'package:healthcareapp_try1/Bloc/User_Bloc/LabBloc/lab_event.dart';
import 'package:healthcareapp_try1/Bloc/User_Bloc/LabBloc/lab_state.dart';
import 'package:healthcareapp_try1/Buttons/buttons.dart';
import 'package:healthcareapp_try1/Buttons/filter_button.dart';
import 'package:healthcareapp_try1/Models/Users_Models/enums.dart';
import 'package:healthcareapp_try1/Pages/Booking/healtcare_provider.dart';
import 'package:healthcareapp_try1/Widgets/custom_loader1.dart';
import 'package:healthcareapp_try1/Widgets/medical_staff_cards.dart';
import 'package:healthcareapp_try1/Widgets/search_for_medical_staff.dart';

class LabPage extends StatefulWidget {
  const LabPage({super.key});

  @override
  State<LabPage> createState() => _LabPageState();
}

class _LabPageState extends State<LabPage> {
  final ScrollController _scrollController = ScrollController();
  bool isFilterd = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    context.read<LabsBloc>().add(FetchLabs());
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
      context.read<LabsBloc>().add(LoadMoreLabs());
    }
  }

  @override
  Widget build(BuildContext context) {
    // لاحظي هنا: لم نعد نغلف الشاشة كلها بـ BlocConsumer
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      // أضفت Scaffold للتأكد من الخلفية
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<LabsBloc>().add(RefreshLabs());
        },
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            // زر الفلتر يظل يستخدم setState لأنه يغير حالة local (isFilterd)
            CustomFilterButton(
              isSelected: isFilterd,
              inactiveText: "Filter Labs",
              onTap: () {
                setState(() {
                  isFilterd = !isFilterd;
                });
              },
              activeColor: Colors.teal,
            ),

            // 1. الفلتر الآن "خارج" الـ BlocBuilder الخاص بالنتائج
            // لن يتأثر بتغير الـ State بتاع الـ Bloc (إلا لو إنتِ عايزة كده)
            SliverAnimatedOpacity(
              opacity: isFilterd ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 400),
              sliver: isFilterd
                  ? SliverToBoxAdapter(
                      child: SearchForNurseAndLab(
                        medicalStaff: MedicalStaff.lab,
                        onFilterChanged: (name, specialty, location) {
                          // هنا نرسل الـ Event للـ Bloc فقط، ولا نحتاج لعمل setState في الـ Parent
                          context.read<LabsBloc>().add(
                            FilterLabs(name: name, location: location),
                          );
                        },
                      ),
                    )
                  : const SliverToBoxAdapter(child: SizedBox.shrink()),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 10)),

            // 2. هنا نضع الـ BlocBuilder فقط للجزء الذي يتغير فعلياً (القائمة)
            BlocBuilder<LabsBloc, LabsState>(
              builder: (context, state) {
                if (state is LabsLoading) {
                  return const SliverFillRemaining(
                    child: Center(
                      child: CustomSpinner(size: 40, color: Colors.teal),
                    ),
                  );
                }

                if (state is LabsError) {
                  return SliverFillRemaining(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            state.message,
                            style: const TextStyle(color: Colors.teal),
                          ),
                          const SizedBox(height: 12),
                          ButtonOfAuth(
                            onPressed: () =>
                                context.read<LabsBloc>().add(FetchLabs()),
                            buttonText: "Try Again",
                            fontcolor: Colors.white,
                            buttoncolor: Colors.teal,
                          ),
                        ],
                      ),
                    ),
                  );
                }

                if (state is LabsLoaded) {
                  if (state.filteredLabs.isEmpty) {
                    return const SliverFillRemaining(
                      child: Center(child: Text('لا توجد معامل مطابقة للبحث')),
                    );
                  }

                  return SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        if (index == state.filteredLabs.length) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.all(16),
                              child: CustomSpinner(
                                color: Colors.teal,
                                size: 40,
                              ),
                            ),
                          );
                        }
                        final lab = state.filteredLabs[index];
                        return UniversalMedicalCard(
                          provider: lab as HealthcareProvider,
                        );
                      },
                      childCount:
                          state.filteredLabs.length +
                          (state.isLoadingMore ? 1 : 0),
                    ),
                  );
                }
                return const SliverToBoxAdapter(child: SizedBox());
              },
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 150)),
          ],
        ),
      ),
    );
  }
}
