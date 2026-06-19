// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:get/get.dart';
// import 'package:transgo_passenger/controller/auth/otp_controller.dart';
// import 'package:transgo_passenger/core/class/statusrequest.dart';
// import 'package:transgo_passenger/core/constant/AppColor.dart';
// import 'package:transgo_passenger/view/widget/auth/custom_auth_button_widget.dart';

// class VerificationScreen extends StatelessWidget {
//   const VerificationScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);

//     Get.put(VerificationControllerImp());

//     return Scaffold(
//       body: GetBuilder<VerificationControllerImp>(
//         builder: (controller) {
//           return Container(
//             width: double.infinity,
//             height: double.infinity,
//             decoration: const BoxDecoration(
//               gradient: LinearGradient(
//                 begin: Alignment.topCenter,
//                 end: Alignment.bottomCenter,
//                 colors: [AppColor.primaryColor, AppColor.secondaryColor],
//               ),
//             ),
//             child: SafeArea(
//               child: SingleChildScrollView(
//                 padding: const EdgeInsets.symmetric(horizontal: 24.0),
//                 child: Column(
//                   children: [
//                     const SizedBox(height: 10),

//                     Align(
//                       alignment: Alignment.centerLeft,
//                       child: IconButton(
//                         onPressed: () {
//                           Get.back();
//                         },
//                         icon: const Icon(
//                           Icons.arrow_back,
//                           color: AppColor.thirdColor,
//                         ),
//                       ),
//                     ),

//                     // Image.asset(
//                     //   'assets/images/download.png',
//                     //   height: 170,
//                     //   fit: BoxFit.fill,
//                     // ),
//                     Container(
//                       width: double.infinity,
//                       padding: const EdgeInsets.all(24),
//                       decoration: BoxDecoration(
//                         color: AppColor.cardColor,
//                         borderRadius: BorderRadius.circular(28),
//                         border: Border.all(color: Colors.white10),
//                       ),
//                       child: Column(
//                         children: [
//                           Container(
//                             padding: EdgeInsets.all(16),
//                             decoration: BoxDecoration(
//                               color: AppColor.fifthColor,
//                               shape: BoxShape.circle,
//                               border: Border.all(
//                                 color: AppColor.thirdColor.withOpacity(0.25),
//                               ),
//                             ),
//                             child: const Icon(
//                               Icons.verified_user_outlined,
//                               color: AppColor.thirdColor,
//                               size: 42,
//                             ),
//                           ),

//                           const SizedBox(height: 24),

//                           Text(
//                             "Verify Account",
//                             style: Theme.of(
//                               context,
//                             ).textTheme.headlineSmall!.copyWith(
//                               color: Colors.white,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),

//                           const SizedBox(height: 12),

//                           Text.rich(
//   TextSpan(
//     text: "Enter the verification code sent to\nyour email at ",
//     style: TextStyle(
//       color: theme.hintColor,
//       fontSize: 14,
//       height: 1.5,
//     ),
//     children: [
//       TextSpan(
//         text: controller.getHiddenEmail(),
//         style: const TextStyle(
//           color: Colors.white,
//           fontWeight: FontWeight.bold,
//         ),
//       ),
//     ],
//   ),
//   textAlign: TextAlign.center,
// ),

//                           const SizedBox(height: 32),

//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: List.generate(
//                               6,
//                               (index) =>
//                                   _buildOtpBox(context, index, controller),
//                             ),
//                           ),

//                           const SizedBox(height: 32),

//                           CustomAuthButton(
//                             text: "Verify Account",
//                             isLoading:
//                                 controller.statusRequest ==
//                                 StatusRequest.loading,
//                             onPressed: () {
//                               controller.verifyAccount();
//                             },
//                           ),

//                           const SizedBox(height: 24),

//                           Text(
//                             "Didn't receive the code?",
//                             style: TextStyle(
//                               color: theme.hintColor,
//                               fontSize: 14,
//                             ),
//                           ),

//                           const SizedBox(height: 4),

//                           // GestureDetector(
//                           //   onTap:
//                           //       controller.canResend
//                           //           ? () {
//                           //             controller.resendCode();
//                           //           }
//                           //           : null,
//                           //   child: Text(
//                           //     controller.canResend
//                           //         ? "Resend Now"
//                           //         : "Resend in ${controller.secondsRemaining}s",
//                           //     style: TextStyle(
//                           //       color:
//                           //           controller.canResend
//                           //               ? Colors.white
//                           //               : theme.hintColor,
//                           //       fontSize: 16,
//                           //       fontWeight: FontWeight.bold,
//                           //     ),
//                           //   ),
//                           // ),
//                         ],
//                       ),
//                     ),

//                     const SizedBox(height: 40),

//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Icon(
//                           Icons.chat_bubble_outline,
//                           color: theme.hintColor,
//                           size: 18,
//                         ),
//                         const SizedBox(width: 8),
//                         Text(
//                           "Contact TransGo Support",
//                           style: TextStyle(
//                             color: theme.hintColor,
//                             fontSize: 14,
//                           ),
//                         ),
//                       ],
//                     ),

//                     const SizedBox(height: 30),
//                   ],
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }

