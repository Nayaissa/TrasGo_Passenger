import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:transgo_passenger/core/class/statusrequest.dart';

abstract class TripSearchController extends GetxController {
  void setTripType(String type);
  Future<void> executeSearch();
}

class TripSearchControllerImp extends TripSearchController {
  StatusRequest statusRequest = StatusRequest.success;

  final TextEditingController departureController = TextEditingController();
  final TextEditingController destinationController = TextEditingController();
  final TextEditingController dateController = TextEditingController();

  String tripType = 'SHARED';
  bool isSearchExecuted = false;
  bool isSearching = false;

  String get departurePoint => departureController.text.trim();
  String get destination => destinationController.text.trim();
  String get tripDate => dateController.text.trim();

  @override
  void setTripType(String type) {
    tripType = type;
    update();
  }

  @override
  Future<void> executeSearch() async {
    if (departurePoint.isEmpty || destination.isEmpty) {
      Get.snackbar(
        "Search",
        "Please enter departure and destination",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    isSearching = true;
    update();

    await Future.delayed(const Duration(milliseconds: 700));

    isSearchExecuted = true;
    isSearching = false;
    statusRequest = StatusRequest.success;
    update();
  }

  @override
  void onClose() {
    departureController.dispose();
    destinationController.dispose();
    dateController.dispose();
    super.onClose();
  }
}