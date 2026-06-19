import 'package:flutter/material.dart';
import 'package:transgo_passenger/controller/passenger_trip/trip_details_controller.dart';
import 'package:transgo_passenger/core/constant/AppColor.dart';
import 'package:transgo_passenger/core/shared/app_network_image.dart';
import 'package:transgo_passenger/view/widget/trip_details/trip_details_common.dart';

class TripDriverCard extends StatelessWidget {
  const TripDriverCard({
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
              Stack(
                children: [
                  AppNetworkImage(
                    imageUrl: controller.driverImage,
                    width: 58,
                    height: 58,
                    borderRadius: 29,
                    fallbackIcon: Icons.person,
                  ),
                  Positioned(
                    bottom: 3,
                    right: 3,
                    child: Container(
                      width: 13,
                      height: 13,
                      decoration: BoxDecoration(
                        color: Colors.greenAccent,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColor.primaryColor,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      controller.driverName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        const Icon(
                          Icons.star_rounded,
                          color: Colors.amber,
                          size: 17,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          controller.driverRating.toStringAsFixed(1),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            "(${controller.driverReviews})",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.50),
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TripDetailsOutlineButton(
                  text: "VIEW PROFILE",
                  onPressed: controller.viewDriverProfile,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TripDetailsOutlineButton(
                  text: "REVIEWS",
                  onPressed: controller.viewReviews,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
