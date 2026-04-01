// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:healthcareapp_try1/Models/Users_Models/doctor_model.dart';
import 'package:healthcareapp_try1/Models/Users_Models/lab_model.dart';
import 'package:healthcareapp_try1/Models/Users_Models/nurse_model.dart';
import 'package:healthcareapp_try1/Pages/Booking/doctor_details_page.dart';

class DoctorCard extends StatefulWidget {
  final Doctor doctor;

  const DoctorCard({super.key, required this.doctor});

  @override
  State<DoctorCard> createState() => _DoctorCard();
}

class _DoctorCard extends State<DoctorCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = screenWidth > 600 ? 350.0 : screenWidth * 0.85;

    return Container(
      width: cardWidth,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildStaffImage(),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildNameAndFavorite(),
                      Text(
                        widget.doctor.specialty,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 13,
                          fontFamily: 'Agency',
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on_outlined,
                            size: 13,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 3),
                          Expanded(
                            child: Text(
                              widget.doctor.address,
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 11,
                                fontFamily: 'Agency',
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(
                            Icons.work_history_outlined,
                            size: 16,
                            color: Colors.blue[700],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            "EGP ${widget.doctor.fee.toStringAsFixed(0)} / session",
                            style: const TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                              fontFamily: 'Agency',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      _buildServiceBadges(),
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
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          DoctorDetailsPage(doctorId: widget.doctor.id),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff0861dd),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 0,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  minimumSize: const Size(100, 35),
                ),
                child: const Padding(
                  padding: EdgeInsets.only(top: 4),
                  child: Text(
                    "View Details",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Agency',
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStaffImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: Image.network(
        widget.doctor.profilePictureUrl,
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

  Widget _buildNameAndFavorite() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            widget.doctor.name,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              fontFamily: 'Cotta',
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const Icon(Icons.favorite_border, color: Colors.red, size: 18),
      ],
    );
  }

  Widget _buildRatingRow() {
    return Row(
      children: [
        ...List.generate(5, (i) {
          final full = i < widget.doctor.rating.floor();
          final half =
              !full &&
              i < widget.doctor.rating &&
              (widget.doctor.rating - i) >= 0.5;
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
          "${widget.doctor.rating.toStringAsFixed(1)} (${widget.doctor.ratingsCount})",
          style: const TextStyle(
            fontSize: 11,
            color: Colors.grey,
            fontFamily: 'Agency',
          ),
        ),
      ],
    );
  }

  Widget _buildServiceBadges() {
    return Row(
      children: [
        if (widget.doctor.allowHome) _badge("🏠 Home", Colors.orange),
        if (widget.doctor.allowHome && widget.doctor.allowOnline)
          const SizedBox(width: 6),
        if (widget.doctor.allowOnline) _badge("💻 Online", Colors.teal),
      ],
    );
  }

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
}

class NurseCard extends StatefulWidget {
  final Nurse nurse;

  const NurseCard({super.key, required this.nurse});

  @override
  State<NurseCard> createState() => _NurseCard();
}

class _NurseCard extends State<NurseCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = screenWidth > 600 ? 350.0 : screenWidth * 0.85;

    return Container(
      width: cardWidth,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildStaffImage(),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildNameAndFavorite(),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on_outlined,
                            size: 13,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 3),
                          Expanded(
                            child: Text(
                              widget.nurse.city,
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 11,
                                fontFamily: 'Agency',
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(
                            Icons.work_history_outlined,
                            size: 16,
                            color: Colors.blue[700],
                          ),
                          const SizedBox(width: 8),
                          Text(
                            "EGP ${widget.nurse.visitFee.toStringAsFixed(0)} / session",
                            style: const TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                              fontFamily: 'Agency',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),

                      Row(
                        children: [
                          Icon(
                            FontAwesomeIcons.clock,
                            size: 16,
                            color: Colors.blue[700],
                          ),
                          const SizedBox(width: 8),
                          Text(
                            "EGP ${widget.nurse.hourPrice.toStringAsFixed(0)} / session",
                            style: const TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                              fontFamily: 'Agency',
                            ),
                          ),
                        ],
                      ),
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
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff0861dd),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 0,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  minimumSize: const Size(100, 35),
                ),
                child: const Padding(
                  padding: EdgeInsets.only(top: 4),
                  child: Text(
                    "View Details",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Agency',
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStaffImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: Image.network(
        widget.nurse.profilePictureUrl,
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

  Widget _buildNameAndFavorite() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            widget.nurse.name,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              fontFamily: 'Cotta',
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const Icon(Icons.favorite_border, color: Colors.red, size: 18),
      ],
    );
  }

  Widget _buildRatingRow() {
    return Row(
      children: [
        ...List.generate(5, (i) {
          final full = i < widget.nurse.rating.floor();
          final half =
              !full &&
              i < widget.nurse.rating &&
              (widget.nurse.rating - i) >= 0.5;
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
          "${widget.nurse.rating.toStringAsFixed(1)} (${widget.nurse.ratingsCount})",
          style: const TextStyle(
            fontSize: 11,
            color: Colors.grey,
            fontFamily: 'Agency',
          ),
        ),
      ],
    );
  }
}

class LabCard extends StatefulWidget {
  final LabModel labModel;

  const LabCard({super.key, required this.labModel});

  @override
  State<LabCard> createState() => _LabCard();
}

class _LabCard extends State<LabCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = screenWidth > 600 ? 350.0 : screenWidth * 0.85;

    return Container(
      width: cardWidth,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildStaffImage(),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildNameAndFavorite(),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on_outlined,
                            size: 13,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 3),
                          Expanded(
                            child: Text(
                              widget.labModel.address,
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 11,
                                fontFamily: 'Agency',
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
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
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff0861dd),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 0,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  minimumSize: const Size(100, 35),
                ),
                child: const Padding(
                  padding: EdgeInsets.only(top: 4),
                  child: Text(
                    "View Details",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Agency',
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStaffImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: Image.network(
        widget.labModel.profilePictureUrl,
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

  Widget _buildNameAndFavorite() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            widget.labModel.name,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              fontFamily: 'Cotta',
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const Icon(Icons.favorite_border, color: Colors.red, size: 18),
      ],
    );
  }

  Widget _buildRatingRow() {
    return Row(
      children: [
        ...List.generate(5, (i) {
          final full = i < widget.labModel.rating.floor();
          final half =
              !full &&
              i < widget.labModel.rating &&
              (widget.labModel.rating - i) >= 0.5;
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
          "${widget.labModel.rating.toStringAsFixed(1)} (${widget.labModel.ratingsCount})",
          style: const TextStyle(
            fontSize: 11,
            color: Colors.grey,
            fontFamily: 'Agency',
          ),
        ),
      ],
    );
  }
}
