
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:full_getx/pages/view_notifikasi.dart';
import 'package:full_getx/services/function.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'app.dart';
import 'pages/login.dart';
import 'bindings/app_binding.dart';
import 'services/controller/init_controller.dart';

Future<dynamic> fcmBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  debugPrint("Handling a background message: ${message.messageId}");

  MyFunc.showNotification(message);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await Firebase.initializeApp();
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  initNotification();
  FirebaseMessaging.onBackgroundMessage(fcmBackgroundHandler);
  runApp(MyApp());
}

class MyApp extends GetView {
  MyApp({Key? key}) : super(key: key);
  final d = Get.put(InitController());

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(
          bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
      )),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.grey,
        ),
      ),
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      initialRoute: FirebaseAuth.instance.currentUser != null ? '/app' : '/login',
      getPages: [
        GetPage(
          name: '/login',
          page: () => Login(),
        ),
        GetPage(
          name: '/app',
          page: () => const App(),
          binding: AppBinding(),
        ),
      ],
    );
  }
}

initNotification() async {
  await AwesomeNotifications().initialize(
    // set the icon to null if you want to use the default app icon
    'resource://drawable/res_app_icon',
    [
      NotificationChannel(
        channelGroupKey: 'basic',
        channelKey: 'basic',
        channelName: 'Basic notifications',
        channelDescription: 'Notification channel for basic tests',
        channelShowBadge: true,
        importance: NotificationImportance.High,
        enableVibration: true,
        defaultColor: Colors.yellow.shade300,
      ),
      NotificationChannel(
        channelGroupKey: 'image',
        channelKey: 'image',
        channelName: 'image notifications',
        channelDescription: 'Notification channel for image tests',
        icon: 'resource://drawable/res_app_icon',
        groupKey: '2',
        ledColor: Colors.white,
        channelShowBadge: true,
        importance: NotificationImportance.High,
        defaultColor: Colors.blue.shade300,
      )
    ],
    // Channel groups are only visual and are not required
    channelGroups: [
      NotificationChannelGroup(
        channelGroupkey: '1',
        channelGroupName: 'Basic group',
      ),
      NotificationChannelGroup(
        channelGroupkey: '2',
        channelGroupName: 'Image group',
      )
    ],
  );

  AwesomeNotifications().actionStream.listen(
    (notification) {
        AwesomeNotifications().getGlobalBadgeCounter().then(
            (value) => AwesomeNotifications().setGlobalBadgeCounter(value - 1));
        Get.to(() => ViewNotifikasi(message: notification));
    },
  );

  // AwesomeNotifications()
}
