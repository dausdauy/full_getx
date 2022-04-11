import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../function.dart';

class InitController extends GetxController {
  @override
  void onInit() {
    FirebaseMessaging.onMessage.listen((message) {
      debugPrint("message recieved");
      MyFunc.showNotification(message);
    });
    super.onInit();
  }
}
