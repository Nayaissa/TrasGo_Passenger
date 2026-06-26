import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:transgo_passenger/core/class/diohelper.dart';
import 'package:transgo_passenger/core/class/statusrequest.dart';
import 'package:transgo_passenger/core/constant/AppColor.dart';
import 'package:transgo_passenger/core/constant/routes.dart';
import 'package:transgo_passenger/core/services/phone_dialer_service.dart';
import 'package:transgo_passenger/data/model/passenger_trips_model.dart';
import 'package:transgo_passenger/data/model/trip_details_model.dart';
import 'package:transgo_passenger/data/model/trip_tracking_model.dart';

class TripTrackingController extends GetxController {
  StatusRequest? statusRequest;

  PassengerTripItemModel? passengerTrip;
  TripTrackingModel? trackingModel;
  TripTrackingData? trackingData;
  TripDetailsModel? tripDetailsModel;
  TripDetailsData? tripDetails;

  int tripId = 0;
  String trackingEndpoint = "";
  String detailsEndpoint = "";

  String statusName = "";
  String statusKey = "";
  String trackingMessage = "";
  String fromCity = "";
  String toCity = "";
  String departureTime = "";

  String driverName = "";
  String driverImage = "";
  String driverPhone = "";
  String driverRating = "0";
  String vehicleName = "";
  String bookingCode = "";

  TripTrackingLocation? driverLocation;
  TripTrackingLocation? pickupLocation;
  TripTrackingLocation? destinationLocation;
  List<TripTrackingLocation> locationHistory = [];

  List<TrackingRoutePoint> routePoints = [];
  List<LatLng> routePolylinePoints = [];
  LatLng? animatedDriverPosition;

  Timer? _trackingRefreshTimer;
  bool _isRefreshingTracking = false;

  bool get trackingAvailable => trackingData?.trackingAvailable == true;

  bool get trackingEnabledAfterStart {
    return trackingData?.trackingEnabledAfterStart == true;
  }

  bool get hasRouteCoordinates {
    return routePolylinePoints.isNotEmpty ||
        routePoints.any((point) => point.hasCoordinates);
  }

  bool get hasTrackingCoordinates {
    return driverLocation?.hasCoordinates == true ||
        pickupLocation?.hasCoordinates == true ||
        destinationLocation?.hasCoordinates == true ||
        locationHistory.isNotEmpty;
  }

  bool get hasMapCoordinates => hasRouteCoordinates || hasTrackingCoordinates;

  String get statusTitle {
    if (trackingAvailable) {
      return "Driver is on the way";
    }

    if (statusName.isNotEmpty) {
      return statusName;
    }

    return "Tracking unavailable";
  }

  String get statusSubtitle {
    if (trackingMessage.isNotEmpty) {
      return trackingMessage;
    }

    if (trackingAvailable) {
      return "Your driver is moving toward your pickup point.";
    }

    return "Tracking will appear when the trip starts.";
  }

  String get pickupTime {
    final pickup = passengerTrip?.pickup?.meetingTime;

    if (pickup != null && pickup.isNotEmpty) {
      return _formatTime(pickup);
    }

    return _formatTime(trackingData?.trip?.departureAt);
  }

  LatLng? get driverMapPosition {
    if (animatedDriverPosition != null) return animatedDriverPosition;

    final driver = driverLocation;
    if (driver?.hasCoordinates == true) {
      return LatLng(driver!.latitude!, driver.longitude!);
    }

    if (locationHistory.isNotEmpty) {
      final last = locationHistory.last;
      return LatLng(last.latitude!, last.longitude!);
    }

    return null;
  }

  @override
  void onInit() {
    super.onInit();

    _readArguments();
    getTripTracking();
  }

  @override
  void onClose() {
    _trackingRefreshTimer?.cancel();
    super.onClose();
  }

