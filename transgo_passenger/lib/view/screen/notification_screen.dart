import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:transgo_passenger/controller/noti/notification_view_controller.dart';
import 'package:transgo_passenger/core/class/statusrequest.dart';
import 'package:transgo_passenger/core/constant/AppColor.dart';
import 'package:transgo_passenger/view/widget/notification/notification_widgets.dart';
import 'package:transgo_passenger/view/widget/state/app_state_view.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});
  @override
  Widget build(BuildContext context) {
           Get.put(NotificationViewControllerImp());

    return GetBuilder<NotificationViewControllerImp>(
 //     init: NotificationViewControllerImp(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: AppColor.primaryColor,
          appBar: AppBar(
            backgroundColor: AppColor.primaryColor,
            elevation: 0,
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Get.back(),
            ),
            title: const Text(
              "NOTIFICATIONS",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.1,
              ),
            ),
            actions: [
              IconButton(
                onPressed: controller.isReadingAll
                    ? null
                    : controller.readAllNotifications,
                icon: controller.isReadingAll
                    ? const SizedBox(
                        width: 19,
                        height: 19,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(
                        Icons.done_all,
                        color: Colors.white,
                      ),
              ),
            ],
          ),
          body: Container(
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
              top: false,
              child: AppStateView(
                statusRequest: controller.statusRequest,
                isEmpty: controller.statusRequest == StatusRequest.success &&
                    controller.notifications.isEmpty,
                loadingMessage: "Loading notifications...",
                emptyTitle: "No Notifications",
                emptySubtitle: "You do not have any notifications yet.",
                errorTitle: "Failed to load notifications",
                errorSubtitle: "Please try again.",
                serverErrorTitle: "Server Error",
                serverErrorSubtitle: "Could not connect to the server.",
                onRetry: controller.getNotifications,
                child: RefreshIndicator(
                  onRefresh: () {
                    return controller.getNotifications(showLoading: false);
                  },
                  color: AppColor.thirdColor,
                  backgroundColor: AppColor.fifthColor,
                  child: ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.only(bottom: 28),
                    itemCount: controller.notifications.length + 1,
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return NotificationHeader(
                          count: controller.notifications.length,
                        );
                      }

                      final item = controller.notifications[index - 1];

                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: NotificationCard(
                          item: item,
                          onTap: () {
                            controller.markAsReadLocal(
                              item.userNotificationId,
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}