import 'package:flutter/material.dart';
import 'package:transgo_passenger/controller/passenger_trip/trip_tracking_controller.dart';
import 'package:transgo_passenger/core/constant/AppColor.dart';

class TrackingStatusCard extends StatelessWidget {
  const TrackingStatusCard({
    super.key,
    required this.controller,
  });

  final TripTrackingController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF111B39).withOpacity(.92),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withOpacity(.08)),
        boxShadow: [
          BoxShadow(
            color: AppColor.thirdColor.withOpacity(.10),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: controller.availabilityColor.withOpacity(.16),
              shape: BoxShape.circle,
            ),
            child: Icon(
              controller.trackingAvailable
                  ? Icons.directions_car_filled_outlined
                  : Icons.info_outline,
              color: Colors.white,
              size: 21,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  controller.statusTitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  controller.statusSubtitle,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white.withOpacity(.72),
                    fontSize: 13,
                    height: 1.25,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            controller.trackingAvailable ? "LIVE" : "WAIT",
            style: TextStyle(
              color: controller.availabilityColor.withOpacity(.75),
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
