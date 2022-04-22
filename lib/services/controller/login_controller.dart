import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:full_getx/services/function.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginController extends GetxController {
  final ref = FirebaseFirestore.instance.collection('users');
  final provider = LoginProvider();
  final showPassword = RxBool(true);
  final isLoading = RxBool(false);
  final google = GoogleSignIn();
  final auth = FirebaseAuth.instance;

  Future<void> signIn(String email, String password) async {
    await 1.delay();
    try {
      await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      setupToken();
      Get.offNamed('/app');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password') {
        Fluttertoast.showToast(msg: 'Password tidak sesuai');
      } else if (e.email != email || e.code == 'wrong-password') {
        Fluttertoast.showToast(msg: 'Email / Password tidak sesuai');
      }
    }
  }

  Future<void> signUp(email, password) async {
    await 1.delay();
    try {
      UserCredential result = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (result.user != null) {
        Fluttertoast.showToast(msg: 'Berhasil dibuat');
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        Fluttertoast.showToast(msg: 'Email sudah digunakan');
      } else if (e.code == 'weak-password') {
        Fluttertoast.showToast(msg: 'Password terlalu mudah');
      }
    }
  }

  Future<void> signInWithGoogle() async {
    isLoading(true);
    final req = await google.signIn();
    final googleAuth = await req!.authentication;

    await auth.signInWithCredential(GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    ));

    setupToken();
    Get.offNamed('/app');
  }

  Future<void> signOut() async {
    showPassword(true);
    await ref.doc(auth.currentUser!.uid).delete();
    await 1.delay();
    await google.signOut();
    await auth.signOut();
    Get.offAllNamed('/login');
  }

  Future<void> setupToken() async {
    // Get the token each time the application loads
    String? token = await FirebaseMessaging.instance.getToken();
    // Save the initial token to the database
    await ref.doc(auth.currentUser!.uid).set({'tokens': token});
    debugPrint(token);
    await 1.delay();
    await saveTokenToDatabase(token!);

    // Any time the token refreshes, store this in the database too.
    FirebaseMessaging.instance.onTokenRefresh.listen(saveTokenToDatabase);
  }

  Future<void> saveTokenToDatabase(String token) async {
    // Assume user is logged in for this example

    await ref.doc(auth.currentUser!.uid).update({
      'tokens': FieldValue.arrayUnion([token]),
    });
  }

  @override
  void onInit() async {
    super.onInit();
    await AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        Get.defaultDialog(
          contentPadding: const EdgeInsets.all(20),
          middleText: 'Allow',
          textCancel: 'Cancel',
          textConfirm: 'Allow',
          onCancel: () => Get.back(),
          onConfirm: () =>
              AwesomeNotifications().requestPermissionToSendNotifications(),
        );
      }
    });
  }
}

class LoginProvider extends GetConnect {
  String url = 'https://reqres.in/api/login';

  Future<void> postLogin(String u, String p) async {
    Map<String, dynamic> body = {
      'email': u,
      'password': p,
    };
    final response = await post(url, body);
    if (response.status.connectionError) {
      MyFunc.toastErrorConnection();
    } else {
      if (response.statusCode == 200 && p == 'daus123') {
        MyFunc.writeIsLogin(true);
        // final token = jsonDecode(response.bodyString!)['token'];
        Get.offNamed('/app');
      } else {
        Fluttertoast.showToast(
            msg:
                '${u.contains('@') ? 'Email' : 'Username'}  / Password salah.');
      }
    }
  }
}
