// ignore_for_file: deprecated_member_use, curly_braces_in_flow_control_structures

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:healthcareapp_try1/API/user_service.dart';
import 'package:healthcareapp_try1/Bloc/BookingBloc/doctor_booking_cubit.dart';
import 'package:healthcareapp_try1/Pages/Booking/healtcare_provider.dart';
import 'package:healthcareapp_try1/Widgets/custom_loader1.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class BookingConfirmationPage extends StatelessWidget {
  final HealthcareProvider provider;
  final String selectedService;
  final DateTime selectedDate;
  final String selectedTime;
  final String slotId;
  final String token;
  final double? totalFee;
  final double? serviceFee;
  final String providerType; // ✅ جديد
  final int? hours; // ✅ للنيرس بس
  final List<String>? labTestsIds;
  final List<String>? labTestsNames;
  const BookingConfirmationPage({
    super.key,
    required this.provider,
    required this.selectedService,
    required this.selectedDate,
    required this.selectedTime,
    required this.slotId,
    required this.token,
    required this.providerType,
    this.labTestsIds,
    this.hours,
    this.totalFee,
    this.serviceFee,
    this.labTestsNames,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => BookingCubit(context.read<UserService>()),
      child: _BookingConfirmationView(
        provider: provider,
        selectedService: selectedService,
        selectedDate: selectedDate,
        selectedTime: selectedTime,
        slotId: slotId,
        token: token,
        providerType: providerType,
        hours: hours,
        totalFee: totalFee,
        labTestsIds: labTestsIds, // ✅ ده كان ناقص
        labTestsNames: labTestsNames, // ✅ جديد
      ),
    );
  }
}

class _BookingConfirmationView extends StatefulWidget {
  final HealthcareProvider provider;
  final String selectedService;
  final DateTime selectedDate;
  final String selectedTime;
  final String slotId;
  final String token;
  final String providerType;
  final int? hours;
  final List<String>? labTestsIds;
  final List<String>? labTestsNames;
  final double? totalFee;

  const _BookingConfirmationView({
    required this.provider,
    required this.selectedService,
    required this.selectedDate,
    required this.selectedTime,
    required this.slotId,
    required this.token,
    required this.providerType,
    this.labTestsIds,
    this.hours,
    this.labTestsNames,
    this.totalFee,
  });

  @override
  State<_BookingConfirmationView> createState() =>
      _BookingConfirmationViewState();
}

class _BookingConfirmationViewState extends State<_BookingConfirmationView> {
  final TextEditingController _notesController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  String? _savedAddress;
  @override
  void initState() {
    super.initState();
    _loadSavedAddress();
  }

  Future<void> _loadSavedAddress() async {
    final prefs = await SharedPreferences.getInstance();

    // جرب تجيبه بأكتر من طريقة
    final address =
        prefs.getString('address') ??
        prefs.getString('user_address') ??
        prefs.getString('userAddress') ??
        '';

    // لو مش لاقيه منفرد، جرب من الـ user JSON
    if (address.isEmpty) {
      final userJson =
          prefs.getString('user') ?? prefs.getString('userData') ?? '';
      if (userJson.isNotEmpty) {
        try {
          final map = jsonDecode(userJson);
          final fromJson = map['address'] ?? '';
          if (mounted) setState(() => _savedAddress = fromJson);
          return;
        } catch (_) {}
      }
    }

    if (mounted) {
      setState(() => _savedAddress = address.isEmpty ? null : address);
    }
  }

