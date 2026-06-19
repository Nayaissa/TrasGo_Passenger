import 'package:flutter/material.dart';
import 'package:transgo_passenger/controller/passenger_trip/show_trips_controller.dart';
import 'package:transgo_passenger/core/constant/AppColor.dart';

class MyTripsTabBar extends StatelessWidget {
  const MyTripsTabBar({super.key, required this.controller});

  final MyTripsController controller;

  @override
  Widget build(BuildContext context) {
    if (controller.tripStatuses.isEmpty) {
      return const SizedBox(height: 42);
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(controller.tripStatuses.length, (index) {
          final status = controller.tripStatuses[index];
          final selected = controller.selectedTab == index;
          final statusColor = _hexToColor(status.color);

          return GestureDetector(
            onTap: () {
              controller.changeTab(index);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              margin: const EdgeInsets.only(right: 10),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color:
                    selected
                        ? statusColor.withOpacity(0.22)
                        : AppColor.cardColor,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color:
                      selected
                          ? statusColor.withOpacity(0.65)
                          : AppColor.thirdColor,
                ),
              ),
              child: Text(
                status.name ?? status.key ?? "",
                style: TextStyle(
                  color: selected ? statusColor : Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Color _hexToColor(String? hex) {
    if (hex == null || hex.isEmpty) {
      return AppColor.thirdColor;
    }

    String value = hex.replaceAll("#", "");

    if (value.length == 6) {
      value = "FF$value";
    }

    return Color(int.parse(value, radix: 16));
  }
}
