import 'package:get/get.dart';
import 'package:transgo_passenger/core/class/diohelper.dart';
import 'package:transgo_passenger/core/class/statusrequest.dart';
import 'package:transgo_passenger/core/constant/routes.dart';
import 'package:transgo_passenger/data/model/category_model.dart';
import 'package:transgo_passenger/data/model/trip_category_trips_model.dart';

class TripsController extends GetxController {
  StatusRequest? tripsStatusRequest;
  StatusRequest? governoratesStatusRequest;

  int? governorateId;

  String bannerTitle = "";
  String bannerSubtitle = "";
  String bannerTripCount = "trips 0";
  String bannerDate = "";
  String bannerImage = "";

  bool showFilters = false;

  String? selectedStartPoint;
  String? selectedDepartureDate;
  String? selectedTripType;

  List<String> startPoints = [];
  List<String> departureDateOptions = [];

  final List<String> tripTypes = ["shared", "private"];

  Map<String, int> startPointNameToId = {};

  TripCategoryTripsModel? tripCategoryTripsModel;
  List<CategoryTripItem> availableTrips = [];

  @override
  void onInit() {
    super.onInit();

    _initDates();

    final args = Get.arguments;

    governorateId = _toInt(args?["governorate_id"]);
    bannerTitle = args?["name"]?.toString() ?? "";
    bannerImage = args?["image"]?.toString() ?? "";

    final count = args?["available_trips_count"] ?? 0;
    bannerTripCount = "trips $count";

    bannerDate = _formatDate(DateTime.now());
    bannerSubtitle = "رحلات متاحة إلى $bannerTitle";

    getGovernoratesForFilter();
    getTrips();
  }

  void _initDates() {
    departureDateOptions = List.generate(14, (index) {
      return _formatDate(DateTime.now().add(Duration(days: index)));
    });
  }

  String _formatDate(DateTime date) {
    final year = date.year.toString();
    final month = date.month.toString().padLeft(2, "0");
    final day = date.day.toString().padLeft(2, "0");

    return "$year-$month-$day";
  }

  void toggleFilters() {
    showFilters = !showFilters;
    update();
  }

  void changeStartPoint(String? value) {
    selectedStartPoint = value;
    update();
  }

  void changeDepartureDate(String? value) {
    selectedDepartureDate = value;
    update();
  }

  void changeTripType(String? value) {
    selectedTripType = value;
    update();
  }

  Future<void> getGovernoratesForFilter() async {
    governoratesStatusRequest = StatusRequest.loading;
    update();

    try {
      final value = await DioHelper.getDataa(
        url: "v1/passenger/trip-categories",
      );

      if (value != null && value.statusCode == 200) {
        final responseBody = value.data;

        if (responseBody is Map && responseBody["success"] == true) {
          final model = CategoriesModel.fromJson(
            Map<String, dynamic>.from(responseBody),
          );

          final governorates = model.data?.items ?? [];

          startPoints = [];
          startPointNameToId = {};

          for (final item in governorates) {
            final name = item.name ?? "";
            final id = item.governorateId;

            if (name.isNotEmpty && id != null) {
              startPoints.add(name);
              startPointNameToId[name] = id;
            }
          }

          governoratesStatusRequest = StatusRequest.success;
        } else {
          governoratesStatusRequest = StatusRequest.failure;
        }
      } else {
        governoratesStatusRequest = StatusRequest.serverfailure;
      }
    } catch (error, stackTrace) {
      print("FILTER GOVERNORATES ERROR => $error");
      print("FILTER GOVERNORATES STACKTRACE => $stackTrace");

      governoratesStatusRequest = StatusRequest.serverfailure;
    }

    update();
  }

