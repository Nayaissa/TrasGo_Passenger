import 'package:flutter/material.dart';
import 'package:transgo_passenger/controller/passenger_trip/trip_details_controller.dart';
import 'package:transgo_passenger/core/constant/AppColor.dart';
import 'package:transgo_passenger/view/widget/trip_details/trip_details_common.dart';

class TripOverviewCard extends StatelessWidget {
  const TripOverviewCard({
    super.key,
    required this.controller,
  });

  final TripDetailsController controller;

  @override
  Widget build(BuildContext context) {
    final items = [
      _OverviewItem(
        title: "STATUS",
        value: controller.tripStatus,
        icon: Icons.pending_actions_outlined,
      ),
      _OverviewItem(
        title: "DEPARTURE",
        value: controller.departureTime,
        icon: Icons.schedule_outlined,
      ),
      _OverviewItem(
        title: "ARRIVAL",
        value: controller.expectedArrivalTime,
        icon: Icons.flag_outlined,
      ),
      _OverviewItem(
        title: "DISTANCE",
        value: controller.estimatedDistance,
        icon: Icons.route_outlined,
      ),
      _OverviewItem(
        title: "DURATION",
        value: controller.estimatedDuration,
        icon: Icons.timer_outlined,
      ),
      _OverviewItem(
        title: "BOOKING",
        value: controller.bookingAvailability,
        icon: Icons.confirmation_number_outlined,
      ),
    ].where((item) => item.value.trim().isNotEmpty).toList();

    if (items.isEmpty) {
      return const SizedBox.shrink();
    }

    return TripDetailsCard(
      padding: const EdgeInsets.all(16),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final bool isNarrow = constraints.maxWidth < 360;
          final double itemWidth = isNarrow
              ? constraints.maxWidth
              : (constraints.maxWidth - 10) / 2;

          return Wrap(
            spacing: 10,
            runSpacing: 10,
            children: items.map((item) {
              return SizedBox(
                width: itemWidth,
                child: _OverviewTile(item: item),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}

class _OverviewTile extends StatelessWidget {
  const _OverviewTile({
    required this.item,
  });

  final _OverviewItem item;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 74,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: AppColor.fifthColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: AppColor.thirdColor.withOpacity(0.14),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              item.icon,
              color: AppColor.thirdColor,
              size: 18,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.45),
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  item.value,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    height: 1.15,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _OverviewItem {
  const _OverviewItem({
    required this.title,
    required this.value,
    required this.icon,
  });

  final String title;
  final String value;
  final IconData icon;
}
