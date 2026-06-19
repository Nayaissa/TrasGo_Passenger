import 'package:flutter/material.dart';
import 'package:transgo_passenger/controller/passenger_trip/show_trips_controller.dart';
import 'package:transgo_passenger/core/constant/AppColor.dart';

class MyTripsStatsCard extends StatelessWidget {
  const MyTripsStatsCard({
    super.key,
    required this.controller,
  });

  final MyTripsController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColor.cardColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Colors.white.withOpacity(0.08),
        ),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final double itemWidth = constraints.maxWidth < 370
              ? (constraints.maxWidth - 12) / 2
              : (constraints.maxWidth - 24) / 3;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "My Trips",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 4),

              Text(
                "Track and manage all your bookings.",
                style: TextStyle(
                  color: Colors.white.withOpacity(0.55),
                  fontSize: 13,
                ),
              ),

              const SizedBox(height: 18),

              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  _StatItem(
                    width: itemWidth,
                    title: "TOTAL",
                    value: controller.totalTrips,
                    icon: Icons.confirmation_number_outlined,
                  ),
                  _StatItem(
                    width: itemWidth,
                    title: "ACTIVE",
                    value: controller.activeTrips,
                    icon: Icons.near_me_outlined,
                  ),
                  _StatItem(
                    width: itemWidth,
                    title: "PENDING",
                    value: controller.pendingTrips,
                    icon: Icons.access_time,
                  ),
                  _StatItem(
                    width: itemWidth,
                    title: "COMPLETED",
                    value: controller.completedTrips,
                    icon: Icons.check_circle_outline,
                  ),
                  _StatItem(
                    width: itemWidth,
                    title: "CANCELLED",
                    value: controller.cancelledTrips,
                    icon: Icons.cancel_outlined,
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({
    required this.width,
    required this.title,
    required this.value,
    required this.icon,
  });

  final double width;
  final String title;
  final int value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColor.fifthColor,
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(
              icon,
              color: AppColor.thirdColor,
              size: 18,
            ),
          ),

          const SizedBox(width: 9),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.45),
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  "$value",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}