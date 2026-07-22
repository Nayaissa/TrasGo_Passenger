import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:transgo_passenger/controller/profile/passenger_profile_controller.dart';
import 'package:transgo_passenger/core/class/diohelper.dart';
import 'package:transgo_passenger/core/class/statusrequest.dart';
import 'package:transgo_passenger/core/constant/AppColor.dart';
import 'package:transgo_passenger/core/constant/routes.dart';
import 'package:transgo_passenger/data/model/cancel_booking_model.dart';
import 'package:transgo_passenger/data/model/passenger_trips_model.dart';
import 'package:transgo_passenger/data/model/trip_statuses_model.dart';
import 'package:flutter/services.dart';

class MyTripsController extends GetxController {
  int selectedTab = 0;

  StatusRequest? statusRequest;

  List<TripStatusItemModel> tripStatuses = [];
  List<PassengerTripItemModel> allTrips = [];
  List<PassengerTripItemModel> visibleTrips = [];

  PassengerTripsModel? passengerTripsModel;
  bool isCancellingBooking = false;
  int? cancellingBookingId;

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
      final value = await DioHelper.getDataa(url: "v1/trip-statuses");

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

      final value = await DioHelper.getDataa(url: url);

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

        Get.snackbar(
          "Error",
          "انتهت صلاحية تسجيل الدخول، يرجى تسجيل الدخول مرة أخرى",
          snackPosition: SnackPosition.BOTTOM,
        );
        App.logout();
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

