import 'package:flutter/material.dart';
import 'package:transgo_passenger/controller/passenger_trip/trip_details_controller.dart';
import 'package:transgo_passenger/view/widget/trip_details/trip_details_common.dart';

class TripDetailsInfoTiles extends StatelessWidget {
  const TripDetailsInfoTiles({
    super.key,
    required this.controller,
  });

  final TripDetailsController controller;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isSmall = constraints.maxWidth < 340;

        final priceTile = _InfoTile(
          title: "SEAT PRICE",
          value: controller.seatPrice,
          subtitle: controller.currency,
          icon: Icons.payments_outlined,
        );

        final seatsTile = _InfoTile(
          title: "SEATS LEFT",
          value: "${controller.seatsLeft} of ${controller.totalSeats}",
          subtitle: "Available seats",
          icon: Icons.event_seat_outlined,
        );

        if (isSmall) {
          return Column(
            children: [
              priceTile,
              const SizedBox(height: 12),
              seatsTile,
            ],
          );
        }

        return Row(
          children: [
            Expanded(child: priceTile),
            const SizedBox(width: 12),
            Expanded(child: seatsTile),
          ],
        );
      },
    );
  }
}

class _InfoTile extends StatelessWidget {
  const _InfoTile({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
  });

  final String title;
  final String value;
  final String subtitle;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return TripDetailsCard(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          TripDetailsSquareIcon(icon: icon),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.45),
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.50),
                    fontSize: 11,
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
