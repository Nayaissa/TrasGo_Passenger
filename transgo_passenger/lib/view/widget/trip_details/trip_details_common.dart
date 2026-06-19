import 'package:flutter/material.dart';
import 'package:transgo_passenger/core/constant/AppColor.dart';

class TripDetailsCard extends StatelessWidget {
  const TripDetailsCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(18),
  });

  final Widget child;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: AppColor.cardColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Colors.white.withOpacity(0.08),
        ),
      ),
      child: child,
    );
  }
}

class TripDetailsSquareIcon extends StatelessWidget {
  const TripDetailsSquareIcon({
    super.key,
    required this.icon,
  });

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        color: AppColor.fifthColor,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Icon(
        icon,
        color: AppColor.thirdColor,
        size: 22,
      ),
    );
  }
}

class TripDetailsOutlineButton extends StatelessWidget {
  const TripDetailsOutlineButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  final String text;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 43,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          side: BorderSide(
            color: Colors.white.withOpacity(0.12),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
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
