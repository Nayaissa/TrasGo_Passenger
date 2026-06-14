import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:transgo_passenger/core/class/diohelper.dart';
import 'package:transgo_passenger/core/class/statusrequest.dart';
import 'package:transgo_passenger/core/constant/routes.dart';

abstract class SendOtpController extends GetxController {
  sendOtp();
  goToLogin();
}

class SendOtpControllerImp extends SendOtpController {
  GlobalKey<FormState> formstate = GlobalKey<FormState>();

  late TextEditingController email;

  StatusRequest? statusRequest;

  @override
  void onInit() {
    email = TextEditingController();
    super.onInit();
  }

  @override
  sendOtp() async {
    var formdata = formstate.currentState;

    if (formdata!.validate()) {
      statusRequest = StatusRequest.loading;
      update();

      DioHelper.postsData(
        // عدّل الرابط حسب API عندك
        url: '/v1/auth/send-otp',
        data: {
          'email': email.text.trim(),
        },
      ).then((value) {
        print(value!.data);

        if (value.statusCode == 200 || value.statusCode == 201) {
          statusRequest = StatusRequest.success;

          Get.snackbar(
            "Success",
            value.data['message'] ?? "Verification code sent successfully",
          );

          Get.toNamed(
            AppRoute.verfiyCodeSignUp,
            arguments: {
              'email': email.text.trim(),

              // بيانات صفحة OTP
              'title': 'Verify Reset Code',
              'subtitle': 'Enter the reset code sent to\nyour email at ',
              'buttonText': 'Verify Code',

              // روابط التحقق وإعادة الإرسال
              'verifyUrl': '/v1/auth/verify-otp',
              'resendUrl': '/v1/auth/send-otp',

              // بعد نجاح التحقق يذهب لصفحة Reset Password
              'successRoute': AppRoute.resetPassword,

              // هذه ستصل إلى ResetPasswordScreen
              'nextArguments': {
                'email': email.text.trim(),
              },
            },
          );

          update();
        } else {
          statusRequest = StatusRequest.failure;

          Get.snackbar(
            "Warning",
            value.data['message'] ?? "Something went wrong",
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
  goToLogin() {
    Get.offNamed(AppRoute.login);
  }

  @override
  void onClose() {
    email.dispose();
    super.onClose();
  }
}