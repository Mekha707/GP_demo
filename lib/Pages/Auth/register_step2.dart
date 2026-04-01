// ignore_for_file: deprecated_member_use, unnecessary_to_list_in_spreads
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healthcareapp_try1/Bloc/Auth_Bloc/RegisterationBloc/register_bloc.dart';
import 'package:healthcareapp_try1/Bloc/Auth_Bloc/RegisterationBloc/register_event.dart';
import 'package:healthcareapp_try1/Bloc/Auth_Bloc/RegisterationBloc/register_state.dart';
import 'package:healthcareapp_try1/Buttons/buttons.dart';
import 'package:healthcareapp_try1/Buttons/Icons_heart_stet.dart';
import 'package:healthcareapp_try1/Pages/Auth/verify_email_page.dart';
import 'package:healthcareapp_try1/Widgets/custom_toggle_yes_no.dart';

class RegisterStep2 extends StatefulWidget {
  const RegisterStep2({super.key});

  @override
  State<RegisterStep2> createState() => _RegisterStep2State();
}

class _RegisterStep2State extends State<RegisterStep2> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController othersController = TextEditingController();

  static const Map<String, String> diseasesMap = {
    'Heart': 'أمراض القلب',
    'Asthma': 'الربو',
    'Kidney': 'أمراض الكلى',
    'Arthritis': 'التهاب المفاصل',
    'Liver': 'أمراض الكبد',
    'Cancer': 'السرطان',
    'HighCholesterol': "الكوليسترول",
    'Others': 'أخرى',
  };

  @override
  void dispose() {
    weightController.dispose();
    othersController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                const Color(0xffc4edff).withOpacity(0.2),
                Colors.white,
                const Color(0xffc4edff).withOpacity(0.2),
              ],
            ),
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              double maxWidth = constraints.maxWidth < 600
                  ? constraints.maxWidth * 0.8
                  : constraints.maxWidth < 1024
                  ? 600
                  : 700;

              return Center(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: maxWidth),
                    child: Container(
                      width: maxWidth,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.blueGrey[100]!),
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(20),
                      child: BlocConsumer<RegisterBloc, RegisterState>(
                        listener: (context, state) {
                          if (state.status == RegisterStatus.success) {
                            // الانتقال باستخدام الـ Constructor
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ConfirmEmailPage(email: state.email.trim()),
                              ),
                            );
                          } else if (state.status == RegisterStatus.error) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(state.errorMessage ?? "حدث خطأ"),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        },

                        builder: (context, state) {
                          if (state.status == RegisterStatus.loading) {
                            return const Center(
                              child: CircularProgressIndicator(
                                color: Color(0xFF2D6CDF),
                              ),
                            );
                          }

                          return Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Iconheartstet(),
                                const SizedBox(height: 10),
                                const FittedBox(
                                  child: Text(
                                    'Medical Information',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Cotta',
                                    ),
                                  ),
                                ),
                                Text(
                                  'Step 2 of 2 - Personal Care',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade700,
                                    fontFamily: 'Agency',
                                  ),
                                ),
                                const SizedBox(height: 30),

                                // --- Diabetes Section ---
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    buildSectionTitle("Diabetes (السكري)"),
                                    const SizedBox(width: 60),
                                    Center(
                                      // وضعناه في المنتصف ليكون شكله أرتب
                                      child: CustomAnimatedToggle(
                                        // تحويل القيمة من String (state) إلى bool (Toggle)
                                        initialValue: (state.diabetes == "Yes"),
                                        onSelectionChange: (bool isChecked) {
                                          // تحويل القيمة من bool إلى String عند إرسال الـ Event للـ Bloc
                                          String valueToSend = isChecked
                                              ? "Yes"
                                              : "No";

                                          context.read<RegisterBloc>().add(
                                            DiabetesChanged(valueToSend),
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 15),

                                // --- Blood Pressure ---
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,

                                  children: [
                                    buildSectionTitle(
                                      "Blood Pressure (ضغط الدم)",
                                    ),
                                    const SizedBox(width: 10),
                                    Center(
                                      child: CustomAnimatedToggle(
                                        // سيعطي false لأن القيمة الابتدائية 'No'
                                        initialValue:
                                            state.bloodPressure == 'Yes',
                                        onSelectionChange: (bool isChecked) {
                                          context.read<RegisterBloc>().add(
                                            BloodPressureChanged(
                                              isChecked ? 'Yes' : 'No',
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 20),

                                // --- Chronic Diseases ---
                                buildSectionTitle(
                                  'Other Chronic Diseases',
                                  subtitle: 'Select all that apply',
                                ),

                                GridView.count(
                                  crossAxisCount: 2,
                                  shrinkWrap: true,
                                  mainAxisSpacing: 10,
                                  crossAxisSpacing: 10,
                                  physics: const NeverScrollableScrollPhysics(),
                                  childAspectRatio: 2,
                                  children: diseasesMap.entries
                                      .map(
                                        (entry) => SizedBox(
                                          width:
                                              (MediaQuery.of(
                                                    context,
                                                  ).size.width -
                                                  52) /
                                              2,
                                          child: buildDiseaseCard(
                                            entry.key,
                                            entry.value,
                                            state.selectedDiseases.contains(
                                              entry.key,
                                            ),
                                            () => context
                                                .read<RegisterBloc>()
                                                .add(
                                                  ChronicDiseaseToggled(
                                                    entry.key,
                                                  ),
                                                ),
                                          ),
                                        ),
                                      )
                                      .toList(),
                                ),
                                const SizedBox(height: 10),

                                if (state.selectedDiseases.contains('Others'))
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 5,
                                    ),
                                    child: TextFormField(
                                      controller: othersController,
                                      decoration: InputDecoration(
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                            color: Color(0xff0861dd),
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            15,
                                          ),
                                        ),
                                        labelText: 'Please specify (حدد المرض)',
                                        labelStyle: const TextStyle(
                                          fontSize: 14,
                                          fontFamily: 'Agency',
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                              horizontal: 15,
                                              vertical: 10,
                                            ),
                                      ),
                                      validator: (value) {
                                        if (state.selectedDiseases.contains(
                                              'Others',
                                            ) &&
                                            (value == null || value.isEmpty)) {
                                          return 'Please enter the disease name';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                const SizedBox(height: 20),

                                // الوزن
                                buildSectionTitle(
                                  'Body Weight (الوزن)',
                                  subtitle: 'Optional - you can skip this',
                                ),
                                TextFormField(
                                  controller: weightController,
                                  keyboardType:
                                      const TextInputType.numberWithOptions(
                                        decimal: true,
                                      ),
                                  onChanged: (value) {
                                    if (value.isNotEmpty) {
                                      context.read<RegisterBloc>().add(
                                        WeightChanged(double.parse(value)),
                                      );
                                    }
                                  },
                                  decoration: InputDecoration(
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                        color: Color(0xff0861dd),
                                      ),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    hintText: 'e.g. 75.5 kg',
                                    suffixText: 'kg',
                                    hintStyle: TextStyle(
                                      fontFamily: 'Agency',
                                      color: Colors.grey.shade700,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 15,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),

                                // زر التسجيلق
                                ButtonOfAuth(
                                  buttonText: "Complete Registration",
                                  buttoncolor: const Color(0xFF2D6CDF),
                                  fontcolor: Colors.white,
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      final state = context
                                          .read<RegisterBloc>()
                                          .state;

                                      context.read<RegisterBloc>().add(
                                        RegisterSubmitted(
                                          otherMedicalConditions:
                                              state.selectedDiseases.contains(
                                                'Others',
                                              )
                                              ? othersController.text
                                              : null,
                                        ),
                                      );
                                    }
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget buildSectionTitle(String title, {String? subtitle}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            fontFamily: 'Agency',
          ),
        ),
        subtitle == null
            ? SizedBox()
            : Text(
                subtitle,
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey.shade700,
                  fontFamily: 'Agency',
                ),
              ),
        const SizedBox(height: 5),
      ],
    );
  }

  Widget buildDiseaseCheckbox(
    String title,
    String subtitle,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return CheckboxListTile(
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          fontFamily: 'Agency',
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          fontFamily: 'Agency',
        ),
      ),
      value: isSelected,
      activeColor: const Color(0xff0861dd),

      onChanged: (_) => onTap(),
    );
  }

  Widget buildDiseaseCard(
    String key,
    String subtitle,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xffE6F1FB) : Colors.white,
          border: Border.all(
            color: isSelected ? const Color(0xff0861dd) : Colors.grey.shade500,
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected
                    ? const Color(0xff0861dd)
                    : Colors.transparent,
                border: Border.all(
                  color: isSelected
                      ? const Color(0xff0861dd)
                      : Colors.grey.shade500,

                  width: 1.5,
                ),
              ),
              child: isSelected
                  ? const Icon(Icons.check, size: 13, color: Colors.white)
                  : null,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    key,
                    style: TextStyle(
                      fontSize: key == "HighCholesterol" ? 9 : 11,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Agency',
                      color: isSelected
                          ? const Color(0xff0C447C)
                          : Colors.black,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 10,
                      fontFamily: 'ElMessiri',
                      fontWeight: FontWeight.bold,
                      color: isSelected
                          ? const Color(0xff185FA5)
                          : Colors.grey.shade700,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
