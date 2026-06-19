import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:transgo_passenger/controller/auth/reset_password_controller.dart';
import 'package:transgo_passenger/core/class/statusrequest.dart';
import 'package:transgo_passenger/core/constant/AppColor.dart';
import 'package:transgo_passenger/view/widget/auth/custom_auth_button_widget.dart';
import 'package:transgo_passenger/view/widget/auth/custom_label_widget.dart';
import 'package:transgo_passenger/view/widget/auth/custom_passtext_filed.dart';

class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: GetBuilder<ResetPasswordControllerImp>(
        init: ResetPasswordControllerImp(),
        global: false,
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

                      const SizedBox(height: 10),

                      Container(
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Reset Password",
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall!
                                  .copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),

                            const SizedBox(height: 8),

                            Text(
                              "Create a new strong password for your account.",
                              style: TextStyle(
                                color: theme.hintColor,
                                fontSize: 14,
                              ),
                            ),

                            const SizedBox(height: 32),

                            const CustomLabel(text: "NEW PASSWORD"),

                            CustomPassTextFiled(
                              controller: controller.password,
                              obscureText: !controller.isPasswordVisible,
                              iconData: controller.isPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              onPressedIcon:
                                  controller.togglePasswordVisibility,
                              onChanged: controller.onPasswordChanged,
                              validator: (val) {
                                if (val == null || val.isEmpty) {
                                  return "Password can't be empty";
                                }

                                if (val.length < 6) {
                                  return "Password must be at least 6 characters";
                                }

                                return null;
                              },
                            ),

                            if (controller.passwordError.isNotEmpty) ...[
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.info_outline,
                                    color: Color(0xFFE57373),
                                    size: 16,
                                  ),
                                  const SizedBox(width: 5),
                                  Expanded(
                                    child: Text(
                                      controller.passwordError,
                                      style: const TextStyle(
                                        color: Color(0xFFE57373),
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],

                            const SizedBox(height: 20),

                            const CustomLabel(text: "CONFIRM PASSWORD"),

                            CustomPassTextFiled(
                              controller: controller.confirmPassword,
                              obscureText:
                                  !controller.isConfirmPasswordVisible,
                              iconData: controller.isConfirmPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              onPressedIcon:
                                  controller.toggleConfirmPasswordVisibility,
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

                            const SizedBox(height: 24),

                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                Text.rich(
                                  TextSpan(
                                    text: "SECURITY STATUS — ",
                                    style: TextStyle(
                                      color: theme.hintColor,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: controller.securityStatus,
                                        style: TextStyle(
                                          color: controller.securityColor,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  "${(controller.securityPercentage * 100).toInt()}%",
                                  style: TextStyle(
                                    color: theme.hintColor,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 8),

                            ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: LinearProgressIndicator(
                                value: controller.securityPercentage,
                                backgroundColor: AppColor.fifthColor,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  controller.securityColor,
                                ),
                                minHeight: 6,
                              ),
                            ),

                            const SizedBox(height: 32),

                            CustomAuthButton(
                              text: "Update Password",
                              isLoading: controller.statusRequest ==
                                  StatusRequest.loading,
                              onPressed: () {
                                controller.updatePassword();
                              },
                            ),

                            const SizedBox(height: 28),

                            Center(
                              child: Text(
                                "Password must be at least 6 characters.",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: theme.hintColor,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ],
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
