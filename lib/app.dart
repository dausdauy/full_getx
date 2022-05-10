import 'dart:io';

import 'package:flutter/material.dart';
import 'package:full_getx/pages/home.dart';
import 'package:full_getx/pages/profile.dart';
import 'package:full_getx/services/controller/home_controller.dart';
import 'package:get/get.dart';

class App extends GetView<HomeController> {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        extendBody: Platform.isIOS ? true : false,
        body: listPagesView[controller.selectedIndexView.value],
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          iconSize: 20,
          currentIndex: controller.selectedIndexView.value,
          onTap: (i) {
            controller.scroollToTop();

            controller.selectedIndexView(i);
          },
          items: listItemNavBar,
        ),
      ),
    );
  }

  List<BottomNavigationBarItem> get listItemNavBar => [
        const BottomNavigationBarItem(
          label: '',
          icon: Icon(Icons.home_filled),
        ),
        const BottomNavigationBarItem(
          label: '',
          icon: Icon(Icons.search),
        ),
        const BottomNavigationBarItem(
          label: '',
          icon: Icon(Icons.add_box),
        ),
        const BottomNavigationBarItem(
          label: '',
          icon: Icon(Icons.favorite_border_outlined),
        ),
        const BottomNavigationBarItem(
          label: '',
          icon: Icon(Icons.person_outline_rounded),
        ),
      ];

  List<Widget> get listPagesView => <Widget>[
        Home(),
        Container(color: Colors.green),
        Container(color: Colors.blue),
        Container(color: Colors.red),
        Profile(),
      ];
}
