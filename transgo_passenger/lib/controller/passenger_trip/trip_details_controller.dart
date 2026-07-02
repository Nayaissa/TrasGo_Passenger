import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:transgo_passenger/core/class/diohelper.dart';
import 'package:transgo_passenger/core/class/statusrequest.dart';
import 'package:transgo_passenger/core/constant/routes.dart';
import 'package:transgo_passenger/data/model/booking_model.dart';
import 'package:transgo_passenger/data/model/trip_details_model.dart';

class TripDetailsController extends GetxController {
  StatusRequest? statusRequest;

  int tripId = 0;
  String detailsEndpoint = "";

  TripDetailsModel? tripDetailsModel;
  TripDetailsData? tripDetails;

  int totalSeats = 0;
  int seatsLeft = 0;
  bool isBooked = false;

  String tripType = "";
  String seatPrice = "";
  String currency = "S.P / ل.س";

  String vehicleName = "";
  String vehicleLicense = "";
  String vehicleImage = "";

  String driverName = "";
  String driverImage = "";
  double driverRating = 0;
  String driverReviews = "Reviews";

  String fromCity = "";
  String fromDetails = "";

  String toCity = "";
  String toDetails = "";

  String tripStatus = "";
  String departureTime = "";
  String expectedArrivalTime = "";
  String estimatedDistance = "";
  String estimatedDuration = "";
  String bookingAvailability = "";
  String mapImage = "";

  String bookingEndpoint = "";
  String trackingEndpoint = "";

  List<TripFeatureModel> features = [];
  List<PassengerUiModel> passengers = [];
  List<RoutePointUiModel> routePoints = [];
  List<LatLng> polylinePoints = [];
@override
void onInit() {
  super.onInit();

  print("============== TRIP DETAILS CONTROLLER INIT ==============");
  print("GET ARGUMENTS => ${Get.arguments}");

  _readArguments();

  print("TRIP ID => $tripId");
  print("DETAILS ENDPOINT => $detailsEndpoint");

  getTripDetails();
}
  void _readArguments() {
    final args = Get.arguments;

    if (args is Map) {
      tripId = _toInt(args["trip_id"]) ?? 0;
      detailsEndpoint = args["details_endpoint"]?.toString() ?? "";
    } else if (args != null) {
      tripId = _toInt(args) ?? 0;
    }
  }

