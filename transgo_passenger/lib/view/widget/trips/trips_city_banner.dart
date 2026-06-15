import 'package:flutter/material.dart';
import 'package:transgo_passenger/core/constant/AppColor.dart';
import 'package:transgo_passenger/core/shared/app_network_image.dart';

class TripsCityBanner extends StatelessWidget {
  const TripsCityBanner({
    super.key,
    required this.title,
    required this.subtitle,
    required this.tripCount,
    required this.date,
    required this.imageUrl,
  });

  final String title;
  final String subtitle;
  final String tripCount;
  final String date;
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 155,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: Colors.white.withOpacity(0.08),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: Stack(
          children: [
            Positioned.fill(
              child: AppNetworkImage(
                imageUrl: imageUrl,
                fit: BoxFit.cover,
                fallbackIcon: Icons.location_city,
              ),
            ),

            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.black.withOpacity(0.08),
                      AppColor.secondaryColor.withOpacity(0.95),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ),

            Positioned(
              left: 16,
              right: 16,
              bottom: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: AppColor.thirdColor.withOpacity(0.25),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: AppColor.thirdColor.withOpacity(0.20),
                      ),
                    ),
                    child: Text(
                      tripCount,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    title,
                    textDirection: TextDirection.rtl,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 3),

                  Text(
                    subtitle,
                    textDirection: TextDirection.rtl,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.72),
                      fontSize: 12,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        date,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.42),
                          fontSize: 11,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Icon(
                        Icons.calendar_today_outlined,
                        color: Colors.white.withOpacity(0.42),
                        size: 13,
                      ),
                      const SizedBox(width: 16),
                      Text(
                        "Trip type: shared",
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.42),
                          fontSize: 11,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Icon(
                        Icons.directions_bus_outlined,
                        color: Colors.white.withOpacity(0.42),
                        size: 14,
                      ),
                    ],
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