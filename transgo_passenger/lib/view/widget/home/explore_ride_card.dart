import 'package:flutter/material.dart';
import 'package:transgo_passenger/core/constant/AppColor.dart';

class ExploreRideCard extends StatelessWidget {
  const ExploreRideCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.buttonText,
    this.onPressed,
  });

  final String title;
  final String subtitle;
  final String buttonText;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColor.cardColor,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: Colors.white.withOpacity(0.08),
        ),
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: AppColor.thirdColor.withOpacity(0.08),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -8,
            top: -8,
            child: Container(
              width: 105,
              height: 105,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    AppColor.thirdColor.withOpacity(0.20),
                    AppColor.fourthColor.withOpacity(0.12),
                  ],
                ),
              ),
            ),
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  height: 1.2,
                ),
              ),

              const SizedBox(height: 10),

              Text(
                subtitle,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.62),
                  fontSize: 14,
                  height: 1.4,
                ),
              ),

              const SizedBox(height: 18),

              Container(
                height: 46,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  gradient: const LinearGradient(
                    colors: [
                      AppColor.thirdColor,
                      AppColor.fourthColor,
                    ],
                  ),
                ),
                child: ElevatedButton.icon(
                  onPressed: onPressed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    padding: const EdgeInsets.symmetric(horizontal: 22),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  icon: const Icon(
                    Icons.search,
                    color: Colors.white,
                    size: 20,
                  ),
                  label: Text(
                    buttonText,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}