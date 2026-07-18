import 'package:get/get.dart';
import 'package:transgo_passenger/core/class/diohelper.dart';
import 'package:transgo_passenger/core/class/statusrequest.dart';
import 'package:transgo_passenger/data/model/driver_profile_model.dart';

abstract class DriverProfileController extends GetxController {
  Future<void> getDriverProfile();
}

class DriverProfileControllerImp extends DriverProfileController {
  StatusRequest statusRequest = StatusRequest.loading;

  DriverProfileModel? driverProfileModel;
  DriverProfileData? driverProfile;

  int driverId = 0;
  String profileEndpoint = "";

  DriverProfileInfo? get profile => driverProfile?.profile;
  List<DriverReviewModel> get reviews => driverProfile?.reviews ?? [];

  @override
  void onInit() {
    super.onInit();
    _readArguments();
    getDriverProfile();
  }

  void _readArguments() {
    final args = Get.arguments;

    if (args is Map) {
      driverId = _toInt(args["driver_id"] ?? args["id"]);
      profileEndpoint = args["profile_endpoint"]?.toString() ?? "";
    } else if (args != null) {
      driverId = _toInt(args);
    }
  }

  int _toInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    return int.tryParse(value.toString()) ?? 0;
  }


  @override
  Future<void> getDriverProfile() async {
    
      statusRequest = StatusRequest.loading;
      update();
    

    try {
     
      final response = await DioHelper.getDataa(
        url: 'v1/passenger/drivers/$driverId',
      );

      if (response != null && response.statusCode == 200) {
        final body = response.data;

        if (body is Map && body["success"] == true) {
          driverProfileModel = DriverProfileModel.fromJson(
            Map<String, dynamic>.from(body),
          );

          driverProfile = driverProfileModel?.data;
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


  
}
