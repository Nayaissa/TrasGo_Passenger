class TripTrackingModel {
  final bool? success;
  final String? message;
  final TripTrackingData? data;
  final int? statusCode;
  final String? timestamp;

  TripTrackingModel({
    this.success,
    this.message,
    this.data,
    this.statusCode,
    this.timestamp,
  });

  factory TripTrackingModel.fromJson(Map<String, dynamic> json) {
    return TripTrackingModel(
      success: _toBool(json["success"]),
      message: json["message"]?.toString(),
      data:
          json["data"] != null
              ? TripTrackingData.fromJson(
                Map<String, dynamic>.from(json["data"]),
              )
              : null,
      statusCode: _toInt(json["status_code"]),
      timestamp: json["timestamp"]?.toString(),
    );
  }
}

class TripTrackingData {
  final int? tripId;
  final bool trackingAvailable;
  final bool trackingEnabledAfterStart;
  final String? trackingEndpoint;
  final TripTrackingStatus? status;
  final TripTrackingTrip? trip;
  final String? message;
  final TripTrackingLocation? driverLocation;
  final TripTrackingLocation? pickupLocation;
  final TripTrackingLocation? destinationLocation;
  final List<TripTrackingLocation> history;

  TripTrackingData({
    this.tripId,
    required this.trackingAvailable,
    required this.trackingEnabledAfterStart,
    this.trackingEndpoint,
    this.status,
    this.trip,
    this.message,
    this.driverLocation,
    this.pickupLocation,
    this.destinationLocation,
    required this.history,
  });

  factory TripTrackingData.fromJson(Map<String, dynamic> json) {

    // tracking object
    final tracking =
        json["tracking"] is Map<String, dynamic>
            ? Map<String, dynamic>.from(json["tracking"])
            : <String, dynamic>{};

    // last position
    final lastPosition =
        tracking["last_position"] is Map<String, dynamic>
            ? Map<String, dynamic>.from(tracking["last_position"])
            : <String, dynamic>{};

    // history object
    final historyObject =
        tracking["history"] is Map<String, dynamic>
            ? Map<String, dynamic>.from(tracking["history"])
            : <String, dynamic>{};

    // history items
    final historyItems =
        historyObject["items"] is List
            ? historyObject["items"] as List
            : [];

    return TripTrackingData(
      tripId: _toInt(json["trip_id"]),

      // في الـ API الجديد
      trackingAvailable:
          _toBool(tracking["is_tracking_active"]) ?? false,

      trackingEnabledAfterStart:
          _toBool(tracking["has_live_location"]) ?? false,

      trackingEndpoint:
          json["details_endpoint"]?.toString(),

      status:
          json["status"] != null
              ? TripTrackingStatus.fromJson(
                  Map<String, dynamic>.from(json["status"]),
                )
              : null,

      trip:
          json["trip"] != null
              ? TripTrackingTrip.fromJson(
                  Map<String, dynamic>.from(json["trip"]),
                )
              : null,

      message: json["message"]?.toString(),

      // موقع السائق الحالي
      driverLocation:
          lastPosition.isNotEmpty
              ? TripTrackingLocation.fromJson(lastPosition)
              : null,

      pickupLocation: null,

      destinationLocation: null,

      // سجل حركة السائق
      history:
          historyItems
              .whereType<Map>()
              .map(
                (e) => TripTrackingLocation.fromJson(
                  Map<String, dynamic>.from(e),
                ),
              )
              .where((e) => e.hasCoordinates)
              .toList(),
    );
  }
}

class TripTrackingStatus {
  final String? key;
  final String? name;

  TripTrackingStatus({
    this.key,
    this.name,
  });

  factory TripTrackingStatus.fromJson(Map<String, dynamic> json) {
    return TripTrackingStatus(
      key: json["key"]?.toString(),
      name: json["name"]?.toString(),
    );
  }
}

class TripTrackingTrip {
  final String? departureAt;
  final String? actualStartTime;
  final String? completedAt;
  final String? from;
  final String? to;
  final String? routePolyline;

