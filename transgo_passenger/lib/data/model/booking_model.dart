class BookingModel {
  final bool? success;
  final String? message;
  final BookingData? data;
  final int? statusCode;
  final String? timestamp;

  BookingModel({
    this.success,
    this.message,
    this.data,
    this.statusCode,
    this.timestamp,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      success: _toBool(json["success"]),
      message: json["message"]?.toString(),
      data: json["data"] != null
          ? BookingData.fromJson(Map<String, dynamic>.from(json["data"]))
          : null,
      statusCode: _toInt(json["status_code"]),
      timestamp: json["timestamp"]?.toString(),
    );
  }
}

class BookingData {
  final int? bookingId;
  final String? bookingCode;
  final int? tripId;
  final int? passengerId;
  final String? bookingType;
  final int? seatsReserved;
  final String? paymentMethod;
  final double? totalAmount;
  final int? statusId;
  final String? confirmedAt;
  final String? createdAt;
  final String? updatedAt;
  final BookingTrip? trip;
  final BookingPickupPoint? pickupPoint;
  final List<BookingPayment> payments;
  final BookingPassenger? passenger;

  BookingData({
    this.bookingId,
    this.bookingCode,
    this.tripId,
    this.passengerId,
    this.bookingType,
    this.seatsReserved,
    this.paymentMethod,
    this.totalAmount,
    this.statusId,
    this.confirmedAt,
    this.createdAt,
    this.updatedAt,
    this.trip,
    this.pickupPoint,
    required this.payments,
    this.passenger,
  });

  factory BookingData.fromJson(Map<String, dynamic> json) {
    return BookingData(
      bookingId: _toInt(json["booking_id"]),
      bookingCode: json["booking_code"]?.toString(),
      tripId: _toInt(json["trip_id"]),
      passengerId: _toInt(json["passenger_id"]),
      bookingType: json["booking_type"]?.toString(),
      seatsReserved: _toInt(json["seats_reserved"]),
      paymentMethod: json["payment_method"]?.toString(),
      totalAmount: _toDouble(json["total_amount"]),
      statusId: _toInt(json["status_id"]),
      confirmedAt: json["confirmed_at"]?.toString(),
      createdAt: json["created_at"]?.toString(),
      updatedAt: json["updated_at"]?.toString(),
      trip: json["trip"] != null
          ? BookingTrip.fromJson(Map<String, dynamic>.from(json["trip"]))
          : null,
      pickupPoint: json["pickup_point"] != null
          ? BookingPickupPoint.fromJson(
              Map<String, dynamic>.from(json["pickup_point"]),
            )
          : null,
      payments: json["payments"] is List
          ? List<BookingPayment>.from(
              json["payments"].map(
                (e) => BookingPayment.fromJson(Map<String, dynamic>.from(e)),
              ),
            )
          : [],
      passenger: json["passenger"] != null
          ? BookingPassenger.fromJson(
              Map<String, dynamic>.from(json["passenger"]),
            )
          : null,
    );
  }
}

class BookingTrip {
  final int? tripId;
  final int? driverId;
  final int? startGovernorateId;
  final int? endGovernorateId;
  final String? departureTime;
  final int? estimatedDurationMinutes;
  final double? estimatedDistanceKm;
  final int? totalSeats;
  final int? availableSeats;
  final bool? allowShared;
  final bool? allowPrivate;
  final bool? isPrivateBooked;
  final double? sharedPrice;
  final double? privatePrice;
  final String? routePolyline;
  final int? statusId;
  final BookingDriver? driver;

  BookingTrip({
    this.tripId,
    this.driverId,
    this.startGovernorateId,
    this.endGovernorateId,
    this.departureTime,
    this.estimatedDurationMinutes,
    this.estimatedDistanceKm,
    this.totalSeats,
    this.availableSeats,
    this.allowShared,
    this.allowPrivate,
    this.isPrivateBooked,
    this.sharedPrice,
    this.privatePrice,
    this.routePolyline,
    this.statusId,
    this.driver,
  });

