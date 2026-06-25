import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:transgo_passenger/core/class/diohelper.dart';
import 'package:transgo_passenger/core/class/statusrequest.dart';
import 'package:transgo_passenger/core/constant/routes.dart';
import 'package:transgo_passenger/data/model/booking_model.dart';
import 'package:transgo_passenger/data/model/trip_details_model.dart';

abstract class BookTripController extends GetxController {
  void incrementSeats();
  void decrementSeats();
  void togglePrivateTrip(bool value);
  void changePaymentMethod(String method);
  void selectExistingPoint(BookingPickupSelection point);
  void selectNewPoint(LatLng position);
  Future<void> confirmBooking();
}

class BookTripControllerImp extends BookTripController {
  StatusRequest statusRequest = StatusRequest.success;

  final TextEditingController newPointNoteController = TextEditingController();

  int tripId = 0;
  String bookingEndpoint = "";
  TripDetailsData? tripDetails;
  BookingModel? bookingModel;

  int selectedSeats = 1;
  bool isPrivateTrip = false;
  bool isConfirming = false;
  String selectedPaymentMethod = "cash";
  BookingPickupSelection? selectedPickupPoint;

  List<BookingPickupSelection> pickupPoints = [];
  List<LatLng> polylinePoints = [];

  String get from {
    return tripDetails?.route?.from?.name ?? "";
  }

  String get to {
    return tripDetails?.route?.to?.name ?? "";
  }

  String get time {
    return _formatDateTime(tripDetails?.schedule?.departureTime);
  }

  String get driver {
    return tripDetails?.driver?.fullName ?? "";
  }

  double get pricePerSeat {
    if (isPrivateTrip) {
      return tripDetails?.pricing?.privatePrice ??
          tripDetails?.pricing?.displayPrice ??
          0;
    }

    return tripDetails?.pricing?.sharedPrice ??
        tripDetails?.pricing?.displayPrice ??
        0;
  }

  int get maxAvailableSeats {
    return tripDetails?.availableSeats ?? 1;
  }

  String get pickupPointTitle {
    final point = selectedPickupPoint;
    if (point == null) return "Select pickup point";

    if (point.isNew) {
      return point.note.isEmpty ? "New pickup point" : point.note;
    }

    return point.title.isEmpty ? "Route point" : point.title;
  }

  double get totalPrice {
    return selectedSeats * pricePerSeat;
  }

  bool get canConfirm {
    return !isConfirming && selectedSeats > 0 && selectedPickupPoint != null;
  }

  bool get canBookPrivate {
    return tripDetails?.type?.allowPrivate == true;
  }

  bool get canBookShared {
    return tripDetails?.type?.allowShared == true;
  }

  @override
  void onInit() {
    super.onInit();
    _readArguments();
    _fillPickupPoints();
    _selectInitialBookingType();
  }

  void _readArguments() {
    final args = Get.arguments;

    if (args is Map) {
      tripId = _toInt(args["trip_id"]) ?? 0;
      bookingEndpoint = args["booking_endpoint"]?.toString() ?? "";

      final details = args["trip_details"];
      if (details is TripDetailsData) {
        tripDetails = details;
        tripId = details.tripId ?? tripId;
      }
    }

    if (tripId == 0 && tripDetails?.tripId != null) {
      tripId = tripDetails!.tripId!;
    }

    polylinePoints = _decodePolyline(tripDetails?.route?.polyline ?? "");
  }

