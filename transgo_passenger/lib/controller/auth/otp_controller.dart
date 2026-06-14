// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:transgo_passenger/core/class/diohelper.dart';
// import 'package:transgo_passenger/core/class/statusrequest.dart';
// import 'package:transgo_passenger/core/constant/routes.dart';

// abstract class VerificationController extends GetxController {
//   verifyAccount();
//   // resendCode();
//   startTimer();
// }

// class VerificationControllerImp extends VerificationController {
//   late List<TextEditingController> otpControllers;
//   late List<FocusNode> focusNodes;

//   StatusRequest? statusRequest;

//   int secondsRemaining = 28;
//   Timer? timer;
//   bool canResend = false;

//   String email = "";
//   String name = "";
//   String password = "";

//   @override
//   void onInit() {
//     otpControllers = List.generate(6, (index) => TextEditingController());
//     focusNodes = List.generate(6, (index) => FocusNode());

//     email = Get.arguments?['email']?.toString() ?? "";
//     name = Get.arguments?['name']?.toString() ?? "";
//     password = Get.arguments?['password']?.toString() ?? "";

//     startTimer();

//     super.onInit();
//   }

//   String getOtpCode() {
//     return otpControllers.map((controller) => controller.text).join();
//   }

//   @override
//   startTimer() {
//     timer?.cancel();

//     canResend = false;
//     secondsRemaining = 28;
//     update();

//     timer = Timer.periodic(const Duration(seconds: 1), (t) {
//       if (secondsRemaining > 0) {
//         secondsRemaining--;
//         update();
//       } else {
//         canResend = true;
//         t.cancel();
//         update();
//       }
//     });
//   }

//   @override
//   verifyAccount() async {
//     String otp = getOtpCode();

//     if (otp.length < 6) {
//       Get.snackbar(
//         "Warning",
//         "Please enter the complete verification code",
//         snackPosition: SnackPosition.BOTTOM,
//       );
//       return;
//     }

//     statusRequest = StatusRequest.loading;
//     update();

//     DioHelper.postsData(
//       url: '/v1/auth/verify-otp',
//       data: {
//         'email':email ,
//         'code': otp,
//       },
//     ).then((value) {
//       print(value!.data);

//       if (value.statusCode == 200 || value.statusCode == 201) {
//         statusRequest = StatusRequest.success;

//         Get.snackbar(
//           "Success",
//           value.data['message'] ?? "Account verified successfully",
//         );

//         Get.offAllNamed(AppRoute.successSignUp);

//         update();
//       } else {
//         statusRequest = StatusRequest.failure;

//         Get.snackbar(
//           "Warning",
//           value.data['message'] ?? "Invalid verification code",
//         );

//         update();
//       }
//     }).catchError((error) {
//       print(error.toString());

//       statusRequest = StatusRequest.serverfailure;

//       Get.snackbar(
//         "Error",
//         "Server error, please try again",
//       );

//       update();
//     });

//     update();
//   }

//   // @override
//   // resendCode() {
//   //   if (!canResend) return;

//   //   statusRequest = StatusRequest.loading;
//   //   update();

//   //   DioHelper.postsData(
//   //     // عدّل الرابط حسب API عندك
//   //     url: 'v1/passenger/resend-code',
//   //     data: {
//   //       'phone': email,
//   //     },
//   //   ).then((value) {
//   //     print(value!.data);

//   //     if (value.statusCode == 200 || value.statusCode == 201) {
//   //       statusRequest = StatusRequest.success;

//   //       Get.snackbar(
//   //         "Success",
//   //         value.data['message'] ?? "Verification code resent successfully",
//   //       );

//   //       clearOtpFields();
//   //       startTimer();
//   //     } else {
//   //       statusRequest = StatusRequest.failure;

//   //       Get.snackbar(
//   //         "Warning",
//   //         value.data['message'] ?? "Could not resend code",
//   //       );
//   //     }

//   //     update();
//   //   }).catchError((error) {
//   //     print(error.toString());

//   //     statusRequest = StatusRequest.serverfailure;

//   //     Get.snackbar(
//   //       "Error",
//   //       "Server error, please try again",
//   //     );

//   //     update();
//   //   });
//   // }

//   void clearOtpFields() {
//     for (var controller in otpControllers) {
//       controller.clear();
//     }

//     if (focusNodes.isNotEmpty) {
//       focusNodes.first.requestFocus();
//     }

//     update();
//   }

//   String getHiddenEmail() {
//   if (email.isEmpty) {
//     return "your email";
//   }

//   if (!email.contains("@")) {
//     return email;
//   }

//   final parts = email.split("@");
//   final username = parts[0];
//   final domain = parts[1];

//   if (username.length == 1) {
//     return "${username[0]}***@$domain";
//   }

//   if (username.length == 2) {
//     return "${username[0]}***${username[1]}@$domain";
//   }

//   return "${username.substring(0, 2)}***${username.substring(username.length - 1)}@$domain";
// }

//   @override
//   void dispose() {
//     timer?.cancel();

//     for (var controller in otpControllers) {
//       controller.dispose();
//     }

