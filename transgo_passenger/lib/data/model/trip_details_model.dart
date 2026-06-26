class TripDetailsModel {
  final bool? success;
  final String? message;
  final TripDetailsData? data;
  final int? statusCode;
  final String? timestamp;

  TripDetailsModel({
    this.success,
    this.message,
    this.data,
    this.statusCode,
    this.timestamp,
  });

  factory TripDetailsModel.fromJson(Map<String, dynamic> json) {
    return TripDetailsModel(
      success: json["success"],
      message: json["message"]?.toString(),
      data: json["data"] != null
          ? TripDetailsData.fromJson(Map<String, dynamic>.from(json["data"]))
          : null,
      statusCode: _toInt(json["status_code"]),
      timestamp: json["timestamp"]?.toString(),
    );
  }
}

class TripDetailsData {
  final int? tripId;
  final TripStatusInfo? status;
  final TripTypeInfo? type;
  final VehicleInfo? vehicle;
  final DriverInfo? driver;
  final ScheduleInfo? schedule;
  final RouteInfo? route;
  final PricingInfo? pricing;
  final int? availableSeats;
  final List<PassengerInfo> passengers;
  final ActionsInfo? actions;

  TripDetailsData({
    this.tripId,
    this.status,
    this.type,
    this.vehicle,
    this.driver,
    this.schedule,
    this.route,
    this.pricing,
    this.availableSeats,
    required this.passengers,
    this.actions,
  });

  factory TripDetailsData.fromJson(Map<String, dynamic> json) {
    return TripDetailsData(
      tripId: _toInt(json["trip_id"]),
      status: json["status"] != null
          ? TripStatusInfo.fromJson(Map<String, dynamic>.from(json["status"]))
          : null,
      type: json["type"] != null
          ? TripTypeInfo.fromJson(Map<String, dynamic>.from(json["type"]))
          : null,
      vehicle: json["vehicle"] != null
          ? VehicleInfo.fromJson(Map<String, dynamic>.from(json["vehicle"]))
          : null,
      driver: json["driver"] != null
          ? DriverInfo.fromJson(Map<String, dynamic>.from(json["driver"]))
          : null,
      schedule: json["schedule"] != null
          ? ScheduleInfo.fromJson(Map<String, dynamic>.from(json["schedule"]))
          : null,
      route: json["route"] != null
          ? RouteInfo.fromJson(Map<String, dynamic>.from(json["route"]))
          : null,
      pricing: json["pricing"] != null
          ? PricingInfo.fromJson(Map<String, dynamic>.from(json["pricing"]))
          : null,
      availableSeats: _toInt(json["available_seats"]),
      passengers: json["passengers"] is List
          ? List<PassengerInfo>.from(
              json["passengers"].map(
                (e) => PassengerInfo.fromJson(Map<String, dynamic>.from(e)),
              ),
            )
          : [],
      actions: json["actions"] != null
          ? ActionsInfo.fromJson(Map<String, dynamic>.from(json["actions"]))
          : null,
    );
  }
}

class TripStatusInfo {
  final String? key;
  final String? name;

  TripStatusInfo({this.key, this.name});

  factory TripStatusInfo.fromJson(Map<String, dynamic> json) {
    return TripStatusInfo(
      key: json["key"]?.toString(),
      name: json["name"]?.toString(),
    );
  }
}

class TripTypeInfo {
  final String? requested;
  final bool? allowShared;
  final bool? allowPrivate;
  final bool? isPrivateBooked;

  TripTypeInfo({
    this.requested,
    this.allowShared,
    this.allowPrivate,
    this.isPrivateBooked,
  });

  factory TripTypeInfo.fromJson(Map<String, dynamic> json) {
    return TripTypeInfo(
      requested: json["requested"]?.toString(),
      allowShared: _toBool(json["allow_shared"]),
      allowPrivate: _toBool(json["allow_private"]),
      isPrivateBooked: _toBool(json["is_private_booked"]),
    );
  }
}

class VehicleInfo {
  final String? type;
  final String? model;
  final int? seatCapacity;
  final String? plateNumber;
  final List<String> amenities;
  final String? image;
  final List<String> images;

  VehicleInfo({
    this.type,
    this.model,
    this.seatCapacity,
    this.plateNumber,
    required this.amenities,
    this.image,
    required this.images,
  });

  factory VehicleInfo.fromJson(Map<String, dynamic> json) {
    return VehicleInfo(
      type: json["type"]?.toString(),
      model: json["model"]?.toString(),
      seatCapacity: _toInt(json["seat_capacity"]),
      plateNumber: json["plate_number"]?.toString(),
      amenities: json["amenities"] is List
          ? List<String>.from(json["amenities"].map((e) => e.toString()))
          : [],
      image: json["image"]?.toString(),
      images: json["images"] is List
          ? List<String>.from(json["images"].map((e) => e.toString()))
          : [],
    );
  }
}

class DriverInfo {
  final int? id;
  final String? fullName;
  final String? image;
  final String? phone;
  final double? rating;
  final String? profileEndpoint;

  DriverInfo({
    this.id,
    this.fullName,
    this.image,
    this.phone,
    this.rating,
    this.profileEndpoint,
  });

  factory DriverInfo.fromJson(Map<String, dynamic> json) {
    return DriverInfo(
      id: _toInt(json["id"]),
      fullName: json["full_name"]?.toString(),
      image: json["image"]?.toString(),
      phone:
          json["phone"]?.toString() ??
          json["mobile"]?.toString() ??
          json["phone_number"]?.toString(),
      rating: _toDouble(json["rating"]),
      profileEndpoint: json["profile_endpoint"]?.toString(),
    );
  }
}

