import 'package:flutter/material.dart';
import 'package:transgo_passenger/core/constant/AppColor.dart';
import 'package:transgo_passenger/core/shared/app_network_image.dart';
import 'package:transgo_passenger/data/model/passenger_trips_model.dart';

class MyTripCard extends StatelessWidget {
  const MyTripCard({
    super.key,
    required this.trip,
    required this.onTrackingPressed,
    required this.onCancelPressed,
    required this.onRatePressed,
    required this.onViewDetails,
    required this.onSharePressed, 
  });

  final PassengerTripItemModel trip;
  final VoidCallback onTrackingPressed;
  final VoidCallback onCancelPressed;
  final VoidCallback onRatePressed;
  final VoidCallback onViewDetails;
  final VoidCallback onSharePressed; 

  bool get isCancelled => trip.isCanceled;

  String get code => trip.bookingCode;
  String get from => trip.fromName;
  String get fromDetails => trip.fromDetails;
  String get to => trip.toName;
  String get toDetails => trip.toDetails;
  String get date => _formatDate(trip.dateText);
  String get info => trip.infoText;
  String get driver => trip.driverName;
  String get rating => trip.ratingText;
  String get car => trip.carType;
  String get price => trip.priceText.replaceAll("Total:", "").trim();
  String get statusName => trip.statusName.isEmpty ? _statusText : trip.statusName;

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 220),
      opacity: isCancelled ? 0.65 : 1,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColor.cardColor,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: _statusColor.withOpacity(isCancelled ? 0.22 : 0.10),
          ),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final bool isSmall = constraints.maxWidth < 345;

            return Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _PriceSection(
                      price: price,
                      isCancelled: isCancelled,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _RouteSection(
                        from: from,
                        fromDetails: fromDetails,
                        to: to,
                        toDetails: toDetails,
                        pickupTitle: trip.pickupTitle,
                        pickupDetails: trip.pickupDetails,
                        hasPickupPoint: trip.hasPickupPoint,
                        isNewPickupPoint: trip.isNewPickupPoint,
                        isCancelled: isCancelled,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                _TripTags(
                  statusText: statusName,
                  statusColor: _statusColor,
                  statusBackground: _statusBackground,
                  info: info,
                  date: date,
                  rating: rating,
                ),

                const SizedBox(height: 14),

                _TripInfoBox(
                  code: code,
                  driver: driver,
                  car: car,
                  driverImage: trip.driverImage,
                  isSmall: isSmall,
                  isCancelled: isCancelled,
                ),

                const SizedBox(height: 16),

                _TripActions(
                  trip: trip,
                  isSmall: isSmall,
                  onTrackingPressed: onTrackingPressed,
                  onCancelPressed: onCancelPressed,
                  onRatePressed: onRatePressed,
                  onViewDetails: onViewDetails,
                  onSharePressed: onSharePressed, // تم تمرير المتغير هنا
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  String get _statusText {
    final key = trip.statusKey;

    if (key == "active" || key == "current") return "Active";
    if (key == "pending") return "Pending";
    if (key == "completed") return "Completed";
    if (key == "canceled" || key == "cancelled") return "Cancelled";

    return "Unknown";
  }

  Color get _statusColor {
    final key = trip.statusKey;

    if (key == "active" || key == "current") return AppColor.thirdColor;
    if (key == "pending") return Colors.amber;
    if (key == "completed") return Colors.greenAccent;
    if (key == "cancelled" || key == "canceled") return Colors.redAccent;

    return AppColor.thirdColor;
  }

  Color get _statusBackground {
    final key = trip.statusKey;

    if (key == "active" || key == "current") {
      return const Color(0xFF142A4A);
    }

    if (key == "pending") {
      return const Color(0xFF3A2F14);
    }

    if (key == "completed") {
      return const Color(0xFF123626);
    }

    if (key == "canceled" || key == "cancelled") {
      return const Color(0xFF3A1F1F);
    }

    return AppColor.fifthColor;
  }

  String _formatDate(String value) {
    if (value.isEmpty) return "";

    try {
      final date = DateTime.parse(value);
      final year = date.year.toString();
      final month = date.month.toString().padLeft(2, "0");
      final day = date.day.toString().padLeft(2, "0");
      final hour = date.hour.toString().padLeft(2, "0");
      final minute = date.minute.toString().padLeft(2, "0");

      return "$year-$month-$day  $hour:$minute";
    } catch (_) {
      return value;
    }
  }
}

class _PriceSection extends StatelessWidget {
  const _PriceSection({
    required this.price,
    required this.isCancelled,
  });

  final String price;
  final bool isCancelled;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          price.isEmpty ? "-" : price,
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
            decoration: isCancelled ? TextDecoration.lineThrough : null,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          "Total Price",
          style: TextStyle(
            color: Colors.white.withOpacity(0.50),
            fontSize: 11,
          ),
        ),
      ],
    );
  }
}

