import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:transgo_passenger/controller/passenger_trip/trip_details_controller.dart';
import 'package:transgo_passenger/core/class/statusrequest.dart';
import 'package:transgo_passenger/core/constant/AppColor.dart';
import 'package:transgo_passenger/view/widget/state/app_state_view.dart';
import 'package:transgo_passenger/view/widget/trip_details/book_trip_button.dart';
import 'package:transgo_passenger/view/widget/trip_details/current_passengers_row.dart';
import 'package:transgo_passenger/view/widget/trip_details/driver_info_card.dart';
import 'package:transgo_passenger/view/widget/trip_details/trip_details_header.dart';
import 'package:transgo_passenger/view/widget/trip_details/trip_info_tiles_row.dart';
import 'package:transgo_passenger/view/widget/trip_details/trip_overview_card.dart';
import 'package:transgo_passenger/view/widget/trip_details/trip_route_card.dart';
import 'package:transgo_passenger/view/widget/trip_details/trip_section_title.dart';
import 'package:transgo_passenger/view/widget/trip_details/vehicle_info_card.dart';

class TripDetailsScreen extends StatelessWidget {
  const TripDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TripDetailsController>(
      init: TripDetailsController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: AppColor.primaryColor,
          appBar: AppBar(
            backgroundColor: AppColor.primaryColor,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
              onPressed: () => Get.back(),
            ),
            title: const Text(
              "Trip Details",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            centerTitle: true,
            actions: [
              IconButton(
                onPressed: controller.getTripDetails,
                icon: const Icon(
                  Icons.refresh,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          body: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColor.primaryColor,
                  AppColor.secondaryColor,
                ],
              ),
            ),
            child: SafeArea(
              top: false,
              child: AppStateView(
                statusRequest: controller.statusRequest,
                isEmpty: controller.statusRequest == StatusRequest.success &&
                    controller.tripDetails == null,
                loadingMessage: "Loading trip details...",
                emptyTitle: "No Details Found",
                emptySubtitle: "There are no details for this trip.",
                errorTitle: "Failed to load trip",
                errorSubtitle: "Please try again.",
                serverErrorTitle: "Server Error",
                serverErrorSubtitle: "Could not connect to the server.",
                onRetry: controller.getTripDetails,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TripDetailsHeader(controller: controller),
                      const SizedBox(height: 16),
                      TripDetailsInfoTiles(controller: controller),
                      const SizedBox(height: 16),
                      TripOverviewCard(controller: controller),
                      const SizedBox(height: 16),
                      TripVehicleCard(controller: controller),
                      const SizedBox(height: 16),
                      TripDriverCard(controller: controller),
                      const SizedBox(height: 24),
                      const TripSectionTitle(title: "TRIP ROUTE"),
                      const SizedBox(height: 12),
                      TripRouteCard(controller: controller),
                      const SizedBox(height: 16),
                      TripPassengersCard(controller: controller),
                      const SizedBox(height: 32),
                      TripBookButton(controller: controller),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
