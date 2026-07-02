import 'package:flutter/material.dart';
import 'package:transgo_passenger/core/constant/AppColor.dart';
import 'package:transgo_passenger/core/shared/app_network_image.dart';

class PassengerProfileAvatar extends StatelessWidget {
  const PassengerProfileAvatar({
    super.key,
    required this.imageUrl,
    this.size = 92,
    this.showEditIcon = false,
    this.onTap,
  });

  final String imageUrl;
  final double size;
  final bool showEditIcon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          Container(
            width: size,
            height: size,
            padding: const EdgeInsets.all(3),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  AppColor.thirdColor,
                  AppColor.fourthColor,
                ],
              ),
            ),
            child: ClipOval(
              child: AppNetworkImage(
                imageUrl: imageUrl,
                width: size,
                height: size,
                fit: BoxFit.cover,
                fallbackIcon: Icons.person,
                backgroundColor: AppColor.fifthColor,
              ),
            ),
          ),
          if (showEditIcon)
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: AppColor.fourthColor,
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColor.primaryColor,
                  width: 2,
                ),
              ),
              child: const Icon(
                Icons.camera_alt_outlined,
                color: Colors.white,
                size: 16,
              ),
            ),
        ],
      ),
    );
  }
}
