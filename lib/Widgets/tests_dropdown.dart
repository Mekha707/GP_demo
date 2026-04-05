// ignore_for_file: library_private_types_in_public_api, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healthcareapp_try1/Bloc/User_Bloc/Tests_Bloc/test_bloc.dart';
import 'package:healthcareapp_try1/Bloc/User_Bloc/Tests_Bloc/test_states.dart';
import 'package:healthcareapp_try1/Models/Booking_Models/test_model.dart';

class TestDropdownScreen extends StatefulWidget {
  final Function(List<Test> selectedTests) onTestsChanged; // لاحظ هنا بقت List

  const TestDropdownScreen({super.key, required this.onTestsChanged});

  @override
  _TestDropdownScreenState createState() => _TestDropdownScreenState();
}

class _TestDropdownScreenState extends State<TestDropdownScreen> {
  // قائمة لتخزين التحاليل المختارة
  List<Test> selectedTests = [];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TestBloc, TestStates>(
      builder: (context, state) {
        if (state is TestLoading) {
          return const Center(child: CircularProgressIndicator(strokeWidth: 2));
        } else if (state is TestLoaded) {
          return Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ExpansionTile(
                  title: Text(
                    selectedTests.isEmpty
                        ? "Select Medical Tests"
                        : "${selectedTests.length} Tests Selected",
                    style: const TextStyle(fontSize: 14, fontFamily: 'Agency'),
                  ),
                  children: state.tests.map((test) {
                    // فحص هل التحليل ده مختار ولا لا
                    bool isSelected = selectedTests.any((t) => t.id == test.id);

                    return CheckboxListTile(
                      title: Text(
                        test.name,
                        style: const TextStyle(
                          fontSize: 14,
                          fontFamily: 'Agency',
                        ),
                      ),
                      value: isSelected,
                      activeColor: Colors.teal, // لون المربع لما يتحدد
                      checkColor: Colors.white, // لون علامة الصح نفسها
                      side: BorderSide(color: Colors.grey.shade400),

                      onChanged: (bool? checked) {
                        setState(() {
                          if (checked == true) {
                            selectedTests.add(test);
                          } else {
                            selectedTests.removeWhere((t) => t.id == test.id);
                          }
                        });
                        // نبعت القائمة كاملة للأب
                        widget.onTestsChanged(selectedTests);
                      },
                    );
                  }).toList(),
                ),
              ),

              // عرض التحاليل المختارة على شكل Chips (اختياري بس شكلها شيك)
              if (selectedTests.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Wrap(
                    spacing: 8,
                    children: selectedTests
                        .map(
                          (test) => Chip(
                            label: Text(
                              test.name,
                              style: const TextStyle(
                                fontSize: 10,
                                fontFamily: 'Agency',
                                color: Colors.black,
                              ),
                            ),
                            backgroundColor: Colors.teal.withOpacity(0.5),

                            deleteIcon: const Icon(
                              Icons.cancel,
                              size: 16,
                              color: Colors.black,
                            ),
                            onDeleted: () {
                              setState(() {
                                selectedTests.removeWhere(
                                  (t) => t.id == test.id,
                                );
                              });
                              widget.onTestsChanged(selectedTests);
                            },
                            // 4. (اختياري) حواف الـ Chip
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                              side: BorderSide(color: Colors.black, width: 1),
                            ),

                            // 5. (اختياري) إضافة أيقونة في الأول
                            avatar: const Icon(
                              Icons.science_outlined,
                              size: 12,
                              color: Colors.black,
                            ),

                            // 6. (اختياري) تحسين المسافات الداخلية
                            padding: const EdgeInsets.all(4),
                          ),
                        )
                        .toList(),
                  ),
                ),
            ],
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
