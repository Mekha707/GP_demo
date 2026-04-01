// // // import 'package:flutter/material.dart';

// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class SpecialtyCard extends StatelessWidget {
  final IconData icon;
  final String specialtyName;
  final Color iconColor;
  final Color backGroundColor;

  const SpecialtyCard({
    super.key,
    required this.icon,
    required this.specialtyName,
    required this.iconColor,
    required this.backGroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final bool isTablet = size.width > 600;
    final bool isDesktop = size.width > 1024; // إضافة فحص للشاشات الكبيرة

    return InkWell(
      // استخدمنا InkWell بدلاً من GestureDetector ليعطي إحساس الضغطة
      onTap: () {
        // ضيف الأكشن هنا لما يضغط على التخصص
      },
      borderRadius: BorderRadius.circular(15),
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: isTablet ? 20 : 15,
          horizontal: 8,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(color: Colors.grey.shade100, width: 1),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize:
              MainAxisSize.min, // يضمن أن الكارت لا يتمدد بشكل غير ضروري
          children: [
            // خلفية الأيقونة الملونة
            Container(
              height: isTablet ? 60 : 50,
              width: isTablet ? 60 : 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: backGroundColor,
              ),
              child: Icon(icon, size: isTablet ? 32 : 26, color: iconColor),
            ),
            const SizedBox(height: 12),
            // اسم التخصص
            Flexible(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: Text(
                  specialtyName,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: isDesktop ? 18 : (isTablet ? 15 : 12),
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                    fontFamily: 'Agency',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
