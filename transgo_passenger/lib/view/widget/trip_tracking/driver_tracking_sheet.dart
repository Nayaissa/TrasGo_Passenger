import 'package:flutter/material.dart';
import 'package:transgo_passenger/controller/passenger_trip/trip_tracking_controller.dart';
import 'package:transgo_passenger/core/constant/AppColor.dart';
import 'package:transgo_passenger/core/shared/app_network_image.dart';

class DriverTrackingSheet extends StatelessWidget {
  const DriverTrackingSheet({
    super.key,
    required this.controller,
  });

  final TripTrackingController controller;

  @override
  Widget build(BuildContext context) {
    final driverName =
        controller.driverName.trim().isEmpty ? "Driver" : controller.driverName;
    final vehicle =
        controller.vehicleName.trim().isEmpty
            ? "Vehicle"
            : controller.vehicleName;
    final plate =
        controller.bookingCode.trim().isEmpty ? "------" : controller.bookingCode;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(22, 12, 22, 24),
      decoration: BoxDecoration(
        color:AppColor.primaryColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(.08)),
      ),
      child: Column(
        children: [
          Container(
            width: 44,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(.13),
              borderRadius: BorderRadius.circular(99),
            ),
          ),
          const SizedBox(height: 26),
          Row(
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  AppNetworkImage(
                    imageUrl: controller.driverImage,
                    width: 54,
                    height: 54,
                    borderRadius: 27,
                    fallbackIcon: Icons.person,
                    backgroundColor: AppColor.fifthColor,
                  ),
                  Positioned(
                    right: -1,
                    bottom: 2,
                    child: Container(
                      width: 13,
                      height: 13,
                      decoration: BoxDecoration(
                        color: controller.availabilityColor,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xFF101A37),
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
                      driverName,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 19,
                        height: 1.18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        const Icon(
                          Icons.star_border_rounded,
                          color: Colors.white,
                          size: 15,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            "${controller.driverRating} - $vehicle",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.white.withOpacity(.78),
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 14),
              _PlateNumber(code: plate),
            ],
          ),
          const SizedBox(height: 26),
          Row(
            children: [
              Expanded(
                child: _OutlineActionButton(
                  icon: Icons.call_outlined,
                  text: "Call",
                  onPressed: controller.callDriver,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: _OutlineActionButton(
                  icon: Icons.chat_bubble_outline,
                  text: "Message",
                  onPressed: controller.messageDriver,
                ),
              ),
            ],
          ),
          const SizedBox(height: 28),
          Container(
            width: double.infinity,
            height: 54,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              gradient: const LinearGradient(
                colors: [
                  AppColor.thirdColor,
                  AppColor.fourthColor,
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColor.fourthColor.withOpacity(.28),
                  blurRadius: 22,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
            child: ElevatedButton.icon(
              onPressed: controller.shareTracking,
              icon: const Icon(
                Icons.ios_share_outlined,
                color: Colors.white,
              ),
              label: const Text(
                "Share Tracking",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PlateNumber extends StatelessWidget {
  const _PlateNumber({
    required this.code,
  });

  final String code;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(.10),
            borderRadius: BorderRadius.circular(9),
            border: Border.all(color: Colors.white.withOpacity(.07)),
          ),
          child: Text(
            code,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Color(0xFFD4DDFB),
              fontSize: 18,
              fontWeight: FontWeight.w600,
              letterSpacing: 2,
            ),
          ),
        ),
        const SizedBox(height: 7),
        Text(
          "BOOKING CODE",
          style: TextStyle(
            color: Colors.white.withOpacity(.72),
            fontSize: 10,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
      ],
    );
  }
}

class _OutlineActionButton extends StatelessWidget {
  const _OutlineActionButton({
    required this.icon,
    required this.text,
    required this.onPressed,
  });

  final IconData icon;
  final String text;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 46,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: Icon(
          icon,
          color: Colors.white,
          size: 20,
        ),
        label: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
        ),
        style: OutlinedButton.styleFrom(
          side: BorderSide(
            color: Colors.white.withOpacity(.11),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}