  @override
  void dispose() {
    _notesController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BookingCubit, BookingState>(
      listener: (context, state) {
        if (state is BookingSuccess) {
          _showSuccessDialog(context);
        } else if (state is BookingError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.grey[100],
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
              onPressed: () => Navigator.pop(context),
            ),
            title: const Text(
              'Confirm Booking',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontFamily: 'Cotta',
              ),
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildProviderCard(),
                const SizedBox(height: 16),
                _buildDetailsCard(),
                const SizedBox(height: 16),
                _buildLabTestsCard(),
                const SizedBox(height: 16),
                _buildNotesField(),
                if (widget.selectedService == "Home Visit" ||
                    widget.providerType == "Nurse") ...[
                  const SizedBox(height: 16),
                  _buildAddressField(),
                ],
                const SizedBox(height: 32),

                _buildConfirmButton(context, state),
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildProviderCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              widget.provider.profilePictureUrl,
              width: 70,
              height: 70,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                width: 70,
                height: 70,
                color: Colors.blue.shade50,
                child: const Icon(Icons.person, color: Colors.blue, size: 40),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.provider.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Cotta',
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.provider.subTitle,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.blue[700],
                    fontFamily: 'Agency',
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.provider.location,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[500],
                    fontFamily: 'Agency',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Booking Details',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              fontFamily: 'Cotta',
            ),
          ),
          const SizedBox(height: 16),
          _buildDetailRow(
            FontAwesomeIcons.briefcaseMedical,
            'Service',
            widget.selectedService,
            Colors.blue,
          ),
          const Divider(height: 24),
          _buildDetailRow(
            FontAwesomeIcons.calendarDay,
            'Date',
            DateFormat('EEEE, dd MMM yyyy').format(widget.selectedDate),
            Colors.orange,
          ),
          const Divider(height: 24),
          _buildDetailRow(
            FontAwesomeIcons.clock,
            'Time',
            widget.selectedTime.length >= 5
                ? widget.selectedTime.substring(0, 5)
                : widget.selectedTime,
            Colors.green,
          ),

          if (widget.totalFee != null && widget.totalFee! > 0) ...[
            const Divider(height: 24),
            _buildDetailRow(
              FontAwesomeIcons.moneyBillWave,
              'Total Amount',
              '${widget.totalFee!.toStringAsFixed(2)} EGP',
              Colors.deepPurpleAccent, // لون مميز للسعر
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDetailRow(
    IconData icon,
    String label,
    String value,
    Color color,
  ) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: FaIcon(icon, color: color, size: 16),
        ),
        const SizedBox(width: 14),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[500],
                fontFamily: 'Agency',
              ),
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                fontFamily: 'Agency',
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildNotesField() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Notes (Optional)',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              fontFamily: 'Cotta',
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _notesController,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: 'Any notes for the doctor...',
              hintStyle: TextStyle(
                color: Colors.grey[400],
                fontFamily: 'Agency',
              ),
              filled: true,
              fillColor: Colors.grey[50],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade200),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade200),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xff0861dd)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddressField() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Home Address',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Cotta',
                ),
              ),
              // ✅ زرار يجيب الـ address المحفوظ
              if (_savedAddress != null && _savedAddress!.isNotEmpty)
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _addressController.text = _savedAddress!;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xff0861dd).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: const Color(0xff0861dd).withOpacity(0.3),
                      ),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.my_location,
                          size: 14,
                          color: Color(0xff0861dd),
                        ),
                        SizedBox(width: 4),
                        Text(
                          'Use My Address',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xff0861dd),
                            fontFamily: 'Agency',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _addressController,
            decoration: InputDecoration(
              hintText: 'Enter your address...',
              hintStyle: TextStyle(
                color: Colors.grey[400],
                fontFamily: 'Agency',
              ),
              filled: true,
              fillColor: Colors.grey[50],
              prefixIcon: const Icon(
                Icons.location_on_outlined,
                color: Colors.red,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade200),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade200),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xff0861dd)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConfirmButton(BuildContext context, BookingState state) {
    final isLoading = state is BookingLoading;
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: isLoading ? null : () => _onConfirm(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xff0861dd),
          disabledBackgroundColor: Colors.grey.shade300,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: isLoading
            ? const CustomSpinner(color: Colors.white, size: 24)
            : const Text(
                'Confirm Booking',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontFamily: 'Agency',
                ),
              ),
      ),
    );
  }

  Widget _buildLabTestsCard() {
    // نتحقق لو فيه أسامي تحاليل موجودة
    if (widget.labTestsNames == null || widget.labTestsNames!.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.biotech_rounded, color: Colors.teal, size: 22),
              SizedBox(width: 8),
              Text(
                'Selected Lab Tests',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Cotta',
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: widget.labTestsNames!.map((testName) {
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.teal.withOpacity(0.08), // خلفية خفيفة Teal
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.teal.withOpacity(0.3)),
                ),
                child: Text(
                  testName,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.teal, // لون النص Teal
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Agency',
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // void _onConfirm(BuildContext context) {
  //   String appointmentType;
  //   switch (widget.selectedService) {
  //     case "Clinic Visit":
  //       appointmentType = "OnSiteVisit";
  //       break;
  //     case "Home Visit":
  //       appointmentType = widget.providerType == "Nurse"
  //           ? "QuickVisit" // 👈 هنا الحل
  //           : "HomeVisit";
  //       break;
  //     case "Hourly Rate":
  //       appointmentType = "HourlyStay";
  //       break;
  //     case "Lab Visit":
  //       appointmentType = "OnSiteVisit";
  //       break;
  //     case "Online":
  //       appointmentType = "Online";
  //       break;
  //     default:
  //       appointmentType = widget.selectedService;
  //   }

  //   context.read<BookingCubit>().confirmBooking(
  //     providerId: widget.provider.id,
  //     slotId: widget.providerType == "Lab" ? "" : widget.slotId,
  //     appointmentType: appointmentType,
  //     startTime: widget.selectedTime,
  //     token: widget.token,
  //     providerType: widget.providerType,
  //     notes: _notesController.text.trim().isEmpty
  //         ? null
  //         : _notesController.text.trim(),
  //     address:
  //         (widget.selectedService == "Home Visit" ||
  //             widget.providerType == "Nurse")
  //         ? _addressController.text.trim()
  //         : null,
  //     hours: widget.hours,

  //     // ✅ للـ lab
  //     labTestsIds: widget.labTestsIds,
  //     date: widget.selectedDate.toIso8601String().split('T')[0],
  //   );
  // }

  void _onConfirm(BuildContext context) {
    String appointmentType;
    switch (widget.selectedService) {
      case "Clinic Visit":
        appointmentType = "OnSiteVisit";
        break;
      case "Home Visit":
        appointmentType = widget.providerType == "Nurse"
            ? "QuickVisit"
            : "HomeVisit";
        break;
      case "Hourly Rate":
        appointmentType = "HourlyStay";
        break;
      case "Lab Visit":
        appointmentType = "OnSiteVisit";
        break;
      case "Online":
        appointmentType = "Online";
        break;
      default:
        appointmentType = widget.selectedService;
    }

    // 1️⃣ تحويل الوقت لتنسيق 24 ساعة (مثال: من 9:00 AM لـ 09:00:00)
    String rawTime = widget.selectedTime.split(' ')[0]; // ياخد الـ "9:00"
    if (rawTime.length == 4)
      rawTime = "0$rawTime"; // يخليها "09:00" لو كانت ساعة واحدة
    String finalTime = "$rawTime:00"; // يضيف الثواني "09:00:00"

    // ملاحظة: لو بتستخدم TimeOfDay يفضل تستخدم Format ثابت،
    // لكن ده حل سريع بناءً على الـ String اللي ظاهر في الـ Log.

    context.read<BookingCubit>().confirmBooking(
      // 2️⃣ هنا بنبعت الـ Parameters والـ Cubit هو اللي هيحطهم جوه "request"
      // تأكد إن الـ Cubit عندك متعدل عشان يستقبلهم ويغلفهم
      providerId: widget.provider.id,
      slotId: widget.providerType == "Lab" ? "" : widget.slotId,
      appointmentType: appointmentType,
      startTime: finalTime, // الوقت المتعدل
      token: widget.token,
      providerType: widget.providerType,
      notes: _notesController.text.trim().isEmpty
          ? ""
          : _notesController.text.trim(),
      address:
          (widget.selectedService == "Home Visit" ||
              widget.providerType == "Nurse")
          ? _addressController.text.trim()
          : "t", // لو الـ API مش بيقبل null ابعت حرف كـ placeholder
      hours: widget.hours ?? 1, // تأكد إنها مش null
      labTestsIds: widget.labTestsIds,
      date: widget.selectedDate.toIso8601String().split('T')[0],
    );
  }

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 80),
            const SizedBox(height: 16),
            const Text(
              'Booking Confirmed!',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'Cotta',
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Your appointment has been booked successfully.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[600], fontFamily: 'Agency'),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () =>
                    Navigator.of(context).popUntil((route) => route.isFirst),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff0861dd),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Back to Home',
                  style: TextStyle(color: Colors.white, fontFamily: 'Agency'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
