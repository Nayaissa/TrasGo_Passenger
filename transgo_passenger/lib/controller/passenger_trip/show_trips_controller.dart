import 'package:get/get.dart';
import 'package:transgo_passenger/core/class/diohelper.dart';
import 'package:transgo_passenger/core/class/statusrequest.dart';
import 'package:transgo_passenger/core/constant/routes.dart';
import 'package:transgo_passenger/data/model/passenger_trips_model.dart';
import 'package:transgo_passenger/data/model/trip_statuses_model.dart';

class MyTripsController extends GetxController {
  int selectedTab = 0;

  StatusRequest? statusRequest;

  List<TripStatusItemModel> tripStatuses = [];
  List<PassengerTripItemModel> allTrips = [];
  List<PassengerTripItemModel> visibleTrips = [];

  PassengerTripsModel? passengerTripsModel;

  @override
  void onInit() {
    super.onInit();

    getTripStatuses();
    getMyTrips();
  }

  int get totalTrips => allTrips.length;

  int get activeTrips {
    return allTrips.where((trip) {
      return trip.statusKey == "active" || trip.statusKey == "current";
    }).length;
  }

  int get pendingTrips {
    return allTrips.where((trip) {
      return trip.statusKey == "pending";
    }).length;
  }

  int get completedTrips {
    return allTrips.where((trip) {
      return trip.statusKey == "completed";
    }).length;
  }

  int get cancelledTrips {
    return allTrips.where((trip) {
      return trip.statusKey == "canceled" || trip.statusKey == "cancelled";
    }).length;
  }

  List<PassengerTripItemModel> get filteredTrips => visibleTrips;

  Future<void> getTripStatuses() async {
    try {
      final value = await DioHelper.getDataa(
        url: "v1/trip-statuses",
      );

      print("TRIP STATUSES STATUS CODE => ${value?.statusCode}");
      print("TRIP STATUSES RESPONSE => ${value?.data}");

      if (value != null && value.statusCode == 200) {
        final responseBody = value.data;

        if (responseBody is Map && responseBody["success"] == true) {
          final model = TripStatusesModel.fromJson(
            Map<String, dynamic>.from(responseBody),
          );

          tripStatuses = model.data?.items ?? [];

          tripStatuses.sort((a, b) {
            return (a.displayOrder ?? 0).compareTo(b.displayOrder ?? 0);
          });
        }
      }
    } catch (error) {
      print("TRIP STATUSES ERROR => $error");
    }

    update();
  }

  Future<void> getMyTrips() async {
    final selectedStatus = _selectedStatusKey;

    statusRequest = StatusRequest.loading;
    update();

    try {
      final url = _buildTripsUrl(selectedStatus);

      print("MY TRIPS URL => $url");

      final value = await DioHelper.getDataa(
        url: url,
      );

      print("MY TRIPS STATUS CODE => ${value?.statusCode}");
      print("MY TRIPS RESPONSE => ${value?.data}");

      if (value != null && value.statusCode == 200) {
        final responseBody = value.data;

        if (responseBody is Map && responseBody["success"] == true) {
          passengerTripsModel = PassengerTripsModel.fromJson(
            Map<String, dynamic>.from(responseBody),
          );

          final trips = passengerTripsModel?.data?.items ?? [];

          if (selectedStatus == "all") {
            allTrips = trips;
            visibleTrips = trips;
          } else {
            visibleTrips = trips;
          }

          statusRequest = StatusRequest.success;
        } else {
          statusRequest = StatusRequest.failure;
        }
      } else if (value != null && value.statusCode == 401) {
        statusRequest = StatusRequest.serverfailure;
        await myServices.removeFromSharedPreferences('token');
        await myServices.setString('step','1');
        Get.snackbar(
          "Error",
          "انتهت صلاحية تسجيل الدخول، يرجى تسجيل الدخول مرة أخرى",
          snackPosition: SnackPosition.BOTTOM,
        );
          Get.offAllNamed(AppRoute.login);

      } else {
        statusRequest = StatusRequest.serverfailure;
      }
    } catch (error, stackTrace) {
      print("MY TRIPS ERROR => $error");
      print("MY TRIPS STACKTRACE => $stackTrace");

      statusRequest = StatusRequest.serverfailure;
    }

    update();
  }

  String get _selectedStatusKey {
    if (tripStatuses.isEmpty) {
      return selectedTab == 0 ? "all" : "";
    }

    return tripStatuses[selectedTab].key ?? "all";
  }

  String _buildTripsUrl(String statusKey) {
    if (statusKey == "all" || statusKey.isEmpty) {
      return "v1/passenger/trips";
    }

    final routeKey = _convertStatusKeyToRouteKey(statusKey);

    return "v1/passenger/trips/$routeKey";
  }

  String _convertStatusKeyToRouteKey(String key) {
    // حسب Postman عندك الحالة active تقابل current في الراوت
    if (key == "active") {
      return "current";
    }

    return key;
  }

  Future<void> changeTab(int index) async {
    selectedTab = index;
    update();

    await getMyTrips();
  }

  Future<void> refreshTrips() async {
    await getMyTrips();
  }

  void onTrackingPressed(PassengerTripItemModel trip) {
    print("TRACKING TRIP ID => ${trip.tripId}");
    print("TRACKING ENDPOINT => ${trip.trackingEndpoint}");
  }

  void onCancelPressed(PassengerTripItemModel trip) {
    print("CANCEL BOOKING ID => ${trip.booking?.bookingId}");
  }

  void onRatePressed(PassengerTripItemModel trip) {
    print("RATE TRIP ID => ${trip.tripId}");
    print("RATING ENDPOINT => ${trip.ratingEndpoint}");
  }

  void onViewDetails(PassengerTripItemModel trip) {
    print("DETAILS TRIP ID => ${trip.tripId}");
    print("DETAILS ENDPOINT => ${trip.detailsEndpoint}");

    Get.toNamed(
      AppRoute.tripDetails,
      arguments: {
        "trip_id": trip.tripId,
        "details_endpoint": trip.detailsEndpoint,
      },
    );
  }
}
