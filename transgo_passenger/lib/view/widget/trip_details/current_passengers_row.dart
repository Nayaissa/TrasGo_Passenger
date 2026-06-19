import 'package:flutter/material.dart';
import 'package:transgo_passenger/controller/passenger_trip/trip_details_controller.dart';
import 'package:transgo_passenger/core/shared/app_network_image.dart';
import 'package:transgo_passenger/view/widget/trip_details/trip_details_common.dart';

class TripPassengersCard extends StatelessWidget {
  const TripPassengersCard({
    super.key,
    required this.controller,
  });

  final TripDetailsController controller;

  @override
  Widget build(BuildContext context) {
    final passengers = controller.passengers;
    final count = passengers.length;

    return TripDetailsCard(
      padding: const EdgeInsets.all(14),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final bool isSmall = constraints.maxWidth < 360;

          final Widget avatars = SizedBox(
            width: 78,
            height: 32,
            child: Stack(
              children: List.generate(
                count > 3 ? 3 : count,
                (index) {
                  return Positioned(
                    left: index * 18,
                    child: AppNetworkImage(
                      imageUrl: passengers[index].image,
                      width: 28,
                      height: 28,
                      borderRadius: 14,
                      fallbackIcon: Icons.person,
                    ),
                  );
                },
              ),
            ),
          );

          final Widget title = Text(
            "CURRENT PASSENGERS",
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.white.withOpacity(0.50),
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          );

          final Widget sharingText = Text(
            "Sharing with $count others",
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.white.withOpacity(0.50),
              fontSize: 12,
            ),
          );

          if (isSmall) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                title,
                const SizedBox(height: 12),
                Row(
                  children: [
                    avatars,
                    const SizedBox(width: 8),
                    Expanded(child: sharingText),
                  ],
                ),
              ],
            );
          }

          return Row(
            children: [
              Expanded(child: title),
              const SizedBox(width: 10),
              avatars,
              const SizedBox(width: 8),
              Flexible(child: sharingText),
            ],
          );
        },
      ),
    );
  }
}
