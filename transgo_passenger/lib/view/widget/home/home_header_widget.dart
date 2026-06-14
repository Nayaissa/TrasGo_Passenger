import 'package:flutter/material.dart';
import 'package:transgo_passenger/core/constant/AppColor.dart';

class HomeHeaderWidget extends StatelessWidget {
  const HomeHeaderWidget({
    super.key,
    required this.title,
    required this.subtitle,
    this.onNotificationTap,
  });

  final String title;
  final String subtitle;
  final VoidCallback? onNotificationTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  color: theme.hintColor,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            color: AppColor.cardColor,
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white.withOpacity(0.08),
            ),
          ),
          child: IconButton(
            onPressed: onNotificationTap,
            icon: const Icon(
              Icons.notifications_none_outlined,
              color: Colors.white,
              size: 24,
            ),
          ),
        ),
      ],
    );
  }
}