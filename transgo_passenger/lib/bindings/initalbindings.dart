import 'package:get/get.dart';
import 'package:transgo_passenger/controller/noti/notification_controller.dart';
import 'package:transgo_passenger/core/class/diohelper.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(DioHelper());
    Get.put(NotificationController(), permanent: true);
  }
}
