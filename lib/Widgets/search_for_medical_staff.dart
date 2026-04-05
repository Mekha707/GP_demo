// ignore_for_file: deprecated_member_use, dead_code, unnecessary_null_comparison, unused_field, no_leading_underscores_for_local_identifiers

import 'dart:async';

import 'package:animated_custom_dropdown/custom_dropdown.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healthcareapp_try1/Bloc/Auth_Bloc/CityCubit/city_cubit.dart';
import 'package:healthcareapp_try1/Bloc/User_Bloc/LabBloc/lab_bloc.dart';
import 'package:healthcareapp_try1/Bloc/User_Bloc/LabBloc/lab_event.dart';
import 'package:healthcareapp_try1/Bloc/User_Bloc/NurseBloc/nurse_bloc.dart';
import 'package:healthcareapp_try1/Bloc/User_Bloc/NurseBloc/nurse_event.dart';
import 'package:healthcareapp_try1/Bloc/User_Bloc/SpecialtyBloc/specialty_bloc.dart';
import 'package:healthcareapp_try1/Bloc/User_Bloc/SpecialtyBloc/specialty_state.dart';
import 'package:healthcareapp_try1/Bloc/User_Bloc/Tests_Bloc/test_bloc.dart';
import 'package:healthcareapp_try1/Bloc/User_Bloc/Tests_Bloc/test_events.dart';
import 'package:healthcareapp_try1/Models/Auth_Models/location_model.dart';
import 'package:healthcareapp_try1/Models/Users_Models/enums.dart';
import 'package:healthcareapp_try1/Models/Users_Models/specialty_model.dart';
import 'package:healthcareapp_try1/Widgets/service_type_widget.dart';
import 'package:healthcareapp_try1/Widgets/tests_dropdown.dart';

// Nurse && Lab
class SearchForNurseAndLab extends StatefulWidget {
  const SearchForNurseAndLab({
    super.key,
    required this.medicalStaff,
    required this.onFilterChanged,
  });
  final MedicalStaff medicalStaff;
  final Function(String name, Specialty? specialty, String? _selectedCity)
  onFilterChanged; // الدالة المرسلة

  @override
  State<SearchForNurseAndLab> createState() => _SearchForNurseAndLab();
}

class _SearchForNurseAndLab extends State<SearchForNurseAndLab> {
  // أضف هذا السطر مع تعريف المتغيرات في البداية
  final _cityController = SingleSelectController<String?>(null);
  String? _selectedCity;
  Timer? _debounce;
  List<String> selectedTestIds = [];
  String _searchName = "";
  Specialty? _selectedSpecialty;

