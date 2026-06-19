import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:transgo_passenger/controller/auth/register_controller.dart';
import 'package:transgo_passenger/core/class/statusrequest.dart';
import 'package:transgo_passenger/core/constant/AppColor.dart';
import 'package:transgo_passenger/core/functions/vaildinput.dart';
import 'package:transgo_passenger/view/widget/auth/custom_auth_button_widget.dart';
import 'package:transgo_passenger/view/widget/auth/custom_label_widget.dart';
import 'package:transgo_passenger/view/widget/auth/custom_passtext_filed.dart';
import 'package:transgo_passenger/view/widget/auth/custom_text_filed.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: GetBuilder<RegisterControllerImp>(
        init: RegisterControllerImp(),
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
                      Image.asset(
                        'assets/images/download.png',
                        height: 200,
                        fit: BoxFit.fill,
                      ),

                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(28),
                          border: Border.all(color: Colors.white10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Create Account",
                              style: Theme.of(
                                context,
                              ).textTheme.headlineSmall!.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),

                            const SizedBox(height: 4),

                            Text(
                              "Create your account to start booking trips.",
                              style: TextStyle(color: theme.hintColor),
                            ),

                            const SizedBox(height: 30),

                            const CustomLabel(text: "NAME"),
                            CustomTextFiled(
                              controller: controller.name,
                              hint: "Enter your full name",
                              icon: Icons.person_outline,
                              validator: (val) {
                                return validInput(val!, 3, 50, "username");
                              },
                            ),

                            const SizedBox(height: 20),

                            const CustomLabel(text: "PHONE NUMBER"),
                            CustomTextFiled(
                              controller: controller.phone,
                              hint: "+963 000-000-0000",
                              icon: Icons.phone_android_outlined,
                              keyboardType: TextInputType.phone,
                              validator: (val) {
                                return validInput(val!, 8, 20, "phone");
                              },
                            ),

                            const SizedBox(height: 20),
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

                            const CustomLabel(text: "PASSWORD"),
                            CustomPassTextFiled(
                              controller: controller.password,
                              obscureText: !controller.isPasswordVisible,
                              iconData:
                                  controller.isPasswordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                              onPressedIcon:
                                  controller.togglePasswordVisibility,
                              validator: (val) {
                                return validInput(val!, 6, 30, "password");
                              },
                            ),

                            const SizedBox(height: 20),

                            const CustomLabel(text: "CONFIRM PASSWORD"),
                            CustomPassTextFiled(
                              controller: controller.confirmPassword,
                              obscureText: !controller.isPasswordVisible,
                              iconData:
                                  controller.isPasswordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                              onPressedIcon:
                                  controller.togglePasswordVisibility,
                              validator: (val) {
                                if (val == null || val.isEmpty) {
                                  return "Confirm password can't be empty";
                                }

                                if (val != controller.password.text) {
                                  return "Passwords do not match";
                                }

                                return null;
                              },
                            ),

                            const SizedBox(height: 30),
                            const SizedBox(height: 30),

                            CustomAuthButton(
                              text: "Send OTP",
                              isLoading:
                                  controller.statusRequest ==
                                  StatusRequest.loading,
                              onPressed: () {
                                controller.sendOtp();
                              },
                            ),

                            const SizedBox(height: 16),

                            Center(
                              child: Text(
                                "We will send a verification code to your WhatsApp number.",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: theme.hintColor.withOpacity(0.9),
                                  fontSize: 13,
                                  height: 1.4,
                                ),
                              ),
                            ),

                            const SizedBox(height: 25),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Already have an account? ",
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
                                    "Sign In",
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