//     for (var node in focusNodes) {
//       node.dispose();
//     }

//     super.dispose();
//   }
// }
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:transgo_passenger/core/class/diohelper.dart';
import 'package:transgo_passenger/core/class/statusrequest.dart';
import 'package:transgo_passenger/core/constant/routes.dart';

abstract class VerificationController extends GetxController {
  verifyAccount();
  resendCode();
  startTimer();
}

class VerificationControllerImp extends VerificationController {
  late List<TextEditingController> otpControllers;
  late List<FocusNode> focusNodes;

  StatusRequest? statusRequest;

  int secondsRemaining = 28;
  Timer? timer;
  bool canResend = false;

  String email = "";

  // هذه القيم ديناميكية وتتغير حسب المكان الذي يفتح صفحة OTP
  String title = "Verify Account";
  String subtitle = "Enter the verification code sent to\nyour email at ";
  String buttonText = "Verify Account";

  String verifyUrl = "/v1/auth/verify-otp";
  String resendUrl = "/v1/auth/resend-otp";

  String successRoute = AppRoute.successSignUp;

  Map<String, dynamic>? nextArguments;

  @override
  void onInit() {
    otpControllers = List.generate(6, (index) => TextEditingController());
    focusNodes = List.generate(6, (index) => FocusNode());

    final arguments = Get.arguments;

    email = arguments?['email']?.toString() ?? "";

    title = arguments?['title']?.toString() ?? "Verify Account";

    subtitle = arguments?['subtitle']?.toString() ??
        "Enter the verification code sent to\nyour email at ";

    buttonText = arguments?['buttonText']?.toString() ?? "Verify Account";

    verifyUrl = arguments?['verifyUrl']?.toString() ?? "/v1/auth/verify-otp";

    resendUrl = arguments?['resendUrl']?.toString() ?? "/v1/auth/resend-otp";

    successRoute =
        arguments?['successRoute']?.toString() ?? AppRoute.successSignUp;

    final dynamic args = arguments?['nextArguments'];
    if (args is Map<String, dynamic>) {
      nextArguments = args;
    }

    startTimer();

    super.onInit();
  }

  String getOtpCode() {
    return otpControllers.map((controller) => controller.text).join();
  }

  String getHiddenEmail() {
    if (email.isEmpty) {
      return "your email";
    }

    if (!email.contains("@")) {
      return email;
    }

    final parts = email.split("@");
    final username = parts[0];
    final domain = parts[1];

    if (username.length == 1) {
      return "${username[0]}***@$domain";
    }

    if (username.length == 2) {
      return "${username[0]}***${username[1]}@$domain";
    }

    return "${username.substring(0, 2)}***${username.substring(username.length - 1)}@$domain";
  }

  @override
  startTimer() {
    timer?.cancel();

    canResend = false;
    secondsRemaining = 28;
    update();

    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (secondsRemaining > 0) {
        secondsRemaining--;
        update();
      } else {
        canResend = true;
        t.cancel();
        update();
      }
    });
  }

  @override
  verifyAccount() async {
    String otp = getOtpCode();

    if (otp.length < 6) {
      Get.snackbar(
        "Warning",
        "Please enter the complete verification code",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    statusRequest = StatusRequest.loading;
    update();

    DioHelper.postsData(
      url: verifyUrl,
      data: {
        'email': email,
        'otp': otp,
      },
    ).then((value) {
      print(value!.data);

      if (value.statusCode == 200 || value.statusCode == 201) {
        statusRequest = StatusRequest.success;

        Get.snackbar(
          "Success",
          value.data['message'] ?? "Verification completed successfully",
        );

        Get.offAllNamed(
          successRoute,
          arguments: {
            'email': email,
            'code': otp,
            if (nextArguments != null) ...nextArguments!,
          },
        );

        update();
      } else {
        statusRequest = StatusRequest.failure;

        Get.snackbar(
          "Warning",
          value.data['message'] ?? "Invalid verification code",
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
  }

  @override
  resendCode() {
    if (!canResend) return;

    statusRequest = StatusRequest.loading;
    update();

    DioHelper.postsData(
      url: resendUrl,
      data: {
        'email': email,
      },
    ).then((value) {
      print(value!.data);

      if (value.statusCode == 200 || value.statusCode == 201) {
        statusRequest = StatusRequest.success;

        Get.snackbar(
          "Success",
          value.data['message'] ?? "Verification code resent successfully",
        );

        clearOtpFields();
        startTimer();

        update();
      } else {
        statusRequest = StatusRequest.failure;

        Get.snackbar(
          "Warning",
          value.data['message'] ?? "Could not resend code",
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
  }

  void clearOtpFields() {
    for (var controller in otpControllers) {
      controller.clear();
    }

    if (focusNodes.isNotEmpty) {
      focusNodes.first.requestFocus();
    }

    update();
  }

  @override
  void onClose() {
    timer?.cancel();

    for (var controller in otpControllers) {
      controller.dispose();
    }

    for (var node in focusNodes) {
      node.dispose();
    }

    super.onClose();
  }
}