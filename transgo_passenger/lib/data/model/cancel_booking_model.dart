class CancelBookingModel {
  final bool? success;
  final String? message;
  final CancelBookingData? data;
  final int? statusCode;
  final String? timestamp;

  CancelBookingModel({
    this.success,
    this.message,
    this.data,
    this.statusCode,
    this.timestamp,
  });

  factory CancelBookingModel.fromJson(Map<String, dynamic> json) {
    return CancelBookingModel(
      success: _toBool(json["success"]),
      message: json["message"]?.toString(),
      data: json["data"] != null
          ? CancelBookingData.fromJson(Map<String, dynamic>.from(json["data"]))
          : null,
      statusCode: _toInt(json["status_code"]),
      timestamp: json["timestamp"]?.toString(),
    );
  }
}

class CancelBookingData {
  final int? bookingId;
  final String? bookingCode;
  final CancelBookingStatus? status;
  final CancelPenalty? penalty;
  final dynamic restriction;
  final CancelTrip? trip;

  CancelBookingData({
    this.bookingId,
    this.bookingCode,
    this.status,
    this.penalty,
    this.restriction,
    this.trip,
  });

  factory CancelBookingData.fromJson(Map<String, dynamic> json) {
    return CancelBookingData(
      bookingId: _toInt(json["booking_id"]),
      bookingCode: json["booking_code"]?.toString(),
      status: json["status"] != null
          ? CancelBookingStatus.fromJson(
              Map<String, dynamic>.from(json["status"]),
            )
          : null,
      penalty: json["penalty"] != null
          ? CancelPenalty.fromJson(Map<String, dynamic>.from(json["penalty"]))
          : null,
      restriction: json["restriction"],
      trip: json["trip"] != null
          ? CancelTrip.fromJson(Map<String, dynamic>.from(json["trip"]))
          : null,
    );
  }
}

class CancelBookingStatus {
  final int? id;
  final String? key;
  final String? name;

  CancelBookingStatus({
    this.id,
    this.key,
    this.name,
  });

  factory CancelBookingStatus.fromJson(Map<String, dynamic> json) {
    return CancelBookingStatus(
      id: _toInt(json["id"]),
      key: json["key"]?.toString(),
      name: json["name"]?.toString(),
    );
  }
}

class CancelPenalty {
  final bool? gracePeriodApplied;
  final double? hoursBeforeDeparture;
  final double? percentage;
  final double? amount;
  final double? walletRefundAmount;
  final double? ratingPenalty;

  CancelPenalty({
    this.gracePeriodApplied,
    this.hoursBeforeDeparture,
    this.percentage,
    this.amount,
    this.walletRefundAmount,
    this.ratingPenalty,
  });

  factory CancelPenalty.fromJson(Map<String, dynamic> json) {
    return CancelPenalty(
      gracePeriodApplied: _toBool(json["grace_period_applied"]),
      hoursBeforeDeparture: _toDouble(json["hours_before_departure"]),
      percentage: _toDouble(json["percentage"]),
      amount: _toDouble(json["amount"]),
      walletRefundAmount: _toDouble(json["wallet_refund_amount"]),
      ratingPenalty: _toDouble(json["rating_penalty"]),
    );
  }
}

class CancelTrip {
  final int? tripId;
  final int? availableSeats;

  CancelTrip({
    this.tripId,
    this.availableSeats,
  });

  factory CancelTrip.fromJson(Map<String, dynamic> json) {
    return CancelTrip(
      tripId: _toInt(json["trip_id"]),
      availableSeats: _toInt(json["available_seats"]),
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
