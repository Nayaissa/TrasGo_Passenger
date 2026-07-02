class TripSearchModel {
  final List<TripSearchItem> items;
  final int total;

  TripSearchModel({
    required this.items,
    required this.total,
  });

  factory TripSearchModel.fromJson(Map<String, dynamic> json) {
    final data = json["data"];
    final itemsJson = data is Map ? data["items"] : [];
    final metaJson = data is Map ? data["meta"] : null;

    return TripSearchModel(
      items: itemsJson is List
          ? itemsJson
              .map(
                (item) => TripSearchItem.fromJson(
                  Map<String, dynamic>.from(item),
                ),
              )
              .toList()
          : [],
      total: metaJson is Map ? _toInt(metaJson["total"]) : 0,
    );
  }
}

class TripSearchItem {
  final int tripId;
  final String tripType;
  final String fromName;
  final String toName;
  final String departureTime;
  final String driverName;
  final double driverRating;
  final double price;
  final int availableSeats;
  final double distanceKm;
  final String detailsEndpoint;
  final String bookingEndpoint;

  TripSearchItem({
    required this.tripId,
    required this.tripType,
    required this.fromName,
    required this.toName,
    required this.departureTime,
    required this.driverName,
    required this.driverRating,
    required this.price,
    required this.availableSeats,
    required this.distanceKm,
    required this.detailsEndpoint,
    required this.bookingEndpoint,
  });

  factory TripSearchItem.fromJson(Map<String, dynamic> json) {
    final type = _asMap(json["type"]);
    final from = _asMap(json["from"]);
    final to = _asMap(json["to"]);
    final driver = _asMap(json["driver"]);
    final pricing = _asMap(json["pricing"]);
    final distance = _asMap(json["distance"]);

    return TripSearchItem(
      tripId: _toInt(json["trip_id"]),
      tripType: _tripTypeText(type),
      fromName: from["name"]?.toString() ?? "",
      toName: to["name"]?.toString() ?? "",
      departureTime: json["departure_time"]?.toString() ?? "",
      driverName: driver["full_name"]?.toString() ?? "",
      driverRating: _toDouble(driver["rating"]),
      price: _toDouble(
        pricing["display_price"] ??
            pricing["shared_price"] ??
            pricing["private_price"],
      ),
      availableSeats: _toInt(json["available_seats"]),
      distanceKm: _toDouble(distance["score_km"]),
      detailsEndpoint: json["details_endpoint"]?.toString() ?? "",
      bookingEndpoint: json["booking_endpoint"]?.toString() ?? "",
    );
  }

  String get priceText {
    return price.toStringAsFixed(
      price.truncateToDouble() == price ? 0 : 2,
    );
  }

  String get distanceText {
    if (distanceKm <= 0) return "-";
    return "${distanceKm.toStringAsFixed(1)} km";
  }

  String get departureText {
    if (departureTime.isEmpty) return "";

    try {
      final date = DateTime.parse(departureTime);

      final year = date.year.toString();
      final month = date.month.toString().padLeft(2, "0");
      final day = date.day.toString().padLeft(2, "0");
      final hour = date.hour.toString().padLeft(2, "0");
      final minute = date.minute.toString().padLeft(2, "0");

      return "$year-$month-$day  $hour:$minute";
    } catch (_) {
      return departureTime;
    }
  }
}

String _tripTypeText(Map<String, dynamic> type) {
  final requested = type["requested"]?.toString() ?? "";

  if (requested.isNotEmpty) {
    return requested.toUpperCase();
  }

  if (type["allow_shared"] == true && type["allow_private"] == true) {
    return "SHARED / PRIVATE";
  }

  if (type["allow_shared"] == true) return "SHARED";
  if (type["allow_private"] == true) return "PRIVATE";

  return "TRIP";
}

Map<String, dynamic> _asMap(dynamic value) {
  if (value is Map) {
    return Map<String, dynamic>.from(value);
  }

  return {};
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