class _RouteSection extends StatelessWidget {
  const _RouteSection({
    required this.from,
    required this.fromDetails,
    required this.to,
    required this.toDetails,
    required this.pickupTitle,
    required this.pickupDetails,
    required this.hasPickupPoint,
    required this.isNewPickupPoint,
    required this.isCancelled,
  });

  final String from;
  final String fromDetails;
  final String to;
  final String toDetails;
  final String pickupTitle;
  final String pickupDetails;
  final bool hasPickupPoint;
  final bool isNewPickupPoint;
  final bool isCancelled;

  @override
  Widget build(BuildContext context) {
    final Color routeColor =
        isCancelled ? Colors.white.withOpacity(0.35) : AppColor.thirdColor;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        _RoutePoint(
          title: from,
          subtitle: fromDetails,
          icon: Icons.radio_button_unchecked,
          color: routeColor,
        ),
        if (hasPickupPoint) ...[
          _RouteLine(color: routeColor),
          _RoutePoint(
            title: pickupTitle.isEmpty ? "Pickup point" : pickupTitle,
            subtitle: pickupDetails,
            icon: isNewPickupPoint
                ? Icons.add_location_alt_outlined
                : Icons.location_on_outlined,
            color: isNewPickupPoint ? AppColor.fourthColor : routeColor,
          ),
        ],
        _RouteLine(color: routeColor),
        _RoutePoint(
          title: to,
          subtitle: toDetails,
          icon: Icons.circle,
          color: routeColor,
        ),
      ],
    );
  }
}

class _RouteLine extends StatelessWidget {
  const _RouteLine({
    required this.color,
  });

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 6, top: 4, bottom: 4),
      width: 1.5,
      height: 24,
      color: color.withOpacity(0.35),
    );
  }
}

class _RoutePoint extends StatelessWidget {
  const _RoutePoint({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Expanded(
          child: Text(
            subtitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.end,
            style: TextStyle(
              color: Colors.white.withOpacity(0.52),
              fontSize: 11,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          textDirection: TextDirection.rtl,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 8),
        Icon(
          icon,
          color: color,
          size: 14,
        ),
      ],
    );
  }
}

class _TripTags extends StatelessWidget {
  const _TripTags({
    required this.statusText,
    required this.statusColor,
    required this.statusBackground,
    required this.info,
    required this.date,
    required this.rating,
  });

  final String statusText;
  final Color statusColor;
  final Color statusBackground;
  final String info;
  final String date;
  final String rating;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.end,
      spacing: 7,
      runSpacing: 8,
      children: [
        _Tag(
          text: statusText,
          backgroundColor: statusBackground,
          textColor: statusColor,
        ),
        _Tag(
          text: info,
          backgroundColor: AppColor.fifthColor,
          textColor: Colors.white.withOpacity(0.65),
        ),
        _Tag(
          text: date,
          icon: Icons.calendar_today_outlined,
          backgroundColor: AppColor.fifthColor,
          textColor: Colors.white.withOpacity(0.65),
        ),
        _Tag(
          text: rating,
          icon: Icons.star_rounded,
          backgroundColor: const Color(0xFF2C1B4D),
          textColor: Colors.amber,
        ),
      ],
    );
  }
}

class _Tag extends StatelessWidget {
  const _Tag({
    required this.text,
    required this.backgroundColor,
    required this.textColor,
    this.icon,
  });

  final String text;
  final Color backgroundColor;
  final Color textColor;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    if (text.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              size: 13,
              color: textColor,
            ),
            const SizedBox(width: 4),
          ],
          Text(
            text,
            style: TextStyle(
              color: textColor,
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _TripInfoBox extends StatelessWidget {
  const _TripInfoBox({
    required this.code,
    required this.driver,
    required this.car,
    required this.driverImage,
    required this.isSmall,
    required this.isCancelled,
  });

  final String code;
  final String driver;
  final String car;
  final String driverImage;
  final bool isSmall;
  final bool isCancelled;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColor.fifthColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Colors.white.withOpacity(0.06),
         ),
      ),
      child: isSmall
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _DriverRow(
                  driver: driver,
                  car: car,
                  driverImage: driverImage,
                  isCancelled: isCancelled,
                ),
                const SizedBox(height: 12),
                _BookingCode(
                  code: code,
                  isCancelled: isCancelled,
                ),
              ],
            )
          : Row(
              children: [
                Expanded(
                  child: _DriverRow(
                    driver: driver,
                    car: car,
                    driverImage: driverImage,
                    isCancelled: isCancelled,
                  ),
                ),
                _BookingCode(
                  code: code,
                  isCancelled: isCancelled,
                ),
              ],
            ),
    );
  }
}

