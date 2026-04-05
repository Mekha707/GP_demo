// ignore_for_file: unused_element_parameter

import 'package:flutter/material.dart';

class UnivrsalPaymendPage extends StatefulWidget {
  const UnivrsalPaymendPage({super.key});

  @override
  State<UnivrsalPaymendPage> createState() => _UnivrsalPaymendPageState();
}

class _UnivrsalPaymendPageState extends State<UnivrsalPaymendPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey.shade600, width: 1),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  'Appointment Details',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade700,
                    fontFamily: 'Cotta',
                  ),
                ),
                SizedBox(height: 20),
                _buildRowOfDetails(
                  title: "Medical Staff",
                  subtitle: "Dr Ahmed Ali",
                  titleColor: Color(0xff0861dd),
                  subTitleColor: Colors.black,
                ),

                _buildRowOfDetails(
                  title: "Service Type",
                  subtitle: "Online Consultation",
                  titleColor: Color(0xff0861dd),
                  subTitleColor: Colors.black,
                ),
                _buildRowOfDetails(
                  title: "Date",
                  subtitle: "Monday, 25 Dec 2023",
                  titleColor: Color(0xff0861dd),
                  subTitleColor: Colors.black,
                ),
                _buildRowOfDetails(
                  title: "Time",
                  subtitle: "10:00 AM - 10:30 AM",
                  titleColor: Color(0xff0861dd),
                  subTitleColor: Colors.black,
                ),
                _buildRowOfDetails(
                  title: "Fee",
                  subtitle: "50.00 EGP",
                  titleColor: Color(0xff0861dd),
                  subTitleColor: Colors.black,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRowOfDetails({
    String? title,
    String? subtitle,
    IconData? icon,
    Color? titleColor,
    Color? subTitleColor,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title ?? 'Dr Ahmed Ali',
          style: TextStyle(
            color: titleColor ?? Colors.black,
            fontFamily: 'Agency',
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          subtitle ?? '',
          style: TextStyle(
            color: subTitleColor ?? Colors.black,
            fontFamily: 'Agency',
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
