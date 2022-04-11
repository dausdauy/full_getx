import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:full_getx/services/models/model_notification.dart';
import 'package:get/get.dart';

class ViewNotifikasi extends GetView {
  const ViewNotifikasi({
    Key? key,
    required this.message,
  }) : super(key: key);

  final ReceivedAction message;

  ModelNotification get data => ModelNotification.fromJson(message.payload!);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.only(top: 20, bottom: 10),
                  height: 70,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Center(
                        child: Text(
                          data.title!,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                      Text(
                        message.displayedDate!,
                        style: const TextStyle(
                          fontSize: 10,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  children: data.image!
                      .map((e) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: CachedNetworkImage(imageUrl: e),
                          ))
                      .toList(),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  margin: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    children: [
                      Text(
                        data.subTitle!,
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        data.body!,
                        style: Theme.of(context).textTheme.bodySmall,
                        textAlign: TextAlign.justify,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
