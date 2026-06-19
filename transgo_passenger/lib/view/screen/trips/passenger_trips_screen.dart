import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:transgo_passenger/controller/passenger_trip/show_trips_controller.dart';
import 'package:transgo_passenger/core/class/statusrequest.dart';
import 'package:transgo_passenger/core/constant/AppColor.dart';
import 'package:transgo_passenger/view/widget/passenger_trip/my_trip_card.dart';
import 'package:transgo_passenger/view/widget/passenger_trip/my_trips_stats_card.dart';
import 'package:transgo_passenger/view/widget/passenger_trip/my_trips_tab_bar.dart';
import 'package:transgo_passenger/view/widget/state/app_state_view.dart';

class MyTripsView extends StatelessWidget {
  const MyTripsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.primaryColor,
      appBar: AppBar(
        backgroundColor: AppColor.primaryColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.white),
          onPressed: () {},
        ),
        title: const Text(
          "My Trips",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.white),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.tune, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: GetBuilder<MyTripsController>(
        init: MyTripsController(),
        builder: (controller) {
          return Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [AppColor.primaryColor, AppColor.secondaryColor],
              ),
            ),
            child: SafeArea(
              top: false,
              child: RefreshIndicator(
                color: AppColor.thirdColor,
                backgroundColor: AppColor.primaryColor,
                onRefresh: controller.getMyTrips,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      MyTripsStatsCard(controller: controller),

                      const SizedBox(height: 22),

                      MyTripsTabBar(controller: controller),

                      const SizedBox(height: 18),

                      ConstrainedBox(
                        constraints: const BoxConstraints(minHeight: 360),
                        child: AppStateView(
                          statusRequest: controller.statusRequest,
                          isEmpty:
                              controller.statusRequest ==
                                  StatusRequest.success &&
                              controller.filteredTrips.isEmpty,
                          loadingMessage: "Loading trips...",
                          emptyTitle:
                              controller.selectedTab == 0
                                  ? "No Trips Found"
                                  : "No Trips In This Status",
                          emptySubtitle:
                              controller.selectedTab == 0
                                  ? "There are no trips to display right now."
                                  : "There are no trips matching this status.",
                          errorTitle: "Failed to load trips",
                          errorSubtitle: "Please try again.",
                          serverErrorTitle: "Server Error",
                          serverErrorSubtitle:
                              "Could not connect to the server.",
                          onRetry: controller.refreshTrips,
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: controller.filteredTrips.length,
                            itemBuilder: (context, index) {
                              final trip = controller.filteredTrips[index];

                              return MyTripCard(
                                trip: trip,
                                onTrackingPressed: () {
                                  controller.onTrackingPressed(trip);
                                },
                                onCancelPressed: () {
                                  controller.onCancelPressed(trip);
                                },
                                onRatePressed: () {
                                  controller.onRatePressed(trip);
                                },
                                onViewDetails: () {
                                  controller.onViewDetails(trip);
                                },
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