  TripTrackingTrip({
    this.departureAt,
    this.actualStartTime,
    this.completedAt,
    this.from,
    this.to,
    this.routePolyline,
  });

  factory TripTrackingTrip.fromJson(
      Map<String, dynamic> json) {
    return TripTrackingTrip(
      departureAt: json["departure_at"]?.toString(),
      actualStartTime:
          json["actual_start_time"]?.toString(),
      completedAt:
          json["completed_at"]?.toString(),
      from: json["from"]?.toString(),
      to: json["to"]?.toString(),
      routePolyline:
          json["route_polyline"]?.toString(),
    );
  }
}
class TripTrackingLocation {
  final double? latitude;
  final double? longitude;
  final String? title;
  final String? address;
  final String? recordedAt;

  TripTrackingLocation({
    this.latitude,
    this.longitude,
    this.title,
    this.address,
    this.recordedAt,
  });

  bool get hasCoordinates => latitude != null && longitude != null;

  factory TripTrackingLocation.fromJson(Map<String, dynamic> json) {
    final coordinates = json["coordinates"];
    final location = json["location"];
    final nestedCoordinates =
        coordinates is Map ? Map<String, dynamic>.from(coordinates) : null;
    final nestedLocation =
        location is Map ? Map<String, dynamic>.from(location) : null;

    return TripTrackingLocation(
      latitude: _toDouble(
        json["latitude"] ??
            json["lat"] ??
            json["driver_latitude"] ??
            json["current_latitude"] ??
            nestedCoordinates?["latitude"] ??
            nestedCoordinates?["lat"] ??
            nestedLocation?["latitude"] ??
            nestedLocation?["lat"],
      ),
      longitude: _toDouble(
        json["longitude"] ??
            json["lng"] ??
            json["lon"] ??
            json["driver_longitude"] ??
            json["current_longitude"] ??
            nestedCoordinates?["longitude"] ??
            nestedCoordinates?["lng"] ??
            nestedCoordinates?["lon"] ??
            nestedLocation?["longitude"] ??
            nestedLocation?["lng"] ??
            nestedLocation?["lon"],
      ),
      title:
          json["title"]?.toString() ??
          json["name"]?.toString() ??
          json["label"]?.toString(),
      address:
          json["address"]?.toString() ?? json["display_address"]?.toString(),
      recordedAt:
          json["recorded_at"]?.toString() ??
          json["created_at"]?.toString() ??
          json["timestamp"]?.toString(),
    );
  }
}

int? _toInt(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  return int.tryParse(value.toString());
}

double? _toDouble(dynamic value) {
  if (value == null) return null;
  if (value is double) return value;
  if (value is int) return value.toDouble();
  return double.tryParse(value.toString());
}

bool? _toBool(dynamic value) {
  if (value == null) return null;
  if (value is bool) return value;

  final text = value.toString().toLowerCase();

  if (text == "true" || text == "1") return true;
  if (text == "false" || text == "0") return false;

  return null;
}

TripTrackingLocation? _locationFromAny(
  Map<String, dynamic> json,
  List<String> keys,
) {
  for (final key in keys) {
    final value = json[key];

    if (value is Map) {
      final location = TripTrackingLocation.fromJson(
        Map<String, dynamic>.from(value),
      );

      if (location.hasCoordinates) return location;
    }
  }

  final directLocation = TripTrackingLocation.fromJson(json);

  if (directLocation.hasCoordinates) return directLocation;

  return null;
}

List<TripTrackingLocation> _locationsFromAny(
  Map<String, dynamic> json,
  List<String> keys,
) {
  for (final key in keys) {
    final value = json[key];

    if (value is List) {
      return value
          .whereType<Map>()
          .map(
            (item) => TripTrackingLocation.fromJson(
              Map<String, dynamic>.from(item),
            ),
          )
          .where((item) => item.hasCoordinates)
          .toList();
    }

    if (value is Map && value["points"] is List) {
      return (value["points"] as List)
          .whereType<Map>()
          .map(
            (item) => TripTrackingLocation.fromJson(
              Map<String, dynamic>.from(item),
            ),
          )
          .where((item) => item.hasCoordinates)
          .toList();
    }
  }

  return [];
}
