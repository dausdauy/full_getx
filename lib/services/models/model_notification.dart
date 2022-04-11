// To parse this JSON data, do
//
//     final notification = notificationFromJson(jsonString);

import 'dart:convert';

ModelNotification notificationFromJson(str) =>
    ModelNotification.fromJson(json.decode(str));

String notificationToJson(ModelNotification data) => json.encode(data.toJson());

class ModelNotification {
  ModelNotification({
    this.title,
    this.subTitle,
    this.body,
    this.imageNotification,
    this.image,
    this.type,
  });

  final String? title;
  final String? subTitle;
  final String? body;
  final String? imageNotification;
  final List<String>? image;
  final String? type;

  ModelNotification.fromJson(Map<String, dynamic> json)
      : title = json["title"],
        subTitle = json["sub_title"],
        body = json["body"],
        imageNotification = json["image_notification"],
        image = List<String>.from(jsonDecode(json["image"]).map((x) => x)),
        type = json["type"];

  Map<String, dynamic> toJson() => {
        "title": title,
        "sub_title": subTitle,
        "body": body,
        "image_notification": imageNotification,
        "image": List<dynamic>.from(image!.map((x) => x)),
        "type": type,
      };
}