class ScheduleInfo {
  final String? departureTime;
  final String? expectedArrivalTime;

  ScheduleInfo({
    this.departureTime,
    this.expectedArrivalTime,
  });

  factory ScheduleInfo.fromJson(Map<String, dynamic> json) {
    return ScheduleInfo(
      departureTime: json["departure_time"]?.toString(),
      expectedArrivalTime: json["expected_arrival_time"]?.toString(),
    );
  }
}

class RouteInfo {
  final RoutePlace? from;
  final RoutePlace? to;
  final String? polyline;
  final double? estimatedDistanceKm;
  final int? estimatedDurationMinutes;
  final List<RoutePointInfo> points;

  RouteInfo({
    this.from,
    this.to,
    this.polyline,
    this.estimatedDistanceKm,
    this.estimatedDurationMinutes,
    required this.points,
  });

  factory RouteInfo.fromJson(Map<String, dynamic> json) {
    return RouteInfo(
      from: json["from"] != null
          ? RoutePlace.fromJson(Map<String, dynamic>.from(json["from"]))
          : null,
      to: json["to"] != null
          ? RoutePlace.fromJson(Map<String, dynamic>.from(json["to"]))
          : null,
      polyline: json["polyline"]?.toString(),
      estimatedDistanceKm: _toDouble(json["estimated_distance_km"]),
      estimatedDurationMinutes: _toInt(json["estimated_duration_minutes"]),
      points: json["points"] is List
          ? List<RoutePointInfo>.from(
              json["points"].map(
                (e) => RoutePointInfo.fromJson(Map<String, dynamic>.from(e)),
              ),
            )
          : [],
    );
  }
}

class RoutePlace {
  final int? governorateId;
  final String? name;
  final String? address;
  final String? displayAddress;
  final double? latitude;
  final double? longitude;

  RoutePlace({
    this.governorateId,
    this.name,
    this.address,
    this.displayAddress,
    this.latitude,
    this.longitude,
  });

  factory RoutePlace.fromJson(Map<String, dynamic> json) {
    return RoutePlace(
      governorateId: _toInt(json["governorate_id"]),
      name: json["name"]?.toString(),
      address: json["address"]?.toString(),
      displayAddress: json["display_address"]?.toString(),
      latitude: _toDouble(json["latitude"]),
      longitude: _toDouble(json["longitude"]),
    );
  }
}

class RoutePointInfo {
  final int? pointId;
  final String? type;
  final String? address;
  final String? displayAddress;
  final String? note;
  final double? latitude;
  final double? longitude;
  final int? sequenceOrder;
  final String? expectedArrivalTime;

  RoutePointInfo({
    this.pointId,
    this.type,
    this.address,
    this.displayAddress,
    this.note,
    this.latitude,
    this.longitude,
    this.sequenceOrder,
    this.expectedArrivalTime,
  });

  factory RoutePointInfo.fromJson(Map<String, dynamic> json) {
    return RoutePointInfo(
      pointId: _toInt(json["point_id"]),
      type: json["type"]?.toString(),
      address: json["address"]?.toString(),
      displayAddress: json["display_address"]?.toString(),
      note: json["note"]?.toString(),
      latitude: _toDouble(json["latitude"]),
      longitude: _toDouble(json["longitude"]),
      sequenceOrder: _toInt(json["sequence_order"]),
      expectedArrivalTime: json["expected_arrival_time"]?.toString(),
    );
  }
}

class PricingInfo {
  final double? sharedPrice;
  final double? privatePrice;
  final double? displayPrice;

  PricingInfo({
    this.sharedPrice,
    this.privatePrice,
    this.displayPrice,
  });

  factory PricingInfo.fromJson(Map<String, dynamic> json) {
    return PricingInfo(
      sharedPrice: _toDouble(json["shared_price"]),
      privatePrice: _toDouble(json["private_price"]),
      displayPrice: _toDouble(json["display_price"]),
    );
  }
}

class PassengerInfo {
  final int? bookingId;
  final int? passengerId;
  final String? fullName;
  final String? image;
  final double? rating;
  final int? seatsReserved;
  final String? profileEndpoint;

  PassengerInfo({
    this.bookingId,
    this.passengerId,
    this.fullName,
    this.image,
    this.rating,
    this.seatsReserved,
    this.profileEndpoint,
  });

  factory PassengerInfo.fromJson(Map<String, dynamic> json) {
    return PassengerInfo(
      bookingId: _toInt(json["booking_id"]),
      passengerId: _toInt(json["passenger_id"]),
      fullName: json["full_name"]?.toString(),
      image: json["image"]?.toString(),
      rating: _toDouble(json["rating"]),
      seatsReserved: _toInt(json["seats_reserved"]),
      profileEndpoint: json["profile_endpoint"]?.toString(),
    );
  }
}

class ActionsInfo {
  final bool? canBookShared;
  final bool? canBookPrivate;
  final String? bookingEndpoint;
  final String? trackingEndpoint;

  ActionsInfo({
    this.canBookShared,
    this.canBookPrivate,
    this.bookingEndpoint,
    this.trackingEndpoint,
  });

  factory ActionsInfo.fromJson(Map<String, dynamic> json) {
    return ActionsInfo(
      canBookShared: _toBool(json["can_book_shared"]),
      canBookPrivate: _toBool(json["can_book_private"]),
      bookingEndpoint: json["booking_endpoint"]?.toString(),
      trackingEndpoint: json["tracking_endpoint"]?.toString(),
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