//   Widget _buildOtpBox(
//     BuildContext context,
//     int index,
//     VerificationControllerImp controller,
//   ) {
//     return SizedBox(
//       width: 45,
//       height: 56,
//       child: TextFormField(
//         controller: controller.otpControllers[index],
//         focusNode: controller.focusNodes[index],
//         textAlign: TextAlign.center,
//         keyboardType: TextInputType.number,
//         maxLength: 1,
//         inputFormatters: [FilteringTextInputFormatter.digitsOnly],
//         style: const TextStyle(
//           color: Colors.white,
//           fontSize: 20,
//           fontWeight: FontWeight.bold,
//         ),
//         decoration: InputDecoration(
//           counterText: "",
//           filled: true,
//           fillColor: AppColor.fifthColor,
//           contentPadding: EdgeInsets.zero,
//           enabledBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(12),
//             borderSide: BorderSide(color: Colors.white.withOpacity(0.08)),
//           ),
//           focusedBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(12),
//             borderSide: const BorderSide(color: AppColor.thirdColor, width: 2),
//           ),
//           errorBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(12),
//             borderSide: const BorderSide(color: Colors.red),
//           ),
//           focusedErrorBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(12),
//             borderSide: const BorderSide(color: Colors.red),
//           ),
//         ),
//         onChanged: (value) {
//           if (value.isNotEmpty && index < 5) {
//             controller.focusNodes[index + 1].requestFocus();
//           } else if (value.isEmpty && index > 0) {
//             controller.focusNodes[index - 1].requestFocus();
//           }

//           if (index == 5 && value.isNotEmpty) {
//             FocusScope.of(context).unfocus();
//           }
//         },
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:transgo_passenger/controller/auth/otp_controller.dart';
import 'package:transgo_passenger/core/class/statusrequest.dart';
import 'package:transgo_passenger/core/constant/AppColor.dart';
import 'package:transgo_passenger/view/widget/auth/custom_auth_button_widget.dart';

class VerificationScreen extends StatelessWidget {
  const VerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: GetBuilder<VerificationControllerImp>(
        init: VerificationControllerImp(),
        builder: (controller) {
          return Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColor.primaryColor,
                  AppColor.secondaryColor,
                ],
              ),
            ),
            child: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  children: [
                    const SizedBox(height: 10),

                    Align(
                      alignment: Alignment.centerLeft,
                      child: IconButton(
                        onPressed: () {
                          Get.back();
                        },
                        icon: const Icon(
                          Icons.arrow_back,
                          color: AppColor.thirdColor,
                        ),
                      ),
                    ),

                    Center(
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: AppColor.cardColor,
                          borderRadius: BorderRadius.circular(28),
                          border: Border.all(
                            color: Colors.white10,
                          ),
                        ),
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: AppColor.fifthColor,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: AppColor.thirdColor.withOpacity(0.25),
                                ),
                              ),
                              child: const Icon(
                                Icons.verified_user_outlined,
                                color: AppColor.thirdColor,
                                size: 42,
                              ),
                            ),
                      
                            const SizedBox(height: 24),
                      
                            Text(
                              controller.title,
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall!
                                  .copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                      
                            const SizedBox(height: 12),
                      
                            Text.rich(
                              TextSpan(
                                text: controller.subtitle,
                                style: TextStyle(
                                  color: theme.hintColor,
                                  fontSize: 14,
                                  height: 1.5,
                                ),
                                children: [
                                  TextSpan(
                                    text: controller.getHiddenEmail(),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              textAlign: TextAlign.center,
                            ),
                      
                            const SizedBox(height: 32),
                      
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: List.generate(
                                6,
                                (index) => _buildOtpBox(
                                  context,
                                  index,
                                  controller,
                                ),
                              ),
                            ),
                      
                            const SizedBox(height: 32),
                      
                            CustomAuthButton(
                              text: controller.buttonText,
                              isLoading: controller.statusRequest ==
                                  StatusRequest.loading,
                              onPressed: () {
                                controller.verifyAccount();
                              },
                            ),
                      
                            const SizedBox(height: 24),
                      
                            Text(
                              "Didn't receive the code?",
                              style: TextStyle(
                                color: theme.hintColor,
                                fontSize: 14,
                              ),
                            ),
                      
                            const SizedBox(height: 4),
                      
                            GestureDetector(
                              onTap: controller.canResend
                                  ? () {
                                      controller.resendCode();
                                    }
                                  : null,
                              child: Text(
                                controller.canResend
                                    ? "Resend Now"
                                    : "Resend in ${controller.secondsRemaining}s",
                                style: TextStyle(
                                  color: controller.canResend
                                      ? Colors.white
                                      : theme.hintColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 40),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.chat_bubble_outline,
                          color: theme.hintColor,
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "Contact TransGo Support",
                          style: TextStyle(
                            color: theme.hintColor,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildOtpBox(
    BuildContext context,
    int index,
    VerificationControllerImp controller,
  ) {
    return SizedBox(
      width: 45,
      height: 56,
      child: TextFormField(
        controller: controller.otpControllers[index],
        focusNode: controller.focusNodes[index],
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
        ],
        style: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        decoration: InputDecoration(
          counterText: "",
          filled: true,
          fillColor: AppColor.fifthColor,
          contentPadding: EdgeInsets.zero,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: Colors.white.withOpacity(0.08),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: AppColor.thirdColor,
              width: 2,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: Colors.red,
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: Colors.red,
            ),
          ),
        ),
        onChanged: (value) {
          if (value.isNotEmpty && index < 5) {
            controller.focusNodes[index + 1].requestFocus();
          } else if (value.isEmpty && index > 0) {
            controller.focusNodes[index - 1].requestFocus();
          }

          if (index == 5 && value.isNotEmpty) {
            FocusScope.of(context).unfocus();
          }
        },
      ),
    );
  }
}