  @override
  void initState() {
    super.initState();
    // تأكدي أن الـ Cubit موجود في الـ Context
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CitiesCubit>().getCities();
      context.read<TestBloc>().add(FetchLabTests());
    });
  }

  void _onSearchChanged(String query) {
    _searchName = query;

    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 700), () {
      // نستخدم الدالة الموحدة بدل كتابة منطق الـ Bloc هنا
      _updateFilters();
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  void _updateFilters() {
    if (widget.medicalStaff == MedicalStaff.lab) {
      // إرسال لـ LabsBloc
      context.read<LabsBloc>().add(
        FilterLabs(
          name: _searchName,
          location: _selectedCity,
          testIds: selectedTestIds,
        ),
      );
    } else if (widget.medicalStaff == MedicalStaff.nurse) {
      // إرسال لـ NursesBloc
      context.read<NursesBloc>().add(
        FilterNurses(
          name: _searchName,
          cityName:
              _selectedCity, // تأكد إن الاسم في الـ Event هو cityName أو location
        ),
      );
    }

    // إبلاغ الـ Parent بالتحديث (اختياري حسب حاجتك)
    widget.onFilterChanged(_searchName, _selectedSpecialty, _selectedCity);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.medicalStaff == MedicalStaff.nurse
                ? "Book a Nurse for Home Care"
                : (widget.medicalStaff == MedicalStaff.lab
                      ? "Book Lab Tests"
                      : " "),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 17,
              fontFamily: 'Cotta',
            ),
          ),
          Text(
            (widget.medicalStaff == MedicalStaff.nurse
                ? "Professional nursing services at your doorstep"
                : (widget.medicalStaff == MedicalStaff.lab
                      ? "Get lab tests done at home or visit the lab"
                      : "")),
            style: TextStyle(
              color: Colors.grey.shade800,
              fontSize: 13,
              fontFamily: 'Agency',
            ),
            maxLines: 1,
          ),

          SizedBox(height: 10),
          // Search by Name
          Text(
            "Search By Name",
            style: TextStyle(color: Colors.grey.shade800, fontFamily: 'Agency'),
          ),
          SizedBox(height: 5),
          TextField(
            onChanged: _onSearchChanged,
            decoration: InputDecoration(
              hintStyle: TextStyle(
                color: Colors.grey.shade800,
                fontSize: 14,
                fontFamily: 'Agency',
              ),
              hintText: widget.medicalStaff == MedicalStaff.nurse
                  ? "Nurse Name..."
                  : (widget.medicalStaff == MedicalStaff.lab
                        ? "Lab Name..."
                        : " "),
              prefixIcon: const Icon(Icons.search, size: 20),
              filled: true,
              fillColor: Colors.grey[100],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Test Dropdown (يظهر فقط لو المستخدم بيبحث عن Lab)
          widget.medicalStaff == MedicalStaff.lab
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Lab Test ",
                      style: TextStyle(
                        color: Colors.grey.shade800,
                        fontFamily: 'Agency',
                      ),
                    ),
                    const SizedBox(height: 5),
                    TestDropdownScreen(
                      onTestsChanged: (tests) {
                        setState(() {
                          // بنجمع أسامي التحاليل في قائمة نصوص عشان نبعتها للـ API
                          selectedTestIds = tests.map((e) => e.id).toList();
                          _updateFilters();
                        });
                      },
                    ),
                    const SizedBox(height: 12),
                  ],
                )
              : const SizedBox.shrink(),

          // Location
          Text(
            "Location",
            style: TextStyle(color: Colors.grey.shade800, fontFamily: 'Agency'),
          ),
          SizedBox(height: 5),
          buildLocationField(context),
        ],
      ),
    );
  }

  Widget buildLocationField(BuildContext context) {
    return BlocBuilder<CitiesCubit, CitiesState>(
      builder: (context, state) {
        List<String> cityItems = [];
        if (state is CitiesSuccess) {
          cityItems = state.cities;
        }

        return CustomDropdown<String>.search(
          controller: _cityController,
          hintText: state is CitiesLoading ? 'Loading...' : 'Select City',
          items: cityItems,
          onChanged: (value) {
            setState(() {
              _selectedCity = value;
              _updateFilters();
            });
          },
          headerBuilder: (context, selectedItem, _) {
            return Row(
              children: [
                const Icon(
                  Icons.location_on,
                  color: Colors.redAccent,
                  size: 18,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    selectedItem,
                    style: const TextStyle(fontSize: 14, fontFamily: 'Agency'),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (selectedItem != null)
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _cityController.clear();
                        _selectedCity = null;
                        _updateFilters();
                      });
                    },
                    child: const Icon(
                      Icons.close,
                      size: 14,
                      color: Colors.grey,
                    ),
                  ),
              ],
            );
          },
          listItemBuilder: (context, item, isSelected, onItemSelect) {
            return Text(
              item,
              style: TextStyle(
                fontSize: 14,
                fontFamily: 'Agency',
                color: isSelected ? Colors.blue : Colors.black,
              ),
            );
          },
          decoration: CustomDropdownDecoration(
            closedFillColor: Colors.grey.shade100,
            expandedFillColor: Colors.white,
            hintStyle: TextStyle(
              color: Colors.grey.shade800,
              fontFamily: 'Agency',
              fontSize: 14,
            ),
          ),
        );
      },
    );
  }
}