class _DriverRow extends StatelessWidget {
  const _DriverRow({
    required this.driver,
    required this.car,
    required this.driverImage,
    required this.isCancelled,
  });

  final String driver;
  final String car;
  final String driverImage;
  final bool isCancelled;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        AppNetworkImage(
          imageUrl: driverImage,
          width: 40,
          height: 40,
          borderRadius: 20,
          fallbackIcon: Icons.person,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                driver,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: isCancelled ? Colors.white70 : Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                car,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.50),
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _BookingCode extends StatelessWidget {
  const _BookingCode({
    required this.code,
    required this.isCancelled,
  });

  final String code;
  final bool isCancelled;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          "BOOKING CODE",
          style: TextStyle(
            color: Colors.white.withOpacity(0.42),
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          code,
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
            decoration: isCancelled ? TextDecoration.lineThrough : null,
          ),
        ),
      ],
    );
  }
}

class _TripActions extends StatelessWidget {
  const _TripActions({
    required this.trip,
    required this.isSmall,
    required this.onTrackingPressed,
    required this.onCancelPressed,
    required this.onRatePressed,
    required this.onViewDetails,
    required this.onSharePressed, // تم إضافة المتغير هنا في البيرنت الداخلي
  });

  final PassengerTripItemModel trip;
  final bool isSmall;
  final VoidCallback onTrackingPressed;
  final VoidCallback onCancelPressed;
  final VoidCallback onRatePressed;
  final VoidCallback onViewDetails;
  final VoidCallback onSharePressed; // تم إضافة المتغير هنا