  void _fillPickupPoints() {
    final route = tripDetails?.route;
    final points = [...(route?.points ?? <RoutePointInfo>[])];

    points.sort((a, b) {
      return (a.sequenceOrder ?? 0).compareTo(b.sequenceOrder ?? 0);
    });

    pickupPoints = points
        .where((point) => point.latitude != null && point.longitude != null)
        .map((point) {
      return BookingPickupSelection(
        tripPointId: point.pointId,
        title: _pointTitle(point),
        subtitle: point.displayAddress ?? point.note ?? point.address ?? "",
        type: point.type ?? "stop",
        latitude: point.latitude!,
        longitude: point.longitude!,
        isNew: false,
      );
    }).toList();

    if (pickupPoints.isEmpty) {
      final fromPoint = route?.from;
      final toPoint = route?.to;

      if (fromPoint?.latitude != null && fromPoint?.longitude != null) {
        pickupPoints.add(
          BookingPickupSelection(
            title: fromPoint?.name ?? "Start",
            subtitle: fromPoint?.displayAddress ?? fromPoint?.address ?? "",
            type: "start",
            latitude: fromPoint!.latitude!,
            longitude: fromPoint.longitude!,
            isNew: false,
          ),
        );
      }

      if (toPoint?.latitude != null && toPoint?.longitude != null) {
        pickupPoints.add(
          BookingPickupSelection(
            title: toPoint?.name ?? "Destination",
            subtitle: toPoint?.displayAddress ?? toPoint?.address ?? "",
            type: "end",
            latitude: toPoint!.latitude!,
            longitude: toPoint.longitude!,
            isNew: false,
          ),
        );
      }
    }

    if (pickupPoints.isNotEmpty) {
      selectedPickupPoint = pickupPoints.first;
    }
  }

  void _selectInitialBookingType() {
    if (canBookShared) {
      isPrivateTrip = false;
      selectedSeats = 1;
      return;
    }

    if (canBookPrivate) {
      isPrivateTrip = true;
      selectedSeats = maxAvailableSeats;
    }
  }

  String _pointTitle(RoutePointInfo point) {
    final type = point.type ?? "";

    if (type == "start") return from.isEmpty ? "Start" : from;
    if (type == "end") return to.isEmpty ? "Destination" : to;

    return point.note?.isNotEmpty == true ? point.note! : "Stop point";
  }

  @override
  void incrementSeats() {
    if (isPrivateTrip) return;

    if (selectedSeats < maxAvailableSeats) {
      selectedSeats++;
      update();
    }
  }

  @override
  void decrementSeats() {
    if (isPrivateTrip) return;

    if (selectedSeats > 1) {
      selectedSeats--;
      update();
    }
  }

  @override
  void togglePrivateTrip(bool value) {
    if (value && !canBookPrivate) return;
    if (!value && !canBookShared) return;

    isPrivateTrip = value;
    selectedSeats = isPrivateTrip ? maxAvailableSeats : 1;
    update();
  }

  @override
  void changePaymentMethod(String method) {
    selectedPaymentMethod = method;
    update();
  }

  @override
  void selectExistingPoint(BookingPickupSelection point) {
    selectedPickupPoint = point;
    update();
  }

  @override
  void selectNewPoint(LatLng position) {
    selectedPickupPoint = BookingPickupSelection(
      title: "New pickup point",
      subtitle:
          "${position.latitude.toStringAsFixed(6)}, ${position.longitude.toStringAsFixed(6)}",
      type: "new point",
      latitude: position.latitude,
      longitude: position.longitude,
      isNew: true,
      note: newPointNoteController.text.trim(),
    );
    update();
  }

  void updateNewPointNote(String value) {
    final point = selectedPickupPoint;

    if (point == null || !point.isNew) return;

    selectedPickupPoint = point.copyWith(note: value.trim());
    update();
  }

