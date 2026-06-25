import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:transgo_passenger/core/constant/AppColor.dart';

class TripGoogleMap extends StatelessWidget {
  const TripGoogleMap({
    super.key,
    required this.initialPosition,
    required this.markers,
    required this.polylinePoints,
    this.bounds,
    this.height = 190,
    this.borderRadius = 18,
    this.zoom = 8.5,
    this.polylineId = "trip_route",
    this.polylineColor = AppColor.thirdColor,
    this.polylineWidth = 5,
    this.boundsPadding = 36,
    this.zoomControlsEnabled = true,
    this.scrollGesturesEnabled = true,
    this.zoomGesturesEnabled = true,
    this.onTap,
  });

  final LatLng initialPosition;
  final Set<Marker> markers;
  final List<LatLng> polylinePoints;
  final LatLngBounds? bounds;
  final double height;
  final double borderRadius;
  final double zoom;
  final String polylineId;
  final Color polylineColor;
  final int polylineWidth;
  final double boundsPadding;
  final bool zoomControlsEnabled;
  final bool scrollGesturesEnabled;
  final bool zoomGesturesEnabled;
  final void Function(LatLng position)? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColor.fifthColor,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: GoogleMap(
          initialCameraPosition: CameraPosition(
            target: initialPosition,
            zoom: zoom,
          ),
          markers: markers,
          polylines: {
            if (polylinePoints.isNotEmpty)
              Polyline(
                polylineId: PolylineId(polylineId),
                points: polylinePoints,
                color: polylineColor,
                width: polylineWidth,
              ),
          },
          myLocationButtonEnabled: false,
          zoomControlsEnabled: zoomControlsEnabled,
          zoomGesturesEnabled: zoomGesturesEnabled,
          scrollGesturesEnabled: scrollGesturesEnabled,
          rotateGesturesEnabled: false,
          tiltGesturesEnabled: false,
          compassEnabled: false,
          mapToolbarEnabled: false,
          onTap: onTap,
          gestureRecognizers: {
            Factory<OneSequenceGestureRecognizer>(
              () => EagerGestureRecognizer(),
            ),
          },
          onMapCreated: (mapController) {
            final mapBounds = bounds;

            if (mapBounds != null) {
              Future.delayed(const Duration(milliseconds: 350), () {
                mapController.animateCamera(
                  CameraUpdate.newLatLngBounds(mapBounds, boundsPadding),
                );
              });
            }
          },
        ),
      ),
    );
  }
}