    Get.toNamed(
      AppRoute.tripTracking,
      arguments: {
        "trip": trip,
        "trip_id": trip.tripId,
        "details_endpoint": trip.detailsEndpoint,
        "tracking_endpoint": trip.trackingEndpoint,
      },
    );
  }

  Future<CancelBookingModel?> onCancelPressed(
    PassengerTripItemModel trip,
  ) async {
    final bookingId = trip.booking?.bookingId;

    print("CANCEL BOOKING ID => $bookingId");

    if (bookingId == null) {
      Get.snackbar(
        "Error",
        "Booking id is missing",
        snackPosition: SnackPosition.BOTTOM,
      );
      return null;
    }

    if (isCancellingBooking) return null;

    isCancellingBooking = true;
    cancellingBookingId = bookingId;
    update();

    try {
      final value = await DioHelper.postsData(
        url: "v1/passenger/bookings/$bookingId/cancel",
        data: {},
      );

      print("CANCEL BOOKING STATUS CODE => ${value?.statusCode}");
      print("CANCEL BOOKING RESPONSE => ${value?.data}");

      if (value != null && value.statusCode == 200) {
        final responseBody = value.data;

        if (responseBody is Map && responseBody["success"] == true) {
          final cancelModel = CancelBookingModel.fromJson(
            Map<String, dynamic>.from(responseBody),
          );

          await getMyTrips();
          return cancelModel;
        } else {
          Get.snackbar(
            "Warning",
            _extractMessage(responseBody),
            snackPosition: SnackPosition.BOTTOM,
          );
        }
      } else if (value != null && value.statusCode == 401) {
        await myServices.removeFromSharedPreferences('token');
        await myServices.setString('step', '1');

        Get.snackbar(
          "Error",
          "انتهت صلاحية تسجيل الدخول، يرجى تسجيل الدخول مرة أخرى",
          snackPosition: SnackPosition.BOTTOM,
        );

        Get.offAllNamed(AppRoute.login);
      } else {
        Get.snackbar(
          "Error",
          _extractMessage(value?.data),
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (error, stackTrace) {
      print("CANCEL BOOKING ERROR => $error");
      print("CANCEL BOOKING STACKTRACE => $stackTrace");

      Get.snackbar(
        "Error",
        "Server error, please try again",
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isCancellingBooking = false;
      cancellingBookingId = null;
      update();
    }

    return null;
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

  String _extractMessage(dynamic responseBody) {
    if (responseBody is Map) {
      final errors = responseBody["errors"];

      if (errors is Map) {
        for (final value in errors.values) {
          if (value is List && value.isNotEmpty) {
            return value.first.toString();
          }

          if (value != null) {
            return value.toString();
          }
        }
      }

      return responseBody["message"]?.toString() ?? "Failed to cancel booking";
    }

    return "Failed to cancel booking";
  }

  bool isSharingTrip = false;
  int? sharingTripId;

  Future<void> onSharePressed(PassengerTripItemModel trip) async {
    final tripId = trip.tripId;

    if (isSharingTrip) return;

    isSharingTrip = true;
    sharingTripId = tripId;
    update();

    // // إظهار مؤشر تحميل للمستخدم
    // Get.dialog(
    //   const Center(child: CircularProgressIndicator(color: AppColor.thirdColor)),
    //   barrierDismissible: false,
    // );

    try {
      final value = await DioHelper.postsData(
        url: "v1/passenger/trips/$tripId/tracking/share",
        data: {},
      );

      // إغلاق مؤشر التحميل
      if (Get.isDialogOpen ?? false) Get.back();

      if (value != null &&
          (value.statusCode == 200 || value.statusCode == 201)) {
        final responseBody = value.data;

        if (responseBody is Map && responseBody["success"] == true) {
          final String? shareUrl = responseBody["data"]?["share_url"];

          if (shareUrl != null && shareUrl.isNotEmpty) {
            _showShareDialog(shareUrl);
          } else {
            _showErrorSnackbar("لم يتم العثور على رابط المشاركة");
          }
        } else {
          _showErrorSnackbar(_extractMessage(responseBody));
        }
      } else if (value != null && value.statusCode == 401) {
        await myServices.removeFromSharedPreferences('token');
        await myServices.setString('step', '1');
        _showErrorSnackbar(
          "انتهت صلاحية تسجيل الدخول، يرجى تسجيل الدخول مرة أخرى",
        );
        Get.offAllNamed(AppRoute.login);
      } else {
        _showErrorSnackbar(_extractMessage(value?.data));
      }
    } catch (error, stackTrace) {
      if (Get.isDialogOpen ?? false) Get.back();
      print("SHARE TRIP ERROR => $error");
      print("SHARE TRIP STACKTRACE => $stackTrace");
      _showErrorSnackbar("حدث خطأ في السيرفر، يرجى المحاولة لاحقاً");
    } finally {
      isSharingTrip = false;
      sharingTripId = null;
      update();
    }
  }

  void _showShareDialog(String url) {
    Get.defaultDialog(
      title: "مشاركة الرحلة",
      titleStyle: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 18,
      ),
      backgroundColor: AppColor.primaryColor,
      radius: 20,
      contentPadding: const EdgeInsets.all(16),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            ": تم إنشاء رابط تتبع الرحلة بنجاح. يمكنك مشاركته مع عائلتك أو أصدقائك",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white70, fontSize: 13),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: AppColor.fifthColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white10),
            ),
            child: Text(
              url,
              style: const TextStyle(color: Colors.white, fontSize: 12),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
      cancel: OutlinedButton(
        onPressed: () => Get.back(),
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Colors.white24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: const Text("إغلاق", style: TextStyle(color: Colors.white)),
      ),
      confirm: ElevatedButton.icon(
        onPressed: () {
          Clipboard.setData(ClipboardData(text: url));
          Get.back();
          Get.snackbar(
            "نجاح",
            "تم نسخ الرابط إلى الحافظة بنجاح",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green.withOpacity(0.8),
            colorText: Colors.white,
          );
        },
        icon: const Icon(Icons.copy, size: 16, color: Colors.white),
        label: const Text("نسخ الرابط", style: TextStyle(color: Colors.white)),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColor.thirdColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  void _showErrorSnackbar(String message) {
    Get.snackbar(
      "تنبيه",
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.redAccent.withOpacity(0.8),
      colorText: Colors.white,
    );
  }
}
