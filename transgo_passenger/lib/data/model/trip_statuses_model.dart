class TripStatusesModel {
  final bool? success;
  final String? message;
  final TripStatusesData? data;
  final int? statusCode;
  final String? timestamp;

  TripStatusesModel({
    this.success,
    this.message,
    this.data,
    this.statusCode,
    this.timestamp,
  });

  factory TripStatusesModel.fromJson(Map<String, dynamic> json) {
    return TripStatusesModel(
      success: json["success"],
      message: json["message"]?.toString(),
      data: json["data"] != null
          ? TripStatusesData.fromJson(Map<String, dynamic>.from(json["data"]))
          : null,
      statusCode: _toInt(json["status_code"]),
      timestamp: json["timestamp"]?.toString(),
    );
  }
}

class TripStatusesData {
  final List<TripStatusItemModel> items;

  TripStatusesData({
    required this.items,
  });

  factory TripStatusesData.fromJson(Map<String, dynamic> json) {
    return TripStatusesData(
      items: json["items"] is List
          ? List<TripStatusItemModel>.from(
              json["items"].map(
                (item) => TripStatusItemModel.fromJson(
                  Map<String, dynamic>.from(item),
                ),
              ),
            )
          : [],
    );
  }
}

class TripStatusItemModel {
  final int? id;
  final String? key;
  final String? name;
  final String? description;
  final bool? isFinal;
  final int? displayOrder;
  final String? color;

  TripStatusItemModel({
    this.id,
    this.key,
    this.name,
    this.description,
    this.isFinal,
    this.displayOrder,
    this.color,
  });

  factory TripStatusItemModel.fromJson(Map<String, dynamic> json) {
    return TripStatusItemModel(
      id: _toInt(json["id"]),
      key: json["key"]?.toString(),
      name: json["name"]?.toString(),
      description: json["description"]?.toString(),
      isFinal: _toBool(json["is_final"]),
      displayOrder: _toInt(json["display_order"]),
      color: json["color"]?.toString(),
    );
  }
}

int? _toInt(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  return int.tryParse(value.toString());
}

bool? _toBool(dynamic value) {
  if (value == null) return null;
  if (value is bool) return value;

  final text = value.toString().toLowerCase();

  if (text == "true" || text == "1") return true;
  if (text == "false" || text == "0") return false;

  return null;
}