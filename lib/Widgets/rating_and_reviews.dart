// import 'package:flutter/material.dart';
// import 'package:healthcareapp_try1/Models/Users_Models/doctor_model.dart';

// class RatinAndReviews extends StatelessWidget {
//   const RatinAndReviews({super.key, required this.medicalstaff});

//   final MedicalStaffModel medicalstaff;

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         const Icon(Icons.star, color: Colors.orange, size: 14),
//         const SizedBox(width: 4),
//         Padding(
//           padding: const EdgeInsets.only(top: 3),
//           child: Text(
//             medicalstaff.rating.toString(),
//             style: const TextStyle(
//               fontWeight: FontWeight.bold,
//               fontSize: 12,
//               fontFamily: 'Agency',
//             ),
//           ),
//         ),
//         const SizedBox(width: 4),
//         Padding(
//           padding: const EdgeInsets.only(top: 3),
//           child: Text(
//             " (${medicalstaff.ratingsCount} Reviews)",
//             style: TextStyle(
//               color: Colors.grey[700],
//               fontSize: 10,
//               fontFamily: 'Agency',
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
