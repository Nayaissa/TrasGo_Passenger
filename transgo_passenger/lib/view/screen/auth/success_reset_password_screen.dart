import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:transgo_passenger/core/constant/routes.dart';
import 'package:transgo_passenger/view/screen/auth/auth_success_screen.dart';

class SuccessResetPasswordScreen extends StatelessWidget {
  const SuccessResetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthSuccessScreen(
      title: "Password Reset Successfully",
      subtitle:
          "Your password has been changed successfully. You can now login with your new password.",
      buttonText: "Back to Login",
      secureText: "Your new password has been saved securely.",
      statusSubtitle: "Password reset completed",
      icon: Icons.lock_reset,
      onPressed: () {
        Get.offAllNamed(AppRoute.login);
      },
    );
  }
}