 Future<void> getTripDetails() async {
  print("============== GET TRIP DETAILS CALLED ==============");

  statusRequest = StatusRequest.loading;
  update();

  try {
    final url = _buildTripDetailsUrl();

    print("TRIP DETAILS FINAL URL => $url");

    if (url.isEmpty) {
      print("TRIP DETAILS ERROR => URL IS EMPTY");
      print("سبب المشكلة: لم يصل trip_id أو details_endpoint إلى الصفحة");

      statusRequest = StatusRequest.failure;
      update();
      return;
    }

    print("TRIP DETAILS URL => $url");

      print("TRIP DETAILS URL => $url");

      final value = await DioHelper.getDataa(
        url: url,
      );

      print("TRIP DETAILS STATUS CODE => ${value?.statusCode}");
      print("TRIP DETAILS RESPONSE => ${value?.data}");

      if (value != null && value.statusCode == 200) {
        final responseBody = value.data;

        if (responseBody is Map && responseBody["success"] == true) {
          tripDetailsModel = TripDetailsModel.fromJson(
            Map<String, dynamic>.from(responseBody),
          );

          tripDetails = tripDetailsModel?.data;

          _fillUiData();

          statusRequest = StatusRequest.success;
        } else {
          statusRequest = StatusRequest.failure;
        }
      } else if (value != null && value.statusCode == 401) {
        statusRequest = StatusRequest.serverfailure;

        Get.snackbar(
          "Error",
          "انتهت صلاحية تسجيل الدخول",
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        statusRequest = StatusRequest.serverfailure;
      }
    } catch (error, stackTrace) {
      print("TRIP DETAILS ERROR => $error");
      print("TRIP DETAILS STACKTRACE => $stackTrace");

      statusRequest = StatusRequest.serverfailure;
    }

    update();
  }

  String _buildTripDetailsUrl() {
    if (detailsEndpoint.trim().isNotEmpty) {
      return _normalizeEndpoint(detailsEndpoint);
    }

    if (tripId > 0) {
      return "v1/passenger/trips/$tripId";
    }

    return "";
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

  void _fillUiData() {
    final data = tripDetails;
    if (data == null) return;

    tripId = data.tripId ?? tripId;

    totalSeats = data.vehicle?.seatCapacity ?? 0;
    seatsLeft = data.availableSeats ?? 0;

    final type = data.type;
    if (type?.allowShared == true && type?.allowPrivate == true) {
      tripType = "Shared / Private";
    } else if (type?.allowShared == true) {
      tripType = "Shared Trip";
    } else if (type?.allowPrivate == true) {
      tripType = "Private Trip";
    } else {
      tripType = data.status?.name ?? "Trip";
    }

    final price = data.pricing?.displayPrice ??
        data.pricing?.sharedPrice ??
        data.pricing?.privatePrice;

    seatPrice = price == null ? "" : price.toString();

    vehicleName = data.vehicle?.model?.isNotEmpty == true
        ? data.vehicle!.model!
        : data.vehicle?.type ?? "Vehicle";

    vehicleLicense = data.vehicle?.plateNumber?.isNotEmpty == true
        ? "Plate: ${data.vehicle!.plateNumber}"
        : "Seat capacity: ${data.vehicle?.seatCapacity ?? 0}";

    vehicleImage = data.vehicle?.image ?? "";

    driverName = data.driver?.fullName ?? "";
    driverImage = data.driver?.image ?? "";
    driverRating = data.driver?.rating ?? 0;
    driverReviews = "Driver rating";

    fromCity = data.route?.from?.name ?? "";
    fromDetails =
        data.route?.from?.displayAddress ?? data.route?.from?.address ?? "";

    toCity = data.route?.to?.name ?? "";
    toDetails = data.route?.to?.displayAddress ?? data.route?.to?.address ?? "";

    tripStatus = data.status?.name ?? "";
    departureTime = _formatDateTime(data.schedule?.departureTime);
    expectedArrivalTime = _formatDateTime(data.schedule?.expectedArrivalTime);
    estimatedDistance = _formatDistance(data.route?.estimatedDistanceKm);
    estimatedDuration = _formatDuration(data.route?.estimatedDurationMinutes);
    bookingAvailability = _formatBookingAvailability(data.actions);

    bookingEndpoint = data.actions?.bookingEndpoint ?? "";
    trackingEndpoint = data.actions?.trackingEndpoint ?? "";

    features = _buildFeatures(data);
    passengers = _buildPassengers(data);
    routePoints = _buildRoutePoints(data);
    polylinePoints = _decodePolyline(data.route?.polyline ?? "");
  }

  List<TripFeatureModel> _buildFeatures(TripDetailsData data) {
    final list = <TripFeatureModel>[
      TripFeatureModel(
        icon: Icons.airline_seat_recline_normal,
        title: "${data.vehicle?.seatCapacity ?? 0} Seats",
      ),
    ];

    if (data.type?.allowShared == true) {
      list.add(
        TripFeatureModel(
          icon: Icons.groups_2_outlined,
          title: "Shared",
        ),
      );
    }

    if (data.type?.allowPrivate == true) {
      list.add(
        TripFeatureModel(
          icon: Icons.lock_outline,
          title: "Private",
        ),
      );
    }

    for (final item in data.vehicle?.amenities ?? []) {
      list.add(
        TripFeatureModel(
          icon: Icons.check_circle_outline,
          title: item,
        ),
      );
    }

    return list;
  }

  List<PassengerUiModel> _buildPassengers(TripDetailsData data) {
    return data.passengers.map((passenger) {
      return PassengerUiModel(
        name: passenger.fullName ?? "",
        image: passenger.image ?? "",
        rating: passenger.rating ?? 0,
      );
    }).toList();
  }

  List<RoutePointUiModel> _buildRoutePoints(TripDetailsData data) {
    final points = [...(data.route?.points ?? [])];

    points.sort((a, b) {
      return (a.sequenceOrder ?? 0).compareTo(b.sequenceOrder ?? 0);
    });

    if (points.isEmpty) {
      return [
        RoutePointUiModel(
          pointId: null,
          title: data.route?.from?.name ?? "",
          subtitle: data.route?.from?.displayAddress ??
              data.route?.from?.address ??
              "",
          type: "start",
          latitude: data.route?.from?.latitude,
          longitude: data.route?.from?.longitude,
        ),
        RoutePointUiModel(
          pointId: null,
          title: data.route?.to?.name ?? "",
          subtitle:
              data.route?.to?.displayAddress ?? data.route?.to?.address ?? "",
          type: "end",
          latitude: data.route?.to?.latitude,
          longitude: data.route?.to?.longitude,
        ),
      ];
    }

    return points.map((point) {
      final type = point.type ?? "";

      String title = "";

      if (type == "start") {
        title = data.route?.from?.name ?? "Start";
      } else if (type == "end") {
        title = data.route?.to?.name ?? "End";
      } else {
        title = "نقطة توقف";
      }

      return RoutePointUiModel(
        pointId: point.pointId,
        title: title,
        subtitle: point.displayAddress ?? point.note ?? point.address ?? "",
        type: type,
        latitude: point.latitude,
        longitude: point.longitude,
      );
    }).toList();
  }

  Set<Marker> get mapMarkers {
    final markers = <Marker>{};

    for (int i = 0; i < routePoints.length; i++) {
      final point = routePoints[i];

      if (point.latitude == null || point.longitude == null) {
        continue;
      }

      markers.add(
        Marker(
          markerId: MarkerId("${point.type}_$i"),
          position: LatLng(point.latitude!, point.longitude!),
          infoWindow: InfoWindow(
            title: point.title,
            snippet: point.subtitle,
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(
            point.type == "start"
                ? BitmapDescriptor.hueAzure
                : point.type == "end"
                    ? BitmapDescriptor.hueRed
                    : BitmapDescriptor.hueViolet,
          ),
        ),
      );
    }

    return markers;
  }

  LatLng get mapInitialPosition {
    if (routePoints.isNotEmpty &&
        routePoints.first.latitude != null &&
        routePoints.first.longitude != null) {
      return LatLng(
        routePoints.first.latitude!,
        routePoints.first.longitude!,
      );
    }

    return const LatLng(33.5138, 36.3481);
  }

  LatLngBounds? get mapBounds {
    final points = polylinePoints.isNotEmpty
        ? polylinePoints
        : routePoints
            .where((e) => e.latitude != null && e.longitude != null)
            .map((e) => LatLng(e.latitude!, e.longitude!))
            .toList();

    if (points.length < 2) {
      return null;
    }

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

  Future<void> bookTrip() async {
    print("BOOKING ENDPOINT => $bookingEndpoint");
    if (tripDetails == null) return;

    final result = await Get.toNamed(
      AppRoute.bookTrip,
      arguments: {
        "trip_id": tripId,
        "booking_endpoint": bookingEndpoint,
        "trip_details": tripDetails,
      },
    );

    if (result is BookingModel && result.success == true) {
      Get.snackbar(
        "Booking",
        result.message ?? "Your trip has been booked successfully",
        snackPosition: SnackPosition.BOTTOM,
      );

      await getTripDetails();
      _addBookedPickupPoint(result.data?.pickupPoint);
    }
  }

  void _addBookedPickupPoint(BookingPickupPoint? pickupPoint) {
    if (pickupPoint == null ||
        pickupPoint.latitude == null ||
        pickupPoint.longitude == null) {
      return;
    }

    final alreadyVisible = routePoints.any((point) {
      if (pickupPoint.pickupPointId != null &&
          point.pointId == pickupPoint.pickupPointId) {
        return true;
      }

      return point.latitude == pickupPoint.latitude &&
          point.longitude == pickupPoint.longitude;
    });

    if (alreadyVisible) return;

    final bookedPoint = RoutePointUiModel(
      pointId: pickupPoint.pickupPointId,
      title: pickupPoint.pointName?.isNotEmpty == true
          ? pickupPoint.pointName!
          : "Pickup point",
      subtitle: pickupPoint.address?.isNotEmpty == true
          ? pickupPoint.address!
          : "${pickupPoint.latitude!.toStringAsFixed(6)}, ${pickupPoint.longitude!.toStringAsFixed(6)}",
      type: "pickup",
      latitude: pickupPoint.latitude,
      longitude: pickupPoint.longitude,
    );

    final endIndex = routePoints.indexWhere((point) => point.type == "end");
    if (endIndex == -1) {
      routePoints.add(bookedPoint);
    } else {
      routePoints.insert(endIndex, bookedPoint);
    }

    update();
  }

  void viewDriverProfile() {
    final driver = tripDetails?.driver;

    Get.toNamed(
      AppRoute.driverProfile,
      arguments: {
        "driver_id": driver?.id,
        "full_name": driver?.fullName,
        "image": driver?.image,
        "phone": driver?.phone,
        "rating": driver?.rating,
        "profile_endpoint": driver?.profileEndpoint,
      },
    );
  }

  void viewReviews() {
    print("View reviews");
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

  String _formatDistance(double? value) {
    if (value == null) return "";

    return "${value.toStringAsFixed(value.truncateToDouble() == value ? 0 : 1)} km";
  }

  String _formatDuration(int? minutes) {
    if (minutes == null) return "";

    final hours = minutes ~/ 60;
    final remainingMinutes = minutes % 60;

    if (hours <= 0) {
      return "$remainingMinutes min";
    }

    if (remainingMinutes == 0) {
      return "$hours h";
    }

    return "$hours h $remainingMinutes min";
  }

  String _formatBookingAvailability(ActionsInfo? actions) {
    final canBookShared = actions?.canBookShared == true;
    final canBookPrivate = actions?.canBookPrivate == true;

    if (canBookShared && canBookPrivate) {
      return "Shared and private";
    }

    if (canBookShared) {
      return "Shared booking";
    }

    if (canBookPrivate) {
      return "Private booking";
    }

    return "Not available";
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
}

class TripFeatureModel {
  final IconData icon;
  final String title;

  TripFeatureModel({
    required this.icon,
    required this.title,
  });
}

class PassengerUiModel {
  final String name;
  final String image;
  final double rating;

  PassengerUiModel({
    required this.name,
    required this.image,
    required this.rating,
  });
}

class RoutePointUiModel {
  final int? pointId;
  final String title;
  final String subtitle;
  final String type;
  final double? latitude;
  final double? longitude;

  RoutePointUiModel({
    this.pointId,
    required this.title,
    required this.subtitle,
    required this.type,
    this.latitude,
    this.longitude,
  });
}
