// ignore_for_file: use_super_parameters, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healthcareapp_try1/Bloc/Auth_Bloc/RegisterationBloc/register_bloc.dart';
import 'package:healthcareapp_try1/Bloc/Auth_Bloc/RegisterationBloc/register_event.dart';
import 'package:healthcareapp_try1/Bloc/Auth_Bloc/RegisterationBloc/register_state.dart';

class GenderToggle extends StatefulWidget {
  const GenderToggle({Key? key}) : super(key: key);

  @override
  State<GenderToggle> createState() => _GenderToggleState();
}

class _GenderToggleState extends State<GenderToggle> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterBloc, RegisterState>(
      buildWhen: (prev, curr) => prev.gender != curr.gender,
      builder: (context, state) {
        return Row(
          children: [
            _genderBtn("Male", Icons.male, state.gender == "Male"),
            const SizedBox(width: 10),
            _genderBtn("Female", Icons.female, state.gender == "Female"),
          ],
        );
      },
    );
  }

  Widget _genderBtn(String label, IconData icon, bool isSelected) {
    final Color activeColor = label == "Female"
        ? Colors.pink
        : const Color(0xff0861dd);

    return Expanded(
      child: OutlinedButton.icon(
        style: OutlinedButton.styleFrom(
          backgroundColor: isSelected
              ? activeColor.withOpacity(0.1)
              : Colors.white,
          side: BorderSide(color: isSelected ? activeColor : Colors.grey),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(vertical: 12),
        ),
        onPressed: () => context.read<RegisterBloc>().add(GenderChanged(label)),
        icon: Icon(icon, color: isSelected ? activeColor : Colors.grey),
        label: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? activeColor : Colors.grey,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w300,
              fontFamily: 'Agency',
            ),
          ),
        ),
      ),
    );
  }
}