  @override
  Widget build(BuildContext context) {
    final Widget mainButton = _MainActionButton(
      trip: trip,
      onTrackingPressed: onTrackingPressed,
      onCancelPressed: onCancelPressed,
      onRatePressed: onRatePressed,
      onSharePressed: onSharePressed, // تم تمريره بشكل صحيح هنا لحل خطأ الـ build
    );

    final Widget detailsButton = SizedBox(
      height: 44,
      child: OutlinedButton(
        onPressed: onViewDetails,
        style: OutlinedButton.styleFrom(
          side: BorderSide(
            color: Colors.white.withOpacity(0.16),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
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
    );

    if (isSmall) {
      return Column(
        children: [
          SizedBox(width: double.infinity, child: mainButton),
          const SizedBox(height: 10),
          SizedBox(width: double.infinity, child: detailsButton),
        ],
      );
    }

    return Row(
      children: [
        Expanded(child: mainButton),
        const SizedBox(width: 10),
        detailsButton,
      ],
    );
  }
}

class _MainActionButton extends StatelessWidget {
  const _MainActionButton({
    required this.trip,
    required this.onTrackingPressed,
    required this.onCancelPressed,
    required this.onRatePressed,
    required this.onSharePressed, 
  });

  final PassengerTripItemModel trip;
  final VoidCallback onTrackingPressed;
  final VoidCallback onCancelPressed;
  final VoidCallback onRatePressed;
  final VoidCallback onSharePressed; 

  @override
  Widget build(BuildContext context) {
    if (trip.isCanceled) {
      return SizedBox(
        height: 44,
        child: ElevatedButton(
          onPressed: null,
          style: ElevatedButton.styleFrom(
            disabledBackgroundColor: AppColor.fifthColor,
            disabledForegroundColor: Colors.white38,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          child: const Text(
            "Cancelled Trip",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
        ),
      );
    }

    if (trip.isPending) {
      return _SolidButton(
        text: "Cancel Booking",
        icon: Icons.cancel_outlined,
        color: Colors.redAccent,
        onPressed: onCancelPressed,
      );
    }

    if (trip.isCompleted) {
      if (trip.isRated == true) {
        return SizedBox(
          height: 44,
          child: ElevatedButton(
            onPressed: null,
            style: ElevatedButton.styleFrom(
              disabledBackgroundColor: AppColor.fifthColor,
              disabledForegroundColor: Colors.white38,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: const Text(
              "Already Rated",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ),
        );
      }

      return _SolidButton(
        text: "Rate Trip",
        icon: Icons.star_outline,
        color: Colors.amber,
        onPressed: onRatePressed,
      );
    }

    if (trip.isActive) {
      return Row(
        children: [
          Expanded(
            child: Container(
              height: 44,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                gradient: const LinearGradient(
                  colors: [
                    AppColor.thirdColor,
                    AppColor.fourthColor,
                  ],
                ),
              ),
              child: ElevatedButton.icon(
                onPressed: onTrackingPressed,
                icon: const Icon(
                  Icons.near_me_outlined,
                  color: Colors.white,
                  size: 18,
                ),
                label: const Text(
                  "Track Trip",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12), 
          Expanded(
            child: Container(
              height: 44,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                gradient: const LinearGradient(
                  colors: [
                    AppColor.thirdColor,
                    AppColor.fourthColor,
                  ],
                ),
              ),
              child: ElevatedButton.icon(
                onPressed: onSharePressed,
                icon: const Icon(
                  Icons.share_outlined,
                  color: Colors.white,
                  size: 18,
                ),
                label: const Text(
                  "Share Trip",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    }

    return SizedBox(
      height: 44,
      child: ElevatedButton(
        onPressed: null,
        style: ElevatedButton.styleFrom(
          disabledBackgroundColor: AppColor.fifthColor,
          disabledForegroundColor: Colors.white38,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: const Text(
          "Unavailable",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}

class _SolidButton extends StatelessWidget {
  const _SolidButton({
    required this.text,
    required this.icon,
    required this.color,
    required this.onPressed,
  });

  final String text;
  final IconData icon;
  final Color color;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(
          icon,
          color: Colors.white,
          size: 18,
        ),
        label: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
    );
  }
}
// import 'package:flutter/material.dart';
// import 'package:transgo_passenger/core/constant/AppColor.dart';
// import 'package:transgo_passenger/core/shared/app_network_image.dart';
// import 'package:transgo_passenger/data/model/passenger_trips_model.dart';

// class MyTripCard extends StatelessWidget {
//   const MyTripCard({
//     super.key,
//     required this.trip,
//     required this.onTrackingPressed,
//     required this.onCancelPressed,
//     required this.onRatePressed,
//     required this.onViewDetails,
//   });

//   final PassengerTripItemModel trip;
//   final VoidCallback onTrackingPressed;
//   final VoidCallback onCancelPressed;
//   final VoidCallback onRatePressed;
//   final VoidCallback onViewDetails;

//   bool get isCancelled => trip.isCanceled;

//   String get code => trip.bookingCode;
//   String get from => trip.fromName;
//   String get fromDetails => trip.fromDetails;
//   String get to => trip.toName;
//   String get toDetails => trip.toDetails;
//   String get date => _formatDate(trip.dateText);
//   String get info => trip.infoText;
//   String get driver => trip.driverName;
//   String get rating => trip.ratingText;
//   String get car => trip.carType;
//   String get price => trip.priceText.replaceAll("Total:", "").trim();
//   String get statusName => trip.statusName.isEmpty ? _statusText : trip.statusName;

//   @override
//   Widget build(BuildContext context) {
//     return AnimatedOpacity(
//       duration: const Duration(milliseconds: 220),
//       opacity: isCancelled ? 0.65 : 1,
//       child: Container(
//         margin: const EdgeInsets.only(bottom: 16),
//         padding: const EdgeInsets.all(16),
//         decoration: BoxDecoration(
//           color: AppColor.cardColor,
//           borderRadius: BorderRadius.circular(24),
//           border: Border.all(
//             color: _statusColor.withOpacity(isCancelled ? 0.22 : 0.10),
//           ),
//         ),
//         child: LayoutBuilder(
//           builder: (context, constraints) {
//             final bool isSmall = constraints.maxWidth < 345;

//             return Column(
//               children: [
//                 Row(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     _PriceSection(
//                       price: price,
//                       isCancelled: isCancelled,
//                     ),
//                     const SizedBox(width: 12),
//                     Expanded(
//                       child: _RouteSection(
//                         from: from,
//                         fromDetails: fromDetails,
//                         to: to,
//                         toDetails: toDetails,
//                         pickupTitle: trip.pickupTitle,
//                         pickupDetails: trip.pickupDetails,
//                         hasPickupPoint: trip.hasPickupPoint,
//                         isNewPickupPoint: trip.isNewPickupPoint,
//                         isCancelled: isCancelled,
//                       ),
//                     ),
//                   ],
//                 ),

//                 const SizedBox(height: 16),

//                 _TripTags(
//                   statusText: statusName,
//                   statusColor: _statusColor,
//                   statusBackground: _statusBackground,
//                   info: info,
//                   date: date,
//                   rating: rating,
//                 ),

//                 const SizedBox(height: 14),

//                 _TripInfoBox(
//                   code: code,
//                   driver: driver,
//                   car: car,
//                   driverImage: trip.driverImage,
//                   isSmall: isSmall,
//                   isCancelled: isCancelled,
//                 ),

//                 const SizedBox(height: 16),

//                 _TripActions(
//                   trip: trip,
//                   isSmall: isSmall,
//                   onTrackingPressed: onTrackingPressed,
//                   onCancelPressed: onCancelPressed,
//                   onRatePressed: onRatePressed,
//                   onViewDetails: onViewDetails,
//                 ),
//               ],
//             );
//           },
//         ),
//       ),
//     );
//   }

//   String get _statusText {
//     final key = trip.statusKey;

//     if (key == "active" || key == "current") return "Active";
//     if (key == "pending") return "Pending";
//     if (key == "completed") return "Completed";
//     if (key == "canceled" || key == "cancelled") return "Cancelled";

//     return "Unknown";
//   }

//   Color get _statusColor {
//     final key = trip.statusKey;

//     if (key == "active" || key == "current") return AppColor.thirdColor;
//     if (key == "pending") return Colors.amber;
//     if (key == "completed") return Colors.greenAccent;
//     if (key == "canceled" || key == "cancelled") return Colors.redAccent;

//     return AppColor.thirdColor;
//   }

//   Color get _statusBackground {
//     final key = trip.statusKey;

//     if (key == "active" || key == "current") {
//       return const Color(0xFF142A4A);
//     }

//     if (key == "pending") {
//       return const Color(0xFF3A2F14);
//     }

//     if (key == "completed") {
//       return const Color(0xFF123626);
//     }

//     if (key == "canceled" || key == "cancelled") {
//       return const Color(0xFF3A1F1F);
//     }

//     return AppColor.fifthColor;
//   }

//   String _formatDate(String value) {
//     if (value.isEmpty) return "";

//     try {
//       final date = DateTime.parse(value);
//       final year = date.year.toString();
//       final month = date.month.toString().padLeft(2, "0");
//       final day = date.day.toString().padLeft(2, "0");
//       final hour = date.hour.toString().padLeft(2, "0");
//       final minute = date.minute.toString().padLeft(2, "0");

//       return "$year-$month-$day  $hour:$minute";
//     } catch (_) {
//       return value;
//     }
//   }
// }

// class _PriceSection extends StatelessWidget {
//   const _PriceSection({
//     required this.price,
//     required this.isCancelled,
//   });

//   final String price;
//   final bool isCancelled;

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           price.isEmpty ? "-" : price,
//           style: TextStyle(
//             color: Colors.white,
//             fontSize: 22,
//             fontWeight: FontWeight.bold,
//             decoration: isCancelled ? TextDecoration.lineThrough : null,
//           ),
//         ),
//         const SizedBox(height: 3),
//         Text(
//           "Total Price",
//           style: TextStyle(
//             color: Colors.white.withOpacity(0.50),
//             fontSize: 11,
//           ),
//         ),
//       ],
//     );
//   }
// }

// class _RouteSection extends StatelessWidget {
//   const _RouteSection({
//     required this.from,
//     required this.fromDetails,
//     required this.to,
//     required this.toDetails,
//     required this.pickupTitle,
//     required this.pickupDetails,
//     required this.hasPickupPoint,
//     required this.isNewPickupPoint,
//     required this.isCancelled,
//   });

//   final String from;
//   final String fromDetails;
//   final String to;
//   final String toDetails;
//   final String pickupTitle;
//   final String pickupDetails;
//   final bool hasPickupPoint;
//   final bool isNewPickupPoint;
//   final bool isCancelled;

//   @override
//   Widget build(BuildContext context) {
//     final Color routeColor =
//         isCancelled ? Colors.white.withOpacity(0.35) : AppColor.thirdColor;

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.end,
//       children: [
//         _RoutePoint(
//           title: from,
//           subtitle: fromDetails,
//           icon: Icons.radio_button_unchecked,
//           color: routeColor,
//         ),
//         if (hasPickupPoint) ...[
//           _RouteLine(color: routeColor),
//           _RoutePoint(
//             title: pickupTitle.isEmpty ? "Pickup point" : pickupTitle,
//             subtitle: pickupDetails,
//             icon: isNewPickupPoint
//                 ? Icons.add_location_alt_outlined
//                 : Icons.location_on_outlined,
//             color: isNewPickupPoint ? AppColor.fourthColor : routeColor,
//           ),
//         ],
//         _RouteLine(color: routeColor),
//         _RoutePoint(
//           title: to,
//           subtitle: toDetails,
//           icon: Icons.circle,
//           color: routeColor,
//         ),
//       ],
//     );
//   }
// }

// class _RouteLine extends StatelessWidget {
//   const _RouteLine({
//     required this.color,
//   });

//   final Color color;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.only(right: 6, top: 4, bottom: 4),
//       width: 1.5,
//       height: 24,
//       color: color.withOpacity(0.35),
//     );
//   }
// }

// class _RoutePoint extends StatelessWidget {
//   const _RoutePoint({
//     required this.title,
//     required this.subtitle,
//     required this.icon,
//     required this.color,
//   });

//   final String title;
//   final String subtitle;
//   final IconData icon;
//   final Color color;

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.end,
//       children: [
//         Expanded(
//           child: Text(
//             subtitle,
//             maxLines: 1,
//             overflow: TextOverflow.ellipsis,
//             textAlign: TextAlign.end,
//             style: TextStyle(
//               color: Colors.white.withOpacity(0.52),
//               fontSize: 11,
//             ),
//           ),
//         ),
//         const SizedBox(width: 8),
//         Text(
//           title,
//           textDirection: TextDirection.rtl,
//           style: const TextStyle(
//             color: Colors.white,
//             fontSize: 16,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         const SizedBox(width: 8),
//         Icon(
//           icon,
//           color: color,
//           size: 14,
//         ),
//       ],
//     );
//   }
// }

// class _TripTags extends StatelessWidget {
//   const _TripTags({
//     required this.statusText,
//     required this.statusColor,
//     required this.statusBackground,
//     required this.info,
//     required this.date,
//     required this.rating,
//   });

//   final String statusText;
//   final Color statusColor;
//   final Color statusBackground;
//   final String info;
//   final String date;
//   final String rating;

//   @override
//   Widget build(BuildContext context) {
//     return Wrap(
//       alignment: WrapAlignment.end,
//       spacing: 7,
//       runSpacing: 8,
//       children: [
//         _Tag(
//           text: statusText,
//           backgroundColor: statusBackground,
//           textColor: statusColor,
//         ),
//         _Tag(
//           text: info,
//           backgroundColor: AppColor.fifthColor,
//           textColor: Colors.white.withOpacity(0.65),
//         ),
//         _Tag(
//           text: date,
//           icon: Icons.calendar_today_outlined,
//           backgroundColor: AppColor.fifthColor,
//           textColor: Colors.white.withOpacity(0.65),
//         ),
//         _Tag(
//           text: rating,
//           icon: Icons.star_rounded,
//           backgroundColor: const Color(0xFF2C1B4D),
//           textColor: Colors.amber,
//         ),
//       ],
//     );
//   }
// }

// class _Tag extends StatelessWidget {
//   const _Tag({
//     required this.text,
//     required this.backgroundColor,
//     required this.textColor,
//     this.icon,
//   });

//   final String text;
//   final Color backgroundColor;
//   final Color textColor;
//   final IconData? icon;

//   @override
//   Widget build(BuildContext context) {
//     if (text.isEmpty) return const SizedBox.shrink();

//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//       decoration: BoxDecoration(
//         color: backgroundColor,
//         borderRadius: BorderRadius.circular(10),
//       ),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           if (icon != null) ...[
//             Icon(
//               icon,
//               size: 13,
//               color: textColor,
//             ),
//             const SizedBox(width: 4),
//           ],
//           Text(
//             text,
//             style: TextStyle(
//               color: textColor,
//               fontSize: 11,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _TripInfoBox extends StatelessWidget {
//   const _TripInfoBox({
//     required this.code,
//     required this.driver,
//     required this.car,
//     required this.driverImage,
//     required this.isSmall,
//     required this.isCancelled,
//   });

//   final String code;
//   final String driver;
//   final String car;
//   final String driverImage;
//   final bool isSmall;
//   final bool isCancelled;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(14),
//       decoration: BoxDecoration(
//         color: AppColor.fifthColor,
//         borderRadius: BorderRadius.circular(18),
//         border: Border.all(
//           color: Colors.white.withOpacity(0.06),
//         ),
//       ),
//       child: isSmall
//           ? Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 _DriverRow(
//                   driver: driver,
//                   car: car,
//                   driverImage: driverImage,
//                   isCancelled: isCancelled,
//                 ),
//                 const SizedBox(height: 12),
//                 _BookingCode(
//                   code: code,
//                   isCancelled: isCancelled,
//                 ),
//               ],
//             )
//           : Row(
//               children: [
//                 Expanded(
//                   child: _DriverRow(
//                     driver: driver,
//                     car: car,
//                     driverImage: driverImage,
//                     isCancelled: isCancelled,
//                   ),
//                 ),
//                 _BookingCode(
//                   code: code,
//                   isCancelled: isCancelled,
//                 ),
//               ],
//             ),
//     );
//   }
// }

// class _DriverRow extends StatelessWidget {
//   const _DriverRow({
//     required this.driver,
//     required this.car,
//     required this.driverImage,
//     required this.isCancelled,
//   });

//   final String driver;
//   final String car;
//   final String driverImage;
//   final bool isCancelled;

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         AppNetworkImage(
//           imageUrl: driverImage,
//           width: 40,
//           height: 40,
//           borderRadius: 20,
//           fallbackIcon: Icons.person,
//         ),
//         const SizedBox(width: 10),
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 driver,
//                 maxLines: 1,
//                 overflow: TextOverflow.ellipsis,
//                 style: TextStyle(
//                   color: isCancelled ? Colors.white70 : Colors.white,
//                   fontWeight: FontWeight.bold,
//                   fontSize: 14,
//                 ),
//               ),
//               const SizedBox(height: 2),
//               Text(
//                 car,
//                 maxLines: 1,
//                 overflow: TextOverflow.ellipsis,
//                 style: TextStyle(
//                   color: Colors.white.withOpacity(0.50),
//                   fontSize: 11,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }

// class _BookingCode extends StatelessWidget {
//   const _BookingCode({
//     required this.code,
//     required this.isCancelled,
//   });

//   final String code;
//   final bool isCancelled;

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.end,
//       children: [
//         Text(
//           "BOOKING CODE",
//           style: TextStyle(
//             color: Colors.white.withOpacity(0.42),
//             fontSize: 10,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         const SizedBox(height: 4),
//         Text(
//           code,
//           style: TextStyle(
//             color: Colors.white,
//             fontSize: 14,
//             fontWeight: FontWeight.bold,
//             decoration: isCancelled ? TextDecoration.lineThrough : null,
//           ),
//         ),
//       ],
//     );
//   }
// }

// class _TripActions extends StatelessWidget {
//   const _TripActions({
//     required this.trip,
//     required this.isSmall,
//     required this.onTrackingPressed,
//     required this.onCancelPressed,
//     required this.onRatePressed,
//     required this.onViewDetails,
//   });

//   final PassengerTripItemModel trip;
//   final bool isSmall;
//   final VoidCallback onTrackingPressed;
//   final VoidCallback onCancelPressed;
//   final VoidCallback onRatePressed;
//   final VoidCallback onViewDetails;

//   @override
//   Widget build(BuildContext context) {
//     final Widget mainButton = _MainActionButton(
//       trip: trip,
//       onTrackingPressed: onTrackingPressed,
//       onCancelPressed: onCancelPressed,
//       onRatePressed: onRatePressed,
//     );

//     final Widget detailsButton = SizedBox(
//       height: 44,
//       child: OutlinedButton(
//         onPressed: onViewDetails,
//         style: OutlinedButton.styleFrom(
//           side: BorderSide(
//             color: Colors.white.withOpacity(0.16),
//           ),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(14),
//           ),
//         ),
//         child: const Text(
//           "Details",
//           style: TextStyle(
//             color: Colors.white,
//             fontSize: 13,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ),
//     );

//     if (isSmall) {
//       return Column(
//         children: [
//           SizedBox(width: double.infinity, child: mainButton),
//           const SizedBox(height: 10),
//           SizedBox(width: double.infinity, child: detailsButton),
//         ],
//       );
//     }

//     return Row(
//       children: [
//         Expanded(child: mainButton),
//         const SizedBox(width: 10),
//         detailsButton,
//       ],
//     );
//   }
// }

// class _MainActionButton extends StatelessWidget {
//   const _MainActionButton({
//     required this.trip,
//     required this.onTrackingPressed,
//     required this.onCancelPressed,
//     required this.onRatePressed,
//     required this.onSharePressed, 
//   });

//   final PassengerTripItemModel trip;
//   final VoidCallback onTrackingPressed;
//   final VoidCallback onCancelPressed;
//   final VoidCallback onRatePressed;
//   final VoidCallback onSharePressed; 

//   @override
//   Widget build(BuildContext context) {
//     if (trip.isCanceled) {
//       return SizedBox(
//         height: 44,
//         child: ElevatedButton(
//           onPressed: null,
//           style: ElevatedButton.styleFrom(
//             disabledBackgroundColor: AppColor.fifthColor,
//             disabledForegroundColor: Colors.white38,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(14),
//             ),
//           ),
//           child: const Text(
//             "Cancelled Trip",
//             style: TextStyle(
//               fontWeight: FontWeight.bold,
//               fontSize: 13,
//             ),
//           ),
//         ),
//       );
//     }

//     if (trip.isPending) {
//       return _SolidButton(
//         text: "Cancel Booking",
//         icon: Icons.cancel_outlined,
//         color: Colors.redAccent,
//         onPressed: onCancelPressed,
//       );
//     }

//     if (trip.isCompleted) {
//       if (trip.isRated == true) {
//         return SizedBox(
//           height: 44,
//           child: ElevatedButton(
//             onPressed: null,
//             style: ElevatedButton.styleFrom(
//               disabledBackgroundColor: AppColor.fifthColor,
//               disabledForegroundColor: Colors.white38,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(14),
//               ),
//             ),
//             child: const Text(
//               "Already Rated",
//               style: TextStyle(
//                 fontWeight: FontWeight.bold,
//                 fontSize: 13,
//               ),
//             ),
//           ),
//         );
//       }

//       return _SolidButton(
//         text: "Rate Trip",
//         icon: Icons.star_outline,
//         color: Colors.amber,
//         onPressed: onRatePressed,
//       );
//     }

//     // تعديل الحالة النشطة لإضافة زر المشاركة الجانبي
//     if (trip.isActive) {
//       return Row(
//         children: [
//           // زر تتبع الرحلة الأصلي
//           Expanded(
//             child: Container(
//               height: 44,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(14),
//                 gradient: const LinearGradient(
//                   colors: [
//                     AppColor.thirdColor,
//                     AppColor.fourthColor,
//                   ],
//                 ),
//               ),
//               child: ElevatedButton.icon(
//                 onPressed: onTrackingPressed,
//                 icon: const Icon(
//                   Icons.near_me_outlined,
//                   color: Colors.white,
//                   size: 18,
//                 ),
//                 label: const Text(
//                   "Track Trip",
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontWeight: FontWeight.bold,
//                     fontSize: 13,
//                   ),
//                 ),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.transparent,
//                   shadowColor: Colors.transparent,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(14),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           const SizedBox(width: 12), // مسافة فاصلة بين الزرين
//           // زر مشاركة الرحلة الجانبي الجديد بنفس التصميم المتناسق
//           Expanded(
//             child: Container(
//               height: 44,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(14),
//                 gradient: const LinearGradient(
//                   colors: [
//                     AppColor.thirdColor,
//                     AppColor.fourthColor,
//                   ],
//                 ),
//               ),
//               child: ElevatedButton.icon(
//                 onPressed: onSharePressed,
//                 icon: const Icon(
//                   Icons.share_outlined,
//                   color: Colors.white,
//                   size: 18,
//                 ),
//                 label: const Text(
//                   "Share Trip",
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontWeight: FontWeight.bold,
//                     fontSize: 13,
//                   ),
//                 ),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.transparent,
//                   shadowColor: Colors.transparent,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(14),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       );
//     }

//     return SizedBox(
//       height: 44,
//       child: ElevatedButton(
//         onPressed: null,
//         style: ElevatedButton.styleFrom(
//           disabledBackgroundColor: AppColor.fifthColor,
//           disabledForegroundColor: Colors.white38,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(14),
//           ),
//         ),
//         child: const Text(
//           "Unavailable",
//           style: TextStyle(
//             fontWeight: FontWeight.bold,
//             fontSize: 13,
//           ),
//         ),
//       ),
//     );
//   }
// }

// class _SolidButton extends StatelessWidget {
//   const _SolidButton({
//     required this.text,
//     required this.icon,
//     required this.color,
//     required this.onPressed,
//   });

//   final String text;
//   final IconData icon;
//   final Color color;
//   final VoidCallback onPressed;

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: 44,
//       child: ElevatedButton.icon(
//         onPressed: onPressed,
//         icon: Icon(
//           icon,
//           color: Colors.white,
//           size: 18,
//         ),
//         label: Text(
//           text,
//           style: const TextStyle(
//             color: Colors.white,
//             fontWeight: FontWeight.bold,
//             fontSize: 13,
//           ),
//         ),
//         style: ElevatedButton.styleFrom(
//           backgroundColor: color,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(14),
//           ),
//         ),
//       ),
//     );
//   }
// }
