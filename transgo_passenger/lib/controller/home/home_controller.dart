import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:transgo_passenger/view/screen/home/home_page_view.dart';
import 'package:transgo_passenger/view/screen/trips/passenger_trips_screen.dart';

class HomeController extends GetxController {
  int currentIndex = 0;

  final List<Widget> pages = const [
    HomeView(),
    MyTripsView(),
    Center(
      child: Text(
        'Wallet Screen Content',
        style: TextStyle(color: Colors.white),
      ),
    ),
    Center(
      child: Text(
        'Profile Screen Content',
        style: TextStyle(color: Colors.white),
      ),
    ),
  ];

  void changePage(int index) {
    currentIndex = index;
    update();
  }
}
