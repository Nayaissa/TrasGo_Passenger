import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:transgo_passenger/controller/home/category_trip_controller.dart';
import 'package:transgo_passenger/core/constant/AppColor.dart';
import 'package:transgo_passenger/view/widget/state/app_state_view.dart';
import 'package:transgo_passenger/view/widget/trips/available_trip_card.dart';
import 'package:transgo_passenger/view/widget/trips/trips_city_banner.dart';
import 'package:transgo_passenger/view/widget/trips/trips_filter_card.dart';
import 'package:transgo_passenger/view/widget/trips/trips_summary_card.dart';

class TripsView extends StatelessWidget {
  const TripsView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TripsController>(
      init: TripsController(),
      global: false,
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
            title: Text(
              controller.bannerTitle.isEmpty
                  ? "Trips"
                  : "Trips to ${controller.bannerTitle}",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            actions: [
              IconButton(
                icon: Icon(
                  controller.showFilters
                      ? Icons.filter_alt_off_outlined
                      : Icons.tune,
                  color: Colors.white,
                ),
                onPressed: controller.toggleFilters,
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
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TripsCityBanner(
                      title: controller.bannerTitle,
                      subtitle: controller.bannerSubtitle,
                      tripCount: controller.bannerTripCount,
                      date: controller.bannerDate,
                      imageUrl: controller.bannerImage,
                    ),

                    const SizedBox(height: 20),

                    TripsInlineFilterCard(
                      controller: controller,
                    ),

                    const SizedBox(height: 20),

                    TripsSummaryCard(
                      destination: controller.bannerTitle,
                      from: controller.selectedStartGovernorateName,
                      mode: controller.selectedTripType ?? "governorates",
                    ),

                    const SizedBox(height: 24),

                    const Text(
                      "Available Trips",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      "Shared trips available to ${controller.bannerTitle}",
                      style: TextStyle(
                        color: Theme.of(context).hintColor,
                        fontSize: 12,
                      ),
                    ),

                    const SizedBox(height: 16),

                    AppStateView(
                      statusRequest: controller.tripsStatusRequest,
                      isEmpty: controller.availableTrips.isEmpty,
                      loadingMessage: "Loading trips...",
                      emptyTitle: "No Trips Found",
                      emptySubtitle:
                          "There are no available trips for this governorate right now.",
                      errorTitle: "Failed to load trips",
                      errorSubtitle: "Please try again.",
                      serverErrorTitle: "Server Error",
                      serverErrorSubtitle: "Could not connect to the server.",
                      onRetry: controller.refreshTrips,
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: controller.availableTrips.length,
                        itemBuilder: (context, index) {
                          final trip = controller.availableTrips[index];

                          return AvailableTripCard(
                            price: trip.priceText,
                            currency: trip.currencyText,
                            from: trip.fromName,
                            fromDetails: trip.fromDetails,
                            to: trip.toName,
                            toDetails: trip.toDetails,
                            seats: trip.seatsText,
                            type: trip.typeText,
                            status: trip.statusText,
                            rating: trip.ratingText,
                            driverName: trip.driverName,
                            carType: trip.carType,
                            driverImage: trip.driverImage,
                            onBookNow: () {
                              controller.bookNow(index);
                            },
                            onViewDetails: () {
                              controller.viewDetails(index);
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}