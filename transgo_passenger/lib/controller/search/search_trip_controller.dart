import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:transgo_passenger/controller/profile/passenger_profile_controller.dart';
import 'package:transgo_passenger/core/class/diohelper.dart';
import 'package:transgo_passenger/core/class/statusrequest.dart';
import 'package:transgo_passenger/core/constant/routes.dart';
import 'package:transgo_passenger/data/model/category_model.dart';
import 'package:transgo_passenger/data/model/trip_search_model.dart';

abstract class TripSearchController extends GetxController {
  void setTripType(String type);
  Future<void> getGovernorates();
  void selectStartGovernorate(TripCategoryItemModel governorate);
  void selectEndGovernorate(TripCategoryItemModel governorate);
  Future<void> pickTripDate(BuildContext context);
  Future<void> executeSearch({bool showLoading = true});
  void viewTripDetails(TripSearchItem trip);
  // void bookTrip(TripSearchItem trip);
}

class TripSearchControllerImp extends TripSearchController {
  StatusRequest statusRequest = StatusRequest.success;
  StatusRequest governoratesStatusRequest = StatusRequest.loading;

  TripSearchModel? tripSearchModel;
  List<TripSearchItem> results = [];
  List<TripCategoryItemModel> governorates = [];

  final TextEditingController departureController = TextEditingController();
  final TextEditingController destinationController = TextEditingController();
  final TextEditingController dateController = TextEditingController();

  String tripType = "SHARED";
  bool isSearchExecuted = false;
  bool isSearching = false;

  int? startGovernorateId;
  int? endGovernorateId;

  String get tripDate => dateController.text.trim();
  bool get isLoadingGovernorates =>
      governoratesStatusRequest == StatusRequest.loading;

  int get totalResults {
    final total = tripSearchModel?.total ?? 0;
    return total == 0 ? results.length : total;
  }

  @override
  void onInit() {
    super.onInit();
    getGovernorates();
  }

  @override
  void setTripType(String type) {
    tripType = type;
    update();
  }

  @override
  Future<void> getGovernorates() async {
    governoratesStatusRequest = StatusRequest.loading;
    update();

    try {
      final response = await DioHelper.getDataa(
        url: "v1/passenger/trip-categories",
      );

      if (response != null && response.statusCode == 200) {
        final body = response.data;

        if (body is Map && body["success"] == true) {
          final model = CategoriesModel.fromJson(
            Map<String, dynamic>.from(body),
          );
          final items = model.data?.items ?? [];

          governorates = items
              .where((item) =>
                  item.governorateId != null &&
                  (item.name ?? "").trim().isNotEmpty)
              .toList();
          governoratesStatusRequest = StatusRequest.success;
        } else {
          governoratesStatusRequest = StatusRequest.failure;
        }
      } else if (response != null && response.statusCode == 401) {
        governoratesStatusRequest = StatusRequest.serverfailure;
        App.logout();
      } else {
        governoratesStatusRequest = StatusRequest.serverfailure;
      }
    } catch (error) {
      governoratesStatusRequest = StatusRequest.serverfailure;
    }

    update();
  }

  @override
  void selectStartGovernorate(TripCategoryItemModel governorate) {
    startGovernorateId = governorate.governorateId;
    departureController.text = governorate.name ?? "";
    update();
  }

  @override
  void selectEndGovernorate(TripCategoryItemModel governorate) {
    endGovernorateId = governorate.governorateId;
    destinationController.text = governorate.name ?? "";
    update();
  }

  @override
  Future<void> pickTripDate(BuildContext context) async {
    final today = DateTime.now();
    final firstDate = DateTime(today.year, today.month, today.day);

    final pickedDate = await showDatePicker(
      context: context,
      initialDate: firstDate,
      firstDate: firstDate,
      lastDate: DateTime(today.year + 2),
    );

    if (pickedDate == null) return;

    dateController.text = _formatDate(pickedDate);
    update();
  }

  @override
  Future<void> executeSearch({bool showLoading = true}) async {
    // if (tripDate.isEmpty) {
    //   Get.snackbar(
    //     "Search",
    //     "Please choose trip date",
    //     snackPosition: SnackPosition.BOTTOM,
    //   );
    //   return;
    // }

    if (showLoading) {
      isSearching = true;
      statusRequest = StatusRequest.loading;
      update();
    }

    try {
      final response = await DioHelper.getDataa(
        url: "v1/passenger/trips/search",
        query: {
          "departure_date": tripDate,
          "trip_type": tripType.toLowerCase(),
          if (startGovernorateId != null)
            "start_governorate_id": startGovernorateId,
          if (endGovernorateId != null) "end_governorate_id": endGovernorateId,
        },
      );

      if (response != null && response.statusCode == 200) {
        final body = response.data;

        if (body is Map && body["success"] == true) {
          tripSearchModel = TripSearchModel.fromJson(
            Map<String, dynamic>.from(body),
          );

          results = tripSearchModel?.items ?? [];
          isSearchExecuted = true;
          statusRequest = StatusRequest.success;
        } else {
          statusRequest = StatusRequest.failure;
        }
      } else if (response != null && response.statusCode == 401) {
        statusRequest = StatusRequest.serverfailure;
        App.logout();

        Get.snackbar(
          "Error",
          "انتهت صلاحية تسجيل الدخول",
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        statusRequest = StatusRequest.serverfailure;
      }
    } catch (error) {
      statusRequest = StatusRequest.serverfailure;
    }

    isSearching = false;
    update();
  }

  @override
  void viewTripDetails(TripSearchItem trip) {
    Get.toNamed(
      AppRoute.tripDetails,
      arguments: {
        "trip_id": trip.tripId,
        "details_endpoint": trip.detailsEndpoint,
      },
    );
  }

  // @override
  // void bookTrip(TripSearchItem trip) {
  //   Get.toNamed(
  //     AppRoute.bookTrip,
  //     arguments: {
  //       "trip_id": trip.tripId,
  //       "details_endpoint": trip.detailsEndpoint,
  //       "booking_endpoint": trip.bookingEndpoint,
  //     },
  //   );
  // }

  @override
  void onClose() {
    departureController.dispose();
    destinationController.dispose();
    dateController.dispose();
    super.onClose();
  }

  String _formatDate(DateTime date) {
    final year = date.year.toString();
    final month = date.month.toString().padLeft(2, "0");
    final day = date.day.toString().padLeft(2, "0");

    return "$year-$month-$day";
  }
}
