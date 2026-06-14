import 'package:flutter/material.dart';
import 'package:transgo_passenger/core/constant/AppColor.dart';

class AppStateMessage extends StatelessWidget {
  const AppStateMessage({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    this.buttonText,
    this.onPressed,
    this.imagePath,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final String? buttonText;
  final VoidCallback? onPressed;
  final String? imagePath;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (imagePath != null)
              Image.asset(
                imagePath!,
                height: 160,
                fit: BoxFit.contain,
              )
            else
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  color: AppColor.thirdColor.withOpacity(0.12),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColor.thirdColor.withOpacity(0.25),
                  ),
                ),
                child: Icon(
                  icon,
                  color: AppColor.thirdColor,
                  size: 42,
                ),
              ),

            const SizedBox(height: 22),

            Text(
              title,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: theme.hintColor,
                fontSize: 14,
                height: 1.5,
              ),
            ),

            if (buttonText != null && onPressed != null) ...[
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: onPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.thirdColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 28,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                child: Text(
                  buttonText!,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}