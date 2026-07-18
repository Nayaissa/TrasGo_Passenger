class DriverProfileModel {
  final bool success;
  final String message;
  final DriverProfileData? data;

  DriverProfileModel({
    required this.success,
    required this.message,
    this.data,
  });

  factory DriverProfileModel.fromJson(Map<String, dynamic> json) {
    return DriverProfileModel(
      success: json["success"] == true,
      message: json["message"]?.toString() ?? "",
      data: json["data"] is Map
          ? DriverProfileData.fromJson(
              Map<String, dynamic>.from(json["data"]),
            )
          : null,
    );
  }
}

class DriverProfileData {
  final DriverProfileInfo profile;
  final List<DriverReviewModel> reviews;

  DriverProfileData({
    required this.profile,
    required this.reviews,
  });

  factory DriverProfileData.fromJson(Map<String, dynamic> json) {
    final reviewsJson = json["reviews"];

    return DriverProfileData(
      profile: json["profile"] is Map
          ? DriverProfileInfo.fromJson(
              Map<String, dynamic>.from(json["profile"]),
            )
          : DriverProfileInfo.empty(),
      reviews: reviewsJson is List
          ? reviewsJson
              .map(
                (e) => DriverReviewModel.fromJson(
                  Map<String, dynamic>.from(e),
                ),
              )
              .toList()
          : [],
    );
  }
}

class DriverProfileInfo {
  final String name;
  final String photo;
  final String phoneNumber;
  final String email;
  final String carPlateNumber;
  final String carType;
  final String categoryName;
  final double pricePerKilometer;
  final List<String> carPhotos;
  final double overallRating;

  DriverProfileInfo({
    required this.name,
    required this.photo,
    required this.phoneNumber,
    required this.email,
    required this.carPlateNumber,
    required this.carType,
    required this.categoryName,
    required this.pricePerKilometer,
    required this.carPhotos,
    required this.overallRating,
  });

  factory DriverProfileInfo.fromJson(Map<String, dynamic> json) {
    final photos = json["car_photos"];
    final category = json["category_id"] ?? json["category"];
    final vehicle = json["vehicle"];

    return DriverProfileInfo(
      name: json["name"]?.toString() ?? "",
      photo: json["photo"]?.toString() ?? "",
      phoneNumber: json["phone_number"]?.toString() ?? "",
      email: json["email"]?.toString() ?? "",
      carPlateNumber: json["car_plate_number"]?.toString() ?? "",
      carType: json["car_type"]?.toString() ??
          json["vehicle_type"]?.toString() ??
          (vehicle is Map ? vehicle["type"]?.toString() : null) ??
          "",
      categoryName: category is Map
          ? category["name"]?.toString() ?? ""
          : json["category_name"]?.toString() ?? "",
      pricePerKilometer: _toDouble(
        json["price_per_kilometer"] ??
            json["price_per_km"] ??
            json["kilometer_price"],
      ),
      carPhotos: photos is List
          ? photos.map((e) => e.toString()).where((e) => e.isNotEmpty).toList()
          : [],
      overallRating: _toDouble(json["overall_rating"]),
    );
  }

  factory DriverProfileInfo.empty() {
    return DriverProfileInfo(
      name: "",
      photo: "",
      phoneNumber: "",
      email: "",
      carPlateNumber: "",
      carType: "",
      categoryName: "",
      pricePerKilometer: 0,
      carPhotos: [],
      overallRating: 0,
    );
  }

  String get ratingText {
    return overallRating.toStringAsFixed(
      overallRating.truncateToDouble() == overallRating ? 0 : 1,
    );
  }

  String get pricePerKilometerText {
    if (pricePerKilometer == 0) return "-";

    return pricePerKilometer.toStringAsFixed(
      pricePerKilometer.truncateToDouble() == pricePerKilometer ? 0 : 2,
    );
  }
}

class DriverReviewModel {
  final String passengerName;
  final String comment;
  final double rating;
  final String createdAt;

  DriverReviewModel({
    required this.passengerName,
    required this.comment,
    required this.rating,
    required this.createdAt,
  });

  factory DriverReviewModel.fromJson(Map<String, dynamic> json) {
    return DriverReviewModel(
      passengerName: json["passenger_name"]?.toString() ??
          json["name"]?.toString() ??
          "",
      comment: json["comment"]?.toString() ??
          json["body"]?.toString() ??
          "",
      rating: _toDouble(json["rating"]),
      createdAt: json["created_at"]?.toString() ?? "",
    );
  }

  String get dateText {
    if (createdAt.isEmpty) return "";

    try {
      final date = DateTime.parse(createdAt);
      final year = date.year.toString();
      final month = date.month.toString().padLeft(2, "0");
      final day = date.day.toString().padLeft(2, "0");

      return "$year-$month-$day";
    } catch (_) {
      return createdAt;
    }
  }
}

double _toDouble(dynamic value) {
  if (value == null) return 0;
  if (value is double) return value;
  if (value is int) return value.toDouble();
  return double.tryParse(value.toString()) ?? 0;
}
