import 'package:flutter/material.dart';
import 'package:transgo_passenger/controller/passenger_trip/trip_details_controller.dart';
import 'package:transgo_passenger/core/constant/AppColor.dart';
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  "CURRENT PASSENGERS",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.50),
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Text(
                "$count passengers",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.50),
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (passengers.isEmpty)
            Text(
              "No passengers yet",
              style: TextStyle(
                color: Colors.white.withOpacity(0.55),
                fontSize: 13,
              ),
            )
          else
            SizedBox(
              height: 136,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: passengers.length,
                separatorBuilder: (_, __) => const SizedBox(width: 10),
                itemBuilder: (context, index) {
                  final passenger = passengers[index];

                  return _PassengerCard(passenger: passenger);
                },
              ),
            ),
        ],
      ),
    );
  }
}

class _PassengerCard extends StatelessWidget {
  const _PassengerCard({
    required this.passenger,
  });

  final PassengerUiModel passenger;

  @override
  Widget build(BuildContext context) {
    final passengerName =
        passenger.name.trim().isEmpty ? "Passenger" : passenger.name;

    return Container(
      width: 118,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: AppColor.primaryColor.withOpacity(0.35),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: Colors.white.withOpacity(0.08),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AppNetworkImage(
            imageUrl: passenger.image,
            width: 42,
            height: 42,
            borderRadius: 21,
            fallbackIcon: Icons.person,
          ),
          const SizedBox(height: 8),
          Text(
            passengerName,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
              height: 1.15,
            ),
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.star_rounded,
                color: Colors.amber,
                size: 15,
              ),
              const SizedBox(width: 3),
              Text(
                passenger.rating.toStringAsFixed(1),
                style: TextStyle(
                  color: Colors.white.withOpacity(0.78),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
