import 'package:flutter/material.dart';
import 'package:transgo_passenger/core/constant/AppColor.dart';

class TripRoutePointData {
  final String title;
  final String subtitle;
  final TripRoutePointType type;

  const TripRoutePointData({
    required this.title,
    required this.subtitle,
    required this.type,
  });
}

enum TripRoutePointType {
  start,
  pickup,
  end,
}

class TripRoutePointsList extends StatelessWidget {
  const TripRoutePointsList({
    super.key,
    required this.points,
    this.activeColor = AppColor.thirdColor,
    this.pickupColor = AppColor.fourthColor,
    this.endColor = Colors.white54,
  });

  final List<TripRoutePointData> points;
  final Color activeColor;
  final Color pickupColor;
  final Color endColor;

  @override
  Widget build(BuildContext context) {
    if (points.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: List.generate(points.length, (index) {
        final point = points[index];
        final bool isLast = index == points.length - 1;

        return _TripRoutePointItem(
          point: point,
          isLast: isLast,
          activeColor: activeColor,
          pickupColor: pickupColor,
          endColor: endColor,
        );
      }),
    );
  }
}

class _TripRoutePointItem extends StatelessWidget {
  const _TripRoutePointItem({
    required this.point,
    required this.isLast,
    required this.activeColor,
    required this.pickupColor,
    required this.endColor,
  });

  final TripRoutePointData point;
  final bool isLast;
  final Color activeColor;
  final Color pickupColor;
  final Color endColor;

  @override
  Widget build(BuildContext context) {
    final Color color = _pointColor();
    final IconData icon = _pointIcon();

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: Text(
                point.subtitle,
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
              point.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
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
              color: color,
              size: 14,
            ),
          ],
        ),

        if (!isLast)
          Container(
            margin: const EdgeInsets.only(
              right: 6,
              top: 4,
              bottom: 4,
            ),
            height: 26,
            width: 1.5,
            color: color.withOpacity(0.35),
          ),
      ],
    );
  }

  Color _pointColor() {
    switch (point.type) {
      case TripRoutePointType.start:
        return activeColor;
      case TripRoutePointType.pickup:
        return pickupColor;
      case TripRoutePointType.end:
        return endColor;
    }
  }

  IconData _pointIcon() {
    switch (point.type) {
      case TripRoutePointType.start:
        return Icons.radio_button_unchecked;
      case TripRoutePointType.pickup:
        return Icons.location_on_outlined;
      case TripRoutePointType.end:
        return Icons.circle;
    }
  }
}