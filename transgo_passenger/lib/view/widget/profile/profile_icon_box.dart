import 'package:flutter/material.dart';
import 'package:transgo_passenger/core/constant/AppColor.dart';

class ProfileIconBox extends StatelessWidget {
  const ProfileIconBox({
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
        color: AppColor.thirdColor.withOpacity(0.14),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Icon(
        icon,
        color: AppColor.thirdColor,
        size: 21,
      ),
    );
  }
}