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
  final int? bookingId;
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
    this.bookingId,
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
    return TripTrackingData(
      tripId: _toInt(json["trip_id"]),
      bookingId: _toInt(json["booking_id"]),
      trackingAvailable: _toBool(json["tracking_available"]) ?? false,
      trackingEnabledAfterStart:
          _toBool(json["tracking_enabled_after_start"]) ?? false,
      trackingEndpoint: json["tracking_endpoint"]?.toString(),
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
      driverLocation: _locationFromAny(json, const [
        "driver_location",
        "current_location",
        "vehicle_location",
        "last_location",
        "location",
      ]),
      pickupLocation: _locationFromAny(json, const [
        "pickup_location",
        "pickup_point",
        "pickup",
      ]),
      destinationLocation: _locationFromAny(json, const [
        "destination_location",
        "destination",
        "dropoff_location",
      ]),
      history: _locationsFromAny(json, const [
        "history",
        "locations",
        "tracking_history",
        "route",
      ]),
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
  final String? from;
  final String? to;

  TripTrackingTrip({
    this.departureAt,
    this.from,
    this.to,
  });

  factory TripTrackingTrip.fromJson(Map<String, dynamic> json) {
    return TripTrackingTrip(
      departureAt: json["departure_at"]?.toString(),
      from: json["from"]?.toString(),
      to: json["to"]?.toString(),
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
