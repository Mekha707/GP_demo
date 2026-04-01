// // ignore_for_file: deprecated_member_use

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:healthcareapp_try1/Bloc/User_Bloc/LabBloc/lab_cubit.dart';
// import 'package:healthcareapp_try1/Models/Users_Models/lab_model.dart';
// import 'package:healthcareapp_try1/Models/Users_Models/lab_test_model.dart';
// import 'package:healthcareapp_try1/Widgets/creditcard_classes.dart';
// import 'package:healthcareapp_try1/Widgets/schedule_timedate_widget.dart';
// import 'package:lottie/lottie.dart';
// import 'package:url_launcher/url_launcher.dart'; // 1. استيراد المكتبة
// import 'package:flutter/services.dart';

// class LabDetailsPage extends StatefulWidget {
//   final LabModel lab;
//   const LabDetailsPage({super.key, required this.lab});

//   @override
//   State<LabDetailsPage> createState() => _LabDetailsPageState();
// }

// class _LabDetailsPageState extends State<LabDetailsPage> {
//   List<LabTestModel> selectedTests = [];
//   bool isHomeVisit = false;
//   DateTime? selectedDate;
//   String? selectedTime;
//   String selectedPaymentMethod = ""; // القيمة الافتراضية
//   // داخل كلاس _LabDetailsPageState
//   final TextEditingController _cardNumberController = TextEditingController();
//   final TextEditingController _expiryController = TextEditingController();
//   final TextEditingController _cvvController = TextEditingController();

//   double get totalPrice {
//     double testsSum = selectedTests.fold(0, (sum, item) => sum + item.price);
//     double visitFee = isHomeVisit ? (widget.lab.homeVisitFee ?? 0) : 0;
//     return testsSum + visitFee;
//   }

//   List<DateTime> getAvailableDates() {
//     return List.generate(7, (i) => DateTime.now().add(Duration(days: i)));
//   }

