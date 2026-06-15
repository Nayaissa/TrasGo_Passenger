import 'package:flutter/material.dart';
import 'package:transgo_passenger/core/constant/AppColor.dart';
import 'package:transgo_passenger/core/shared/app_network_image.dart';

class AvailableTripCard extends StatelessWidget {
  const AvailableTripCard({
    super.key,
    required this.price,
    required this.currency,
    required this.from,
    required this.fromDetails,
    required this.to,
    required this.toDetails,
    required this.seats,
    required this.type,
    required this.status,
    required this.rating,
    required this.driverName,
    required this.carType,
    required this.driverImage,
    this.onBookNow,
    this.onViewDetails,
  });

  final String price;
  final String currency;
  final String from;
  final String fromDetails;
  final String to;
  final String toDetails;
  final String seats;
  final String type;
  final String status;
  final String rating;
  final String driverName;
  final String carType;
  final String driverImage;
  final VoidCallback? onBookNow;
  final VoidCallback? onViewDetails;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColor.cardColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Colors.white.withOpacity(0.08),
        ),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _PriceSection(
                price: price,
                currency: currency,
              ),

              const SizedBox(width: 12),

              Expanded(
                child: _RouteSection(
                  from: from,
                  fromDetails: fromDetails,
                  to: to,
                  toDetails: toDetails,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          Wrap(
            alignment: WrapAlignment.end,
            spacing: 6,
            runSpacing: 8,
            children: [
              _TripTag(
                text: rating,
                icon: Icons.star_rounded,
                backgroundColor: const Color(0xFF2C1B4D),
                textColor: Colors.amber,
                iconColor: Colors.amber,
              ),
              _TripTag(
                text: status,
                backgroundColor: const Color(0xFF142A4A),
                textColor: AppColor.thirdColor,
              ),
              _TripTag(
                text: type,
                backgroundColor: AppColor.fifthColor,
                textColor: theme.hintColor,
              ),
              _TripTag(
                text: seats,
                backgroundColor: AppColor.fifthColor,
                textColor: theme.hintColor,
              ),
            ],
          ),

          const Divider(
            color: Colors.white10,
            height: 28,
          ),

          Row(
            children: [
              _GradientButton(
                text: "Book Now",
                onPressed: onBookNow,
              ),

              const SizedBox(width: 8),

              SizedBox(
                height: 38,
                child: OutlinedButton(
                  onPressed: onViewDetails,
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(
                      color: theme.hintColor.withOpacity(0.45),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "View Details",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),

              const Spacer(),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      driverName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      carType,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: theme.hintColor,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 10),

              AppNetworkImage(
                imageUrl: driverImage,
                width: 38,
                height: 38,
                borderRadius: 19,
                fallbackIcon: Icons.person,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PriceSection extends StatelessWidget {
  const _PriceSection({
    required this.price,
    required this.currency,
  });

  final String price;
  final String currency;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          price,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          currency,
          style: TextStyle(
            color: theme.hintColor,
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
  });

  final String from;
  final String fromDetails;
  final String to;
  final String toDetails;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        _RoutePoint(
          title: from,
          subtitle: fromDetails,
          icon: Icons.radio_button_unchecked,
          iconColor: AppColor.thirdColor,
        ),

        Container(
          margin: const EdgeInsets.only(right: 6, top: 4, bottom: 4),
          height: 24,
          width: 1.5,
          color: AppColor.thirdColor.withOpacity(0.35),
        ),

        _RoutePoint(
          title: to,
          subtitle: toDetails,
          icon: Icons.circle,
          iconColor: AppColor.thirdColor,
        ),
      ],
    );
  }
}

class _RoutePoint extends StatelessWidget {
  const _RoutePoint({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
              color: theme.hintColor,
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
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(width: 8),
        Icon(
          icon,
          color: iconColor,
          size: 14,
        ),
      ],
    );
  }
}

class _TripTag extends StatelessWidget {
  const _TripTag({
    required this.text,
    required this.backgroundColor,
    required this.textColor,
    this.icon,
    this.iconColor,
  });

  final String text;
  final Color backgroundColor;
  final Color textColor;
  final IconData? icon;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 5,
      ),
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
              color: iconColor ?? textColor,
              size: 13,
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

class _GradientButton extends StatelessWidget {
  const _GradientButton({
    required this.text,
    this.onPressed,
  });

  final String text;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 38,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: const LinearGradient(
          colors: [
            AppColor.thirdColor,
            AppColor.fourthColor,
          ],
        ),
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}