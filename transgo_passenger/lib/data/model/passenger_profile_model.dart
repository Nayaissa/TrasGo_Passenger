class PassengerProfileModel {
  final bool success;
  final String message;
  final PassengerProfileData? data;

  PassengerProfileModel({
    required this.success,
    required this.message,
    this.data,
  });

  factory PassengerProfileModel.fromJson(Map<String, dynamic> json) {
    return PassengerProfileModel(
      success: json["success"] == true,
      message: json["message"]?.toString() ?? "",
      data: json["data"] is Map
          ? PassengerProfileData.fromJson(
              Map<String, dynamic>.from(json["data"]),
            )
          : null,
    );
  }
}

class PassengerProfileData {
  final String photo;
  final String name;
  final String email;
  final String phoneNumber;
  final int cancelledReservationsCount;
  final int completedReservationsCount;
  final double rating;

  PassengerProfileData({
    required this.photo,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.cancelledReservationsCount,
    required this.completedReservationsCount,
    required this.rating,
  });

  factory PassengerProfileData.fromJson(Map<String, dynamic> json) {
    return PassengerProfileData(
      photo: json["photo"]?.toString() ?? "",
      name: json["name"]?.toString() ?? "",
      email: json["email"]?.toString() ?? "",
      phoneNumber: json["phone_number"]?.toString() ?? "",
      cancelledReservationsCount: _toInt(json["cancelled_reservations_count"]),
      completedReservationsCount: _toInt(json["completed_reservations_count"]),
      rating: _toDouble(json["rating"]),
    );
  }

  String get ratingText {
    return rating.toStringAsFixed(rating.truncateToDouble() == rating ? 0 : 1);
  }
}

int _toInt(dynamic value) {
  if (value == null) return 0;
  if (value is int) return value;
  return int.tryParse(value.toString()) ?? 0;
}

double _toDouble(dynamic value) {
  if (value == null) return 0;
  if (value is double) return value;
  if (value is int) return value.toDouble();
  return double.tryParse(value.toString()) ?? 0;
}