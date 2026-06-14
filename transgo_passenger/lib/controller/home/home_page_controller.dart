import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeViewController extends GetxController {
  String fromLocation = "Current Location";
  String toLocation = "";
  String selectedDate = "Today";
  String selectedTripType = "Shared";

  final List<Map<String, dynamic>> categories = [
    {
      "name": "Damascus",
      "trips": "24 TRIPS",
      "icon": Icons.location_city,
    },
    {
      "name": "Aleppo",
      "trips": "18 TRIPS",
      "icon": Icons.architecture,
    },
    {
      "name": "Latakia",
      "trips": "9 TRIPS",
      "icon": Icons.beach_access,
    },
  ];

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

  void searchTrips() {
    print("Searching from $fromLocation to $toLocation...");
  }

  void topUpWallet() {
    print("Top Up Pressed");
  }
}