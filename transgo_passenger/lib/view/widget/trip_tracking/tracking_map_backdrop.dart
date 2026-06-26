import 'package:flutter/material.dart';
import 'package:transgo_passenger/controller/passenger_trip/trip_tracking_controller.dart';
import 'package:transgo_passenger/core/constant/AppColor.dart';
import 'package:transgo_passenger/view/widget/shared/trip_google_map.dart';

class TrackingMapBackdrop extends StatelessWidget {
  const TrackingMapBackdrop({
    super.key,
    required this.controller,
  });

  final TripTrackingController controller;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          children: [
            TripGoogleMap(
              initialPosition: controller.mapInitialPosition,
              markers: controller.mapMarkers,
              polylinePoints: controller.mapPolylinePoints,
              bounds: null,
              height: constraints.maxHeight,
              borderRadius: 0,
              zoom: controller.driverMapPosition == null ? 11.5 : 16,
              polylineId: "live_tracking_route",
              polylineColor: controller.mapPolylineColor,
              polylineWidth: 5,
              boundsPadding: 20,
              zoomControlsEnabled: false,
              scrollGesturesEnabled: true,
              zoomGesturesEnabled: true,
            ),
            const Positioned.fill(
              child: IgnorePointer(
                child: _MapGradientOverlay(),
              ),
            ),
            if (!controller.hasMapCoordinates)
              const Positioned(
                left: 18,
                right: 18,
                top: 96,
                child: IgnorePointer(
                  child: _MapNotice(
                    icon: Icons.location_off_outlined,
                    text: "No car coordinates are available yet.",
                  ),
                ),
              ),
            if (controller.hasMapCoordinates &&
                controller.driverMapPosition == null)
              const Positioned(
                left: 18,
                right: 18,
                top: 96,
                child: IgnorePointer(
                  child: _MapNotice(
                    icon: Icons.directions_car_outlined,
                    text: "Route is visible. Waiting for car location.",
                  ),
                ),
              ),
            Positioned(
              left: 18,
              bottom: 18,
              child: IgnorePointer(
                child: _MapStatusPill(
                  color: controller.availabilityColor,
                  text:
                      controller.hasMapCoordinates
                          ? "Google Map"
                          : "Waiting for coordinates",
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _MapGradientOverlay extends StatelessWidget {
  const _MapGradientOverlay();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            const Color(0xFF071126).withOpacity(.24),
            Colors.transparent,
            const Color(0xFF070B19).withOpacity(.38),
          ],
        ),
      ),
    );
  }
}

class _MapNotice extends StatelessWidget {
  const _MapNotice({
    required this.icon,
    required this.text,
  });

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF111B39).withOpacity(.88),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(.08)),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: Colors.amber,
            size: 20,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: Colors.white.withOpacity(.86),
                fontSize: 12,
                fontWeight: FontWeight.bold,
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MapStatusPill extends StatelessWidget {
  const _MapStatusPill({
    required this.color,
    required this.text,
  });

  final Color color;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColor.fifthColor.withOpacity(.88),
        borderRadius: BorderRadius.circular(99),
        border: Border.all(color: Colors.white.withOpacity(.08)),
      ),
      child: Row(
        children: [
          Icon(
            Icons.my_location,
            color: color,
            size: 15,
          ),
          const SizedBox(width: 6),
          Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
