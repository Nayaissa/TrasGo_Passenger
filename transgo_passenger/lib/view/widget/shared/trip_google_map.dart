import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:transgo_passenger/core/constant/AppColor.dart';

class TripGoogleMap extends StatefulWidget {
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
    this.mapStyle,
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
  final String? mapStyle;
  final void Function(LatLng position)? onTap;

  @override
  State<TripGoogleMap> createState() => _TripGoogleMapState();
}

class _TripGoogleMapState extends State<TripGoogleMap> {
  GoogleMapController? _mapController;

  @override
  void didUpdateWidget(covariant TripGoogleMap oldWidget) {
    super.didUpdateWidget(oldWidget);

    final positionChanged =
        oldWidget.initialPosition.latitude != widget.initialPosition.latitude ||
        oldWidget.initialPosition.longitude != widget.initialPosition.longitude;
    final boundsChanged = oldWidget.bounds != widget.bounds;

    if (positionChanged || boundsChanged) {
      _moveCamera();
    }
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColor.fifthColor,
        borderRadius: BorderRadius.circular(widget.borderRadius),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(widget.borderRadius),
        child: GoogleMap(
          initialCameraPosition: CameraPosition(
            target: widget.initialPosition,
            zoom: widget.zoom,
          ),
          markers: widget.markers,
          polylines: {
            if (widget.polylinePoints.isNotEmpty)
              Polyline(
                polylineId: PolylineId(widget.polylineId),
                points: widget.polylinePoints,
                color: widget.polylineColor,
                width: widget.polylineWidth,
              ),
          },
          myLocationButtonEnabled: false,
          zoomControlsEnabled: widget.zoomControlsEnabled,
          zoomGesturesEnabled: widget.zoomGesturesEnabled,
          scrollGesturesEnabled: widget.scrollGesturesEnabled,
          rotateGesturesEnabled: false,
          tiltGesturesEnabled: false,
          compassEnabled: false,
          mapToolbarEnabled: false,
          style: widget.mapStyle,
          onTap: widget.onTap,
          gestureRecognizers: {
            Factory<OneSequenceGestureRecognizer>(
              () => EagerGestureRecognizer(),
            ),
          },
          onMapCreated: (mapController) {
            _mapController = mapController;
            Future.delayed(const Duration(milliseconds: 350), _moveCamera);
          },
        ),
      ),
    );
  }

  void _moveCamera() {
    final controller = _mapController;
    if (controller == null) return;

    final mapBounds = widget.bounds;

    if (mapBounds != null) {
      controller.animateCamera(
        CameraUpdate.newLatLngBounds(mapBounds, widget.boundsPadding),
      );
      return;
    }

    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: widget.initialPosition,
          zoom: widget.zoom,
        ),
      ),
    );
  }
}
