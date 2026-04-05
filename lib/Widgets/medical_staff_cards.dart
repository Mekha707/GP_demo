// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:healthcareapp_try1/Models/Users_Models/doctor_model.dart';
import 'package:healthcareapp_try1/Models/Users_Models/lab_model.dart';
import 'package:healthcareapp_try1/Models/Users_Models/nurse_model.dart';
import 'package:healthcareapp_try1/Pages/Booking/universal_details_page.dart';
import 'package:healthcareapp_try1/Pages/Booking/healtcare_provider.dart';

class UniversalMedicalCard extends StatefulWidget {
  final HealthcareProvider provider;

  const UniversalMedicalCard({super.key, required this.provider});

  @override
  State<UniversalMedicalCard> createState() => _UniversalMedicalCardState();
}

class _UniversalMedicalCardState extends State<UniversalMedicalCard> {
  Color color = Color(0xff131ab9);
  @override
  void initState() {
    super.initState();
    widget.provider.providerType == "Nurse"
        ? color = Color(0xff0082c5)
        : widget.provider.providerType == "Lab"
        ? color = Colors.teal
        : color = Color(0xff131ab9);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = screenWidth > 600 ? 350.0 : screenWidth * 0.85;

    // تحديد نوع المزود
    final isDoctor = widget.provider is Doctor;
    final isLab = widget.provider is LabModel;

    return Container(
      width: cardWidth,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 2)),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildProviderImage(),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildNameAndFavorite(),

