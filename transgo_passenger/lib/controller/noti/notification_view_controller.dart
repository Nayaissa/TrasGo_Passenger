import 'package:get/get.dart';
import 'package:transgo_passenger/controller/noti/notification_controller.dart';
import 'package:transgo_passenger/core/class/diohelper.dart';
import 'package:transgo_passenger/core/class/statusrequest.dart';
import 'package:transgo_passenger/data/model/notification_model.dart';

abstract class NotificationViewController extends GetxController {
  Future<void> getNotifications({bool showLoading = true});
  Future<void> readAllNotifications();
  void markAsReadLocal(int userNotificationId);
}

class NotificationViewControllerImp extends NotificationViewController {
  StatusRequest statusRequest = StatusRequest.loading;

  NotificationModel? notificationModel;
  List<PassengerNotificationItem> notifications = [];

  bool isReadingAll = false;

  @override
  void onInit() {
    super.onInit();
    getNotifications();
  }

  @override
  Future<void> getNotifications({bool showLoading = true}) async {
    if (showLoading) {
      statusRequest = StatusRequest.loading;
      update();
    }

    try {
      final response = await DioHelper.getDataa(
        url: "v1/passenger/notifications",
      );

      if (response != null && response.statusCode == 200) {
        final body = response.data;

        if (body is Map && body["success"] == true) {
          notificationModel = NotificationModel.fromJson(
            Map<String, dynamic>.from(body),
          );

          notifications = notificationModel?.items ?? [];
          _syncUnreadCount();
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
  Future<void> readAllNotifications() async {
    if (isReadingAll) return;

    isReadingAll = true;
    update();

    try {
      final response = await DioHelper.patchData(
        url: "v1/passenger/notifications/read-all",
      );

      if (response != null && response.statusCode == 200) {
        for (final item in notifications) {
          item.isRead = true;
          notificationModel = NotificationModel.fromJson(response.data);
        }
        _syncUnreadCount();

        Get.snackbar(
          "Notifications",
          notificationModel!.message,
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        Get.snackbar(
          "Error",
               notificationModel!.message ,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (error) {
      Get.snackbar(
        "Error",
        "حدث خطأ أثناء تنفيذ العملية",
        snackPosition: SnackPosition.BOTTOM,
      );
    }

    isReadingAll = false;
    update();
  }

  @override
  void markAsReadLocal(int userNotificationId) {
    final index = notifications.indexWhere(
      (item) => item.userNotificationId == userNotificationId,
    );

    if (index == -1) return;

    notifications[index].isRead = true;
    _syncUnreadCount();
    update();
  }

  void _syncUnreadCount() {
    if (!Get.isRegistered<NotificationController>()) return;

    final unreadCount = notifications.where((item) => !item.isRead).length;
    Get.find<NotificationController>().setUnreadCount(unreadCount);
  }
}
