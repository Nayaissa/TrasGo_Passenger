import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:transgo_passenger/controller/passenger_trip/trip_tracking_controller.dart';
import 'package:transgo_passenger/core/class/statusrequest.dart';
import 'package:transgo_passenger/core/constant/AppColor.dart';
import 'package:transgo_passenger/view/widget/state/app_state_view.dart';
import 'package:transgo_passenger/view/widget/trip_tracking/driver_tracking_sheet.dart';
import 'package:transgo_passenger/view/widget/trip_tracking/tracking_map_backdrop.dart';

class TripTrackingScreen extends StatelessWidget {
  const TripTrackingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TripTrackingController>(
      init: TripTrackingController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: AppColor.primaryColor,
          appBar: AppBar(
            backgroundColor: AppColor.primaryColor,
            elevation: 0,
            leading: IconButton(
              onPressed: () => Get.back(),
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
            ),
            title: const Text(
              "Live Tracking",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            centerTitle: false,
            actions: [
              IconButton(
                onPressed: controller.shareTracking,
                icon: const Icon(
                  Icons.share_outlined,
                  color: Colors.white,
                ),
              ),
              IconButton(
                onPressed: controller.getTripTracking,
                icon: const Icon(
                  Icons.refresh,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          body: Stack(
            children: [
              Positioned.fill(
                child: TrackingMapBackdrop(controller: controller),
              ),
              if (controller.statusRequest != null)
                Positioned.fill(
                  child: IgnorePointer(
                    ignoring: controller.statusRequest ==
                        StatusRequest.success,
                    child: AppStateView(
                      statusRequest: controller.statusRequest,
                      isEmpty: false,
                      loadingMessage: "Loading tracking...",
                      emptyTitle: "No Tracking Data",
                      emptySubtitle:
                          "There is no tracking data for this trip.",
                      errorTitle: "Failed to load tracking",
                      errorSubtitle: controller.trackingMessage.isEmpty
                          ? "Please try again."
                          : controller.trackingMessage,
                      serverErrorTitle: "Server Error",
                      serverErrorSubtitle:
                          "Could not connect to the server.",
                      onRetry: controller.getTripTracking,
                      child: const SizedBox.shrink(),
                    ),
                  ),
                ),
              Positioned(
                left: 18,
                right: 18,
                bottom: 24,
                child: SafeArea(
                  top: false,
                  child: DriverTrackingSheet(controller: controller),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