//   List<String> getAvailableTimes() {
//     return [
//       "09:00 AM",
//       "10:00 AM",
//       "11:00 AM",
//       "12:00 PM",
//       "01:00 PM",
//       "05:00 PM",
//       "08:00 PM",
//     ];
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocListener<LabCubit, LabState>(
//       listener: (context, state) {
//         if (state is LabBookingSuccess) {
//           _showSuccessDialog(context);
//         }
//       },
//       child: Scaffold(
//         backgroundColor: Colors.grey.shade100,
//         bottomNavigationBar: _buildBottomCheckout(),
//         body: CustomScrollView(
//           slivers: [
//             _buildAppBar(),
//             SliverToBoxAdapter(
//               child: Padding(
//                 padding: const EdgeInsets.all(20),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     _buildHeaderInfo(),
//                     const SizedBox(height: 25),

//                     // --- إضافة قسم الموقع هنا ---
//                     if (widget.lab.address != null) ...[
//                       const Text(
//                         "Lab Location",
//                         style: TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                           fontFamily: 'Agency',
//                         ),
//                       ),
//                       const SizedBox(height: 10),
//                       _buildLocationTile(
//                         widget.lab.address!,
//                       ), // تأكد أن الموديل يحتوي على address
//                       const SizedBox(height: 25),
//                     ],

//                     // -----------------------
//                     _buildVisitTypeSelection(),
//                     const SizedBox(height: 25),
//                     // 1. قسم اختيار التحاليل (أولاً)
//                     const Text(
//                       "Select Tests",
//                       style: TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                         fontFamily: 'Agency',
//                       ),
//                     ),
//                     const SizedBox(height: 10),
//                   ],
//                 ),
//               ),
//             ),
//             // قائمة التحاليل
//             _buildTestsList(),

//             SliverToBoxAdapter(
//               child: Padding(
//                 padding: const EdgeInsets.all(20),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const Divider(height: 40),
//                     // 2. قسم اختيار الموعد (ثانياً)
//                     const Text(
//                       "Select Appointment",
//                       style: TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                         fontFamily: 'Agency',
//                       ),
//                     ),
//                     const SizedBox(height: 15),
//                     ScheduleTimedateWidget(
//                       showSchedule: true,
//                       availableDates: getAvailableDates(),
//                       timeSlots: getAvailableTimes(),
//                       onDateSelected: (date) => setState(() {
//                         selectedDate = date;
//                         selectedTime = null;
//                       }),
//                       onTimeSelected: (time) =>
//                           setState(() => selectedTime = time),
//                     ),

//                     _buildPaymentSection(),
//                   ],
//                 ),
//               ),
//             ),
//             const SliverToBoxAdapter(child: SizedBox(height: 120)),
//           ],
//         ),
//       ),
//     );
//   }

//   // --- المكونات الفرعية (Widgets) ---

//   Widget _buildAppBar() {
//     return SliverAppBar(
//       expandedHeight: 200,
//       pinned: true,
//       backgroundColor: Colors.teal,
//       flexibleSpace: FlexibleSpaceBar(
//         background: widget.lab.imageUrl != null
//             ? Image.network(widget.lab.imageUrl!, fit: BoxFit.cover)
//             : Container(
//                 color: Colors.grey[200],
//                 child: const Icon(Icons.biotech, size: 60, color: Colors.teal),
//               ),
//       ),
//     );
//   }

//   Widget _buildHeaderInfo() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           widget.lab.name,
//           style: const TextStyle(
//             fontSize: 24,
//             fontWeight: FontWeight.bold,
//             fontFamily: 'Cotta',
//           ),
//         ),
//         const SizedBox(height: 5),
//         Text(
//           "${widget.lab.workingDays} | ${widget.lab.openingTime} - ${widget.lab.closingTime}",
//           style: TextStyle(color: Colors.grey[700], fontFamily: 'Agency'),
//         ),
//       ],
//     );
//   }

//   Widget _buildVisitTypeSelection() {
//     return Row(
//       children: [
//         _buildChoiceChip(
//           "Lab Visit",
//           !isHomeVisit,
//           () => setState(() => isHomeVisit = false),
//         ),
//         const SizedBox(width: 10),
//         if (widget.lab.allowHomeVisit)
//           _buildChoiceChip(
//             "Home Visit (+${widget.lab.homeVisitFee})",
//             isHomeVisit,
//             () => setState(() => isHomeVisit = true),
//           ),
//       ],
//     );
//   }

//   Widget _buildChoiceChip(String label, bool selected, VoidCallback onTap) {
//     return Expanded(
//       child: GestureDetector(
//         onTap: onTap,
//         child: Container(
//           padding: const EdgeInsets.symmetric(vertical: 12),
//           decoration: BoxDecoration(
//             color: selected ? Colors.teal.withOpacity(0.1) : Colors.white,
//             border: Border.all(
//               color: selected ? Colors.teal : Colors.grey.shade300,
//             ),
//             borderRadius: BorderRadius.circular(10),
//           ),
//           child: Center(
//             child: Text(
//               label,
//               style: TextStyle(
//                 color: selected ? Colors.teal : Colors.black,
//                 fontWeight: selected ? FontWeight.bold : FontWeight.normal,
//                 fontFamily: 'Agency',
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildTestsList() {
//     return SliverPadding(
//       padding: const EdgeInsets.symmetric(horizontal: 20),
//       sliver: SliverList(
//         delegate: SliverChildBuilderDelegate((context, index) {
//           final test = widget.lab.availableTests[index];
//           final isSelected = selectedTests.contains(test);
//           return CheckboxListTile(
//             title: Text(test.name, style: TextStyle(fontFamily: 'Agency')),
//             subtitle: Text(
//               "${test.price} EGP",
//               style: const TextStyle(
//                 color: Colors.green,
//                 fontWeight: FontWeight.bold,
//                 fontFamily: 'Agency',
//               ),
//             ),
//             value: isSelected,
//             activeColor: Colors.teal,
//             onChanged: (val) => setState(
//               () => val! ? selectedTests.add(test) : selectedTests.remove(test),
//             ),
//           );
//         }, childCount: widget.lab.availableTests.length),
//       ),
//     );
//   }

//   Widget _buildBottomCheckout() {
//     // الشروط الأساسية لعرض الملخص الكامل
//     bool hasTests = selectedTests.isNotEmpty;
//     bool hasDateTime = selectedDate != null && selectedTime != null;
//     bool hasPayment =
//         selectedPaymentMethod.isNotEmpty; // التأكد من اختيار وسيلة الدفع
//     // يظهر الملخص الكامل فقط إذا تم اختيار التحاليل والموعد معاً
//     bool isReadyToConfirm = hasTests && hasDateTime && hasPayment;

//     return BlocBuilder<LabCubit, LabState>(
//       builder: (context, state) {
//         bool isLoading = state is LabBookingLoading;

//         // الحالة 1: إذا لم يكتمل الاختيار (شريط توجيهي بسيط)
//         if (!isReadyToConfirm) {
//           return Container(
//             padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               border: Border(top: BorderSide(color: Colors.grey.shade200)),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black.withOpacity(0.05),
//                   blurRadius: 10,
//                 ),
//               ],
//             ),
//             child: SafeArea(
//               child: Row(
//                 children: [
//                   Icon(
//                     !hasTests
//                         ? Icons.add_circle_outline
//                         : Icons.calendar_today_outlined,
//                     color: Colors.orangeAccent,
//                   ),
//                   const SizedBox(width: 12),
//                   Text(
//                     !hasTests
//                         ? "Step 1: Please select your tests"
//                         : !hasDateTime
//                         ? "Step 2: Please select date & time"
//                         : "Step 3: Select Payment Method",
//                     style: TextStyle(
//                       color: Colors.grey.shade800,
//                       fontWeight: FontWeight.w600,
//                       fontSize: 14,
//                       fontFamily: 'Agency',
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         }

//         // الحالة 2: كل شيء جاهز (عرض الملخص الثابت والنهائي)
//         return AnimatedContainer(
//           duration: const Duration(milliseconds: 400),
//           curve: Curves.fastOutSlowIn,
//           padding: const EdgeInsets.fromLTRB(20, 20, 20, 25),
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.teal.withOpacity(0.15),
//                 blurRadius: 25,
//                 offset: const Offset(0, -5),
//               ),
//             ],
//           ),
//           child: SafeArea(
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // --- رأس الملخص ---
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             widget.lab.name,
//                             style: const TextStyle(
//                               fontWeight: FontWeight.bold,
//                               fontSize: 18,
//                               color: Colors.teal,
//                               fontFamily: 'Cotta',
//                             ),
//                           ),
//                           const SizedBox(height: 4),
//                           Text(
//                             "Appointment: ${selectedDate!.day}/${selectedDate!.month} at $selectedTime",
//                             style: TextStyle(
//                               fontSize: 13,
//                               color: Colors.grey.shade800,
//                               fontWeight: FontWeight.w500,
//                               fontFamily: 'Agency',
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     _buildServiceBadge(), // التاغ (Home/Lab)
//                   ],
//                 ),
//                 const SizedBox(height: 15),

//                 // --- قائمة التحاليل المختارة ---
//                 Text(
//                   "Tests Selected:",
//                   style: TextStyle(
//                     fontSize: 12,
//                     color: Colors.grey[800],
//                     fontWeight: FontWeight.bold,
//                     fontFamily: 'Agency',
//                   ),
//                 ),
//                 const SizedBox(height: 8),
//                 _buildTestsChips(), // الـ Chips للتحاليل
//                 const SizedBox(height: 8),

//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       "Payment Method",
//                       style: TextStyle(
//                         color: Colors.grey[800],
//                         fontFamily: 'Agency',
//                       ),
//                     ),
//                     Text(
//                       selectedPaymentMethod,
//                       style: const TextStyle(
//                         fontWeight: FontWeight.w600,
//                         fontFamily: 'Agency',
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 8), // مسافة بسيطة قبل الـ Total Paid

