class PassengerTripsModel {
  final bool? success;
  final String? message;
  final PassengerTripsData? data;
  final int? statusCode;
  final String? timestamp;

  PassengerTripsModel({
    this.success,
    this.message,
    this.data,
    this.statusCode,
    this.timestamp,
  });

  factory PassengerTripsModel.fromJson(Map<String, dynamic> json) {
    return PassengerTripsModel(
      success: json["success"],
      message: json["message"]?.toString(),
      data: json["data"] != null
          ? PassengerTripsData.fromJson(Map<String, dynamic>.from(json["data"]))
          : null,
      statusCode: _toInt(json["status_code"]),
      timestamp: json["timestamp"]?.toString(),
    );
  }
}

class PassengerTripsData {
  final List<PassengerTripItemModel> items;
  final int? total;

  PassengerTripsData({
    required this.items,
    this.total,
  });

  factory PassengerTripsData.fromJson(Map<String, dynamic> json) {
    return PassengerTripsData(
      items: json["items"] is List
          ? List<PassengerTripItemModel>.from(
              json["items"].map(
                (item) => PassengerTripItemModel.fromJson(
                  Map<String, dynamic>.from(item),
                ),
              ),
            )
          : [],
      total: _toInt(json["total"]),
    );
  }
}

class PassengerTripItemModel {
  final BookingInfoModel? booking;
  final int? tripId;
  final int? clusterId;
  final bool? isBookingVisible;
  final SimpleStatusModel? status;
  final TripTypeInfoModel? type;
  final String? departureTime;
  final TripPointModel? from;
  final TripPointModel? to;
  final PickupInfoModel? pickup;
  final DriverInfoModel? driver;
  final VehicleInfoModel? vehicle;
  final PricingInfoModel? pricing;
  final int? availableSeats;
  final bool? isRated;
  final String? detailsEndpoint;
  final String? trackingEndpoint;
  final String? ratingEndpoint;

  PassengerTripItemModel({
    this.booking,
    this.tripId,
    this.clusterId,
    this.isBookingVisible,
    this.status,
    this.type,
    this.departureTime,
    this.from,
    this.to,
    this.pickup,
    this.driver,
    this.vehicle,
    this.pricing,
    this.availableSeats,
    this.isRated,
    this.detailsEndpoint,
    this.trackingEndpoint,
    this.ratingEndpoint,
  });

  factory PassengerTripItemModel.fromJson(Map<String, dynamic> json) {
    return PassengerTripItemModel(
      booking: json["booking"] != null
          ? BookingInfoModel.fromJson(Map<String, dynamic>.from(json["booking"]))
          : null,
      tripId: _toInt(json["trip_id"]),
      clusterId: _toInt(json["cluster_id"]),
      isBookingVisible: _toBool(json["is_booking_visible"]),
      status: json["status"] != null
          ? SimpleStatusModel.fromJson(Map<String, dynamic>.from(json["status"]))
          : null,
      type: json["type"] != null
          ? TripTypeInfoModel.fromJson(Map<String, dynamic>.from(json["type"]))
          : null,
      departureTime: json["departure_time"]?.toString(),
      from: json["from"] != null
          ? TripPointModel.fromJson(Map<String, dynamic>.from(json["from"]))
          : null,
      to: json["to"] != null
          ? TripPointModel.fromJson(Map<String, dynamic>.from(json["to"]))
          : null,
      pickup: json["pickup"] != null
          ? PickupInfoModel.fromJson(Map<String, dynamic>.from(json["pickup"]))
          : null,
      driver: json["driver"] != null
          ? DriverInfoModel.fromJson(Map<String, dynamic>.from(json["driver"]))
          : null,
      vehicle: json["vehicle"] != null
          ? VehicleInfoModel.fromJson(Map<String, dynamic>.from(json["vehicle"]))
          : null,
      pricing: json["pricing"] != null
          ? PricingInfoModel.fromJson(Map<String, dynamic>.from(json["pricing"]))
          : null,
      availableSeats: _toInt(json["available_seats"]),
      isRated: _toBool(json["is_rated"]),
      detailsEndpoint: json["details_endpoint"]?.toString(),
      trackingEndpoint: json["tracking_endpoint"]?.toString(),
      ratingEndpoint: json["rating_endpoint"]?.toString(),
    );
  }

  String get bookingCode => booking?.bookingCode ?? "";

  String get statusKey => status?.key ?? "";

  String get statusName => status?.name ?? "";

  String get fromName => from?.name ?? "";

  String get fromDetails => from?.displayAddress ?? from?.address ?? "";

  String get toName => to?.name ?? "";

  String get toDetails => to?.displayAddress ?? to?.address ?? "";

  String get dateText => departureTime ?? booking?.createdAt ?? "";

  String get infoText {
    final typeText = booking?.bookingType ?? type?.requested ?? "";
    final seats = booking?.seatsReserved;

    if (seats == null) {
      return typeText;
    }

    return "$typeText • $seats Seats Reserved";
  }

  String get driverName => driver?.fullName ?? "";

  String get driverImage => driver?.image ?? "";

  String get ratingText => driver?.rating?.toString() ?? "0";

  String get carType => vehicle?.type ?? "";

  String get priceText {
    final amount = booking?.totalAmount ?? pricing?.displayPrice;

    if (amount == null) {
      return "";
    }

    return "Total: $amount";
  }

