import 'package:flutter/material.dart';
import 'package:transgo_passenger/core/constant/AppColor.dart';

class TripsSummaryCard extends StatelessWidget {
  const TripsSummaryCard({
    super.key,
    required this.destination,
    required this.from,
    required this.mode,
  });

  final String destination;
  final String from;
  final String mode;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColor.cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withOpacity(0.08),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: _SummaryItem(
              title: "DESTINATION",
              value: destination,
              valueDirection: TextDirection.rtl,
            ),
          ),
          Expanded(
            child: _SummaryItem(
              title: "FROM",
              value: from,
              valueDirection: TextDirection.rtl,
            ),
          ),
          Expanded(
            child: _SummaryItem(
              title: "MODE",
              value: mode,
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryItem extends StatelessWidget {
  const _SummaryItem({
    required this.title,
    required this.value,
    this.valueDirection,
  });

  final String title;
  final String value;
  final TextDirection? valueDirection;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: theme.hintColor,
            fontSize: 11,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textDirection: valueDirection,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
        ),
      ],
    );
  }
}