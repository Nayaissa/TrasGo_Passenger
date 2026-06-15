import 'package:flutter/material.dart';
import 'package:transgo_passenger/core/constant/AppColor.dart';
import 'package:transgo_passenger/core/shared/app_network_image.dart';

// ignore: must_be_immutable
class PopularTripCard extends StatelessWidget {
   PopularTripCard({
    super.key,
    required this.from,
    required this.to,
    required this.time,
    required this.seats,
    required this.price,
    required this.rating,
    required this.isPrivate,
     this.imageUrl,
    this.onDetailsTap,
  });

  final String from;
  final String to;
  final String time;
  final String seats;
  final String price;
  final String rating;
  final bool isPrivate;
   String ? imageUrl;
  final VoidCallback? onDetailsTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: 285,
      margin: const EdgeInsets.only(right: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColor.cardColor,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: Colors.white.withOpacity(0.08),
        ),
      ),
      child: Column(
        children: [
          Stack(
            children: [
              AppNetworkImage(
                imageUrl: imageUrl,
                height: 122,
                width: double.infinity,
                borderRadius: 22,
                fit: BoxFit.cover,
                fallbackIcon: isPrivate
                    ? Icons.directions_car_filled_outlined
                    : Icons.directions_bus_filled_outlined,
              ),

              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.35),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.08),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.star_rounded,
                        color: Colors.amber,
                        size: 15,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        rating,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          Row(
            children: [
              Expanded(
                child: Text(
                  from,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Icon(
                  Icons.arrow_forward,
                  color: Colors.white70,
                  size: 16,
                ),
              ),

              Expanded(
                child: Text(
                  to,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.end,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          Row(
            children: [
              Icon(
                Icons.access_time,
                color: theme.hintColor,
                size: 16,
              ),
              const SizedBox(width: 5),
              Text(
                time,
                style: TextStyle(
                  color: theme.hintColor,
                  fontSize: 13,
                ),
              ),

              const SizedBox(width: 14),

              Icon(
                isPrivate
                    ? Icons.directions_car_outlined
                    : Icons.airline_seat_recline_normal,
                color: theme.hintColor,
                size: 16,
              ),
              const SizedBox(width: 5),
              Expanded(
                child: Text(
                  seats,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: theme.hintColor,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),

          const Spacer(),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                price,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              SizedBox(
                height: 40,
                child: ElevatedButton(
                  onPressed: onDetailsTap,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.fifthColor,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  child: const Text(
                    "Details",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}