  void _readArguments() {
    final args = Get.arguments;

    if (args is Map) {
      if (args["trip"] is PassengerTripItemModel) {
        passengerTrip = args["trip"] as PassengerTripItemModel;
      }

      tripId = _toInt(args["trip_id"]) ?? passengerTrip?.tripId ?? 0;
      detailsEndpoint =
          args["details_endpoint"]?.toString() ??
          passengerTrip?.detailsEndpoint ??
          "";
      trackingEndpoint =
          args["tracking_endpoint"]?.toString() ??
          passengerTrip?.trackingEndpoint ??
          "";
    } else if (args != null) {
      tripId = _toInt(args) ?? 0;
    }

    _fillFallbackData();
  }

  Future<void> getTripTracking() async {
    statusRequest = StatusRequest.loading;
    update();

    final detailsLoaded = await _fetchTripDetails();
    final trackingLoaded = await _fetchTracking();

    _syncAnimatedDriverPosition();
    _startLiveRefresh();

    statusRequest =
        trackingLoaded || detailsLoaded
            ? StatusRequest.success
            : StatusRequest.failure;
    update();
  }

  Future<bool> _fetchTripDetails() async {
    final url = _buildTripDetailsUrl();

    if (url.isEmpty) return false;

    try {
      print("TRIP TRACKING DETAILS URL => $url");

      final value = await DioHelper.getDataa(url: url);

      print("TRIP TRACKING DETAILS STATUS CODE => ${value?.statusCode}");
      print("TRIP TRACKING DETAILS RESPONSE => ${value?.data}");

      if (value != null && value.statusCode == 200) {
        final responseBody = value.data;

        if (responseBody is Map && responseBody["success"] == true) {
          tripDetailsModel = TripDetailsModel.fromJson(
            Map<String, dynamic>.from(responseBody),
          );
          tripDetails = tripDetailsModel?.data;

          final details = tripDetails;
          if (details != null) {
            _fillDetailsUiData(details);
            return true;
          }
        }
      } else if (value != null && value.statusCode == 401) {
        _handleUnauthorized();
      }
    } catch (error, stackTrace) {
      print("TRIP TRACKING DETAILS ERROR => $error");
      print("TRIP TRACKING DETAILS STACKTRACE => $stackTrace");
    }

    return false;
  }

  Future<bool> _fetchTracking() async {
    if (_isRefreshingTracking) return false;

    final url = _buildTrackingUrl();

    if (url.isEmpty) {
      trackingMessage = "Tracking endpoint is missing.";
      return false;
    }

    _isRefreshingTracking = true;

    try {
      print("TRIP TRACKING FINAL URL => $url");

      final value = await DioHelper.getDataa(
        url: url,
        query: const {
          "history_limit": 50,
        },
      );

      print("TRIP TRACKING STATUS CODE => ${value?.statusCode}");
      print("TRIP TRACKING RESPONSE => ${value?.data}");

      if (value != null && value.statusCode == 200) {
        final responseBody = value.data;

        if (responseBody is Map && responseBody["success"] == true) {
          trackingModel = TripTrackingModel.fromJson(
            Map<String, dynamic>.from(responseBody),
          );
          trackingData = trackingModel?.data;
          _fillTrackingUiData();
          return true;
        }

        trackingMessage = _extractMessage(responseBody);
      } else if (value != null && value.statusCode == 401) {
        _handleUnauthorized();
      } else {
        trackingMessage = _extractMessage(value?.data);
      }
    } catch (error, stackTrace) {
      print("TRIP TRACKING ERROR => $error");
      print("TRIP TRACKING STACKTRACE => $stackTrace");
    } finally {
      _isRefreshingTracking = false;
    }

    return false;
  }

  Future<void> _refreshTrackingSilently() async {
    final trackingLoaded = await _fetchTracking();

    if (!trackingLoaded) return;

    _syncAnimatedDriverPosition();
    update();
  }

