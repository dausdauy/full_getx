import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

GetStorage box = GetStorage();

class MyFunc {
  static String? validatorUserEmail(String? value) {
    if (value!.contains('@')) {
      return GetUtils.isEmail(value) ? null : 'Masukkan email dengan benar';
    } else if (value.isEmpty) {
      return 'Email tidak boleh kosong';
    }
    //  else if (!value.contains('@')) {
    //   return 'Masukkan email dengan benar';
    // }
    // if (value.length < 4) return 'Username terlalu pendek';

    return null;
  }

  static String? validatorPassword(String? value) {
    if (value!.isEmpty) return 'Password tidak boleh kosong';
    if (value.length < 4) return 'Password terlalu pendek';
    return null;
  }

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
