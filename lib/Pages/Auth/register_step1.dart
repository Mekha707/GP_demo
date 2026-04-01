// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healthcareapp_try1/API/auth_service.dart';
import 'package:healthcareapp_try1/Bloc/Auth_Bloc/CityCubit/city_cubit.dart';
import 'package:healthcareapp_try1/Bloc/Auth_Bloc/RegisterationBloc/register_bloc.dart';
import 'package:healthcareapp_try1/Bloc/Auth_Bloc/RegisterationBloc/register_event.dart';
import 'package:healthcareapp_try1/Bloc/Auth_Bloc/RegisterationBloc/register_state.dart';
import 'package:healthcareapp_try1/Buttons/Icons_heart_stet.dart';
import 'package:healthcareapp_try1/Buttons/buttons.dart';
import 'package:healthcareapp_try1/Widgets/gender_toggle.dart';
import 'package:healthcareapp_try1/Widgets/custom_loader1.dart';
import 'package:healthcareapp_try1/Widgets/password_Filed.dart';
import 'package:geolocator/geolocator.dart';

class RegisterStep1 extends StatefulWidget {
  const RegisterStep1({super.key});

  @override
  State<RegisterStep1> createState() => _RegisterStep1State();
}

class _RegisterStep1State extends State<RegisterStep1> {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController dateOfBirthController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool obscurePassword = true;

  @override
  void initState() {
    super.initState();
    final currentState = context.read<RegisterBloc>().state;
    fullNameController.text = currentState.name;
    emailController.text = currentState.email;
    addressController.text = currentState.address;
    cityController.text = currentState.city;
    phoneController.text = currentState.phoneNumber;
    passwordController.text = currentState.password;
    dateOfBirthController.text =
        "${currentState.dateOfBirth.day}/${currentState.dateOfBirth.month}/${currentState.dateOfBirth.year}";
  }

