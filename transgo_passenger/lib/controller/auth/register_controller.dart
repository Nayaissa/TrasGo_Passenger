import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:transgo_passenger/core/class/diohelper.dart';
import 'package:transgo_passenger/core/class/statusrequest.dart';
import 'package:transgo_passenger/core/constant/routes.dart';

abstract class RegisterController extends GetxController {
  sendOtp();
  goToLogin();
}

class RegisterControllerImp extends RegisterController {
  GlobalKey<FormState> formstate = GlobalKey<FormState>();

  late TextEditingController name;
  late TextEditingController email;
  late TextEditingController phone;
  late TextEditingController password;
  late TextEditingController confirmPassword;

  StatusRequest? statusRequest;

  bool isPasswordVisible = false;

  void togglePasswordVisibility() {
    isPasswordVisible = !isPasswordVisible;
    update();
  }

  @override
  goToLogin() {
    if (Get.previousRoute == AppRoute.login || Get.previousRoute == '/') {
      Get.back();
      return;
    }

    Get.offNamed(AppRoute.login);
  }

  @override
  sendOtp() async {
    var formdata = formstate.currentState;

    if (formdata!.validate()) {
      if (password.text != confirmPassword.text) {
        Get.snackbar(
          'Warning',
          'Passwords do not match',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      statusRequest = StatusRequest.loading;
      update();

      DioHelper.postsData(
            url: 'v1/passenger/register',
            data: {
              'name': name.text.trim(),
              'email': email.text.trim(),
              'phone': phone.text.trim(),
              'password': password.text,
              'password_confirmation': confirmPassword.text,
            },
          )
          .then((value) {
            print(value!.data);

            if (value.statusCode == 200 || value.statusCode == 201) {
              statusRequest = StatusRequest.success;

              Get.snackbar(
                'Success',
                value.data['message'] ?? 'Verification code sent successfully',
              );

              Get.toNamed(
                AppRoute.verfiyCodeSignUp,
                arguments: {
                  'email': email.text.trim(),

                  'title': 'Verify Account',
                  'subtitle':
                      'Enter the verification code sent to\nyour email at ',
                  'buttonText': 'Verify Account',

                  'verifyUrl': '/v1/auth/verify-otp',
                  'resendUrl': '/v1/auth/resend-otp',

                  'successRoute': AppRoute.successSignUp,
                },
              );

              update();
            } else {
              statusRequest = StatusRequest.failure;

              Get.snackbar(
                'Warning',
                value.data['message'] ?? 'Something went wrong',
              );

              update();
            }
          })
          .catchError((error) {
            print(error.toString());

            statusRequest = StatusRequest.serverfailure;

            Get.snackbar('Error', 'Server error, please try again');

            update();
          });

      update();
    }
  }

  @override
  void onInit() {
    name = TextEditingController();
    email = TextEditingController();
    phone = TextEditingController();
    password = TextEditingController();
    confirmPassword = TextEditingController();
    super.onInit();
  }

  @override
  void onClose() {
    name.dispose();
    email.dispose();
    phone.dispose();
    password.dispose();
    confirmPassword.dispose();
    super.onClose();
  }
}
// Get.toNamed(
//   AppRoute.verfiyCodeSignUp,
//   arguments: {
//     'email': email.text.trim(),

//     'title': 'Verify Reset Code',
//     'subtitle': 'Enter the reset code sent to\nyour email at ',
//     'buttonText': 'Verify Code',

//     'verifyUrl': '/v1/auth/verify-otp',
//     'resendUrl': '/v1/auth/resend-otp',

//     'successRoute': AppRoute.resetPassword,

//     'nextArguments': {
//       'email': email.text.trim(),
//     },
//   },
// );
