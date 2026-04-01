// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healthcareapp_try1/Bloc/BookingBloc/booking_bloc.dart';
import 'package:healthcareapp_try1/Widgets/creditcard_classes.dart';

class BookingCheckoutForMedicalStaff extends StatefulWidget {
  final dynamic staff; // الطبيب أو الممرض
  final DateTime selectedDate;
  final String selectedTime;
  final String serviceType;
  final double price;

  const BookingCheckoutForMedicalStaff({
    super.key,
    required this.staff,
    required this.selectedDate,
    required this.selectedTime,
    required this.serviceType,
    required this.price,
  });

  @override
  State<BookingCheckoutForMedicalStaff> createState() =>
      _BookingCheckoutForMedicalStaff();
}

class _BookingCheckoutForMedicalStaff
    extends State<BookingCheckoutForMedicalStaff> {
  String selectedPaymentMethod = "Cash"; // الطريقة الافتراضية
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _expiryController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(top: 2, left: 10),
          child: const Text(
            "Checkout",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontFamily: 'Cotta',
            ),
          ),
        ),
        backgroundColor: Colors.grey[100],
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. ملخص الموعد
            _buildSectionTitle("Appointment Summary"),
            _buildSummaryCard(),
            const SizedBox(height: 15),
            _buildSectionTitle("Price Details"),
            _buildPriceRow("Consultation Fee :", "${widget.price} EGP"),
            _buildPriceRow(
              "Total Amount",
              "${widget.price} EGP",
              isTotal: true,
            ),
            const Divider(height: 30),

            // 2. اختيار طريقة الدفع
            _buildSectionTitle("Payment Method"),
            _buildPaymentOption("Cash After Visit", Icons.money, "Cash"),
            _buildPaymentOption(
              "Credit / Debit Card",
              Icons.credit_card,
              "Card",
            ),

            AnimatedSwitcher(
              duration: const Duration(milliseconds: 400),
              transitionBuilder: (child, animation) => FadeTransition(
                opacity: animation,
                child: SizeTransition(
                  sizeFactor: animation,
                  axisAlignment: -1,
                  child: child,
                ),
              ),
              child: selectedPaymentMethod == "Card"
                  ? _buildCreditCardFields()
                  : const SizedBox(key: ValueKey('empty'), height: 25),
            ),
            // 3. تفاصيل السعر (الفاتورة)
          ],
        ),
      ),
      bottomNavigationBar: _buildConfirmButton(),
    );
  }

  Widget _buildCreditCardFields() {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.indigo.withOpacity(0.5)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.01), blurRadius: 10),
        ],
      ),
      child: Column(
        children: [
          TextField(
            controller: _cardNumberController,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(16), // 16 رقم
              CardNumberFormatter(), // التنسيق التلقائي
            ],
            decoration: InputDecoration(
              labelText: "Card Number",
              hintText: "XXXX XXXX XXXX XXXX",
              prefixIcon: const Icon(Icons.credit_card_outlined),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _expiryController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(4),
                    CardDateFormatter(),
                  ],
                  decoration: InputDecoration(
                    labelText: "Expiry Date",
                    hintText: "MM/YY",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: TextField(
                  controller: _cvvController,
                  keyboardType: TextInputType.number,
                  obscureText: true,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(3), // CVV عادة 3 أرقام
                  ],
                  decoration: InputDecoration(
                    labelText: "CVV",
                    hintText: "***",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          fontFamily: 'Cotta',
        ),
      ),
    );
  }

  Widget _buildSummaryCard() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundImage: AssetImage(widget.staff.imageUrl),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${widget.staff.name}",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    fontFamily: 'Cotta',
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  "Service Type : ${widget.serviceType}",
                  style: TextStyle(
                    color: Color(0xff0861dd),
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Agency',
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  "Date : ${widget.selectedDate.day}/${widget.selectedDate.month}/${widget.selectedDate.year}",
                  style: const TextStyle(
                    color: Color(0xff0861dd),
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Agency',
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  "Time : ${widget.selectedTime}",
                  style: TextStyle(
                    color: Color(0xff0861dd),
                    fontWeight: FontWeight.w500,
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

  Widget _buildPaymentOption(String title, IconData icon, String value) {
    bool isSelected = selectedPaymentMethod == value;
    return GestureDetector(
      onTap: () => setState(() => selectedPaymentMethod = value),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? const Color(0xff0861dd) : Colors.grey.shade200,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? const Color(0xff0861dd) : Colors.grey,
            ),
            const SizedBox(width: 15),
            Text(
              title,
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                fontFamily: 'Agency',
              ),
            ),
            const Spacer(),
            if (isSelected)
              const Icon(Icons.check_circle, color: Color(0xff0861dd)),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceRow(String label, String amount, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 18 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              fontFamily: 'Agency',
            ),
          ),
          Text(
            amount,
            style: TextStyle(
              fontSize: isTotal ? 18 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: isTotal ? Colors.green : Colors.black,
              fontFamily: 'Agency',
            ),
          ),
        ],
      ),
    );
  }

  void _confirmBooking() {
    context.read<BookingBloc>().add(
      ConfirmBookingEvent(
        staffId: widget.staff.id,
        selectedDate: widget.selectedDate,
        selectedTime: widget.selectedTime,
        serviceType: widget.serviceType,
        paymentMethod:
            selectedPaymentMethod, // تأكد من إضافة هذا الحقل في الـ Event الخاص بك
      ),
    );

    // بعد إرسال الحدث، الـ Bloc سيتكفل بإظهار SuccessDialog الذي صممته أنت سابقاً
  }

  Widget _buildConfirmButton() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(color: Colors.white),
      child: SafeArea(
        child: ElevatedButton(
          onPressed: () {
            if (selectedPaymentMethod == "Card") {
              // تحقق إن الحقول متملياش قبل ما تبعت
              if (_cardNumberController.text.length < 19 ||
                  _expiryController.text.length < 5 ||
                  _cvvController.text.length < 3) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Please fill in all card details"),
                    backgroundColor: Colors.red,
                  ),
                );
                return;
              }
            }
            _confirmBooking();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xff0861dd),
            minimumSize: const Size(double.infinity, 55),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
          child: const Text(
            "Pay & Confirm Booking",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
