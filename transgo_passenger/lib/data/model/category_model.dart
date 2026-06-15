class CategoriesModel {
  final bool? success;
  final String? message;
  final TripCategoriesData? data;
  final int? statusCode;
  final String? timestamp;

  CategoriesModel({
    this.success,
    this.message,
    this.data,
    this.statusCode,
    this.timestamp,
  });

  factory CategoriesModel.fromJson(Map<String, dynamic> json) {
    return CategoriesModel(
      success: json["success"],
      message: json["message"]?.toString(),
      data: json["data"] != null
          ? TripCategoriesData.fromJson(
              Map<String, dynamic>.from(json["data"]),
            )
          : null,
      statusCode: json["status_code"],
      timestamp: json["timestamp"]?.toString(),
    );
  }
}

class TripCategoriesData {
  final List<TripCategoryItemModel> items;
  final TripCategoriesMeta? meta;

  TripCategoriesData({
    required this.items,
    this.meta,
  });

  factory TripCategoriesData.fromJson(Map<String, dynamic> json) {
    return TripCategoriesData(
      items: json["items"] is List
          ? List<TripCategoryItemModel>.from(
              json["items"].map(
                (item) => TripCategoryItemModel.fromJson(
                  Map<String, dynamic>.from(item),
                ),
              ),
            )
          : [],
      meta: json["meta"] != null
          ? TripCategoriesMeta.fromJson(
              Map<String, dynamic>.from(json["meta"]),
            )
          : null,
    );
  }
}

class TripCategoryItemModel {
  final int? governorateId;
  final String? name;
  final String? image;
  final int? availableTripsCount;
  final String? tripsEndpoint;

  TripCategoryItemModel({
    this.governorateId,
    this.name,
    this.image,
    this.availableTripsCount,
    this.tripsEndpoint,
  });

  factory TripCategoryItemModel.fromJson(Map<String, dynamic> json) {
    return TripCategoryItemModel(
      governorateId: json["governorate_id"],
      name: json["name"]?.toString(),
      image: json["image"]?.toString(),
      availableTripsCount: json["available_trips_count"],
      tripsEndpoint: json["trips_endpoint"]?.toString(),
    );
  }
}

class TripCategoriesMeta {
  final int? total;
  final int? startGovernorateId;
  final String? startFilterLabel;
  final String? tripType;
  final String? departureDate;

  TripCategoriesMeta({
    this.total,
    this.startGovernorateId,
    this.startFilterLabel,
    this.tripType,
    this.departureDate,
  });

  factory TripCategoriesMeta.fromJson(Map<String, dynamic> json) {
    return TripCategoriesMeta(
      total: json["total"],
      startGovernorateId: json["start_governorate_id"],
      startFilterLabel: json["start_filter_label"]?.toString(),
      tripType: json["trip_type"]?.toString(),
      departureDate: json["departure_date"]?.toString(),
    );
  }
}