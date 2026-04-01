// import 'package:flutter/material.dart';
// import 'package:lottie/lottie.dart';

// class ConfirmAppointment extends StatefulWidget {
//   const ConfirmAppointment({
//     super.key,
//     required this.selectedDate,
//     required this.selectedTime,
//     required this.selectedTests,
//     required this.onBack,
//   });
//   final DateTime? selectedDate;
//   final String? selectedTime;
//   final Set<String> selectedTests;
//   final VoidCallback onBack;

//   @override
//   State<ConfirmAppointment> createState() => _ConfirmAppointmentState();
// }

// class _ConfirmAppointmentState extends State<ConfirmAppointment> {
//   bool isLoading = false; // لمتابعة حالة التحميل

//   @override
//   Widget build(BuildContext context) {
//     return ElevatedButton(
//       onPressed: () {
//         if (widget.selectedTests.isEmpty) {
//           _showErrorSnackBar("Please select at least one test");
//         } else if (widget.selectedDate == null) {
//           _showErrorSnackBar("Please select a date");
//         } else if (widget.selectedTime == null) {
//           _showErrorSnackBar("Please select a time slot");
//         } else {
//           // إذا كل شيء تمام، نفذ الحجز
//           _showSuccessDialog();
//         }
//       },
//       style: ElevatedButton.styleFrom(
//         backgroundColor: const Color(0xff0861dd),
//         minimumSize: const Size(double.infinity, 55),
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
//         disabledBackgroundColor: Colors.grey[300],
//       ),
//       child: const Text(
//         "Confirm Appointment",
//         style: TextStyle(
//           color: Colors.white,
//           fontSize: 16,
//           fontWeight: FontWeight.bold,
//         ),
//       ),
//     );
//   }

//   void _showErrorSnackBar(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Row(
//           children: [
//             const Icon(Icons.error_outline, color: Colors.white),
//             const SizedBox(width: 10),
//             Text(message),
//           ],
//         ),
//         backgroundColor: Colors.redAccent,
//         behavior: SnackBarBehavior.floating,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//         margin: const EdgeInsets.all(15),
//         duration: const Duration(seconds: 2),
//       ),
//     );
//   }

//   void _showSuccessDialog() {
//     showDialog(
//       context: context,
//       barrierDismissible: false, // منع إغلاق الدايالوج أثناء التحميل
//       builder: (context) => StatefulBuilder(
//         // نستخدم StatefulBuilder لتحديث الحالة داخل الدايالوج
//         builder: (context, setDialogState) {
//           return AlertDialog(
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(20),
//             ),
//             content: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 if (!isLoading) ...[
//                   Lottie.asset(
//                     'assets/animations/success.json',
//                     width: 150,
//                     height: 150,
//                     repeat: false, // يعمل مرة واحدة فقط عند الفتح
//                   ),
//                   const SizedBox(height: 15),
//                   const Text(
//                     "Booking Confirmed!",
//                     style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
//                   ),
//                 ] else ...[
//                   const CircularProgressIndicator(color: Color(0xff0861dd)),
//                   const SizedBox(height: 5),
//                   const Text("Returning to search..."),
//                 ],
//                 const SizedBox(height: 10),
//                 if (!isLoading)
//                   Text(
//                     "Your appointment is set for ${widget.selectedDate?.day}/${widget.selectedDate?.month} at ${widget.selectedTime}",
//                     textAlign: TextAlign.center,
//                     style: TextStyle(color: Colors.grey[600]),
//                   ),
//                 const SizedBox(height: 20),
//                 if (!isLoading)
//                   ElevatedButton(
//                     onPressed: () async {
//                       // ابدأ حالة التحميل
//                       setDialogState(() => isLoading = true);

//                       // تأخير بسيط جداً لضمان سلاسة الأنميشن (200-500ms)
//                       await Future.delayed(const Duration(milliseconds: 500));

//                       if (!mounted)
//                         return Navigator.of(context, rootNavigator: true).pop();
//                       widget.onBack();
//                       setState(() => isLoading = false); // إعادة الحالة لأصلها
//                     },
//                     child: const Text(
//                       "Done",
//                       style: TextStyle(color: Colors.black),
//                     ),
//                   ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class ConfirmAppointment extends StatefulWidget {
  const ConfirmAppointment({
    super.key,
    required this.selectedDate,
    this.selectedTime,
    required this.selectedTests,
    required this.onBack,
  });
  final DateTime? selectedDate;
  final String? selectedTime;
  final Set<String> selectedTests;
  final VoidCallback onBack;

  @override
  State<ConfirmAppointment> createState() => _ConfirmAppointmentState();
}

class _ConfirmAppointmentState extends State<ConfirmAppointment> {
  bool isLoading = false; // لمتابعة حالة التحميل

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        if (widget.selectedTests.isEmpty) {
          _showErrorSnackBar("Please select at least one test");
        } else if (widget.selectedDate == null) {
          _showErrorSnackBar("Please select a date");
        } else if (widget.selectedTime == null) {
          _showErrorSnackBar("Please select a time slot");
        } else {
          // إذا كل شيء تمام، نفذ الحجز
          _showSuccessDialog();
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xff0861dd),
        minimumSize: const Size(double.infinity, 55),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        disabledBackgroundColor: Colors.grey[300],
      ),
      child: const Text(
        "Confirm Appointment",
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white),
            const SizedBox(width: 10),
            Text(message),
          ],
        ),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(15),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false, // منع إغلاق الدايالوج أثناء التحميل
      builder: (context) => StatefulBuilder(
        // نستخدم StatefulBuilder لتحديث الحالة داخل الدايالوج
        builder: (context, setDialogState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (!isLoading) ...[
                  Lottie.asset(
                    'assets/animations/success.json',
                    width: 150,
                    height: 150,
                    repeat: false, // يعمل مرة واحدة فقط عند الفتح
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    "Booking Confirmed!",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ] else ...[
                  const CircularProgressIndicator(color: Color(0xff0861dd)),
                  const SizedBox(height: 5),
                  const Text("Returning to search..."),
                ],
                const SizedBox(height: 10),
                if (!isLoading)
                  Text(
                    "Your appointment is set for ${widget.selectedDate?.day}/${widget.selectedDate?.month} at ${widget.selectedTime}",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                const SizedBox(height: 20),
                if (!isLoading)
                  ElevatedButton(
                    onPressed: () async {
                      // ابدأ حالة التحميل
                      setDialogState(() => isLoading = true);

                      // تأخير بسيط جداً لضمان سلاسة الأنميشن (200-500ms)
                      await Future.delayed(const Duration(milliseconds: 500));

                      if (!mounted) {
                        // ignore: use_build_context_synchronously
                        return Navigator.of(context, rootNavigator: true).pop();
                      }
                      widget.onBack();
                      setState(() => isLoading = false); // إعادة الحالة لأصلها
                    },
                    child: const Text(
                      "Done",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
