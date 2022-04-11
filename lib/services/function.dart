import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_storage/get_storage.dart';

GetStorage box = GetStorage();

class MyFunc {
  static toastErrorConnection() =>
      Fluttertoast.showToast(msg: 'Koneksi anda bermasalah');

  static readIsLogin() => box.read('isLoggedIn') ?? false;

  static writeIsLogin(bool value) => box.write('isLoggedIn', value);

  static showNotification(RemoteMessage message) async {
    final data = message.data;
    final Map<String, String>? dataPayload = {
      'title': data['title'],
      'sub_title': data['sub_title'],
      'image': data['image'],
      'body': data['body'],
      'type': data['type'],
    };
    switch (data['type']) {
      case 'basic':
        return await AwesomeNotifications().createNotification(
          content: NotificationContent(
            id: message.hashCode,
            channelKey: 'basic',
            title: data['title'],
            body: data['sub_title'],
            payload: dataPayload,
            wakeUpScreen: true,
            notificationLayout: NotificationLayout.Default,
          ),
        );
      case 'image':
        return await AwesomeNotifications().createNotification(
          content: NotificationContent(
            id: message.hashCode,
            channelKey: 'image',
            title: data['title'],
            body: data['sub_title'],
            summary: 'Hot News',
            category: NotificationCategory.Recommendation,
            payload: dataPayload,
            wakeUpScreen: true,
            bigPicture: data['image_notification'],
            notificationLayout: NotificationLayout.BigPicture,
            groupKey: '2',
            backgroundColor: const Color.fromARGB(255, 123, 174, 216),
          ),
        );
      default:
    }
  }
}
