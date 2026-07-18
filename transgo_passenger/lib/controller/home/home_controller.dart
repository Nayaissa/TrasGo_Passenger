import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:transgo_passenger/view/screen/home/home_page_view.dart';
import 'package:transgo_passenger/view/screen/profile/passenger_profile_screen.dart';
import 'package:transgo_passenger/view/screen/trips/passenger_trips_screen.dart';
import 'package:transgo_passenger/view/wallet/wallet_screen.dart';

class HomeController extends GetxController {
  int currentIndex = 0;

  final List<Widget> pages = const [
    HomeView(),
    MyTripsView(),
   WalletScreen(),
   PassengerProfileScreen() ,
  ];

  void changePage(int index) {
    currentIndex = index;
    update();
  }
}
