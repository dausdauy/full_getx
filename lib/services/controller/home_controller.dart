import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import '../models/model_users.dart';

class HomeController extends GetxController with StateMixin<List<Users>> {
  final provider = HomeProvider();
  final users = RxList<Users>();
  final selectedIndexView = RxInt(0);
  final scrollController = ScrollController();
  final isMax = RxBool(false);
  final isLoading = RxBool(false);
  final liked = RxBool(false);
  final isFavorite = RxBool(false);

  Future getUsers() => provider.getAllUser().then((res) {
        return change(users(res), status: RxStatus.success());
      }, onError: (err) {
        Fluttertoast.showToast(msg: 'Koneksi anda bermasalah');
        return change(null, status: RxStatus.error());
      });

  Future appendUsers() => provider.getAllUser().then((res) {
        res.isEmpty ? isMax(true) : isMax(false);
        return change(isMax.isFalse ? users + res : users,
            status: RxStatus.loadingMore());
      }, onError: (err) {
        Fluttertoast.showToast(msg: 'Koneksi anda bermasalah');
      });

  void scroollToTop() {
    if (scrollController.hasClients) {
      if (scrollController.offset > 20) {
        scrollController.animateTo(
          0,
          duration: const Duration(milliseconds: 500),
          curve: Curves.fastOutSlowIn,
        );
      }
    }
  }

  void _onScrollMaxAddPost() {
    double maxScroll = scrollController.position.maxScrollExtent;
    double currentScroll = scrollController.position.pixels;
    if (currentScroll == maxScroll) appendUsers();
  }

  @override
  void onInit() {
    scrollController.addListener(_onScrollMaxAddPost);
    getUsers();
    super.onInit();
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }
}

class HomeProvider extends GetConnect {
  String url = 'https://randomuser.me/api';
  String users = 'users/';
  String todos = 'todos/';

  Future<List<Users>> getAllUser() async {
    final response = await get(url + '?results=10');

    if (response.status.hasError) {
      return Future.error(response.statusText!);
    } else {
      final result = jsonDecode(response.bodyString!)['results'];
      return result.map<Users>((json) => Users.fromJson(json)).toList();
    }
  }
}
