// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class HomeViewController extends GetxController {
//   String fromLocation = "Current Location";
//   String toLocation = "";
//   String selectedDate = "Today";
//   String selectedTripType = "Shared";

//   final List<Map<String, dynamic>> categories = [
//     {
//       "name": "Damascus",
//       "trips": "24 TRIPS",
//       "icon": Icons.location_city,
//     },
//     {
//       "name": "Aleppo",
//       "trips": "18 TRIPS",
//       "icon": Icons.architecture,
//     },
//     {
//       "name": "Latakia",
//       "trips": "9 TRIPS",
//       "icon": Icons.beach_access,
//     },
//   ];

//   final List<Map<String, dynamic>> popularTrips = [
//     {
//       "from": "Damascus",
//       "to": "Aleppo",
//       "time": "08:30 AM",
//       "seats": "4 Seats left",
//       "price": "\$12.50",
//       "rating": "4.9",
//       "isPrivate": false,
//       "image": "assets/bus.png",
//     },
//     {
//       "from": "Homs",
//       "to": "Latakia",
//       "time": "02:15 PM",
//       "seats": "Private Trip",
//       "price": "\$85.00",
//       "rating": "4.7",
//       "isPrivate": true,
//       "image": "assets/car.png",
//     },
//   ];

//   String totalBalance = "\$42.50";

//   void searchTrips() {
//     print("Searching from $fromLocation to $toLocation...");
//   }

//   void topUpWallet() {
//     print("Top Up Pressed");
//   }
// }
import 'package:get/get.dart';
import 'package:transgo_passenger/controller/profile/passenger_profile_controller.dart';
import 'package:transgo_passenger/core/class/diohelper.dart';
import 'package:transgo_passenger/core/class/statusrequest.dart';
import 'package:transgo_passenger/core/constant/routes.dart';
import 'package:transgo_passenger/data/model/category_model.dart';

abstract class HomeViewController extends GetxController {
  Future<void> getTripCategories();
  Future<void> refreshTripCategories();
  void searchTrips();
  void openCategoryTrips(TripCategoryItemModel category);
  goToNotification();
  goToSearch();
}

class HomeViewControllerImp extends HomeViewController {
  String fromLocation = "Current Location";
  String toLocation = "";
  String selectedDate = "Today";
  String selectedTripType = "Shared";

  StatusRequest? categoriesStatusRequest;

  CategoriesModel? categoriesModel;
  List<TripCategoryItemModel> categories = [];

  final List<Map<String, dynamic>> popularTrips = [
    {
      "from": "Damascus",
      "to": "Aleppo",
      "time": "08:30 AM",
      "seats": "4 Seats left",
      "price": "\$12.50",
      "rating": "4.9",
      "isPrivate": false,
      "image": "assets/bus.png",
    },
    {
      "from": "Homs",
      "to": "Latakia",
      "time": "02:15 PM",
      "seats": "Private Trip",
      "price": "\$85.00",
      "rating": "4.7",
      "isPrivate": true,
      "image": "assets/car.png",
    },
  ];

  String totalBalance = "\$42.50";

  @override
  void onInit() {
    super.onInit();
    getTripCategories();
  }

  @override
  Future<void> getTripCategories() async {
    categoriesStatusRequest = StatusRequest.loading;
    update();

    try {
      final value = await DioHelper.getDataa(
        url: "v1/passenger/trip-categories",
      );

      print("CATEGORIES STATUS CODE => ${value?.statusCode}");
      print("CATEGORIES RESPONSE => ${value?.data}");

      if (value != null && value.statusCode == 200) {
        final responseBody = value.data;

        if (responseBody is Map && responseBody["success"] == true) {
          categoriesModel = CategoriesModel.fromJson(
            Map<String, dynamic>.from(responseBody),
          );

          categories = categoriesModel?.data?.items ?? [];

          categoriesStatusRequest = StatusRequest.success;
        } else {
          categoriesStatusRequest = StatusRequest.failure;

          Get.snackbar(
            "Warning",
            responseBody is Map
                ? responseBody["message"]?.toString() ??
                    "Failed to load categories"
                : "Failed to load categories",
            snackPosition: SnackPosition.BOTTOM,
          );
        }
      } else if (value != null && value.statusCode == 401) {
        categoriesStatusRequest = StatusRequest.serverfailure;

        Get.snackbar(
          "Error",
          "انتهت صلاحية تسجيل الدخول، يرجى تسجيل الدخول مرة أخرى",
          snackPosition: SnackPosition.BOTTOM,
        );
        App.logout();
      } else {
        categoriesStatusRequest = StatusRequest.serverfailure;

        Get.snackbar(
          "Error",
          "Failed to load categories",
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (error, stackTrace) {
      print("CATEGORIES ERROR => $error");
      print("CATEGORIES STACKTRACE => $stackTrace");

      categoriesStatusRequest = StatusRequest.serverfailure;

      Get.snackbar(
        "Error",
        "حدث خطأ أثناء تحميل المحافظات",
        snackPosition: SnackPosition.BOTTOM,
      );
    }

    update();
  }

  @override
  Future<void> refreshTripCategories() async {
    await getTripCategories();
  }

  // String getCategoryImageUrl(String? image) {
  //   if (image == null || image.isEmpty) {
  //     return "";
  //   }

  //   if (image.startsWith("http")) {
  //     return image;
  //   }

  //   // غيّر هذا الرابط حسب رابط الباك عندك
  //   const String imageBaseUrl = "";

  //   final fixedImage = image.startsWith("/") ? image.substring(1) : image;

  //   return "$imageBaseUrl/$fixedImage";
  // }

  @override
  void openCategoryTrips(TripCategoryItemModel category) {
    print("GOVERNORATE ID => ${category.governorateId}");
    print("CATEGORY NAME => ${category.name}");
    print("TRIPS ENDPOINT => ${category.tripsEndpoint}");

    // لاحقًا نربطها بصفحة رحلات المحافظة
    Get.toNamed(
      AppRoute.categoryTrips,
      arguments: {
        "governorate_id": category.governorateId,
        "name": category.name ?? "",
        "image": category.image ?? "",
        "available_trips_count": category.availableTripsCount ?? 0,
        "trips_endpoint": category.tripsEndpoint ?? "",
      },
    );
    // );
  }

  @override
  void searchTrips() {
    print("Searching from $fromLocation to $toLocation...");
  }

  @override
  goToNotification() {
    Get.toNamed(AppRoute.notification);
  }

  @override
  goToSearch() {
    Get.toNamed(AppRoute.searchTrip);
  }
}