  String _buildTrackingUrl() {
    if (trackingEndpoint.trim().isNotEmpty) {
      return _normalizeEndpoint(trackingEndpoint);
    }

    if (tripId > 0) {
      return "v1/passenger/trips/$tripId/tracking";
    }

    return "";
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

  void _fillTrackingUiData() {
    final data = trackingData;
    if (data == null) return;

    tripId = data.tripId ?? tripId;
    trackingEndpoint = data.trackingEndpoint ?? trackingEndpoint;
    statusName = data.status?.name ?? "";
    statusKey = data.status?.key ?? "";
    trackingMessage = data.message ?? trackingModel?.message ?? "";
    fromCity = data.trip?.from ?? fromCity;
    toCity = data.trip?.to ?? toCity;
    departureTime = _formatDateTime(data.trip?.departureAt);
    driverLocation = data.driverLocation ?? driverLocation;
    pickupLocation = data.pickupLocation ?? pickupLocation;
    destinationLocation = data.destinationLocation ?? destinationLocation;
    locationHistory = data.history.isEmpty ? locationHistory : data.history;
  }

  void _fillDetailsUiData(TripDetailsData data) {
    tripId = data.tripId ?? tripId;
    trackingEndpoint = data.actions?.trackingEndpoint ?? trackingEndpoint;

    driverName = data.driver?.fullName ?? driverName;
    driverImage = data.driver?.image ?? driverImage;
    driverPhone = data.driver?.phone ?? driverPhone;
    driverRating = (data.driver?.rating ?? double.tryParse(driverRating) ?? 0)
        .toStringAsFixed(1);

    vehicleName =
        data.vehicle?.model?.isNotEmpty == true
            ? data.vehicle!.model!
            : data.vehicle?.type ?? vehicleName;

    fromCity = data.route?.from?.name ?? fromCity;
    toCity = data.route?.to?.name ?? toCity;
    departureTime = _formatDateTime(data.schedule?.departureTime) == ""
        ? departureTime
        : _formatDateTime(data.schedule?.departureTime);

    routePoints = _buildRoutePoints(data);
    routePolylinePoints = _decodePolyline(data.route?.polyline ?? "");

    _addPassengerPickupPoint();
  }

  void _fillFallbackData() {
    final trip = passengerTrip;
    if (trip == null) return;

    tripId = trip.tripId ?? tripId;
    fromCity = trip.fromName;
    toCity = trip.toName;
    departureTime = _formatDateTime(trip.departureTime);
    driverName = trip.driverName;
    driverImage = trip.driverImage;
    driverPhone = trip.driver?.phone ?? driverPhone;
    driverRating = trip.ratingText;
    vehicleName = trip.carType;
    bookingCode = trip.bookingCode;

    _setPassengerPickupLocation();
  }

  List<TrackingRoutePoint> _buildRoutePoints(TripDetailsData data) {
    final points = [...(data.route?.points ?? [])];

    points.sort((a, b) {
      return (a.sequenceOrder ?? 0).compareTo(b.sequenceOrder ?? 0);
    });

    if (points.isEmpty) {
      return [
        TrackingRoutePoint(
          title: data.route?.from?.name ?? "Start",
          subtitle:
              data.route?.from?.displayAddress ??
              data.route?.from?.address ??
              "",
          type: "start",
          latitude: data.route?.from?.latitude,
          longitude: data.route?.from?.longitude,
        ),
        TrackingRoutePoint(
          title: data.route?.to?.name ?? "End",
          subtitle:
              data.route?.to?.displayAddress ?? data.route?.to?.address ?? "",
          type: "end",
          latitude: data.route?.to?.latitude,
          longitude: data.route?.to?.longitude,
        ),
      ];
    }

    return points.map((point) {
      final type = point.type ?? "stop";

      String title = "Stop point";

      if (type == "start") {
        title = data.route?.from?.name ?? "Start";
      } else if (type == "end") {
        title = data.route?.to?.name ?? "End";
      }

      return TrackingRoutePoint(
        title: title,
        subtitle: point.displayAddress ?? point.note ?? point.address ?? "",
        type: type,
        latitude: point.latitude,
        longitude: point.longitude,
      );
    }).toList();
  }

  void _setPassengerPickupLocation() {
    final pickup = passengerTrip?.pickup;

    if (pickup?.latitude == null || pickup?.longitude == null) return;

    pickupLocation = TripTrackingLocation(
      latitude: pickup!.latitude,
      longitude: pickup.longitude,
      title:
          pickup.pointName?.isNotEmpty == true
              ? pickup.pointName
              : pickup.governorateName,
      address: pickup.displayAddress ?? pickup.address,
      recordedAt: pickup.meetingTime,
    );
  }

  void _addPassengerPickupPoint() {
    final pickup = pickupLocation;

    if (pickup?.hasCoordinates != true) return;
    final pickupData = pickup!;

    final alreadyExists = routePoints.any((point) {
      return point.latitude == pickupData.latitude &&
          point.longitude == pickupData.longitude;
    });

    if (alreadyExists) return;

    final point = TrackingRoutePoint(
      title: pickupData.title ?? "Pickup point",
      subtitle: pickupData.address ?? "",
      type: "pickup",
      latitude: pickupData.latitude,
      longitude: pickupData.longitude,
    );

    final endIndex = routePoints.indexWhere((item) => item.type == "end");

    if (endIndex == -1) {
      routePoints.add(point);
    } else {
      routePoints.insert(endIndex, point);
    }
  }

  void _syncAnimatedDriverPosition() {
    final driver = driverLocation;

    if (driver?.hasCoordinates == true) {
      animatedDriverPosition = LatLng(driver!.latitude!, driver.longitude!);
      return;
    }

    if (locationHistory.isNotEmpty) {
      final last = locationHistory.last;
      animatedDriverPosition = LatLng(last.latitude!, last.longitude!);
      return;
    }

    animatedDriverPosition = null;
  }

  void _startLiveRefresh() {
    _trackingRefreshTimer?.cancel();

    if (!trackingAvailable && !trackingEnabledAfterStart) return;

    _trackingRefreshTimer = Timer.periodic(
      const Duration(seconds: 15),
      (_) => _refreshTrackingSilently(),
    );
  }

  List<LatLng> get _routeCoordinatePoints {
    return routePoints
        .where((point) => point.hasCoordinates)
        .map((point) => LatLng(point.latitude!, point.longitude!))
        .toList();
  }

  Future<void> callDriver() async {
    if (driverPhone.trim().isEmpty) {
      Get.snackbar(
        "Call",
        "Driver phone number is not available yet.",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    final opened = await PhoneDialerService.openDialer(driverPhone);

    if (!opened) {
      Get.snackbar(
        "Call",
        "Could not open the phone dialer.",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void messageDriver() {
    Get.snackbar(
      "Message",
      "Driver chat is not available yet.",
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void shareTracking() {
    Get.snackbar(
      "Share Tracking",
      trackingAvailable
          ? "Tracking link is ready to share."
          : "Tracking is not available yet.",
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  Color get availabilityColor {
    if (trackingAvailable) return const Color(0xFF22E083);
    if (trackingEnabledAfterStart) return Colors.amber;
    return Colors.redAccent;
  }

  Set<Marker> get mapMarkers {
    final markers = <Marker>{};

    for (int i = 0; i < routePoints.length; i++) {
      final point = routePoints[i];

      if (!point.hasCoordinates) continue;

      markers.add(
        Marker(
          markerId: MarkerId("${point.type}_$i"),
          position: LatLng(point.latitude!, point.longitude!),
          infoWindow: InfoWindow(
            title: point.title,
            snippet: point.subtitle,
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(
            _markerHueFor(point.type),
          ),
        ),
      );
    }

    final pickup = pickupLocation;
    if (pickup?.hasCoordinates == true && !_hasRoutePointAt(pickup!)) {
      markers.add(
        Marker(
          markerId: const MarkerId("pickup"),
          position: LatLng(pickup.latitude!, pickup.longitude!),
          infoWindow: InfoWindow(
            title: pickup.title ?? "Pickup point",
            snippet: pickup.address,
          ),
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet),
        ),
      );
    }

    final destination = destinationLocation;
    if (destination?.hasCoordinates == true && !_hasRoutePointAt(destination!)) {
      markers.add(
        Marker(
          markerId: const MarkerId("destination"),
          position: LatLng(destination.latitude!, destination.longitude!),
          infoWindow: InfoWindow(
            title: destination.title ?? "Destination",
            snippet: destination.address,
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        ),
      );
    }

    final driver = driverMapPosition;
    if (driver != null) {
      markers.add(
        Marker(
          markerId: const MarkerId("driver"),
          position: driver,
          infoWindow: const InfoWindow(title: "Driver location"),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
        ),
      );
    }

    return markers;
  }

  bool _hasRoutePointAt(TripTrackingLocation location) {
    return routePoints.any((point) {
      return point.latitude == location.latitude &&
          point.longitude == location.longitude;
    });
  }

  double _markerHueFor(String type) {
    if (type == "start") return BitmapDescriptor.hueGreen;
    if (type == "end") return BitmapDescriptor.hueRed;
    if (type == "pickup") return BitmapDescriptor.hueViolet;
    return BitmapDescriptor.hueYellow;
  }

  List<LatLng> get mapPolylinePoints {
    if (routePolylinePoints.isNotEmpty) return routePolylinePoints;

    final route = _routeCoordinatePoints;
    if (route.length > 1) return route;

    final trackingTrail =
        locationHistory
            .where((item) => item.hasCoordinates)
            .map((item) => LatLng(item.latitude!, item.longitude!))
            .toList();

    if (trackingTrail.length > 1) return trackingTrail;

    return [];
  }

  LatLng get mapInitialPosition {
    final driver = driverMapPosition;
    if (driver != null) return driver;

    if (routePoints.isNotEmpty) {
      TrackingRoutePoint? point;

      for (final routePoint in routePoints) {
        if (routePoint.hasCoordinates) {
          point = routePoint;
          break;
        }
      }

      if (point != null) return LatLng(point.latitude!, point.longitude!);
    }

    final pickup = pickupLocation;
    if (pickup?.hasCoordinates == true) {
      return LatLng(pickup!.latitude!, pickup.longitude!);
    }

    if (locationHistory.isNotEmpty) {
      final first = locationHistory.first;
      return LatLng(first.latitude!, first.longitude!);
    }

    return const LatLng(33.5138, 36.2765);
  }

  LatLngBounds? get mapBounds {
    final points = <LatLng>[
      ...mapPolylinePoints,
      for (final marker in mapMarkers) marker.position,
    ];

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

  Color get mapPolylineColor {
    return trackingAvailable ? AppColor.fourthColor : AppColor.thirdColor;
  }

  void _handleUnauthorized() {
    Get.snackbar(
      "Error",
      "انتهت صلاحية تسجيل الدخول",
      snackPosition: SnackPosition.BOTTOM,
    );

    Get.offAllNamed(AppRoute.login);
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

  String _formatTime(String? value) {
    if (value == null || value.trim().isEmpty) return "";

    try {
      final date = DateTime.parse(value);
      final hour = date.hour > 12 ? date.hour - 12 : date.hour;
      final safeHour = hour == 0 ? 12 : hour;
      final minute = date.minute.toString().padLeft(2, "0");
      final period = date.hour >= 12 ? "PM" : "AM";

      return "$safeHour:$minute $period";
    } catch (_) {
      return value;
    }
  }

  String _extractMessage(dynamic responseBody) {
    if (responseBody is Map) {
      return responseBody["message"]?.toString() ?? "Failed to load tracking";
    }

    return "Failed to load tracking";
  }

  List<LatLng> _decodePolyline(String encoded) {
    if (encoded.isEmpty) return [];

    final points = <LatLng>[];

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

      final dLat = (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
      lat += dLat;

      shift = 0;
      result = 0;

      do {
        byte = encoded.codeUnitAt(index++) - 63;
        result |= (byte & 0x1f) << shift;
        shift += 5;
      } while (byte >= 0x20);

      final dLng = (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
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

class TrackingRoutePoint {
  final String title;
  final String subtitle;
  final String type;
  final double? latitude;
  final double? longitude;

  TrackingRoutePoint({
    required this.title,
    required this.subtitle,
    required this.type,
    this.latitude,
    this.longitude,
  });

  bool get hasCoordinates => latitude != null && longitude != null;
}
