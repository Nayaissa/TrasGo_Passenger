import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:transgo_passenger/core/constant/routes.dart';
import 'package:transgo_passenger/view/screen/auth/auth_success_screen.dart';

class SuccessSignUpScreen extends StatelessWidget {
  const SuccessSignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthSuccessScreen(
      title: "Account Created Successfully",
      subtitle:
          "Your account has been verified successfully. You can now login and start using TransGo.",
      buttonText: "Back to Login",
      secureText: "Your account is secure and ready to use.",
      statusSubtitle: "Account verification completed",
      icon: Icons.check,
      onPressed: () {
        Get.offAllNamed(AppRoute.login);
      },
    );
  }
}