// Doctor
class SearchForDoctor extends StatefulWidget {
  const SearchForDoctor({super.key, required this.onFilterChanged});
  final Function(
    String name,
    Specialty? specialty,
    String? cityName,
    String serviceType,
  )
  onFilterChanged; // الدالة المرسلة

  @override
  State<SearchForDoctor> createState() => _SearchForDoctor();
}

class _SearchForDoctor extends State<SearchForDoctor> {
  // أضف هذا السطر مع تعريف المتغيرات في البداية
  final _specialtyController = SingleSelectController<Specialty?>(null);
  final _cityController = SingleSelectController<String?>(null);
  String? _selectedCity;

  // تعريف المتغير الذي سيحمل القيمة المختارة
  String _searchName = "";
  Specialty? _selectedSpecialty;
  String _selectedServiceString = "clinic";
  LocationModel? _selectedLocation;
  Timer? _debounce;

  // دالة مساعدة لتحديث الأب
  void _updateFilters() {
    widget.onFilterChanged(
      _searchName,
      _selectedSpecialty,
      _selectedCity,
      _selectedServiceString, // ✅ أضف ده
    );
  }

  @override
  void initState() {
    super.initState();
    // تأكد من استدعاء الدالة التي تجلب المدن هنا
    context.read<CitiesCubit>().getCities();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 700), () {
      // 700ms وقت مثالي
      _searchName = query;
      _updateFilters();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Find a Doctor",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              fontFamily: 'Cotta',
            ),
          ),
          SizedBox(height: 4),

          _buildSearchByName(),

          const SizedBox(height: 12),

          Row(
            children: [
              // Specialty
              Expanded(
                flex: 2,
                child: Column(
                  children: [
                    SizedBox(height: 5),
                    buildDropDownSpecialty(context),
                  ],
                ),
              ),

              const SizedBox(width: 8),

              // Location
              Expanded(
                flex: 2,
                child: Column(
                  children: [SizedBox(height: 5), buildLocationField(context)],
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Text(
            "Service Type",
            style: TextStyle(color: Colors.grey.shade800, fontFamily: 'Agency'),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              FlipRadioButton<String>(
                value: "clinic",
                groupValue: _selectedServiceString,
                onChanged: (val) {
                  setState(() {
                    _selectedServiceString = val;
                    _updateFilters(); // ✅ أضف السطر ده
                  });
                },
                labelA: "Clinic",
                labelB: "Clinic",
              ),
              FlipRadioButton<String>(
                value: "online",
                groupValue: _selectedServiceString,
                onChanged: (val) {
                  setState(() {
                    _selectedServiceString = val;
                    _updateFilters(); // ✅ أضف السطر ده
                  });
                },
                labelA: "Online",
                labelB: "Online",
              ),
              FlipRadioButton<String>(
                value: "home",
                groupValue: _selectedServiceString,
                onChanged: (val) {
                  setState(() {
                    _selectedServiceString = val;
                    _updateFilters(); // ✅ أضف السطر ده
                  });
                },
                labelA: "home",
                labelB: "home",
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildDropDownSpecialty(BuildContext context) {
    return BlocBuilder<SpecialtyBloc, SpecialtyState>(
      builder: (context, state) {
        List<Specialty> items = [];

        if (state is SpecialtyLoaded) {
          items = state.specialties;
        }

        return CustomDropdown<Specialty>.search(
          controller: _specialtyController, // الربط بالكنترولر
          hintText: state is SpecialtyLoading
              ? 'Loading...'
              : 'Select Specialty',
          items: items,
          excludeSelected: false,

          onChanged: (value) {
            setState(() {
              _selectedSpecialty = value;
              _updateFilters(); // دي هتبعت الـ ID الجديد للـ DoctorsBloc
            });
          },
          headerBuilder: (context, selectedItem, _) {
            if (selectedItem == null) {
              return Text(
                'Select Specialty',
                style: TextStyle(fontSize: 11, color: Colors.grey.shade800),
              );
            }

            return Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Icon(selectedItem.icon, color: selectedItem.color, size: 14),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    selectedItem.name,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow
                        .ellipsis, // يضع نقاط ... إذا كان النص طويلاً جداً
                    maxLines: 1,
                  ),
                ),

                GestureDetector(
                  onTap: () {
                    setState(() {
                      _specialtyController.clear();
                      _selectedSpecialty = null;
                      _updateFilters();
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(2), // مساحة لمس بسيطة
                    child: const Icon(
                      Icons.close,
                      size: 14, // تصغير أيقونة الحذف
                      color: Colors.grey,
                    ),
                  ),
                ),
              ],
            );
          },

          listItemBuilder: (context, item, isSelected, onItemSelect) {
            return Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: item.color.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(item.icon, color: item.color, size: 11),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Text(
                    item.name,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                      fontFamily: 'Agency',
                      color: isSelected ? Colors.blue : Colors.black87,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                if (isSelected)
                  const Icon(Icons.check, color: Colors.blue, size: 11),
              ],
            );
          },
          // تحسين الشكل الجمالي ليناسب تطبيق طبي
          decoration: CustomDropdownDecoration(
            hintStyle: TextStyle(
              color: Colors.grey.shade800, // لون الخط
              fontSize: 11, // حجم الخط

              fontWeight: FontWeight.w400, // وزن الخط
              fontFamily: 'Agency', // إذا كنت تستخدم خطاً مخصصاً
            ),
            closedFillColor: Colors.grey.shade100,
            expandedFillColor: Colors.white,
          ),
        );
      },
    );
  }

  Widget buildLocationField(BuildContext context) {
    return BlocBuilder<CitiesCubit, CitiesState>(
      builder: (context, state) {
        List<String> cityItems = [];
        if (state is CitiesSuccess) {
          cityItems = state.cities;
        }

        return CustomDropdown<String>.search(
          controller: _cityController,
          hintText: state is CitiesLoading ? 'Loading...' : 'Select City',
          items: cityItems,
          onChanged: (value) {
            setState(() {
              _selectedCity = value;
              _updateFilters();
            });
          },
          // إضافة listItemBuilder للتأكد من ظهور العناصر في القائمة
          listItemBuilder: (context, item, isSelected, onItemSelect) {
            return Text(
              item,
              style: TextStyle(
                fontSize: 14,
                fontFamily: 'Agency',
                color: isSelected ? Colors.blue : Colors.black,
              ),
            );
          },
          headerBuilder: (context, selectedItem, _) {
            return Row(
              children: [
                const Icon(
                  Icons.location_on,
                  color: Colors.redAccent,
                  size: 18,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    selectedItem,
                    style: const TextStyle(fontSize: 12, fontFamily: 'Agency'),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (selectedItem != null)
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _cityController.clear();
                        _selectedCity = null;
                        _updateFilters();
                      });
                    },
                    child: const Icon(
                      Icons.close,
                      size: 14,
                      color: Colors.grey,
                    ),
                  ),
              ],
            );
          },
          decoration: CustomDropdownDecoration(
            closedFillColor: Colors.grey.shade100,
            expandedFillColor: Colors.white,
            hintStyle: TextStyle(
              color: Colors.grey.shade800,
              fontFamily: 'Agency',
              fontSize: 12,
            ),
          ),
        );
      },
    );
  }

  Widget _buildSearchByName() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            onChanged: _onSearchChanged,
            decoration: InputDecoration(
              hintStyle: TextStyle(
                color: Colors.grey.shade800,
                fontSize: 12,
                fontFamily: 'Agency',
              ),
              hintText: "Doctor name...",
              prefixIcon: const Icon(Icons.search, size: 20),
              filled: true,
              fillColor: Colors.grey[100],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
