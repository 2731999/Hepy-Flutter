import 'dart:async';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/route_manager.dart';
import 'package:hepy/app/Utils/common_utils.dart';
import 'package:hepy/app/Utils/image_path_utils.dart';
import 'package:hepy/app/Utils/preference_utils.dart';
import 'package:hepy/app/modules/chat/controller/chat_controller.dart';
import 'package:hepy/app/modules/dashboard/controller/dashboard_controller.dart';
import 'package:hepy/app/routes/app_routes.dart';

Future<void> onBackgroundMessage(RemoteMessage message) async {
  await Firebase.initializeApp();

  if (message.data.containsKey('data')) {
    // Handle data message
  }

  if (message.data.containsKey('notification')) {
    // Handle notification message
  }
}

class FCM {
  final _firebaseMessaging = FirebaseMessaging.instance;

  final streamCtlr = StreamController<String>.broadcast();
  final titleCtlr = StreamController<String>.broadcast();
  final bodyCtlr = StreamController<String>.broadcast();

  InitializationSettings initSettings = const InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: IOSInitializationSettings());

  final noticeDetail = const NotificationDetails(
      iOS: IOSNotificationDetails(),
      android: AndroidNotificationDetails("1", "Hepy app",
          importance: Importance.max,
          priority: Priority.high,
          playSound: true,
          channelDescription: 'testing',
          icon: '@mipmap/ic_launcher' // channel Name
          ));

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  setNotifications() async {
    RemoteMessage? conversationPayload;
    RemoteMessage? likedYouPayload;
    RemoteMessage? chatPayload;

    await flutterLocalNotificationsPlugin.initialize(
      initSettings,
      onSelectNotification: (_) {
        //your code
        if (CommonUtils().auth.currentUser != null) {
          /// When app is in foreground and user click on notification,
          /// then user will navigate on particular screen
          if (conversationPayload?.data['screen'] == 'conversations') {
            Get.offAndToNamed(Routes.DASHBOARD, arguments: [2, true]);
          } else if (likedYouPayload?.data['screen'] == 'liked-you') {
            Get.offAndToNamed(Routes.DASHBOARD, arguments: [1, true]);
          } else if (chatPayload?.data['screen'] == 'chat') {
            ChatController chatController = ChatController();
            chatController
                .getConversationFromId(chatPayload?.data['conversationId'])
                .then((conversationModel) {
              Get.offAndToNamed(Routes.CHAT_MESSAGE_SCREEN,
                  arguments: [conversationModel, true]);
            });
          }
        } else {
          Get.offAllNamed(Routes.LOGIN);
        }
      },
    );

    await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    FirebaseMessaging.instance.getInitialMessage().then((message) {
      debugPrint("App killed click event ===> ${message?.data}");
      if (message?.data['screen'] == 'conversations') {
        Get.offAndToNamed(Routes.DASHBOARD, arguments: [2, true]);
      } else if (message?.data['screen'] == 'liked-you') {
        Get.offAndToNamed(Routes.DASHBOARD, arguments: [1, true]);
      } else if (message?.data['screen'] == 'chat') {
        ChatController chatController = ChatController();
        chatController
            .getConversationFromId(message?.data['conversationId'])
            .then((conversationModel) {
          Get.offAndToNamed(Routes.CHAT_MESSAGE_SCREEN,
              arguments: [conversationModel]);
        });
      }
    });

    FirebaseMessaging.onBackgroundMessage(onBackgroundMessage);

    FirebaseMessaging.onMessage.listen(
      (message) async {
        String? notiMsgId = message.messageId;
        if (CommonUtils.messageId == notiMsgId) {
          return;
        }

        if (message.data['screen'] == 'conversations') {
          conversationPayload = message;
        } else if (message.data['screen'] == 'liked-you') {
          likedYouPayload = message;
        } else if (message.data['screen'] == 'chat') {
          chatPayload = message;
        }

        if (CommonUtils().auth.currentUser != null) {
          // if (message.data['screen'] == 'conversations') {
          //   Get.offAndToNamed(Routes.DASHBOARD, arguments: [2]);
          // }

          if (message.data.containsKey('data')) {
            // Handle data message
            streamCtlr.sink.add(message.data['data']);
          }
          if (message.data.containsKey('notification')) {
            //  Handle notification message
            streamCtlr.sink.add(message.data['notification']);
          }
          // Or do other work.
          titleCtlr.sink.add(message.notification!.title!);
          bodyCtlr.sink.add(message.notification!.body!);

          if (PreferenceUtils.isCurrentChatConversationScreen &&
              message.data['conversationId'] !=
                  PreferenceUtils.conversationId) {
            flutterLocalNotificationsPlugin.show(
                message.notification!.hashCode,
                message.notification!.title,
                message.notification!.body,
                noticeDetail);
          } else if (!PreferenceUtils.isCurrentChatConversationScreen) {
            flutterLocalNotificationsPlugin.show(
                message.notification!.hashCode,
                message.notification!.title,
                message.notification!.body,
                noticeDetail);
          }
          CommonUtils.messageId = notiMsgId!;
        }
      },
    );

    /// while app is in background user click on notification
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if (message.data['screen'] == 'conversations') {
        Get.offAndToNamed(Routes.DASHBOARD, arguments: [2, true]);
      } else if (message.data['screen'] == 'liked-you') {
        Get.offAndToNamed(Routes.DASHBOARD, arguments: [1, true]);
      } else if (message.data['screen'] == 'chat') {
        ChatController chatController = ChatController();
        chatController
            .getConversationFromId(message.data['conversationId'])
            .then((conversationModel) {
          Get.offAndToNamed(Routes.CHAT_MESSAGE_SCREEN,
              arguments: [conversationModel]);
        });
      }
    });

    // With this token you can test it easily on your phone
    final token =
        _firebaseMessaging.getToken().then((value) => print('Token: $value'));
  }

  dispose() {
    streamCtlr.close();
    bodyCtlr.close();
    titleCtlr.close();
  }
}
