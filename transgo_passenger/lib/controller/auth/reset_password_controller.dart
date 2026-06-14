import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:transgo_passenger/core/class/diohelper.dart';
import 'package:transgo_passenger/core/class/statusrequest.dart';
import 'package:transgo_passenger/core/constant/routes.dart';

abstract class ResetPasswordController extends GetxController {
  updatePassword();
  togglePasswordVisibility();
  toggleConfirmPasswordVisibility();
  onPasswordChanged(String value);
}

class ResetPasswordControllerImp extends ResetPasswordController {
  GlobalKey<FormState> formstate = GlobalKey<FormState>();

  late TextEditingController password;
  late TextEditingController confirmPassword;

  StatusRequest? statusRequest;

  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;

  String email = "";
  String code = "";

  String passwordError = "";
  String securityStatus = "WEAK";
  double securityPercentage = 0.0;
  Color securityColor = const Color(0xFFE57373);

  @override
  void onInit() {
    password = TextEditingController();
    confirmPassword = TextEditingController();

    email = Get.arguments?['email']?.toString() ?? "";
    code = Get.arguments?['code']?.toString() ?? "";

    super.onInit();
  }

  @override
  togglePasswordVisibility() {
    isPasswordVisible = !isPasswordVisible;
    update();
  }

  @override
  toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisible = !isConfirmPasswordVisible;
    update();
  }

  @override
  onPasswordChanged(String value) {
    if (value.isEmpty) {
      passwordError = "";
      securityStatus = "WEAK";
      securityPercentage = 0.0;
      securityColor = const Color(0xFFE57373);
      update();
      return;
    }

    if (value.length < 6) {
      passwordError = "Password must be at least 6 characters";
      securityStatus = "WEAK";
      securityPercentage = 0.33;
      securityColor = const Color(0xFFE57373);
    } else if (value.length >= 6 && value.length < 10) {
      passwordError = "";
      securityStatus = "MEDIUM";
      securityPercentage = 0.66;
      securityColor = Colors.orangeAccent;
    } else {
      passwordError = "";
      securityStatus = "STRONG";
      securityPercentage = 1.0;
      securityColor = const Color(0xFF4DE2A6);
    }

    update();
  }

  @override
  updatePassword() async {
    var formdata = formstate.currentState;

    if (formdata!.validate()) {
      if (password.text != confirmPassword.text) {
        Get.snackbar(
          "Warning",
          "Passwords do not match",
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      statusRequest = StatusRequest.loading;
      update();

      DioHelper.postsData(
        url: "/v1/auth/reset-password",
        data: {
          "email": email,
          // "code": code,
          "password": password.text,
          "password_confirmation": confirmPassword.text,
        },
      ).then((value) {
        print(value!.data);

        if (value.statusCode == 200 || value.statusCode == 201) {
          statusRequest = StatusRequest.success;

          Get.snackbar(
            "Success",
            value.data["message"] ?? "Password updated successfully",
          );

          Get.offAllNamed(AppRoute.successReset);

          update();
        } else {
          statusRequest = StatusRequest.failure;

          Get.snackbar(
            "Warning",
            value.data["message"] ?? "Something went wrong",
          );

          update();
        }
      }).catchError((error) {
        print(error.toString());

        statusRequest = StatusRequest.serverfailure;

        Get.snackbar(
          "Error",
          "Server error, please try again",
        );

        update();
      });

      update();
    }
  }

  @override
  void onClose() {
    password.dispose();
    confirmPassword.dispose();
    super.onClose();
  }
}