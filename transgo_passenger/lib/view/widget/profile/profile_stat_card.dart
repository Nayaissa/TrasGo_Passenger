import 'package:flutter/material.dart';
import 'package:transgo_passenger/core/constant/AppColor.dart';

class ProfileStatCard extends StatelessWidget {
  const ProfileStatCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    this.highlight = false,
  });

  final String title;
  final String value;
  final IconData icon;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    final color = highlight ? AppColor.fourthColor : AppColor.thirdColor;

    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 10,
        ),
        decoration: BoxDecoration(
          color: AppColor.fifthColor,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: color.withOpacity(0.18),
          ),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 8),
            Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white.withOpacity(0.48),
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }
}