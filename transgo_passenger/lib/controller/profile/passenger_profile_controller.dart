import 'package:get/get.dart';
import 'package:transgo_passenger/core/class/diohelper.dart';
import 'package:transgo_passenger/core/class/statusrequest.dart';
import 'package:transgo_passenger/core/constant/routes.dart';
import 'package:transgo_passenger/data/model/passenger_profile_model.dart';

abstract class PassengerProfileController extends GetxController {
  Future<void> getProfile({bool showLoading = true});
  void goToEditProfile();
  void goToComplaints();
  void goToLanguage();
  void goToHelpSupport();
  void logout();
}

class PassengerProfileControllerImp extends PassengerProfileController {
  StatusRequest statusRequest = StatusRequest.loading;

  PassengerProfileModel? profileModel;
  PassengerProfileData? profile;

  @override
  void onInit() {
    super.onInit();
    getProfile();
  }

  @override
  Future<void> getProfile({bool showLoading = true}) async {
    if (showLoading) {
      statusRequest = StatusRequest.loading;
      update();
    }

    try {
      final response = await DioHelper.getDataa(url: "v1/passenger/me");

      if (response != null && response.statusCode == 200) {
        final body = response.data;

        if (body is Map && body["success"] == true) {
          profileModel = PassengerProfileModel.fromJson(
            Map<String, dynamic>.from(body),
          );

          profile = profileModel?.data;
          statusRequest = StatusRequest.success;
        } else {
          statusRequest = StatusRequest.failure;
        }
      } else if (response != null && response.statusCode == 401) {
        statusRequest = StatusRequest.serverfailure;

        Get.snackbar(
          "Error",
          "انتهت صلاحية تسجيل الدخول",
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        statusRequest = StatusRequest.serverfailure;
      }
    } catch (error) {
      statusRequest = StatusRequest.serverfailure;
    }

    update();
  }

  @override
  void goToEditProfile() {
    Get.toNamed("/editPassengerProfile", arguments: profile);
  }

  @override
  void goToComplaints() {
    Get.toNamed("/passengerComplaints");
  }

  @override
  void goToLanguage() {
    Get.toNamed("/language");
  }

  @override
  void goToHelpSupport() {
    Get.toNamed("/helpSupport");
  }

  @override
  void logout() {
    App.logout();
  }
}

class App {
  static void logout() {
    myServices.removeFromSharedPreferences('token');
    myServices.setString('step', '1');
    Get.offAllNamed(AppRoute.login);
  }
}

// public
