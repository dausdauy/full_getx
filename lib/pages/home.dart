import 'dart:io';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:full_getx/services/controller/home_controller.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../services/models/model_users.dart';

class Home extends GetView<HomeController> {
  Home({Key? key}) : super(key: key);

  final numberFormat = NumberFormat.decimalPattern();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: Platform.isIOS ? false : true,
      bottom: Platform.isIOS ? false : true,
      child: Platform.isIOS
          ? CustomScrollView(
              slivers: [
                CupertinoSliverRefreshControl(
                  onRefresh: () => controller.getUsers(),
                ),
                buildDataObx(context),
              ],
            )
          : RefreshIndicator(
              onRefresh: () => controller.getUsers(),
              child: buildDataObx(context),
            ),
    );
  }

  Widget buildDataObx(context) {
    return controller.obx(
      (data) => SingleChildScrollView(
        controller: controller.scrollController,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            widgetHeader(),
            widgetStories(context, data!),
            widgetPosting(data),
          ],
        ),
      ),
      onError: (error) => Obx(
        () => Padding(
          padding: const EdgeInsets.fromLTRB(10.0, 50.0, 10.0, 0.0),
          child: Column(
            children: [
              Image.asset(
                'assets/nointernet.jpg',
                fit: BoxFit.fitWidth,
              ),
              Text(
                controller.isLoading.isFalse
                    ? 'Pastikan anda terkoneksi dengan internet'
                    : 'Menghubungkan Kembali',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 20),
              if (controller.isLoading.isFalse)
                OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    shape: const StadiumBorder(),
                    side: const BorderSide(
                      width: 1,
                      color: Colors.blue,
                    ),
                  ),
                  onPressed: () {
                    controller.isLoading(true);
                    controller
                        .getUsers()
                        .whenComplete(() => controller.isLoading(false));
                  },
                  label: const Text('Coba Lagi'),
                  icon: const Icon(Icons.wifi_protected_setup_sharp),
                ),
              if (controller.isLoading.isTrue) const CircularProgressIndicator()
            ],
          ),
        ),
      ),
    );
  }

  Widget widgetPosting(List<Users> data) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: controller.isMax.isFalse ? data.length + 1 : data.length,
      itemBuilder: (BuildContext context, int index) {
        if (index >= data.length) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Center(
              child: SizedBox(
                width: 30,
                height: 30,
                child: CircularProgressIndicator(),
              ),
            ),
          );
        }
        if (controller.isMax.isTrue) {
          Fluttertoast.showToast(msg: 'All data has loaded');
        }

        return postTemplate(context, data[index]);
      },
    );
  }

  Widget widgetStories(BuildContext context, List<Users> data) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        border: const Border(bottom: BorderSide(width: 0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Stories',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton.icon(
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                  ),
                  onPressed: () {},
                  icon: const Icon(
                    Icons.play_arrow,
                    size: 20,
                    color: Colors.black,
                  ),
                  label: const Text(
                    'Watch All',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: 80,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: data.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (BuildContext context, int index) {
                return listStatus(context, data[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget widgetHeader() {
    return Container(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(width: 0.15)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.camera_alt),
          ),
          Text(
            'Iclone',
            style: GoogleFonts.pacifico(
              fontSize: 20,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.message_outlined),
          ),
        ],
      ),
    );
  }

  Widget postTemplate(BuildContext context, Users data) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(width: 0.15)),
      ),
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 10, left: 10),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: 30,
                      width: 30,
                      child: ClipOval(
                        child: CachedNetworkImage(
                          imageUrl: data.picture.thumbnail,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data.name.first.toLowerCase() +
                              '_' +
                              data.name.last.toLowerCase() +
                              DateTime.parse(data.dob.date.toString())
                                  .year
                                  .toString(),
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          data.location.city,
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.more_horiz_rounded),
                onPressed: () {},
              )
            ],
          ),
          Stack(
            alignment: Alignment.center,
            children: [
              GestureDetector(
                onDoubleTap: () {
                  if (data.isFavorite == false) {
                    Future.delayed(const Duration(milliseconds: 1250), () {
                      controller.liked(false);
                      data.liked = false;
                    }).whenComplete(() => controller.update());
                  }

                  controller.liked(true);
                  data.liked = true;
                  data.isFavorite = !data.isFavorite;
                  controller.update();
                },
                child: CarouselSlider(
                  options: CarouselOptions(
                    height: MediaQuery.of(context).size.height * .4,
                    viewportFraction: 1,
                  ),
                  items: [
                    data.picture.large,
                    data.picture.medium,
                    data.picture.thumbnail
                  ].map((e) {
                    return CachedNetworkImage(
                      imageUrl: e,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                      errorWidget: (b, s, d) => Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.error_outline_outlined),
                          Text(
                            'Failed to load image',
                            style: Theme.of(b).textTheme.bodyMedium,
                          )
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
              if (data.liked == true && data.isFavorite == true)
                const AvatarGlow(
                  endRadius: 60,
                  repeat: false,
                  duration: Duration(seconds: 1),
                  startDelay: Duration.zero,
                  child: Icon(
                    Icons.favorite,
                    size: 100,
                    color: Colors.red,
                  ),
                )
            ],
          ),
          GetBuilder<HomeController>(
            init: HomeController(),
            initState: (_) {},
            builder: (_) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: data.isFavorite
                        ? const Icon(Icons.favorite, color: Colors.red)
                        : const Icon(Icons.favorite_border),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: const Icon(Icons.comment_outlined),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: const Icon(Icons.share_outlined),
                    onPressed: () {},
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.archive_outlined),
                    onPressed: () {},
                  ),
                ],
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(left: 3, right: 5),
                      width: 50,
                      child: Stack(
                        children: <Widget>[
                          Align(
                            alignment: Alignment.centerRight,
                            child: SizedBox(
                              height: 20,
                              child: ClipOval(
                                child: CachedNetworkImage(
                                  imageUrl:
                                      controller.users[0].picture.thumbnail,
                                ),
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: SizedBox(
                              height: 20,
                              child: ClipOval(
                                child: CachedNetworkImage(
                                  imageUrl:
                                      controller.users[1].picture.thumbnail,
                                ),
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: SizedBox(
                              height: 20,
                              child: ClipOval(
                                child: CachedNetworkImage(
                                  imageUrl:
                                      controller.users[2].picture.thumbnail,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      'Liked by ',
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                    const Text(
                      'sandra_321 ',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'and ',
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                    Text(
                      '${numberFormat.format(data.location.street.number)} others',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                RichText(
                  text: TextSpan(
                    text: data.name.first.toLowerCase() +
                        '_' +
                        data.name.last.toLowerCase() +
                        DateTime.parse(data.dob.date.toString())
                            .year
                            .toString() +
                        ' ',
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                    children: [
                      TextSpan(
                        text:
                            '❤ at ' + data.location.timezone.description + '.',
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  'View all ${numberFormat.format(data.dob.age)} comments',
                  style: Theme.of(context).textTheme.caption,
                ),
                const SizedBox(height: 10),
                Text(
                  DateFormat.MMMMd(Get.locale).format(data.registered.date),
                  style: Theme.of(context).textTheme.caption,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget listStatus(BuildContext context, Users data) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Column(
        children: [
          Container(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(255, 220, 124, 233),
                  Color.fromARGB(255, 216, 231, 56),
                ],
                tileMode: TileMode.repeated,
                begin: Alignment.bottomRight,
                end: Alignment.topLeft,
              ),
            ),
            padding: const EdgeInsets.all(2.75),
            child: Center(
              child: ClipOval(
                child: CachedNetworkImage(
                  width: 50,
                  imageUrl: data.picture.thumbnail,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          const SizedBox(height: 3),
          Text(
            data.name.first.toLowerCase() +
                // '_' +
                // data.name.last.toLowerCase() +
                DateTime.parse(data.dob.date.toString()).year.toString(),
            style: const TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.bold,
                overflow: TextOverflow.ellipsis),
          ),
        ],
      ),
    );
  }
}
