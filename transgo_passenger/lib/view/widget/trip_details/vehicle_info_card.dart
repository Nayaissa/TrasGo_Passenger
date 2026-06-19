import 'package:flutter/material.dart';
import 'package:transgo_passenger/controller/passenger_trip/trip_details_controller.dart';
import 'package:transgo_passenger/core/constant/AppColor.dart';
import 'package:transgo_passenger/view/widget/trip_details/trip_details_common.dart';

class TripVehicleCard extends StatelessWidget {
  const TripVehicleCard({
    super.key,
    required this.controller,
  });

  final TripDetailsController controller;

  @override
  Widget build(BuildContext context) {
    return TripDetailsCard(
      child: Column(
        children: [
          Row(
            children: [
              const TripDetailsSquareIcon(
                icon: Icons.directions_car_filled_outlined,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      controller.vehicleName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      controller.vehicleLicense,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.50),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          LayoutBuilder(
            builder: (context, constraints) {
              final double itemWidth = constraints.maxWidth < 360
                  ? constraints.maxWidth
                  : (constraints.maxWidth - 12) / 2;

              return Wrap(
                spacing: 12,
                runSpacing: 12,
                children: controller.features.map((feature) {
                  return SizedBox(
                    width: itemWidth,
                    child: _FeatureItem(
                      icon: feature.icon,
                      title: feature.title,
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _FeatureItem extends StatelessWidget {
  const _FeatureItem({
    required this.icon,
    required this.title,
  });

  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        color: AppColor.fifthColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: Colors.white.withOpacity(0.70),
            size: 19,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
