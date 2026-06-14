import 'package:flutter/material.dart';
import 'package:transgo_passenger/controller/home/home_controller.dart';
import 'package:transgo_passenger/core/constant/AppColor.dart';

class MainBottomNavBar extends StatelessWidget {
  const MainBottomNavBar({
    super.key,
    required this.controller,
  });

  final  HomeController controller;

  @override
  Widget build(BuildContext context) {
    const Color activeColor = Colors.white;
     Color inactiveColor = AppColor.grey;

    return SafeArea(
      top: false,
      child: BottomAppBar(
        color: AppColor.secondaryColor,
        elevation: 0,
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        child: SizedBox(
          height: 72,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                icon: Icons.home_outlined,
                label: "Home",
                index: 0,
                activeColor: activeColor,
                inactiveColor: inactiveColor,
              ),

              _buildNavItem(
                icon: Icons.calendar_today_outlined,
                label: "Bookings",
                index: 2,
                activeColor: activeColor,
                inactiveColor: inactiveColor,
              ),

              const SizedBox(width: 56),

              _buildNavItem(
                icon: Icons.account_balance_wallet_outlined,
                label: "Wallet",
                index: 3,
                activeColor: activeColor,
                inactiveColor: inactiveColor,
              ),

              _buildNavItem(
                icon: Icons.person_outline,
                label: "Profile",
                index: 4,
                activeColor: activeColor,
                inactiveColor: inactiveColor,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required int index,
    required Color activeColor,
    required Color inactiveColor,
  }) {
    final bool isActive = controller.currentIndex == index;

    return Expanded(
      child: InkWell(
        onTap: () {
          controller.changePage(index);
        },
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: SizedBox(
          height: 72,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: isActive ? activeColor : inactiveColor,
                size: 24,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: isActive ? activeColor : inactiveColor,
                  fontSize: 11,
                  fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}