  Future<void> getTrips() async {
    if (governorateId == null) {
      tripsStatusRequest = StatusRequest.failure;
      update();

      Get.snackbar(
        "Error",
        "لم يتم تحديد المحافظة",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    tripsStatusRequest = StatusRequest.loading;
    update();

    try {
      final query = _buildTripsQuery();

      print("TRIPS URL => v1/passenger/trip-categories/$governorateId/trips");
      print("TRIPS QUERY => $query");

      final value = await DioHelper.getDataa(
        url: "v1/passenger/trip-categories/$governorateId/trips",
        query: query,
      );

      print("TRIPS STATUS CODE => ${value?.statusCode}");
      print("TRIPS RESPONSE => ${value?.data}");

      if (value != null && value.statusCode == 200) {
        final responseBody = value.data;

        if (responseBody is Map && responseBody["success"] == true) {
          tripCategoryTripsModel = TripCategoryTripsModel.fromJson(
            Map<String, dynamic>.from(responseBody),
          );

          availableTrips = tripCategoryTripsModel?.data?.items ?? [];

          final category = tripCategoryTripsModel?.data?.category;
          if (category != null) {
            bannerTitle = category.name ?? bannerTitle;
            bannerImage = category.image ?? bannerImage;
          }

          final meta = tripCategoryTripsModel?.data?.meta;
          if (meta != null) {
            bannerTripCount = "trips ${meta.total ?? availableTrips.length}";
            bannerDate = meta.departureDate ?? bannerDate;
          } else {
            bannerTripCount = "trips ${availableTrips.length}";
          }

          bannerSubtitle = "رحلات متاحة إلى $bannerTitle";

          tripsStatusRequest = StatusRequest.success;
        } else {
          tripsStatusRequest = StatusRequest.failure;

          Get.snackbar(
            "Warning",
            responseBody is Map
                ? responseBody["message"]?.toString() ?? "Failed to load trips"
                : "Failed to load trips",
            snackPosition: SnackPosition.BOTTOM,
          );
        }
      } else if (value != null && value.statusCode == 401) {
        tripsStatusRequest = StatusRequest.serverfailure;
        await myServices.removeFromSharedPreferences('token');
        await myServices.setString('step', '1');
        Get.snackbar(
          "Error",
          "انتهت صلاحية تسجيل الدخول، يرجى تسجيل الدخول مرة أخرى",
          snackPosition: SnackPosition.BOTTOM,
        );
        Get.offAllNamed(AppRoute.login);
      } else {
        tripsStatusRequest = StatusRequest.serverfailure;

        Get.snackbar(
          "Error",
          "Failed to load trips",
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (error, stackTrace) {
      print("TRIPS ERROR => $error");
      print("TRIPS STACKTRACE => $stackTrace");

      tripsStatusRequest = StatusRequest.serverfailure;

      Get.snackbar(
        "Error",
        "حدث خطأ أثناء تحميل الرحلات",
        snackPosition: SnackPosition.BOTTOM,
      );
    }

    update();
  }

  Map<String, dynamic> _buildTripsQuery() {
    final Map<String, dynamic> query = {};

    if (selectedStartPoint != null && selectedStartPoint!.trim().isNotEmpty) {
      final id = startPointNameToId[selectedStartPoint];

      if (id != null) {
        query["start_governorate_id"] = id;
      }
    }

    if (selectedTripType != null && selectedTripType!.trim().isNotEmpty) {
      query["trip_type"] = selectedTripType!.trim();
    }

    if (selectedDepartureDate != null &&
        selectedDepartureDate!.trim().isNotEmpty) {
      query["departure_date"] = selectedDepartureDate!.trim();
    }

    return query;
  }

  Future<void> applyFilters() async {
    await getTrips();
  }

  Future<void> clearFilters() async {
    selectedStartPoint = null;
    selectedDepartureDate = null;
    selectedTripType = null;

    await getTrips();
  }

  Future<void> refreshTrips() async {
    await getTrips();
  }

  String get selectedStartGovernorateName {
    if (selectedStartPoint == null || selectedStartPoint!.isEmpty) {
      return "كل المحافظات";
    }

    return selectedStartPoint!;
  }

  void bookNow(int index) {
    final trip = availableTrips[index];

    print("BOOK TRIP ID => ${trip.tripId}");
    print("BOOKING ENDPOINT => ${trip.bookingEndpoint}");
  }

 void viewDetails(int index) {
  final trip = availableTrips[index];

  print("========== OPEN TRIP DETAILS ==========");
  print("INDEX => $index");
  print("TRIP ID FROM CARD => ${trip.tripId}");
  print("DETAILS ENDPOINT FROM CARD => ${trip.detailsEndpoint}");

  Get.toNamed(
    AppRoute.tripDetails,
    arguments: {
      "trip_id": trip.tripId,
      "details_endpoint": trip.detailsEndpoint,
    },
  );
}

int? _toInt(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  return int.tryParse(value.toString());
}
}

