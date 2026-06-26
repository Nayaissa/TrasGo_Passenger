import 'package:flutter/material.dart';
import 'package:transgo_passenger/controller/passenger_trip/trip_tracking_controller.dart';

class TrackingMetricsRow extends StatelessWidget {
  const TrackingMetricsRow({
    super.key,
    required this.controller,
  });

  final TripTrackingController controller;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _MetricPill(
            icon: Icons.location_on_outlined,
            label: controller.fromCity.isEmpty ? "From" : controller.fromCity,
            value: controller.toCity.isEmpty ? "-" : controller.toCity,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _MetricPill(
            icon: Icons.schedule_outlined,
            label: "Pickup",
            value: controller.pickupTime.isEmpty ? "-" : controller.pickupTime,
          ),
        ),
      ],
    );
  }
}

class TrackingTripInfoStrip extends StatelessWidget {
  const TrackingTripInfoStrip({
    super.key,
    required this.controller,
  });

  final TripTrackingController controller;

  @override
  Widget build(BuildContext context) {
    if (controller.departureTime.isEmpty && controller.bookingCode.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF111B39).withOpacity(.86),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withOpacity(.08)),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.route_outlined,
            color: Colors.white,
            size: 18,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              controller.departureTime.isEmpty
                  ? "Booking ${controller.bookingCode}"
                  : "Departure ${controller.departureTime}",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.white.withOpacity(.82),
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          if (controller.statusKey.isNotEmpty)
            Text(
              controller.statusKey,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: controller.availabilityColor,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
        ],
      ),
    );
  }
}

class _MetricPill extends StatelessWidget {
  const _MetricPill({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF111B39).withOpacity(.88),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withOpacity(.08)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 15,
            color: Colors.white.withOpacity(.82),
          ),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              "$label: $value",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