  @override
  void dispose() {
    fullNameController.dispose();
    dateOfBirthController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    cityController.dispose();
    addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double containerWidth = size.width > 600 ? 400 : size.width * 0.85;

    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                const Color(0xffc4edff).withOpacity(0.2),
                Colors.white,
                const Color(0xffc4edff).withOpacity(0.2),
              ],
            ),
          ),
          child: SingleChildScrollView(
            child: Center(
              child: Container(
                width: containerWidth,
                margin: const EdgeInsets.symmetric(vertical: 30),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      const Iconheartstet(),
                      const SizedBox(height: 15),
                      const Text(
                        'Create Account',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Cotta',
                        ),
                      ),
                      Text(
                        'Step 1 of 2 - Personal Information',
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontFamily: 'Agency',
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Full Name
                      _buildField(
                        controller: fullNameController,
                        label: "Full Name",
                        icon: Icons.person,
                        onChanged: (value) {
                          context.read<RegisterBloc>().add(
                            PersonalInfoChanged(name: value),
                          );
                        },
                      ),
                      const SizedBox(height: 15),

                      // Birthday Field
                      _buildBirthdayField(),
                      const SizedBox(height: 15),

                      // City Dropdown
                      _buildCityDropDown(),

                      const SizedBox(height: 15),
                      // Address
                      _buildField(
                        controller: addressController,
                        label: "Address",
                        icon: Icons.home,
                        isAddress: true,
                        type: TextInputType.streetAddress,
                        onChanged: (val) {
                          context.read<RegisterBloc>().add(
                            PersonalInfoChanged(address: val),
                          );
                        },
                      ),
                      const SizedBox(height: 15),

                      // Address URL
                      BlocBuilder<RegisterBloc, RegisterState>(
                        buildWhen: (prev, curr) =>
                            prev.addressurl != curr.addressurl,
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
                                      ? Colors.green
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
                                        ? Colors.green
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
                                            ? Colors.green
                                            : Colors.grey[600],
                                        fontSize: 14,
                                        fontFamily: 'Agency',
                                      ),
                                    ),
                                  ),
                                  if (state.addressurl != null)
                                    GestureDetector(
                                      onTap: () =>
                                          context.read<RegisterBloc>().add(
                                            LocationCleared(),
                                          ), // ✅ التغيير هنا
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

                      // Gender Selector
                      const GenderToggle(),
                      const SizedBox(height: 15),

                      // Email
                      _buildField(
                        controller: emailController,
                        label: "Email",
                        icon: Icons.email,
                        type: TextInputType.emailAddress,
                        isEmail: true,
                        onChanged: (val) => context.read<RegisterBloc>().add(
                          PersonalInfoChanged(email: val),
                        ),
                      ),
                      const SizedBox(height: 15),

                      // Phone Number
                      _buildField(
                        controller: phoneController,
                        label: "Phone Number",
                        icon: Icons.phone_android,
                        type: TextInputType.phone,
                        isPhone: true,
                        onChanged: (val) => context.read<RegisterBloc>().add(
                          PersonalInfoChanged(phoneNumber: val),
                        ),
                      ),
                      const SizedBox(height: 15),

                      // Password
                      PasswordField(controller: passwordController),
                      const SizedBox(height: 10),

                      // Next
                      ButtonOfAuth(
                        buttonText: "Next",
                        buttoncolor: const Color(0xFF2D6CDF),
                        fontcolor: Colors.white,
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            Navigator.pushNamed(context, 'Register2');
                          }
                        },
                      ),
                      const SizedBox(height: 10),

                      // Back To Login
                      ButtonOfAuth(
                        buttonText: "Back To Login",
                        fontcolor: Colors.black,
                        buttoncolor: Colors.grey.shade200,
                        onPressed: () {
                          Navigator.pushReplacementNamed(context, 'Login');
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  BlocProvider<CitiesCubit> _buildCityDropDown() {
    return BlocProvider(
      create: (_) => CitiesCubit(AuthService())..getCities(),
      child: BlocBuilder<CitiesCubit, CitiesState>(
        builder: (context, state) {
          if (state is CitiesLoading) {
            return const CustomSpinner(color: Color(0xff0861dd), size: 40);
          }
          if (state is CitiesError) {
            return Text(state.message);
          }
          if (state is CitiesSuccess) {
            return DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'City',
                prefixIcon: const Icon(
                  Icons.location_city,
                  color: Color(0xff0861dd),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: Color(0xff0861dd),
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              hint: const Text('Select City'),
              // ✅ عشان لو رجع المستخدم للصفحة يلاقي اختياره
              value: context.read<RegisterBloc>().state.city.isEmpty
                  ? null
                  : context.read<RegisterBloc>().state.city,
              items: state.cities
                  .map(
                    (city) => DropdownMenuItem(value: city, child: Text(city)),
                  )
                  .toList(),
              onChanged: (city) {
                context.read<RegisterBloc>().add(
                  PersonalInfoChanged(city: city ?? ''),
                );
              },
              // ✅ مهم عشان الـ form validation يشتغل
              validator: (value) =>
                  value == null ? 'Please select a city' : null,
            );
          }
          return const SizedBox();
        },
      ),
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType type = TextInputType.text,
    bool isPhone = false,
    bool isEmail = false,
    bool isAddress = false,
    Function(String)? onChanged,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: type,
      textInputAction: TextInputAction.next,
      maxLength: isPhone ? 11 : null,
      inputFormatters: isPhone
          ? [FilteringTextInputFormatter.digitsOnly]
          : (isEmail || isAddress) // ✅ Address مفيش formatter
          ? null
          : [
              FilteringTextInputFormatter.allow(
                RegExp(r'[a-zA-Z0-9\u0600-\u065F\u066A-\u06FF\s/-]'),
              ),
            ],
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          color: Colors.grey.shade700,
          fontSize: 14,
          fontFamily: 'Agency',
        ),
        counterText: "", // لإخفاء عداد الحروف لو مش محتاجه
        prefixIcon: Icon(icon, color: const Color(0xff0861dd)),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Color(0xff0861dd), width: 2),
        ),
      ),
      validator: (val) {
        if (val == null || val.isEmpty) return "Required field";
        return null;
      },
    );
  }

  Widget _buildBirthdayField() {
    return BlocBuilder<RegisterBloc, RegisterState>(
      buildWhen: (prev, curr) => prev.dateOfBirth != curr.dateOfBirth,
      builder: (context, state) {
        dateOfBirthController.text =
            "${state.dateOfBirth.day}/${state.dateOfBirth.month}/${state.dateOfBirth.year}";
        return TextFormField(
          controller: dateOfBirthController,
          readOnly: true,
          onTap: () => _showCupertinoDatePicker(context, state.dateOfBirth),
          decoration: InputDecoration(
            labelText: "Birthday",
            prefixIcon: const Icon(
              Icons.calendar_month,
              color: Color(0xff0861dd),
            ),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
          ),
        );
      },
    );
  }

  void _showCupertinoDatePicker(BuildContext context, DateTime initialDate) {
    showModalBottomSheet(
      context: context,
      builder: (_) => Container(
        height: 250,
        color: Colors.white,
        child: CupertinoDatePicker(
          initialDateTime: initialDate,
          mode: CupertinoDatePickerMode.date,
          onDateTimeChanged: (date) =>
              context.read<RegisterBloc>().add(BirthdayChanged(date)),
        ),
      ),
    );
  }

  // أضف الـ method دي في الـ State class
  Future<void> _getCurrentLocation(BuildContext context) async {
    try {
      // طلب إذن الموقع
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

      // جيب الموقع
      final Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // عمل Google Maps URL من الـ coordinates
      final String mapsUrl =
          "https://www.google.com/maps?q=${position.latitude},${position.longitude}";

      // ابعت للـ BLoC
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
