class TripCategoryTripsModel {
  final bool? success;
  final String? message;
  final TripCategoryTripsData? data;
  final int? statusCode;
  final String? timestamp;

  TripCategoryTripsModel({
    this.success,
    this.message,
    this.data,
    this.statusCode,
    this.timestamp,
  });

  factory TripCategoryTripsModel.fromJson(Map<String, dynamic> json) {
    return TripCategoryTripsModel(
      success: json["success"],
      message: json["message"]?.toString(),
      data: json["data"] != null
          ? TripCategoryTripsData.fromJson(
              Map<String, dynamic>.from(json["data"]),
            )
          : null,
      statusCode: _toInt(json["status_code"]),
      timestamp: json["timestamp"]?.toString(),
    );
  }
}

class TripCategoryTripsData {
  final TripCategoryInfo? category;
  final List<CategoryTripItem> items;
  final TripCategoryTripsMeta? meta;

  TripCategoryTripsData({
    this.category,
    required this.items,
    this.meta,
  });

  factory TripCategoryTripsData.fromJson(Map<String, dynamic> json) {
    return TripCategoryTripsData(
      category: json["category"] != null
          ? TripCategoryInfo.fromJson(
              Map<String, dynamic>.from(json["category"]),
            )
          : null,
      items: json["items"] is List
          ? List<CategoryTripItem>.from(
              json["items"].map(
                (item) => CategoryTripItem.fromJson(
                  Map<String, dynamic>.from(item),
                ),
              ),
            )
          : [],
      meta: json["meta"] != null
          ? TripCategoryTripsMeta.fromJson(
              Map<String, dynamic>.from(json["meta"]),
            )
          : null,
    );
  }
}

class TripCategoryInfo {
  final int? governorateId;
  final String? name;
  final String? image;

  TripCategoryInfo({
    this.governorateId,
    this.name,
    this.image,
  });

  factory TripCategoryInfo.fromJson(Map<String, dynamic> json) {
    return TripCategoryInfo(
      governorateId: _toInt(json["governorate_id"]),
      name: json["name"]?.toString(),
      image: json["image"]?.toString(),
    );
  }
}

class CategoryTripItem {
  final int? tripId;
  final int? clusterId;
  final bool? isBookingVisible;
  final TripTypeInfo? type;
  final String? departureTime;
  final TripLocationInfo? from;
  final TripLocationInfo? to;
  final TripDriverInfo? driver;
  final TripVehicleInfo? vehicle;
  final TripPricingInfo? pricing;
  final int? availableSeats;
  final TripDistanceInfo? distance;
  final String? detailsEndpoint;
  final String? bookingEndpoint;

  CategoryTripItem({
    this.tripId,
    this.clusterId,
    this.isBookingVisible,
    this.type,
    this.departureTime,
    this.from,
    this.to,
    this.driver,
    this.vehicle,
    this.pricing,
    this.availableSeats,
    this.distance,
    this.detailsEndpoint,
    this.bookingEndpoint,
  });

  factory CategoryTripItem.fromJson(Map<String, dynamic> json) {
    return CategoryTripItem(
      tripId: _toInt(json["trip_id"]),
      clusterId: _toInt(json["cluster_id"]),
      isBookingVisible: _toBool(json["is_booking_visible"]),
      type: json["type"] != null
          ? TripTypeInfo.fromJson(Map<String, dynamic>.from(json["type"]))
          : null,
      departureTime: json["departure_time"]?.toString(),
      from: json["from"] != null
          ? TripLocationInfo.fromJson(Map<String, dynamic>.from(json["from"]))
          : null,
      to: json["to"] != null
          ? TripLocationInfo.fromJson(Map<String, dynamic>.from(json["to"]))
          : null,
      driver: json["driver"] != null
          ? TripDriverInfo.fromJson(Map<String, dynamic>.from(json["driver"]))
          : null,
      vehicle: json["vehicle"] != null
          ? TripVehicleInfo.fromJson(
              Map<String, dynamic>.from(json["vehicle"]),
            )
          : null,
      pricing: json["pricing"] != null
          ? TripPricingInfo.fromJson(
              Map<String, dynamic>.from(json["pricing"]),
            )
          : null,
      availableSeats: _toInt(json["available_seats"]),
      distance: json["distance"] != null
          ? TripDistanceInfo.fromJson(
              Map<String, dynamic>.from(json["distance"]),
            )
          : null,
      detailsEndpoint: json["details_endpoint"]?.toString(),
      bookingEndpoint: json["booking_endpoint"]?.toString(),
    );
  }

  String get priceText {
    if (pricing?.displayPrice == null) return "";
    return pricing!.displayPrice.toString();
  }

  String get currencyText => "S.P / ل.س";