//                 const Padding(
//                   padding: EdgeInsets.symmetric(vertical: 15),
//                   child: Divider(height: 1),
//                 ),
//                 // --- الإجمالي وزر التأكيد ---
//                 Row(
//                   children: [
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           "Total Amount",
//                           style: TextStyle(
//                             fontSize: 12,
//                             color: Colors.grey[800],
//                           ),
//                         ),
//                         Text(
//                           "${totalPrice.toStringAsFixed(0)} EGP",
//                           style: const TextStyle(
//                             fontSize: 24,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.black87,
//                           ),
//                         ),
//                       ],
//                     ),
//                     const Spacer(),
//                     ElevatedButton(
//                       onPressed: !isLoading ? () => _confirmBooking() : null,
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.teal,
//                         padding: const EdgeInsets.symmetric(
//                           horizontal: 35,
//                           vertical: 15,
//                         ),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(15),
//                         ),
//                         elevation: 0,
//                       ),
//                       child: isLoading
//                           ? const SizedBox(
//                               height: 24,
//                               width: 24,
//                               child: CircularProgressIndicator(
//                                 color: Colors.white,
//                                 strokeWidth: 2,
//                               ),
//                             )
//                           : const Text(
//                               "Confirm Booking",
//                               style: TextStyle(
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.bold,
//                                 color: Colors.white,
//                                 fontFamily: 'Agency',
//                               ),
//                             ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildTestsChips() {
//     return Wrap(
//       spacing: 6,
//       children: selectedTests
//           .map(
//             (t) => Chip(
//               label: Text(
//                 t.name,
//                 style: const TextStyle(
//                   fontSize: 10,
//                   color: Colors.teal,
//                   fontWeight: FontWeight.bold,
//                   fontFamily: 'Agency',
//                 ),
//               ),
//               backgroundColor: Colors.teal.withOpacity(0.05),
//               visualDensity: VisualDensity.compact,
//             ),
//           )
//           .toList(),
//     );
//   }

