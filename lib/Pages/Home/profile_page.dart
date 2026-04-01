// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healthcareapp_try1/Bloc/Auth_Bloc/Patient_Profile.dart/patient_profile_cubit.dart';
import 'package:healthcareapp_try1/Bloc/Auth_Bloc/Patient_Profile.dart/patient_profile_state.dart';
import 'package:healthcareapp_try1/Buttons/buttons.dart';
import 'package:healthcareapp_try1/Models/Auth_Models/patient_profile_model.dart';
import 'package:healthcareapp_try1/Pages/Home/edit_profile_page.dart';
import 'package:url_launcher/url_launcher.dart';

class PatientProfilePage extends StatefulWidget {
  final PatientProfile profile;
  const PatientProfilePage({super.key, required this.profile});

  @override
  State<PatientProfilePage> createState() => _PatientProfilePageState();
}

class _PatientProfilePageState extends State<PatientProfilePage> {
  late PatientProfile _currentProfile;

  @override
  void initState() {
    super.initState();
    _currentProfile = widget.profile; // ابدأ بالبيانات الموجودة
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text('My Profile'),
        backgroundColor: const Color(0xff0861dd),
        foregroundColor: Colors.white,
      ),
      body: BlocListener<ProfileCubit, ProfileState>(
        listener: (context, state) {
          if (state is ProfileSuccess) {
            // ← لما الـ Cubit يجيب البيانات الجديدة، حدّث الـ UI
            setState(() {
              _currentProfile = state.profile;
            });
          }
        },
        child: _buildProfile(context, _currentProfile),
      ), // ✅ بعّت context
    );
  }

  Widget _buildProfile(BuildContext context, PatientProfile p) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildHeaderCard(p),
          const SizedBox(height: 16),
          _buildSection('Personal Information', [
            _buildInfoRow(Icons.email, 'Email', p.email),
            _buildInfoRow(Icons.phone, 'Phone', p.phoneNumber),
            _buildInfoRow(Icons.location_city, 'City', p.city),
            _buildInfoRow(Icons.home, 'Address', p.address),
            _buildInfoRow(Icons.cake, 'Date of Birth', p.dateOfBirth),
            _buildInfoRow(Icons.wc, 'Gender', p.gender),
            if (p.weight != null)
              _buildInfoRow(Icons.monitor_weight, 'Weight', '${p.weight} kg'),
            if (p.addressUrl != null) _buildLinkRow(p.addressUrl!),
          ]),
          const SizedBox(height: 16),
          _buildSection('Medical Conditions', [
            _buildConditionRow('Diabetes', p.hasDiabetes),
            _buildConditionRow('Blood Pressure', p.hasBloodPressure),
            _buildConditionRow('Asthma', p.hasAsthma),
            _buildConditionRow('Heart Disease', p.hasHeartDisease),
            _buildConditionRow('Kidney Disease', p.hasKidneyDisease),
            _buildConditionRow('Arthritis', p.hasArthritis),
            _buildConditionRow('Cancer', p.hasCancer),
            _buildConditionRow('High Cholesterol', p.hasHighCholesterol),
            if (p.otherMedicalConditions != null)
              _buildInfoRow(Icons.note, 'Other', p.otherMedicalConditions!),
          ]),
          const SizedBox(height: 15),
          ButtonOfAuth(
            borderSide: const BorderSide(color: Colors.indigoAccent),
            onPressed: () async {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => EditProfilePage(profile: widget.profile),
                ),
              );
            },
            fontcolor: Colors.indigoAccent,
            buttoncolor: Colors.white,
            buttonText: "Edit Profile",
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderCard(PatientProfile p) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Color(0xFF2D6CDF)),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: _getGradientForLetter(
                p.name.isNotEmpty ? p.name[0] : '?',
              ),
              boxShadow: [
                BoxShadow(
                  color: _getGradientForLetter(
                    p.name.isNotEmpty ? p.name[0] : '?',
                  ).colors.first.withOpacity(0.4),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Center(
              child: Text(
                p.name.isNotEmpty ? p.name[0].toUpperCase() : '?',
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),

          const SizedBox(height: 12),
          Text(
            p.name,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D6CDF),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            p.email,
            style: const TextStyle(color: Color(0xFF2D6CDF), fontSize: 15),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D6CDF),
            ),
          ),
          const Divider(),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 18, color: const Color(0xFF2D6CDF)),
          const SizedBox(width: 10),
          Text('$label: ', style: const TextStyle(fontWeight: FontWeight.w600)),
          Expanded(
            child: Text(value, style: TextStyle(color: Colors.grey[700])),
          ),
        ],
      ),
    );
  }

  Widget _buildConditionRow(String label, bool hasCondition) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(
            hasCondition ? Icons.check_circle : Icons.cancel,
            size: 18,
            color: hasCondition ? Colors.green : Colors.red,
          ),
          const SizedBox(width: 10),
          Text(label),
        ],
      ),
    );
  }

  Widget _buildLinkRow(String url) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          const Icon(Icons.map, size: 18, color: Color(0xFF2D6CDF)),
          const SizedBox(width: 10),
          const Text(
            'Location: ',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () async {
                final uri = Uri.parse(url);
                if (await canLaunchUrl(uri)) {
                  await launchUrl(uri, mode: LaunchMode.externalApplication);
                } else {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Could not open map")),
                    );
                  }
                }
              },
              child: Text(
                url,
                style: const TextStyle(
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }

  LinearGradient _getGradientForLetter(String letter) {
    final Map<String, List<Color>> gradients = {
      'A': [const Color(0xFFFF6B6B), const Color(0xFFFF8E53)],
      'B': [const Color(0xFF6B6BFF), const Color(0xFF53B8FF)],
      'C': [const Color(0xFF6BFF6B), const Color(0xFF53FFB8)],
      'D': [const Color(0xFFFF6BE8), const Color(0xFFB853FF)],
      'E': [const Color(0xFFFFD36B), const Color(0xFFFF6B6B)],
      'F': [const Color(0xFF6BFFD3), const Color(0xFF6BB8FF)],
      'G': [const Color(0xFFFF9A6B), const Color(0xFFFFD36B)],
      'H': [const Color(0xFF6B8EFF), const Color(0xFFB06EF5)],
      'I': [const Color(0xFFFF6B9A), const Color(0xFFFFB86B)],
      'J': [const Color(0xFF6BFFE8), const Color(0xFF6BFF8E)],
      'K': [const Color(0xFFD36BFF), const Color(0xFF6B8EFF)],
      'L': [const Color(0xFFFFB86B), const Color(0xFFFF6BD3)],
      'M': [const Color(0xFF6BFF6B), const Color(0xFFFFD36B)],
      'N': [const Color(0xFF536EF5), const Color(0xFF53D8FF)],
      'O': [const Color(0xFFFF536E), const Color(0xFFFF8E53)],
      'P': [const Color(0xFFB06EF5), const Color(0xFF6E8EF5)],
      'Q': [const Color(0xFF6EF5B0), const Color(0xFF6EF5F5)],
      'R': [const Color(0xFFF56E6E), const Color(0xFFF5B06E)],
      'S': [const Color(0xFF6EF56E), const Color(0xFF6EF5B0)],
      'T': [const Color(0xFFF56EB0), const Color(0xFFB06EF5)],
      'U': [const Color(0xFF6EB0F5), const Color(0xFF6E6EF5)],
      'V': [const Color(0xFFF5B06E), const Color(0xFFF5F56E)],
      'W': [const Color(0xFF6EF5F5), const Color(0xFF6EB0F5)],
      'X': [const Color(0xFFB0F56E), const Color(0xFF6EF5B0)],
      'Y': [const Color(0xFFF56EB0), const Color(0xFFF56E6E)],
      'Z': [const Color(0xFF6E6EF5), const Color(0xFFB06EF5)],
    };

    final key = letter.toUpperCase();
    final colors =
        gradients[key] ?? [const Color(0xFFB06EF5), const Color(0xFF6E8EF5)];

    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: colors,
    );
  }
}
