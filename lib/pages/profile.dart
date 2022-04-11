import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:full_getx/services/controller/login_controller.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class Profile extends GetView {
  Profile({Key? key}) : super(key: key);
  final c = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Obx(
          () => Stack(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Center(
                          child: SizedBox(
                            height: 120,
                            width: 120,
                            child: ClipOval(
                              child: CachedNetworkImage(
                                imageUrl: c.auth.currentUser!.photoURL ?? '',
                                fit: BoxFit.cover,
                                errorWidget: (b, s, d) =>
                                    const Icon(Icons.person_rounded, size: 50),
                              ),
                            ),
                          ),
                        ),
                        Text(c.auth.currentUser!.displayName ?? 'No Name'),
                        Text(c.auth.currentUser!.email ?? ''),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          'Last active :' +
                              DateFormat('EEE, d/M/y')
                                  .add_jms()
                                  .format(c.auth.currentUser!.metadata
                                          .lastSignInTime ??
                                      DateTime(2017, 9, 7, 17, 30))
                                  .toString(),
                          style: Theme.of(context).textTheme.caption,
                        ),
                        ElevatedButton(
                          onPressed: () => c.isLoading.isTrue
                              ? null
                              : logOut().whenComplete(() => c.isLoading(false)),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.white,
                          ),
                          child: Text(
                            'SIGN OUT',
                            style: TextStyle(
                              color:
                                  c.isLoading.isTrue ? Colors.grey : Colors.red,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (c.isLoading.isTrue) const LinearProgressIndicator()
            ],
          ),
        ),
      ),
    );
  }

  Future<void> logOut() async {
    c.isLoading(true);
    await 1.delay();
    c.signOut();
  }
}
