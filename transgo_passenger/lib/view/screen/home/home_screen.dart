import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:transgo_passenger/controller/home/home_controller.dart';
import 'package:transgo_passenger/core/constant/AppColor.dart';
import 'package:transgo_passenger/view/widget/home/bottom_nav_bar.dart';

// ignore: must_be_immutable
class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

    HomeController controller =
      Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      builder: (controller) {
        return Scaffold(
          extendBody: true,
          resizeToAvoidBottomInset: false,
          backgroundColor: AppColor.primaryColor,

          body: SafeArea(
            bottom: false,
            child: IndexedStack(
              index: controller.currentIndex,
              children: controller.pages,
            ),
          ),

          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,

          floatingActionButton: _TripsFloatingButton(
            controller: controller,
          ),

          bottomNavigationBar: MainBottomNavBar(
            controller: controller,
          ),
        );
      },
    );
  }
}

class _TripsFloatingButton extends StatelessWidget {
  const _TripsFloatingButton({
    required this.controller,
  });

  final HomeController controller;

  @override
  Widget build(BuildContext context) {
    final bool isActive = controller.currentIndex == 1;

    return Container(
      width: 72,
      height: 72,
      margin: const EdgeInsets.only(top: 8),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          colors: [
            AppColor.thirdColor,
            AppColor.fourthColor,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColor.fourthColor.withOpacity(0.4),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: () {
            controller.changePage(1);
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.directions_bus_filled_outlined,
                color: Colors.white,
                size: 28,
              ),
              const SizedBox(height: 2),
              Text(
                "Trips",
                style: TextStyle(
                  color: isActive ? Colors.white : Colors.white70,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}