import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:transgo_passenger/controller/auth/login_controller.dart';
import 'package:transgo_passenger/core/class/statusrequest.dart';
import 'package:transgo_passenger/core/constant/AppColor.dart';
import 'package:transgo_passenger/core/constant/routes.dart';
import 'package:transgo_passenger/core/functions/vaildinput.dart';
import 'package:transgo_passenger/view/widget/auth/custom_auth_button_widget.dart';
import 'package:transgo_passenger/view/widget/auth/custom_label_widget.dart';
import 'package:transgo_passenger/view/widget/auth/custom_passtext_filed.dart';
import 'package:transgo_passenger/view/widget/auth/custom_text_filed.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Get.put(LoginControllerImp());

    return Scaffold(
      body: GetBuilder<LoginControllerImp>(
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

                      Image.asset(
                        'assets/images/download.png',
                        height: 200,
                        fit: BoxFit.fill,
                      ),

                      Container(
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
                              "Welcome Back",
                              style: Theme.of(
                                context,
                              ).textTheme.headlineSmall!.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),

                            const SizedBox(height: 4),

                            Text(
                              "Login to continue your trips with TransGo.",
                              style: TextStyle(color: theme.hintColor),
                            ),

                            const SizedBox(height: 30),

                            const CustomLabel(text: "PHONE NUMBER"),

                            CustomTextFiled(
                              controller: controller.email,
                              hint: "Enter your email",
                              icon: Icons.phone_outlined,
                              keyboardType: TextInputType.emailAddress,
                              validator: (val) {
                                return validInput(val!, 8, 40, "email");
                              },
                            ),

                            const SizedBox(height: 20),

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

                            const SizedBox(height: 10),

                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () {
                                  controller.goToForgetPassword();
                                },
                                child: Text(
                                  "Forgot Password?",
                                  style: TextStyle(color: theme.primaryColor),
                                ),
                              ),
                            ),

                            const SizedBox(height: 20),

                            CustomAuthButton(
                              text: "Login",
                              isLoading:
                                  controller.statusRequest ==
                                  StatusRequest.loading,

                              onPressed: () {
                                controller.login();
                              },
                            ),

                            const SizedBox(height: 25),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Don't have an account? ",
                                  style: TextStyle(
                                    color: theme.hintColor,
                                    fontSize: 14,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Get.toNamed(AppRoute.register);
                                  },
                                  child: const Text(
                                    "Sign up now",
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