//   // التاغ الصغير (Home / Lab)
//   Widget _buildServiceBadge() {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//       decoration: BoxDecoration(
//         color: Colors.teal.withOpacity(0.1),
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: Text(
//         isHomeVisit ? "Home" : "Lab",
//         style: const TextStyle(
//           color: Colors.teal,
//           fontSize: 12,
//           fontWeight: FontWeight.bold,
//         ),
//       ),
//     );
//   }

//   // دالة التأكيد (لتقليل التكرار)
//   void _confirmBooking() {
//     if (selectedPaymentMethod.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Please select a payment method")),
//       );
//       return;
//     }

//     // التحقق من بيانات البطاقة إذا اختار Credit Card
//     if (selectedPaymentMethod == "Credit Card") {
//       if (_cardNumberController.text.isEmpty ||
//           _expiryController.text.isEmpty ||
//           _cvvController.text.isEmpty) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("Please fill in your card details")),
//         );
//         return;
//       }
//     }

//     context.read<LabCubit>().confirmBooking(
//       lab: widget.lab,
//       tests: selectedTests,
//       isHomeVisit: isHomeVisit,
//       totalAmount: totalPrice,
//       appointmentDate: selectedDate!,
//       appointmentTime: selectedTime!,
//       paymentMethod: selectedPaymentMethod, // الباراميتر الجديد
//     );
//   }

//   void _showSuccessDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (context) => Dialog(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
//         backgroundColor: Colors.white,
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               // 1. أيقونة النجاح (يمكنك استخدام Lottie أو Icon)
//               Lottie.asset(
//                 'assets/animations/Success.json',
//                 width: 150,
//                 height: 150,
//                 repeat: false, // يشتغل مرة واحدة بس عند الفتح
//               ),
//               const SizedBox(height: 24),

//               // 2. نص تأكيد الحجز
//               const Text(
//                 "Booking Confirmed!",
//                 style: TextStyle(
//                   fontSize: 22,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.black,
//                 ),
//               ),
//               const SizedBox(height: 30),

//               // 3. مستطيل الموعد (Date & Time Container)
//               Container(
//                 padding: const EdgeInsets.symmetric(
//                   vertical: 16,
//                   horizontal: 12,
//                 ),
//                 decoration: BoxDecoration(
//                   color: const Color(0xFFF8F9FA), // رمادي فاتح جداً
//                   borderRadius: BorderRadius.circular(16),
//                   border: Border.all(color: Colors.grey.shade200),
//                 ),
//                 // داخل الـ Container في _showSuccessDialog
//                 child: Column(
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         const Icon(
//                           Icons.calendar_today_outlined,
//                           size: 16,
//                           color: Colors.blue,
//                         ),
//                         const SizedBox(width: 8),
//                         Text(
//                           "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}",
//                         ),
//                         const SizedBox(width: 15),
//                         const Icon(
//                           Icons.access_time,
//                           size: 16,
//                           color: Colors.blue,
//                         ),
//                         const SizedBox(width: 8),
//                         Text(selectedTime!),
//                       ],
//                     ),
//                     const Padding(
//                       padding: EdgeInsets.symmetric(vertical: 10),
//                       child: Divider(),
//                     ),
//                     // داخل الـ Column في الدايلوج تحت الـ Divider
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         const Text(
//                           "Payment Method",
//                           style: TextStyle(color: Colors.grey),
//                         ),
//                         Text(
//                           selectedPaymentMethod,
//                           style: const TextStyle(fontWeight: FontWeight.w600),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 8), // مسافة بسيطة قبل الـ Total Paid

//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         const Text(
//                           "Total Paid",
//                           style: TextStyle(fontWeight: FontWeight.bold),
//                         ),
//                         Text(
//                           "${totalPrice.toStringAsFixed(0)} EGP",
//                           style: const TextStyle(
//                             fontWeight: FontWeight.bold,
//                             color: Colors.green,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 30),

//               // 4. زر العودة للرئيسية
//               SizedBox(
//                 width: double.infinity,
//                 height: 55,
//                 child: ElevatedButton(
//                   onPressed: () {
//                     Navigator.pop(context); // إغلاق الدايلوج
//                     Navigator.pop(context); // العودة للصفحة السابقة
//                   },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: const Color(
//                       0xFF0D6EFD,
//                     ), // اللون الأزرق اللي في الصورة
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(16),
//                     ),
//                     elevation: 0,
//                   ),
//                   child: const Text(
//                     "Back to Home",
//                     style: TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.white,
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildLocationTile(String address) {
//     return Container(
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: Colors.red.withOpacity(0.05),
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Row(
//         children: [
//           const Icon(Icons.location_on, color: Colors.redAccent),
//           const SizedBox(width: 10),
//           Expanded(child: Text(address, style: const TextStyle(fontSize: 14))),
//           IconButton(
//             onPressed: () => _openMap(address),
//             icon: const Icon(Icons.directions, color: Colors.blue),
//           ),
//         ],
//       ),
//     );
//   }

//   // دالة لفتح جوجل ماب
//   Future<void> _openMap(String address) async {
//     // الرابط الصحيح للبحث عن مكان في جوجل ماب
//     final String query = Uri.encodeComponent(address);
//     final Uri googleMapsUrl = Uri.parse(
//       "https://www.google.com/maps/search/?api=1&query=$query",
//     );

//     if (await canLaunchUrl(googleMapsUrl)) {
//       await launchUrl(googleMapsUrl, mode: LaunchMode.externalApplication);
//     } else {
//       debugPrint('Could not launch maps for: $address');
//     }
//   }

//   Widget _buildPaymentSection() {
//     if (selectedDate == null || selectedTime == null) {
//       return const SizedBox.shrink();
//     }

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Divider(height: 40),
//         const Text(
//           "Payment Method",
//           style: TextStyle(
//             fontSize: 18,
//             fontWeight: FontWeight.bold,
//             fontFamily: 'Agency',
//           ),
//         ),
//         const SizedBox(height: 15),
//         Row(
//           children: [
//             _buildPaymentCard("Cash", Icons.money, "Pay at the lab"),
//             const SizedBox(width: 12),
//             _buildPaymentCard(
//               "Credit Card",
//               Icons.credit_card,
//               "Online Payment",
//             ),
//           ],
//         ),

//         // --- الجزء الجديد: إظهار الفورم عند اختيار الكريديت ---
//         if (selectedPaymentMethod == "Credit Card") _buildCreditCardFields(),
//       ],
//     );
//   }

//   Widget _buildCreditCardFields() {
//     return Container(
//       margin: const EdgeInsets.only(top: 20),
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(15),
//         border: Border.all(color: Colors.teal.withOpacity(0.3)),
//         boxShadow: [
//           BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10),
//         ],
//       ),
//       child: Column(
//         children: [
//           TextField(
//             controller: _cardNumberController,
//             keyboardType: TextInputType.number,
//             inputFormatters: [
//               FilteringTextInputFormatter.digitsOnly,
//               LengthLimitingTextInputFormatter(16), // 16 رقم
//               CardNumberFormatter(), // التنسيق التلقائي
//             ],
//             decoration: InputDecoration(
//               labelText: "Card Number",
//               labelStyle: TextStyle(fontFamily: 'Agency'),
//               hintText: "XXXX XXXX XXXX XXXX",
//               prefixIcon: const Icon(Icons.credit_card_outlined),
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//             ),
//           ),
//           const SizedBox(height: 15),
//           Row(
//             children: [
//               Expanded(
//                 child: TextField(
//                   controller: _expiryController,
//                   keyboardType: TextInputType.number,
//                   inputFormatters: [
//                     FilteringTextInputFormatter.digitsOnly,
//                     LengthLimitingTextInputFormatter(4),
//                     CardDateFormatter(),
//                   ],
//                   decoration: InputDecoration(
//                     labelText: "Expiry Date",
//                     hintText: "MM/YY",
//                     labelStyle: TextStyle(fontFamily: 'Agency'),
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                   ),
//                 ),
//               ),
//               const SizedBox(width: 15),
//               Expanded(
//                 child: TextField(
//                   controller: _cvvController,
//                   keyboardType: TextInputType.number,
//                   obscureText: true,
//                   inputFormatters: [
//                     FilteringTextInputFormatter.digitsOnly,
//                     LengthLimitingTextInputFormatter(3), // CVV عادة 3 أرقام
//                   ],
//                   decoration: InputDecoration(
//                     labelText: "CVV",
//                     hintText: "***",
//                     labelStyle: TextStyle(fontFamily: 'Agency'),
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildPaymentCard(String value, IconData icon, String subtitle) {
//     bool isSelected = selectedPaymentMethod == value;
//     return Expanded(
//       child: GestureDetector(
//         onTap: () => setState(() => selectedPaymentMethod = value),
//         child: AnimatedContainer(
//           duration: const Duration(milliseconds: 300),
//           padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
//           decoration: BoxDecoration(
//             color: isSelected ? Colors.teal.withOpacity(0.05) : Colors.white,
//             borderRadius: BorderRadius.circular(15),
//             border: Border.all(
//               color: isSelected ? Colors.teal : Colors.grey.shade200,
//               width: 2,
//             ),
//           ),
//           child: Column(
//             children: [
//               Icon(
//                 icon,
//                 color: isSelected ? Colors.teal : Colors.grey.shade800,
//               ),
//               const SizedBox(height: 8),
//               Text(
//                 value,
//                 style: TextStyle(
//                   fontWeight: FontWeight.bold,
//                   color: isSelected ? Colors.teal : Colors.black,
//                   fontFamily: 'Agency',
//                 ),
//               ),
//               Text(
//                 subtitle,
//                 style: TextStyle(
//                   fontSize: 10,
//                   color: Colors.grey.shade800,
//                   fontFamily: 'Agency',
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
