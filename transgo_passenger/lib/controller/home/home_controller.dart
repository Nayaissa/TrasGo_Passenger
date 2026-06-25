import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:transgo_passenger/core/constant/AppColor.dart';
import 'package:transgo_passenger/view/screen/home/home_page_view.dart';
import 'package:transgo_passenger/view/screen/trips/passenger_trips_screen.dart';

class HomeController extends GetxController {
  int currentIndex = 0;

  final List<Widget> pages = const [
    HomeView(),
    MyTripsView(),
    _HomePlaceholderPage(
      icon: Icons.account_balance_wallet_outlined,
      title: "Wallet",
      subtitle: "Wallet features will be available soon",
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

class _HomePlaceholderPage extends StatelessWidget {
  const _HomePlaceholderPage({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
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
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: AppColor.thirdColor,
                size: 56,
              ),
              const SizedBox(height: 16),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppColor.hintColor,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
