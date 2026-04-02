// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:healthcareapp_try1/Pages/Booking/doctor_page.dart';
import 'package:healthcareapp_try1/Pages/Booking/lab_page.dart';
import 'package:healthcareapp_try1/Pages/Booking/nurse_page.dart';

class BookingPage extends StatefulWidget {
  const BookingPage({super.key});

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  int _selectedIndex = 0; // الخيار الأول هو المختار افتراضياً
  List<Map<String, dynamic>> tabBar = [
    {
      "name": "Doctor",
      "icon": FontAwesomeIcons.stethoscope,
      "color": Color(0xff131ab9),
    },
    {
      "name": "Nurse",
      "icon": Icons.medical_services,
      "color": Color(0xff0082c5),
    },
    {"name": "Labs", "icon": Icons.biotech, "color": Colors.teal},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(child: _buildMainBookingContent()),
    );
  }

  Widget _buildMainBookingContent() {
    // جلب أبعاد الشاشة لاستخدامها في الحسابات النسبية
    final size = MediaQuery.of(context).size;
    final bool isSmallScreen = size.width < 360; // للهواتف الصغيرة جداً
    final bool isTablet = size.width > 600; // للأجهزة اللوحية

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min, // مهم جداً
        children: [
          // 1. الهيدر مع هوامش مرنة
          Padding(
            padding: EdgeInsets.only(
              left: isTablet ? 40 : 25,
              top: isTablet ? 40 : 25,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Book Appointment",
                  style: TextStyle(
                    fontSize: isTablet ? 25 : 22,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Cotta',
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Book doctors, nurses, or lab tests",
                  style: TextStyle(
                    fontSize: isTablet ? 20 : 16,
                    color: Colors.grey[700],
                    fontFamily: 'Agency',
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 15),

          // 2. التبويبات (Tabs) - تقسيم بالتساوي
          Container(
            height: isTablet ? 80 : 65,
            margin: const EdgeInsets.symmetric(horizontal: 15),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.grey.shade300,
            ),
            child: Row(
              // استبدلنا الـ ListView بـ Row
              children: List.generate(tabBar.length, (index) {
                bool isSelected = _selectedIndex == index;
                Color categoryColor = tabBar[index]['color'];

                return Expanded(
                  // Expanded تجعل كل عنصر يأخذ مساحة متساوية
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedIndex = index),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      margin: const EdgeInsets.symmetric(
                        horizontal: 4,
                      ), // مسافة بسيطة بين التابات
                      decoration: BoxDecoration(
                        color: isSelected
                            ? categoryColor.withOpacity(0.2)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: isSelected
                              ? categoryColor
                              : Colors.transparent,
                          width: 1.5,
                        ),
                      ),
                      child: Column(
                        // استخدمنا Column لجعل الأيقونة والنص فوق بعض أو Row حسب رغبتك
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            tabBar[index]['icon'],
                            size: isSelected ? 20 : 18,
                            color: isSelected
                                ? categoryColor
                                : Colors.grey[700],
                          ),
                          const SizedBox(height: 5),
                          Text(
                            tabBar[index]['name'],
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: isSelected
                                  ? categoryColor
                                  : Colors.grey[700],
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Agency',
                              fontSize: isSmallScreen ? 10 : 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
          SizedBox(height: 15),

          // 3. المحتوى المتغير
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: SizedBox(
              key: ValueKey<int>(_selectedIndex),
              height:
                  MediaQuery.of(context).size.height *
                  0.75, // أو أي نسبة تناسبك
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: isTablet ? 40 : 20),
                child: _getSelectedPageContent(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Pages Of Booking
  Widget _getSelectedPageContent() {
    switch (_selectedIndex) {
      case 0:
        return DoctorPage();
      case 1:
        return NursePage();
      case 2:
        return LabPage();
      default:
        return const SizedBox();
    }
  }
}
