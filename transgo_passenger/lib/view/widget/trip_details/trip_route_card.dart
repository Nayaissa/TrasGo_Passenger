import 'package:flutter/material.dart';
import 'package:transgo_passenger/controller/passenger_trip/trip_details_controller.dart';
import 'package:transgo_passenger/view/widget/shared/trip_google_map.dart';
import 'package:transgo_passenger/view/widget/shared/trip_route_points_list.dart';
import 'package:transgo_passenger/view/widget/trip_details/trip_details_common.dart';

class TripRouteCard extends StatelessWidget {
  const TripRouteCard({
    super.key,
    required this.controller,
  });

  final TripDetailsController controller;

  @override
  Widget build(BuildContext context) {
    return TripDetailsCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          TripGoogleMap(
            initialPosition: controller.mapInitialPosition,
            markers: controller.mapMarkers,
            polylinePoints: controller.polylinePoints,
            bounds: controller.mapBounds,
          ),
          const SizedBox(height: 18),
          TripRoutePointsList(
            points: controller.routePoints.map(_toRoutePointData).toList(),
          ),
        ],
      ),
    );
  }

  TripRoutePointData _toRoutePointData(RoutePointUiModel point) {
    return TripRoutePointData(
      title: point.title,
      subtitle: point.subtitle,
      type: _toRoutePointType(point.type),
    );
  }

  TripRoutePointType _toRoutePointType(String type) {
    switch (type) {
      case "start":
        return TripRoutePointType.start;
      case "end":
        return TripRoutePointType.end;
      default:
        return TripRoutePointType.pickup;
    }
  }
}