  String get fromName => from?.name ?? "";

  String get fromDetails => from?.displayAddress ?? from?.address ?? "";

  String get toName => to?.name ?? "";

  String get toDetails => to?.displayAddress ?? to?.address ?? "";

  String get seatsText {
    if (availableSeats == null) return "";
    return "Seats $availableSeats 💺";
  }

  String get typeText => type?.requested ?? "";

  String get statusText {
    return isBookingVisible == true ? "Booking Available" : "Booking Closed";
  }

  String get ratingText => driver?.rating?.toString() ?? "0";

  String get driverName => driver?.fullName ?? "";

  String get driverImage => driver?.image ?? "";

  String get carType => vehicle?.type ?? "";

  String get vehicleImage => vehicle?.image ?? "";
}

class TripTypeInfo {
  final String? requested;
  final bool? allowShared;
  final bool? allowPrivate;

  TripTypeInfo({
    this.requested,
    this.allowShared,
    this.allowPrivate,
  });

  factory TripTypeInfo.fromJson(Map<String, dynamic> json) {
    return TripTypeInfo(
      requested: json["requested"]?.toString(),
      allowShared: _toBool(json["allow_shared"]),
      allowPrivate: _toBool(json["allow_private"]),
    );
  }
}

class TripLocationInfo {
  final int? governorateId;
  final String? name;
  final String? address;
  final String? displayAddress;

  TripLocationInfo({
    this.governorateId,
    this.name,
    this.address,
    this.displayAddress,
  });

  factory TripLocationInfo.fromJson(Map<String, dynamic> json) {
    return TripLocationInfo(
      governorateId: _toInt(json["governorate_id"]),
      name: json["name"]?.toString(),
      address: json["address"]?.toString(),
      displayAddress: json["display_address"]?.toString(),
    );
  }
}

class TripDriverInfo {
  final int? id;
  final String? fullName;
  final String? image;
  final double? rating;

  TripDriverInfo({
    this.id,
    this.fullName,
    this.image,
    this.rating,
  });

  factory TripDriverInfo.fromJson(Map<String, dynamic> json) {
    return TripDriverInfo(
      id: _toInt(json["id"]),
      fullName: json["full_name"]?.toString(),
      image: json["image"]?.toString(),
      rating: _toDouble(json["rating"]),
    );
  }
}

class TripVehicleInfo {
  final String? type;
  final String? image;

  TripVehicleInfo({
    this.type,
    this.image,
  });

  factory TripVehicleInfo.fromJson(Map<String, dynamic> json) {
    return TripVehicleInfo(
      type: json["type"]?.toString(),
      image: json["image"]?.toString(),
    );
  }
}

class TripPricingInfo {
  final double? sharedPrice;
  final double? privatePrice;
  final double? displayPrice;

  TripPricingInfo({
    this.sharedPrice,
    this.privatePrice,
    this.displayPrice,
  });

  factory TripPricingInfo.fromJson(Map<String, dynamic> json) {
    return TripPricingInfo(
      sharedPrice: _toDouble(json["shared_price"]),
      privatePrice: _toDouble(json["private_price"]),
      displayPrice: _toDouble(json["display_price"]),
    );
  }
}

class TripDistanceInfo {
  final double? pickupKm;
  final double? dropoffKm;
  final double? scoreKm;

  TripDistanceInfo({
    this.pickupKm,
    this.dropoffKm,
    this.scoreKm,
  });

  factory TripDistanceInfo.fromJson(Map<String, dynamic> json) {
    return TripDistanceInfo(
      pickupKm: _toDouble(json["pickup_km"]),
      dropoffKm: _toDouble(json["dropoff_km"]),
      scoreKm: _toDouble(json["score_km"]),
    );
  }
}

class TripCategoryTripsMeta {
  final int? total;
  final int? returned;
  final int? perPage;
  final int? startGovernorateId;
  final String? startFilterLabel;
  final String? tripType;
  final String? departureDate;
  final String? searchMode;

  TripCategoryTripsMeta({
    this.total,
    this.returned,
    this.perPage,
    this.startGovernorateId,
    this.startFilterLabel,
    this.tripType,
    this.departureDate,
    this.searchMode,
  });

  factory TripCategoryTripsMeta.fromJson(Map<String, dynamic> json) {
    return TripCategoryTripsMeta(
      total: _toInt(json["total"]),
      returned: _toInt(json["returned"]),
      perPage: _toInt(json["per_page"]),
      startGovernorateId: _toInt(json["start_governorate_id"]),
      startFilterLabel: json["start_filter_label"]?.toString(),
      tripType: json["trip_type"]?.toString(),
      departureDate: json["departure_date"]?.toString(),
      searchMode: json["search_mode"]?.toString(),
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