                      // عرض التخصص للدكاترة أو وصف قصير للمعمل
                      if (isDoctor)
                        Text(
                          (widget.provider as Doctor).specialty,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 13,
                            fontFamily: 'Agency',
                          ),
                        )
                      else if (isLab)
                        const Text(
                          "Medical Laboratory", // أو أي حقل من LabModel
                          style: TextStyle(
                            color: Colors.teal,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                      const SizedBox(height: 4),
                      _buildLocationRow(),
                      const SizedBox(height: 6),

                      // عرض السعر (موجود في الأب)
                      _buildPriceRow(),

                      if (isDoctor) ...[
                        const SizedBox(height: 6),
                        _buildDoctorBadges(widget.provider as Doctor),
                      ],
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            _buildRatingRow(),
            const SizedBox(height: 8),
            const Divider(height: 1, thickness: 0.5),
            const SizedBox(height: 8),

            if (widget.provider is LabModel) ...[
              // نقوم بعمل Casting داخل نطاق الـ if فقط لضمان الأمان
              (() {
                final lab = widget.provider as LabModel;

                // نتحقق هل المستخدم يبحث عن تحاليل معينة أم لا
                if (lab.totalRequestedTests != null &&
                    lab.totalRequestedTests! > 0) {
                  return Column(
                    children: [
                      _buildMatchIndicator(lab),
                      const SizedBox(height: 8),
                      _buildMatchedTestsNames(lab),
                      const SizedBox(height: 12),
                    ],
                  );
                }
                return const SizedBox.shrink();
              }()),
            ],

            _buildActionButton(),
          ],
        ),
      ),
    );
  }

  // --- Widgets مساعدة ---

  Widget _buildMatchIndicator(LabModel lab) {
    // تجنب الخطأ إذا كانت القيم null
    final matched = lab.matchedTestsCount ?? 0;
    final total = lab.totalRequestedTests ?? 0;
    bool isFullMatch = matched == total && total > 0;

    return Container(
      width: double.infinity, // ليمتد بعرض الكارت
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isFullMatch ? const Color(0xFFE1F5EE) : Colors.blueGrey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isFullMatch
              ? const Color(0xFFB2E2D1)
              : Colors.blueGrey.shade100,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isFullMatch ? Icons.check_circle : Icons.biotech_rounded,
            size: 16,
            color: isFullMatch ? const Color(0xFF0F6E56) : Colors.blueGrey,
          ),
          const SizedBox(width: 8),
          Text(
            "Tests Availability: $matched / $total",
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: isFullMatch
                  ? const Color(0xFF0F6E56)
                  : Colors.blueGrey.shade800,
              fontFamily: 'Agency',
            ),
          ),
          const Spacer(),
          if (isFullMatch)
            const Text(
              "COMPLETE",
              style: TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0F6E56),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildMatchedTestsNames(LabModel lab) {
    if (lab.matchedTestsNames == null || lab.matchedTestsNames!.isEmpty) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      height: 30, // تحديد ارتفاع ثابت للـ Chips
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: lab.matchedTestsNames!.length,
        separatorBuilder: (_, __) => const SizedBox(width: 6),
        itemBuilder: (context, index) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFE0F2F1), // Teal خفيف جداً
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                lab.matchedTestsNames![index],
                style: const TextStyle(
                  fontSize: 10,
                  color: Colors.teal,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Agency',
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildLocationRow() {
    // بما أنك قمت بعمل override لـ location في الـ LabModel،
    // تأكد أن HealthcareProvider يحتوي أيضاً على getter اسمه location
    String address = widget.provider.location;

    return Row(
      children: [
        Icon(
          Icons.location_on_outlined,
          size: 14,
          color: color,
        ), // استخدام لون النوع (أزرق/تيل)
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            address,
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 12,
              fontFamily: 'Agency',
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildPriceRow() {
    return Row(
      children: [
        if (widget.provider is Nurse || widget.provider is Doctor) ...[
          Icon(Icons.work_history_outlined, size: 16, color: Colors.blue[700]),
          const SizedBox(width: 4),
          Text(
            "EGP ${widget.provider.mainFee.toStringAsFixed(0)} / session",
            style: const TextStyle(
              color: Colors.green,
              fontWeight: FontWeight.bold,
              fontSize: 12,
              fontFamily: 'Agency',
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildActionButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          // الانتقال لصفحة التفاصيل الموحدة
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ProviderDetailsPage(provider: widget.provider),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: const Text(
          "View Details",
          style: TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.bold,
            fontFamily: 'Agency',
          ),
        ),
      ),
    );
  }

  // 1. دالة بناء صورة المزود (تعمل مع الكل)
  Widget _buildProviderImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: Image.network(
        widget.provider.profilePictureUrl, // خاصية من الأب
        width: 75,
        height: 75,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Container(
          width: 75,
          height: 75,
          color: Colors.blue.shade50,
          child: const Icon(Icons.person, color: Colors.blue),
        ),
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            width: 75,
            height: 75,
            color: Colors.blue.shade50,
            child: const Center(
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          );
        },
      ),
    );
  }

  // 2. دالة بناء الاسم وأيقونة المفضلة
  Widget _buildNameAndFavorite() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            widget.provider.name, // خاصية من الأب
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              fontFamily: 'Cotta',
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        // يمكنك لاحقاً ربط هذه الأيقونة بحالة المفضلة في الـ Database
        const Icon(Icons.favorite_border, color: Colors.red, size: 18),
      ],
    );
  }

  // 3. دالة بناء نظام النجوم والتقييم
  Widget _buildRatingRow() {
    return Row(
      children: [
        ...List.generate(5, (i) {
          // حساب النجوم بناءً على الرقم العشري (مثلاً 4.5)
          final full = i < widget.provider.rating.floor();
          final half =
              !full &&
              i < widget.provider.rating &&
              (widget.provider.rating - i) >= 0.5;

          return Icon(
            full
                ? Icons.star
                : half
                ? Icons.star_half
                : Icons.star_border,
            size: 16,
            color: Colors.amber,
          );
        }),
        const SizedBox(width: 4),
        Text(
          "${widget.provider.rating.toStringAsFixed(1)} (${widget.provider.ratingsCount})",
          style: const TextStyle(
            fontSize: 11,
            color: Colors.grey,
            fontFamily: 'Agency',
          ),
        ),
      ],
    );
  }

  // 4. دالة بناء الشارات (Badges) - مخصصة للدكتور أو يمكن تعميمها
  Widget _badge(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.bold,
          fontFamily: 'Agency',
        ),
      ),
    );
  }

  // 5. دالة إضافية لعرض شارات الدكتور (Home / Online)
  Widget _buildDoctorBadges(Doctor doctor) {
    return Row(
      children: [
        if (doctor.allowHome) _badge("🏠 Home", Colors.orange),
        if (doctor.allowHome && doctor.allowOnline) const SizedBox(width: 6),
        if (doctor.allowOnline) _badge("💻 Online", Colors.pinkAccent),
      ],
    );
  }
}
