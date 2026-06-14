import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:transgo_passenger/controller/home/home_page_controller.dart';
import 'package:transgo_passenger/core/constant/AppColor.dart';
import 'package:transgo_passenger/view/widget/home/category_card.dart';
import 'package:transgo_passenger/view/widget/home/explore_ride_card.dart';
import 'package:transgo_passenger/view/widget/home/home_header_widget.dart';
import 'package:transgo_passenger/view/widget/home/home_search_panel.dart';
import 'package:transgo_passenger/view/widget/home/home_section_header.dart';
import 'package:transgo_passenger/view/widget/home/popular_trip_card.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<HomeViewController>()) {
      Get.put(HomeViewController());
    }

    return GetBuilder<HomeViewController>(
      builder: (controller) {
        return Container(
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
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(18, 12, 18, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HomeHeaderWidget(
                    title: "Good Evening, Khader",
                    subtitle: "Ready for your next trip?",
                    onNotificationTap: () {},
                  ),

                  const SizedBox(height: 22),

                  ExploreRideCard(
                    title: "Explore Your Next\nRide",
                    subtitle: "Book shared or private trips بسهولة\nوسرعة",
                    buttonText: "Find Trip",
                    onPressed: controller.searchTrips,
                  ),

                  const SizedBox(height: 20),

                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.only(bottom: 120),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          HomeSearchPanel(
                            fromLocation: controller.fromLocation,
                            toLocation: controller.toLocation.isEmpty
                                ? "Where to?"
                                : controller.toLocation,
                            selectedDate: controller.selectedDate,
                            selectedTripType: controller.selectedTripType,
                            onSearch: controller.searchTrips,
                          ),

                          const SizedBox(height: 26),

                          HomeSectionHeader(
                            title: "Categories",
                            subtitle:
                                "Choose your destination by governorate",
                            showViewAll: true,
                            onViewAll: () {},
                          ),

                          const SizedBox(height: 16),

                          SizedBox(
                            height: 142,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: controller.categories.length,
                              itemBuilder: (context, index) {
                                final category = controller.categories[index];

                                return CategoryCard(
                                  title: category["name"],
                                  subtitle: category["trips"],
                                  icon: category["icon"],
                                );
                              },
                            ),
                          ),

                          const SizedBox(height: 26),

                          const HomeSectionHeader(
                            title: "Popular Trips",
                            subtitle: "Most booked routes",
                          ),

                          const SizedBox(height: 16),

                          SizedBox(
                            height: 292,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: controller.popularTrips.length,
                              itemBuilder: (context, index) {
                                final trip = controller.popularTrips[index];

                                return PopularTripCard(
                                  from: trip["from"],
                                  to: trip["to"],
                                  time: trip["time"],
                                  seats: trip["seats"],
                                  price: trip["price"],
                                  rating: trip["rating"],
                                  isPrivate: trip["isPrivate"] == true,
                                  onDetailsTap: () {},
                                );
                              },
                            ),
                          ),

                          // const SizedBox(height: 26),

                          // WalletBalanceCard(
                          //   balance: controller.totalBalance,
                          //   onTopUp: controller.topUpWallet,
                          // ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}