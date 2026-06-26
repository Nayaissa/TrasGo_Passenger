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
        value: controller.tripStatus,
        icon: Icons.pending_actions_outlined,
      ),
      _OverviewItem(
        value: controller.departureTime,
        icon: Icons.schedule_outlined,
      ),
      _OverviewItem(
        value: controller.expectedArrivalTime,
        icon: Icons.flag_outlined,
      ),
      _OverviewItem(
        value: controller.estimatedDistance,
        icon: Icons.route_outlined,
      ),
      _OverviewItem(
        value: controller.estimatedDuration,
        icon: Icons.timer_outlined,
      ),
      _OverviewItem(
        value: controller.bookingAvailability,
        icon: Icons.confirmation_number_outlined,
      ),
    ].where((item) => item.value.trim().isNotEmpty).toList();

    if (items.isEmpty) {
      return const SizedBox.shrink();
    }

    return TripDetailsCard(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final double itemWidth = (constraints.maxWidth - 18) / 2;

          return Wrap(
            spacing: 18,
            runSpacing: 18,
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
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: const Color(0xFF22305B),
            borderRadius: BorderRadius.circular(9),
          ),
          child: Icon(
            item.icon,
            color: AppColor.thirdColor,
            size: 18,
          ),
        ),

        const SizedBox(width: 10),

        Expanded(
          child: Text(
            item.value,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              height: 1.25,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

class _OverviewItem {
  const _OverviewItem({
    required this.value,
    required this.icon,
  });

  final String value;
  final IconData icon;
}