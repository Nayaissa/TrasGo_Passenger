import 'package:flutter/material.dart';
import 'package:transgo_passenger/core/constant/AppColor.dart';
import 'package:transgo_passenger/data/model/notification_model.dart';

class NotificationHeader extends StatelessWidget {
  const NotificationHeader({
    super.key,
    required this.count,
  });

  final int count;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: Row(
        children: [
          Expanded(
            child: Text(
              "Stay updated about your trips and bookings.",
              style: TextStyle(
                color: Colors.white.withOpacity(0.52),
                fontSize: 14,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 6,
            ),
            decoration: BoxDecoration(
              color: AppColor.fifthColor,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: Colors.white.withOpacity(0.08),
              ),
            ),
            child: Text(
              "$count",
              style: const TextStyle(
                color: AppColor.thirdColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class NotificationCard extends StatelessWidget {
  const NotificationCard({
    super.key,
    required this.item,
    required this.onTap,
  });

  final PassengerNotificationItem item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(22),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: AppColor.cardColor,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: item.isRead
                ? Colors.white.withOpacity(0.07)
                : item.color.withOpacity(0.35),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _NotificationIcon(item: item),
            const SizedBox(width: 13),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _NotificationTopRow(item: item),
                  const SizedBox(height: 8),
                  Text(
                    item.title,
                    textDirection: TextDirection.rtl,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    item.body,
                    textDirection: TextDirection.rtl,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.55),
                      fontSize: 13,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NotificationIcon extends StatelessWidget {
  const _NotificationIcon({
    required this.item,
  });

  final PassengerNotificationItem item;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: item.color.withOpacity(0.14),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Icon(
        item.icon,
        color: item.color,
        size: 23,
      ),
    );
  }
}

class _NotificationTopRow extends StatelessWidget {
  const _NotificationTopRow({
    required this.item,
  });

  final PassengerNotificationItem item;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _NotificationBadge(item: item),
        const Spacer(),
        Text(
          item.timeText,
          style: TextStyle(
            color: Colors.white.withOpacity(0.40),
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
        if (!item.isRead) ...[
          const SizedBox(width: 7),
          Container(
            width: 7,
            height: 7,
            decoration: BoxDecoration(
              color: item.color,
              shape: BoxShape.circle,
            ),
          ),
        ],
      ],
    );
  }
}

class _NotificationBadge extends StatelessWidget {
  const _NotificationBadge({
    required this.item,
  });

  final PassengerNotificationItem item;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 9,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: item.color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        item.badgeText,
        style: TextStyle(
          color: item.color,
          fontSize: 10,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}