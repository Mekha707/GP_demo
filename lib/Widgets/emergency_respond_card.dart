// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class EmergencyResponseCard extends StatelessWidget {
  const EmergencyResponseCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFEEEE),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.local_hospital_rounded,
                  color: Color(0xFFE53935),
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '24/7 Emergency Response',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1A1A2E),
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Our ambulances are equipped with advanced life support systems and staffed by trained paramedics ready to respond to your emergency.',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF6B7280),
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),
          const Divider(color: Color(0xFFF0F0F0), height: 1),
          const SizedBox(height: 12),

          // Average response time
          _InfoRow(
            icon: Icons.access_time_rounded,
            iconColor: const Color(0xFF10B981),
            text: 'Average response time: 8-12 minutes',
          ),

          const SizedBox(height: 10),

          // Emergency hotline
          _InfoRow(
            icon: Icons.phone_rounded,
            iconColor: const Color(0xFF3B82F6),
            text: 'Emergency Hotline: 911',
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String text;

  const _InfoRow({
    required this.icon,
    required this.iconColor,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: iconColor),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF374151),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
