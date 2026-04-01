// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AmbulancePage extends StatefulWidget {
  const AmbulancePage({super.key});

  @override
  State<AmbulancePage> createState() => _AmbulancePageState();
}

class _AmbulancePageState extends State<AmbulancePage> {
  final _formKey = GlobalKey<FormState>();
  bool selectedForm = false;

  // المتحكمات للنصوص
  final TextEditingController _nameController = TextEditingController(
    text: "Mekha Morcos",
  );
  final TextEditingController _phoneController = TextEditingController(
    text: "0666666666",
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Padding(
        padding: const EdgeInsets.only(bottom: 50),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: Column(
              children: [
                // Emergency Ambulance Service
                _buildMainAmbulanceCard(),
                const SizedBox(height: 20),

                // EmergencyResponseCard
                _buildEmergencyResponseCard(),
                const SizedBox(height: 20),

                // 3. كارت طلب الإسعاف (من الصورة الثالثة)
                selectedForm == true
                    ? _buildEmergencyForm()
                    : _buildRequestActionCard(),
                const SizedBox(height: 20),

                // Advanced Life Support
                _buildAmbulanceFeatures(
                  color: Color(0xffd51934).withOpacity(0.5),
                  icon: FontAwesomeIcons.truckMedical,
                  title: "Advanced Life Support",
                  subTitle:
                      "All ambulances equipped with ALS equipment and trained paramedics",
                ),
                SizedBox(height: 20),

                // Rapid Response
                _buildAmbulanceFeatures(
                  color: Color(0xff0861dd),
                  icon: FontAwesomeIcons.clock,
                  title: "Rapid Response",
                  subTitle:
                      "Average response time of 8-12 minutes across all service areas",
                ),
                SizedBox(height: 20),

                // 24/7 Availability
                _buildAmbulanceFeatures(
                  color: Colors.green,
                  icon: FontAwesomeIcons.circleCheck,
                  title: "24/7 Availability",
                  subTitle:
                      "Round-the-clock emergency medical services every day of the year",
                ),
                SizedBox(height: 20),

                // Form
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Widget الكارت الرئيسي (الصورة مع النص المتراكب)
  Widget _buildMainAmbulanceCard() {
    return Container(
      width: double.infinity,
      height: 220,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        image: const DecorationImage(
          image: AssetImage("assets/images/ambulance_demo.jpg"),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          // التعتيم لضمان وضوح النص
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [Colors.black.withOpacity(0.8), Colors.transparent],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Emergency Ambulance\nService",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Cotta',
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  "24/7 Emergency Medical Transport -\nFast and Reliable",
                  style: TextStyle(
                    color: Colors.grey[100],
                    fontSize: 14,
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

  // Widget كارت تفاصيل الاستجابة (الخلفية الوردية الفاتحة)
  Widget _buildEmergencyResponseCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xfffff5f5), // لون وردي فاتح جداً
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Color(0xffd51934).withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Color(0xffd51934).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.notifications_active_outlined,
                  color: Color(0xffd51934),
                  size: 24,
                ),
              ),
              const SizedBox(width: 15),
              const Text(
                "24/7 Emergency Response",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff444444),
                  fontFamily: 'Cotta',
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Text(
            "Our ambulances are equipped with advanced life support systems and staffed by trained paramedics ready to respond to your emergency.",
            style: TextStyle(
              color: Colors.grey[700],
              fontSize: 14,
              height: 1.5,
              fontFamily: 'Agency',
            ),
          ),
          const SizedBox(height: 20),

          // تفاصيل الوقت ورقم الهاتف
          _buildInfoRow(
            Icons.access_time,
            "Average response time: 8-12 minutes",
          ),
          const SizedBox(height: 12),
          _buildInfoRow(
            Icons.phone_in_talk,
            "Emergency Hotline: 123",
            isBold: true,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text, {bool isBold = false}) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Color(0xffd51934)),
        const SizedBox(width: 10),
        Text(
          text,
          style: TextStyle(
            fontSize: 14,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            color: isBold ? Color(0xffd51934) : Colors.grey[700],
            fontFamily: 'Agency',
          ),
        ),
      ],
    );
  }

  // الكارت الثالث: زر الطلب (الأيقونة في دائرة وردية)
  Widget _buildRequestActionCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Color(0xffd51934)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Color(0xffd51934).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              FontAwesomeIcons.truckMedical,
              color: Color(0xffd51934),
              size: 30,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            "Need Emergency Medical Transport?",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              fontFamily: 'Cotta',
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "Request an ambulance immediately. Our team will respond within minutes.",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey[800],
              fontSize: 14,
              fontFamily: 'Agency',
            ),
          ),
          const SizedBox(height: 25),
          ElevatedButton.icon(
            onPressed: () {
              setState(() {
                selectedForm = true;
              });
            },
            label: const Text(
              "Request Ambulance Now",
              style: TextStyle(fontFamily: 'Agency'),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xffd51934),
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAmbulanceFeatures({
    required String title,
    required String subTitle,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.blueGrey),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 30),
          ),
          const SizedBox(height: 20),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              fontFamily: 'Cotta',
            ),
          ),
          const SizedBox(height: 10),
          Text(
            subTitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey[800],
              fontSize: 14,
              fontFamily: 'Agency',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmergencyForm() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Color(0xffd51934),
          width: 1.5,
        ), // الإطار الأحمر كما في الصورة
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // الهيدر الخاص بالنموذج
            const Row(
              children: [
                Icon(
                  FontAwesomeIcons.truckMedical,
                  color: Color(0xffd51934),
                  size: 20,
                ),
                SizedBox(width: 10),
                Text(
                  "Emergency Ambulance Request",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              "Fill in the details below. Our team will be dispatched immediately.",
              style: TextStyle(color: Colors.grey[800], fontSize: 13),
            ),
            const SizedBox(height: 5),

            // الحقول
            _buildFieldLabel("Patient Name *"),
            _buildTextField(_nameController, "Enter patient name"),

            _buildFieldLabel("Contact Number *"),
            _buildTextField(
              _phoneController,
              "Enter contact number",
              isPhone: true,
            ),

            _buildFieldLabel("Emergency Location *"),
            _buildTextField(
              null,
              "Complete address with landmark",
              icon: Icons.location_on_outlined,
            ),

            _buildFieldLabel("Type of Emergency *"),
            _buildDropdownField(),

            _buildFieldLabel("Additional Details"),
            _buildTextField(
              null,
              "Describe the emergency situation...",
              isLongText: true,
            ),

            const Text(
              "Any additional information that can help the medical team prepare",
              style: TextStyle(color: Colors.grey, fontSize: 11),
            ),

            const SizedBox(height: 30),

            // الأزرار السفلية
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.blue.shade100),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                    child: const Text("Cancel"),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  flex: 2,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // تنفيذ الطلب
                      }
                    },
                    icon: const Icon(Icons.emergency, size: 18),
                    label: const Text("Dispatch Ambulance Now"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xffd51934),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ميثود مساعدة لبناء عنوان الحقل
  Widget _buildFieldLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, top: 10),
      child: Text(
        label,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
      ),
    );
  }

  // ميثود مساعدة لبناء الحقل النصي
  Widget _buildTextField(
    TextEditingController? controller,
    String hint, {
    bool isPhone = false,
    bool isLongText = false,
    IconData? icon,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: isLongText ? 4 : 1,
      keyboardType: isPhone ? TextInputType.phone : TextInputType.text,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.grey, fontSize: 13),
        prefixIcon: icon != null
            ? Icon(icon, size: 18, color: Colors.grey)
            : null,
        filled: true,
        fillColor: Colors.grey.shade50,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 12,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.red),
        ),
      ),
    );
  }

  // ميثود القائمة المنسدلة (Type of Emergency)
  Widget _buildDropdownField() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          hint: const Text(
            "Select emergency type",
            style: TextStyle(color: Colors.grey, fontSize: 13),
          ),
          isExpanded: true,
          items: [
            "Heart Attack",
            "Accident",
            "Stroke",
            "Breathing Issue",
            "Poisoning",
            "Other",
          ].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
          onChanged: (val) {},
        ),
      ),
    );
  }
}
