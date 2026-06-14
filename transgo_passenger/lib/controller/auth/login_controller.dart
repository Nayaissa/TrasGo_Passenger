import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:transgo_passenger/core/class/diohelper.dart';
import 'package:transgo_passenger/core/class/statusrequest.dart';
import 'package:transgo_passenger/core/constant/routes.dart';
import 'package:transgo_passenger/core/services/service.dart';
import 'package:transgo_passenger/data/model/login_model.dart';

abstract class LoginController extends GetxController {
  login();
  goToForgetPassword();
  goToRegister();
}

class LoginControllerImp extends LoginController {
  GlobalKey<FormState> formstate = GlobalKey<FormState>();

  late TextEditingController email;
  late TextEditingController password;

  MyServices myServices = Get.find();

  StatusRequest? statusRequest;

  LoginModel? loginModel;

  bool isPasswordVisible = false;

  void togglePasswordVisibility() {
    isPasswordVisible = !isPasswordVisible;
    update();
  }

  @override
  goToForgetPassword() {
    Get.toNamed(AppRoute.forgetPassword);
  }

  @override
  goToRegister() {
    Get.toNamed(AppRoute.register);
  }

  @override
  login() async {
    var formdata = formstate.currentState;

    if (formdata!.validate()) {
      statusRequest = StatusRequest.loading;
      update();

      DioHelper.postsData(
        url: 'v1/passenger/login',
        data: {
          'email': email.text.trim(),
          'password': password.text,
        },
      ).then((value) {
        print(value!.data);

        loginModel = LoginModel.fromJson(value.data);

        if (value.statusCode == 200 && loginModel?.success == true) {
          final user = loginModel?.data?.user;
          final token = loginModel?.data?.token;
          final role = loginModel?.data?.role;
        

          if (token != null && token.isNotEmpty) {
            myServices.sharedPreferences.setString('token', token);
          }

          myServices.sharedPreferences.setString(
            'userid',
            user?.userId.toString() ?? '',
          );

          myServices.sharedPreferences.setString(
            'username',
            user?.fullName ?? '',
          );

          myServices.sharedPreferences.setString(
            'phone',
            user?.phone ?? '',
          );

          myServices.sharedPreferences.setString(
            'email',
            user?.email ?? '',
          );

          myServices.sharedPreferences.setString(
            'role',
            role ?? '',
          );

          myServices.sharedPreferences.setString('step', '2');

          statusRequest = StatusRequest.success;
          update();

          Get.snackbar(
            'Success',
            loginModel?.message ?? 'Login successfully',
          );

         
         
            Get.offAllNamed(AppRoute.homepage);
          
        } else {
          statusRequest = StatusRequest.failure;
          update();

          Get.snackbar(
            'Warning',
            loginModel?.message ?? 'Login failed',
          );
        }
      }).catchError((error) {
        print(error.toString());

        statusRequest = StatusRequest.serverfailure;
        update();

        Get.snackbar(
          'Error',
          'Server error, please try again',
        );
      });
    }
  }

  @override
  void onInit() {
    email = TextEditingController();
    password = TextEditingController();
    super.onInit();
  }

  @override
  void onClose() {
    email.dispose();
    password.dispose();
    super.onClose();
  }
}