  factory BookingTrip.fromJson(Map<String, dynamic> json) {
    return BookingTrip(
      tripId: _toInt(json["trip_id"]),
      driverId: _toInt(json["driver_id"]),
      startGovernorateId: _toInt(json["start_governorate_id"]),
      endGovernorateId: _toInt(json["end_governorate_id"]),
      departureTime: json["departure_time"]?.toString(),
      estimatedDurationMinutes: _toInt(json["estimated_duration_minutes"]),
      estimatedDistanceKm: _toDouble(json["estimated_distance_km"]),
      totalSeats: _toInt(json["total_seats"]),
      availableSeats: _toInt(json["available_seats"]),
      allowShared: _toBool(json["allow_shared"]),
      allowPrivate: _toBool(json["allow_private"]),
      isPrivateBooked: _toBool(json["is_private_booked"]),
      sharedPrice: _toDouble(json["shared_price"]),
      privatePrice: _toDouble(json["private_price"]),
      routePolyline: json["route_polyline"]?.toString(),
      statusId: _toInt(json["status_id"]),
      driver: json["driver"] != null
          ? BookingDriver.fromJson(Map<String, dynamic>.from(json["driver"]))
          : null,
    );
  }
}

class BookingDriver {
  final int? userId;
  final String? personalPhoto;
  final BookingPassenger? user;

  BookingDriver({
    this.userId,
    this.personalPhoto,
    this.user,
  });

  factory BookingDriver.fromJson(Map<String, dynamic> json) {
    return BookingDriver(
      userId: _toInt(json["user_id"]),
      personalPhoto: json["personal_photo"]?.toString(),
      user: json["user"] != null
          ? BookingPassenger.fromJson(Map<String, dynamic>.from(json["user"]))
          : null,
    );
  }
}

class BookingPickupPoint {
  final int? pickupPointId;
  final int? bookingId;
  final int? tripPointId;
  final int? governorateId;
  final String? pointName;
  final String? address;
  final double? latitude;
  final double? longitude;
  final String? meetingTime;
  final bool? isNew;
  final String? createdAt;
  final String? updatedAt;

  BookingPickupPoint({
    this.pickupPointId,
    this.bookingId,
    this.tripPointId,
    this.governorateId,
    this.pointName,
    this.address,
    this.latitude,
    this.longitude,
    this.meetingTime,
    this.isNew,
    this.createdAt,
    this.updatedAt,
  });

  factory BookingPickupPoint.fromJson(Map<String, dynamic> json) {
    return BookingPickupPoint(
      pickupPointId: _toInt(json["pickup_point_id"]),
      bookingId: _toInt(json["booking_id"]),
      tripPointId: _toInt(json["trip_point_id"]),
      governorateId: _toInt(json["governorate_id"]),
      pointName: json["point_name"]?.toString(),
      address: json["address"]?.toString(),
      latitude: _toDouble(json["latitude"]),
      longitude: _toDouble(json["longitude"]),
      meetingTime: json["meeting_time"]?.toString(),
      isNew: _toBool(json["is_new"]),
      createdAt: json["created_at"]?.toString(),
      updatedAt: json["updated_at"]?.toString(),
    );
  }
}

class BookingPayment {
  final int? paymentId;
  final int? bookingId;
  final int? walletId;
  final String? paymentMethod;
  final double? amount;
  final String? paymentStatus;
  final String? transactionReference;
  final String? failureReason;
  final String? paidAt;

  BookingPayment({
    this.paymentId,
    this.bookingId,
    this.walletId,
    this.paymentMethod,
    this.amount,
    this.paymentStatus,
    this.transactionReference,
    this.failureReason,
    this.paidAt,
  });

  factory BookingPayment.fromJson(Map<String, dynamic> json) {
    return BookingPayment(
      paymentId: _toInt(json["payment_id"]),
      bookingId: _toInt(json["booking_id"]),
      walletId: _toInt(json["wallet_id"]),
      paymentMethod: json["payment_method"]?.toString(),
      amount: _toDouble(json["amount"]),
      paymentStatus: json["payment_status"]?.toString(),
      transactionReference: json["transaction_reference"]?.toString(),
      failureReason: json["failure_reason"]?.toString(),
      paidAt: json["paid_at"]?.toString(),
    );
  }
}

class BookingPassenger {
  final int? userId;
  final String? fullName;
  final String? phone;
  final String? email;
  final double? rating;
  final String? profilePhoto;

  BookingPassenger({
    this.userId,
    this.fullName,
    this.phone,
    this.email,
    this.rating,
    this.profilePhoto,
  });

  factory BookingPassenger.fromJson(Map<String, dynamic> json) {
    return BookingPassenger(
      userId: _toInt(json["user_id"]),
      fullName: json["full_name"]?.toString(),
      phone: json["phone"]?.toString(),
      email: json["email"]?.toString(),
      rating: _toDouble(json["rating"]),
      profilePhoto: json["profile_photo"]?.toString(),
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