  @override
  Future<void> confirmBooking() async {
    if (!canConfirm) {
      Get.snackbar(
        "Warning",
        "Please select a pickup point",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    isConfirming = true;
    update();

    try {
      final value = await DioHelper.postsData(
        url: _buildBookingUrl(),
        data: _buildBookingBody(),
      );

      print("BOOKING STATUS CODE => ${value?.statusCode}");
      print("BOOKING RESPONSE => ${value?.data}");

      if (value != null && _isSuccessfulStatus(value.statusCode)) {
        final responseBody = value.data;

        if (responseBody is Map && _isSuccessValue(responseBody["success"])) {
          bookingModel = BookingModel.fromJson(
            Map<String, dynamic>.from(responseBody),
          );

          statusRequest = StatusRequest.success;

          Get.back(result: bookingModel);
        } else {
          statusRequest = StatusRequest.success;
          Get.snackbar(
            "Warning",
            _extractBookingErrorMessage(responseBody),
            snackPosition: SnackPosition.BOTTOM,
          );
        }
      } else if (value != null && value.statusCode == 401) {
        statusRequest = StatusRequest.serverfailure;
        await myServices.removeFromSharedPreferences("token");
        await myServices.setString("step", "1");

        Get.snackbar(
          "Error",
          "Session expired, please login again",
          snackPosition: SnackPosition.BOTTOM,
        );

        Get.offAllNamed(AppRoute.login);
      } else {
        statusRequest = StatusRequest.success;
        Get.snackbar(
          "Error",
          _extractBookingErrorMessage(value?.data),
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (error, stackTrace) {
      print("BOOKING ERROR => $error");
      print("BOOKING STACKTRACE => $stackTrace");

      statusRequest = StatusRequest.serverfailure;
      Get.snackbar(
        "Error",
        "Server error, please try again",
        snackPosition: SnackPosition.BOTTOM,
      );
    }

    isConfirming = false;
    update();
  }

  String _buildBookingUrl() {
    if (bookingEndpoint.trim().isNotEmpty) {
      return _normalizeEndpoint(bookingEndpoint);
    }

    return "v1/passenger/bookings";
  }

  Map<String, dynamic> _buildBookingBody() {
    final point = selectedPickupPoint!;

    final body = <String, dynamic>{
      "trip_id": tripId,
      "booking_type": isPrivateTrip ? "private" : "shared",
      "payment_method": selectedPaymentMethod,
      "pickup_point": point.toRequestJson(),
    };

    if (!isPrivateTrip) {
      body["seats_reserved"] = selectedSeats;
    }

    print("BOOKING BODY => $body");
    return body;
  }

  String _normalizeEndpoint(String endpoint) {
    String url = endpoint.trim();

    if (url.startsWith("/api/")) {
      url = url.replaceFirst("/api/", "");
    }

    if (url.startsWith("api/")) {
      url = url.replaceFirst("api/", "");
    }

    if (url.startsWith("/")) {
      url = url.substring(1);
    }

    return url;
  }

  bool _isSuccessfulStatus(int? statusCode) {
    return statusCode != null && statusCode >= 200 && statusCode < 300;
  }

  bool _isSuccessValue(dynamic value) {
    if (value is bool) return value;
    if (value == null) return false;

    final text = value.toString().toLowerCase();
    return text == "true" || text == "1";
  }

  String _extractBookingErrorMessage(dynamic responseBody) {
    if (responseBody is Map) {
      final errors = responseBody["errors"];

      if (errors is Map) {
        final pickupPointErrors = errors["pickup_point"];

        if (pickupPointErrors is List && pickupPointErrors.isNotEmpty) {
          return pickupPointErrors.first.toString();
        }

        if (pickupPointErrors != null) {
          return pickupPointErrors.toString();
        }

        for (final value in errors.values) {
          if (value is List && value.isNotEmpty) {
            return value.first.toString();
          }

          if (value != null) {
            return value.toString();
          }
        }
      }

      return responseBody["message"]?.toString() ?? "Booking failed";
    }

    return "Booking failed";
  }

  Set<Marker> get mapMarkers {
    final markers = <Marker>{};

    for (int i = 0; i < pickupPoints.length; i++) {
      final point = pickupPoints[i];

      markers.add(
        Marker(
          markerId: MarkerId("pickup_${point.tripPointId ?? i}"),
          position: point.position,
          infoWindow: InfoWindow(
            title: point.title,
            snippet: point.subtitle,
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(_markerHue(point.type)),
          onTap: () => selectExistingPoint(point),
        ),
      );
    }

    final selected = selectedPickupPoint;
    if (selected != null && selected.isNew) {
      markers.add(
        Marker(
          markerId: const MarkerId("selected_new_pickup"),
          position: selected.position,
          infoWindow: InfoWindow(
            title: selected.title,
            snippet: selected.subtitle,
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueGreen,
          ),
        ),
      );
    }

    return markers;
  }

  double _markerHue(String type) {
    if (type == "start") return BitmapDescriptor.hueAzure;
    if (type == "end") return BitmapDescriptor.hueRed;
    return BitmapDescriptor.hueViolet;
  }

  LatLng get mapInitialPosition {
    if (pickupPoints.isNotEmpty) {
      return pickupPoints.first.position;
    }

    return const LatLng(33.5138, 36.3481);
  }

  LatLngBounds? get mapBounds {
    final points = polylinePoints.isNotEmpty
        ? polylinePoints
        : pickupPoints.map((e) => e.position).toList();

    if (points.length < 2) return null;

    double minLat = points.first.latitude;
    double maxLat = points.first.latitude;
    double minLng = points.first.longitude;
    double maxLng = points.first.longitude;

    for (final point in points) {
      if (point.latitude < minLat) minLat = point.latitude;
      if (point.latitude > maxLat) maxLat = point.latitude;
      if (point.longitude < minLng) minLng = point.longitude;
      if (point.longitude > maxLng) maxLng = point.longitude;
    }

    return LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );
  }

  String _formatDateTime(String? value) {
    if (value == null || value.isEmpty) return "";

    try {
      final date = DateTime.parse(value);

      final year = date.year.toString();
      final month = date.month.toString().padLeft(2, "0");
      final day = date.day.toString().padLeft(2, "0");
      final hour = date.hour.toString().padLeft(2, "0");
      final minute = date.minute.toString().padLeft(2, "0");

      return "$year-$month-$day  $hour:$minute";
    } catch (_) {
      return value;
    }
  }

  List<LatLng> _decodePolyline(String encoded) {
    if (encoded.isEmpty) return [];

    final List<LatLng> points = [];

    int index = 0;
    int lat = 0;
    int lng = 0;

    while (index < encoded.length) {
      int shift = 0;
      int result = 0;
      int byte;

      do {
        byte = encoded.codeUnitAt(index++) - 63;
        result |= (byte & 0x1f) << shift;
        shift += 5;
      } while (byte >= 0x20);

      final int dLat = (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
      lat += dLat;

      shift = 0;
      result = 0;

      do {
        byte = encoded.codeUnitAt(index++) - 63;
        result |= (byte & 0x1f) << shift;
        shift += 5;
      } while (byte >= 0x20);

      final int dLng = (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
      lng += dLng;

      points.add(
        LatLng(
          lat / 100000.0,
          lng / 100000.0,
        ),
      );
    }

    return points;
  }

  int? _toInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    return int.tryParse(value.toString());
  }

  @override
  void onClose() {
    newPointNoteController.dispose();
    super.onClose();
  }
}

class BookingPickupSelection {
  final int? tripPointId;
  final String title;
  final String subtitle;
  final String type;
  final double latitude;
  final double longitude;
  final bool isNew;
  final String note;

  BookingPickupSelection({
    this.tripPointId,
    required this.title,
    required this.subtitle,
    required this.type,
    required this.latitude,
    required this.longitude,
    required this.isNew,
    this.note = "",
  });

  LatLng get position => LatLng(latitude, longitude);

  Map<String, dynamic> toRequestJson() {
    if (!isNew && tripPointId != null) {
      return {
        "trip_point_id": tripPointId,
      };
    }

    return {
      "point_type": "new point",
      "latitude": latitude,
      "longitude": longitude,
      "note": note.isNotEmpty ? note : title,
    };
  }

  BookingPickupSelection copyWith({
    String? note,
  }) {
    return BookingPickupSelection(
      tripPointId: tripPointId,
      title: title,
      subtitle: subtitle,
      type: type,
      latitude: latitude,
      longitude: longitude,
      isNew: isNew,
      note: note ?? this.note,
    );
  }
}
