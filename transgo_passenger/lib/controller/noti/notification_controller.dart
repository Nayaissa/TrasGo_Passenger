import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:transgo_passenger/core/class/diohelper.dart';
import 'package:transgo_passenger/core/constant/AppColor.dart';

class NotificationController extends GetxController {
  static NotificationController? _activeController;
  static StreamSubscription<RemoteMessage>? _foregroundMessageSubscription;
  static final Set<String> _handledForegroundMessages = <String>{};
  static String? _lastForegroundSignature;
  static DateTime? _lastForegroundTime;

  String message = "";
  int unreadCount = 0;

  @override
  void onInit() {
    super.onInit();
    _activeController = this;
    _initFirebaseMessaging();
  }

  void _initFirebaseMessaging() async {
    await FirebaseMessaging.instance.requestPermission();

    FirebaseMessaging.instance.getToken().then((token) {
      if (token != null) {
        print('FCM Token: $token');
        _sendTokenToServer(token);
      }
    });

    _foregroundMessageSubscription ??= FirebaseMessaging.onMessage.listen(
      (RemoteMessage msg) {
        _activeController?._handleForegroundMessage(msg);
      },
    );

    FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? msg) {
      if (msg != null && msg.notification != null) {
        message = msg.notification!.body ?? '';
        unreadCount++;
        update();
      }
    });

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  Future<void> _sendTokenToServer(String token) async {
    DioHelper.postsData(
          url: '/api/user/update-fcm-token',
          data: {"fcm_token": token},
        )
        .then((value) {
          print(value!.data);
        })
        .catchError((error) {
          print(error);
        });
  }

  void resetUnread() {
    unreadCount = 0;
    update();
  }

  void setUnreadCount(int count) {
    unreadCount = count < 0 ? 0 : count;
    update();
  }

  void _handleForegroundMessage(RemoteMessage msg) {
    final messageKey = _messageKey(msg);
    final signature = _messageSignature(msg);
    final now = DateTime.now();
    final isRecentDuplicate =
        _lastForegroundSignature == signature &&
        _lastForegroundTime != null &&
        now.difference(_lastForegroundTime!) < const Duration(seconds: 5);

    if (_handledForegroundMessages.contains(messageKey) || isRecentDuplicate) {
      return;
    }

    _handledForegroundMessages.add(messageKey);
    _lastForegroundSignature = signature;
    _lastForegroundTime = now;

    if (msg.notification == null) return;

    final title = msg.notification!.title ?? "New Notification";
    final body = msg.notification!.body ?? "";

    message = body;
    unreadCount++;
    Get.snackbar(
      title,
      body,
      snackPosition: SnackPosition.TOP,
      backgroundColor: AppColor.cardColor,
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
      margin: const EdgeInsets.all(12),
    );
    update();
  }

  String _messageKey(RemoteMessage msg) {
    if (msg.messageId != null && msg.messageId!.isNotEmpty) {
      return msg.messageId!;
    }

    final title = msg.notification?.title ?? "";
    final body = msg.notification?.body ?? "";
    final sentTime = msg.sentTime?.millisecondsSinceEpoch ?? 0;
    return "$sentTime|$title|$body";
  }

  String _messageSignature(RemoteMessage msg) {
    final title = msg.notification?.title ?? "";
    final body = msg.notification?.body ?? "";
    return "$title|$body";
  }

  @override
  void onClose() {
    super.onClose();
  }
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print(" Background handler message: ${message.messageId}");
}