  bool get isCanceled {
    return statusKey == "canceled" || statusKey == "cancelled";
  }

  bool get isActive {
    return statusKey == "active" || statusKey == "current";
  }

  bool get isPending {
    return statusKey == "pending";
  }

  bool get isCompleted {
    return statusKey == "completed";
  }
}

class BookingInfoModel {
  final int? bookingId;
  final String? bookingCode;
  final SimpleStatusModel? status;
  final String? bookingType;
  final int? seatsReserved;
  final double? totalAmount;
  final String? createdAt;

  BookingInfoModel({
    this.bookingId,
    this.bookingCode,
    this.status,
    this.bookingType,
    this.seatsReserved,
    this.totalAmount,
    this.createdAt,
  });

  factory BookingInfoModel.fromJson(Map<String, dynamic> json) {
    return BookingInfoModel(
      bookingId: _toInt(json["booking_id"]),
      bookingCode: json["booking_code"]?.toString(),
      status: json["status"] != null
          ? SimpleStatusModel.fromJson(Map<String, dynamic>.from(json["status"]))
          : null,
      bookingType: json["booking_type"]?.toString(),
      seatsReserved: _toInt(json["seats_reserved"]),
      totalAmount: _toDouble(json["total_amount"]),
      createdAt: json["created_at"]?.toString(),
    );
  }
}

class SimpleStatusModel {
  final String? key;
  final String? name;

  SimpleStatusModel({
    this.key,
    this.name,
  });

  factory SimpleStatusModel.fromJson(Map<String, dynamic> json) {
    return SimpleStatusModel(
      key: json["key"]?.toString(),
      name: json["name"]?.toString(),
    );
  }
}

class TripTypeInfoModel {
  final String? requested;
  final bool? allowShared;
  final bool? allowPrivate;

  TripTypeInfoModel({
    this.requested,
    this.allowShared,
    this.allowPrivate,
  });

  factory TripTypeInfoModel.fromJson(Map<String, dynamic> json) {
    return TripTypeInfoModel(
      requested: json["requested"]?.toString(),
      allowShared: _toBool(json["allow_shared"]),
      allowPrivate: _toBool(json["allow_private"]),
    );
  }
}

class TripPointModel {
  final int? governorateId;
  final String? name;
  final String? address;
  final String? displayAddress;

  TripPointModel({
    this.governorateId,
    this.name,
    this.address,
    this.displayAddress,
  });

  factory TripPointModel.fromJson(Map<String, dynamic> json) {
    return TripPointModel(
      governorateId: _toInt(json["governorate_id"]),
      name: json["name"]?.toString(),
      address: json["address"]?.toString(),
      displayAddress: json["display_address"]?.toString(),
    );
  }
}

class PickupInfoModel {
  final int? pickupPointId;
  final int? tripPointId;
  final int? governorateId;
  final String? governorateName;
  final String? pointName;
  final String? address;
  final String? displayAddress;
  final double? latitude;
  final double? longitude;
  final String? meetingTime;
  final bool? isNew;

  PickupInfoModel({
    this.pickupPointId,
    this.tripPointId,
    this.governorateId,
    this.governorateName,
    this.pointName,
    this.address,
    this.displayAddress,
    this.latitude,
    this.longitude,
    this.meetingTime,
    this.isNew,
  });

  factory PickupInfoModel.fromJson(Map<String, dynamic> json) {
    return PickupInfoModel(
      pickupPointId: _toInt(json["pickup_point_id"]),
      tripPointId: _toInt(json["trip_point_id"]),
      governorateId: _toInt(json["governorate_id"]),
      governorateName: json["governorate_name"]?.toString(),
      pointName: json["point_name"]?.toString(),
      address: json["address"]?.toString(),
      displayAddress: json["display_address"]?.toString(),
      latitude: _toDouble(json["latitude"]),
      longitude: _toDouble(json["longitude"]),
      meetingTime: json["meeting_time"]?.toString(),
      isNew: _toBool(json["is_new"]),
    );
  }
}

class DriverInfoModel {
  final int? id;
  final String? fullName;
  final String? image;
  final double? rating;

  DriverInfoModel({
    this.id,
    this.fullName,
    this.image,
    this.rating,
  });

  factory DriverInfoModel.fromJson(Map<String, dynamic> json) {
    return DriverInfoModel(
      id: _toInt(json["id"]),
      fullName: json["full_name"]?.toString(),
      image: json["image"]?.toString(),
      rating: _toDouble(json["rating"]),
    );
  }
}

class VehicleInfoModel {
  final String? type;
  final String? image;

  VehicleInfoModel({
    this.type,
    this.image,
  });

  factory VehicleInfoModel.fromJson(Map<String, dynamic> json) {
    return VehicleInfoModel(
      type: json["type"]?.toString(),
      image: json["image"]?.toString(),
    );
  }
}

class PricingInfoModel {
  final double? sharedPrice;
  final double? privatePrice;
  final double? displayPrice;

  PricingInfoModel({
    this.sharedPrice,
    this.privatePrice,
    this.displayPrice,
  });

  factory PricingInfoModel.fromJson(Map<String, dynamic> json) {
    return PricingInfoModel(
      sharedPrice: _toDouble(json["shared_price"]),
      privatePrice: _toDouble(json["private_price"]),
      displayPrice: _toDouble(json["display_price"]),
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