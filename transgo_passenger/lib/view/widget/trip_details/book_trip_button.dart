import 'package:flutter/material.dart';
import 'package:transgo_passenger/controller/passenger_trip/trip_details_controller.dart';
import 'package:transgo_passenger/core/constant/AppColor.dart';

class TripBookButton extends StatelessWidget {
  const TripBookButton({
    super.key,
    required this.controller,
  });

  final TripDetailsController controller;

  @override
  Widget build(BuildContext context) {
    final bool isDisabled = controller.isBooked || controller.seatsLeft <= 0;

    return Column(
      children: [
        Container(
          width: double.infinity,
          height: 56,
          decoration: BoxDecoration(
            gradient: isDisabled
                ? null
                : const LinearGradient(
                    colors: [
                      AppColor.thirdColor,
                      AppColor.fourthColor,
                    ],
                  ),
            color: isDisabled ? AppColor.fifthColor : null,
            borderRadius: BorderRadius.circular(18),
          ),
          child: ElevatedButton(
            onPressed: isDisabled ? null : controller.bookTrip,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              disabledBackgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  controller.isBooked
                      ? "Trip Booked"
                      : controller.seatsLeft <= 0
                          ? "No Seats Left"
                          : "Book Trip",
                  style: TextStyle(
                    color: isDisabled ? Colors.white38 : Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  controller.isBooked
                      ? Icons.check_circle_outline
                      : Icons.arrow_forward,
                  color: isDisabled ? Colors.white38 : Colors.white,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 9),
        Text(
          controller.isBooked
              ? "Your seat has been reserved successfully"
              : "Instant confirmation available",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white.withOpacity(0.50),
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
