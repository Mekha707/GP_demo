// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:healthcareapp_try1/API/auth_service.dart';
import 'package:healthcareapp_try1/Bloc/Auth_Bloc/Patient_Profile.dart/patient_profile_cubit.dart';
import 'package:healthcareapp_try1/Bloc/Auth_Bloc/Patient_Profile.dart/patient_profile_state.dart';
import 'package:healthcareapp_try1/Bloc/Auth_Bloc/RegisterationBloc/register_bloc.dart';
import 'package:healthcareapp_try1/Bloc/Auth_Bloc/RegisterationBloc/register_event.dart';
import 'package:healthcareapp_try1/Bloc/Auth_Bloc/RegisterationBloc/register_state.dart';
import 'package:healthcareapp_try1/Buttons/buttons.dart';
import 'package:healthcareapp_try1/Models/Auth_Models/patient_profile_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditProfilePage extends StatefulWidget {
  final PatientProfile profile;
  const EditProfilePage({super.key, required this.profile});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  final cityController = TextEditingController();
  final weightController = TextEditingController();
  final addressUrlController = TextEditingController();

  String userId = "";
  List<String> _cities = [];
  String? _selectedCity;
  bool _citiesError = false;

  @override
  void initState() {
    super.initState();
    nameController.text = widget.profile.name;
    phoneController.text = widget.profile.phoneNumber;
    addressController.text = widget.profile.address;
    cityController.text = widget.profile.city;
    weightController.text = widget.profile.weight?.toString() ?? "";
    addressUrlController.text = widget.profile.addressUrl ?? "";
    _selectedCity = widget.profile.city;
    getUserId();
    _loadCities();
  }

  Future<void> _loadCities() async {
    try {
      final cities = await AuthService().getCities();
      if (mounted) {
        setState(() {
          _cities = cities;
          // تأكد إن الـ selectedCity موجودة في القايمة
          if (!_cities.contains(_selectedCity)) {
            _selectedCity = null;
          }
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _citiesError = true);
      }
    }
  }

  Future<void> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    userId = prefs.getString("userId") ?? "";
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    addressController.dispose();
    cityController.dispose();
    weightController.dispose();
    addressUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text(
          "Edit Profile",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xff0861dd),
      ),
      body: BlocListener<ProfileCubit, ProfileState>(
        listener: (context, state) {
          if (state is ProfileUpdated) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Profile updated successfully")),
            );
            Navigator.pop(context);
          }
          if (state is ProfileError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: ListView(
            children: [
              // ── Name ──────────────────────────────────────────────
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: "Name",
                  counterText: "",
                  prefixIcon: const Icon(
                    Icons.abc_sharp,
                    color: Color(0xff0861dd),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(
                      color: Color(0xff0861dd),
                      width: 2,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 15),

              // ── Phone ─────────────────────────────────────────────
              TextField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: "Phone",
                  counterText: "",
                  prefixIcon: const Icon(
                    Icons.phone_android,
                    color: Color(0xff0861dd),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(
                      color: Color(0xff0861dd),
                      width: 2,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 15),

              // ── City ──────────────────────────────────────────────
              _citiesError
                  ? const Text(
                      "Failed to load cities",
                      style: TextStyle(color: Colors.red),
                    )
                  : _cities.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: "City",
                        prefixIcon: const Icon(
                          Icons.location_city,
                          color: Color(0xff0861dd),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: const BorderSide(
                            color: Color(0xff0861dd),
                            width: 2,
                          ),
                        ),
                      ),
                      hint: const Text('Select City'),
                      value: _selectedCity,
                      items: _cities
                          .map(
                            (city) => DropdownMenuItem(
                              value: city,
                              child: Text(city),
                            ),
                          )
                          .toList(),
                      onChanged: (city) {
                        setState(() {
                          _selectedCity = city;
                          cityController.text = city ?? "";
                        });
                      },
                    ),
              const SizedBox(height: 15),

              // ── Address ───────────────────────────────────────────
              TextField(
                controller: addressController,
                decoration: InputDecoration(
                  labelText: "Address",
                  counterText: "",
                  prefixIcon: const Icon(Icons.home, color: Color(0xff0861dd)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(
                      color: Color(0xff0861dd),
                      width: 2,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 15),

              // ── Location Button ───────────────────────────────────
              BlocBuilder<RegisterBloc, RegisterState>(
                buildWhen: (prev, curr) => prev.addressurl != curr.addressurl,
                builder: (context, state) {
                  return GestureDetector(
                    onTap: () => _getCurrentLocation(context),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: state.addressurl != null
                              ? Colors.lightGreen
                              : const Color(0xff0861dd),
                          width: state.addressurl != null ? 2 : 1,
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            state.addressurl != null
                                ? Icons.location_on
                                : Icons.my_location,
                            color: state.addressurl != null
                                ? Colors.lightGreen
                                : const Color(0xff0861dd),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              state.addressurl != null
                                  ? 'Location captured ✓'
                                  : 'Get Current Location (Optional)',
                              style: TextStyle(
                                color: state.addressurl != null
                                    ? Colors.lightGreen
                                    : Colors.grey[600],
                                fontSize: 14,
                              ),
                            ),
                          ),
                          if (state.addressurl != null)
                            GestureDetector(
                              onTap: () => context.read<RegisterBloc>().add(
                                LocationCleared(),
                              ),
                              child: const Icon(
                                Icons.close,
                                color: Colors.grey,
                                size: 18,
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 15),

              // ── Weight ────────────────────────────────────────────
              TextField(
                controller: weightController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Weight (Optional)",
                  counterText: "",
                  prefixIcon: const Icon(
                    Icons.monitor_weight,
                    color: Color(0xff0861dd),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(
                      color: Color(0xff0861dd),
                      width: 2,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // ── Save Button ───────────────────────────────────────
              BlocBuilder<ProfileCubit, ProfileState>(
                builder: (context, state) {
                  if (state is ProfileUpdating) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return ButtonOfAuth(
                    buttonText: "Save Changes",
                    buttoncolor: Colors.grey.shade50,
                    fontcolor: Colors.lightGreen,
                    borderSide: const BorderSide(color: Colors.lightGreen),
                    onPressed: () async {
                      if (userId.isEmpty) await getUserId();

                      if (userId.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              "Session expired, please login again",
                            ),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }

                      if (nameController.text.isEmpty ||
                          phoneController.text.isEmpty ||
                          addressController.text.isEmpty ||
                          cityController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Please fill in all required fields"),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }

                      context.read<ProfileCubit>().updateProfile(
                        userId: userId,
                        name: nameController.text,
                        phoneNumber: phoneController.text,
                        address: addressController.text,
                        city: cityController.text,
                        addressUrl: addressUrlController.text.isEmpty
                            ? null
                            : addressUrlController.text,
                        weight: weightController.text.isEmpty
                            ? null
                            : double.tryParse(weightController.text),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _getCurrentLocation(BuildContext context) async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permission denied')),
          );
          return;
        }
      }
      if (permission == LocationPermission.deniedForever) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enable location from settings')),
        );
        return;
      }

      final Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      final String mapsUrl =
          "https://www.google.com/maps?q=${position.latitude},${position.longitude}";

      if (context.mounted) {
        context.read<RegisterBloc>().add(LocationChanged(mapsUrl));
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Location captured ✓'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to get location: $e')));
      }
    }
  }
}
