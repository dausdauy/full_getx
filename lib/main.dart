import 'package:flutter/material.dart';
import 'package:full_getx/bindings/binding.dart';
import 'package:get/get.dart';

import 'app.dart';
import 'pages/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

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
      initialRoute: '/app',
      getPages: [
        GetPage(
          name: '/app',
          page: () => const App(),
          binding: Binding(),
          children: [
            GetPage(
              name: '/home',
              page: () => Home(),
            ),
          ],
        ),
      ],
    );
  }
}
