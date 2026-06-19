import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:transgo_passenger/controller/auth/forget_password_controller.dart';
import 'package:transgo_passenger/core/class/statusrequest.dart';
import 'package:transgo_passenger/core/constant/AppColor.dart';
import 'package:transgo_passenger/core/functions/vaildinput.dart';
import 'package:transgo_passenger/view/widget/auth/custom_auth_button_widget.dart';
import 'package:transgo_passenger/view/widget/auth/custom_label_widget.dart';
import 'package:transgo_passenger/view/widget/auth/custom_text_filed.dart';

class SendOtpScreen extends StatelessWidget {
  const SendOtpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: GetBuilder<SendOtpControllerImp>(
        init: SendOtpControllerImp(),
        global: false,
        builder: (controller) {
          return Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [AppColor.primaryColor, AppColor.secondaryColor],
              ),
            ),
            child: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Form(
                  key: controller.formstate,
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

                      const SizedBox(height: 20),

                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: AppColor.fifthColor,
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                            color: AppColor.thirdColor.withOpacity(0.25),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColor.thirdColor.withOpacity(0.18),
                              blurRadius: 35,
                              spreadRadius: 4,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.email_outlined,
                          color: AppColor.thirdColor,
                          size: 46,
                        ),
                      ),

                      const SizedBox(height: 30),

                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: AppColor.cardColor,
                          borderRadius: BorderRadius.circular(28),
                          border: Border.all(color: Colors.white10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Forgot Password?",
                              style: Theme.of(
                                context,
                              ).textTheme.headlineSmall!.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 8),

                            Text(
                              "Enter your email address and we will send you a verification code.",
                              style: TextStyle(
                                color: theme.hintColor,
                                fontSize: 14,
                                height: 1.5,
                              ),
                            ),

                            const SizedBox(height: 32),

                            const CustomLabel(text: "EMAIL"),

                            CustomTextFiled(
                              controller: controller.email,
                              hint: "Enter your email",
                              icon: Icons.email_outlined,
                              keyboardType: TextInputType.emailAddress,
                              validator: (val) {
                                return validInput(val!, 5, 100, "email");
                              },
                            ),

                            const SizedBox(height: 30),

                            CustomAuthButton(
                              text: "Send Code",
                              isLoading:
                                  controller.statusRequest ==
                                  StatusRequest.loading,
                              onPressed: () {
                                controller.sendOtp();
                              },
                            ),

                            const SizedBox(height: 24),

                            Center(
                              child: Text(
                                "We will send a 6-digit code to your email.",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: theme.hintColor,
                                  fontSize: 13,
                                  height: 1.4,
                                ),
                              ),
                            ),

                            const SizedBox(height: 26),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Remember your password? ",
                                  style: TextStyle(
                                    color: theme.hintColor,
                                    fontSize: 14,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    controller.goToLogin();
                                  },
                                  child: const Text(
                                    "Login",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 30),

                      Text(
                        "TransGo Passenger App",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: theme.hintColor.withOpacity(0.4),
                          fontSize: 10,
                        ),
                      ),

                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
