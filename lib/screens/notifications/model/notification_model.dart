import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationsModel {
  final String? userName;
  final String? userImage;
  final String? postId;
  final String? notificationAction;
  final Timestamp notificationTime;
  final bool notificationSeen;

  NotificationsModel({
    required this.userName,
    required this.userImage,
    required this.postId,
    required this.notificationAction,
    required this.notificationTime,
    required this.notificationSeen,
  });

  factory NotificationsModel.fromJson(Map<String, dynamic> json) {
    return NotificationsModel(
      userName: json['userName'],
      userImage: json['userImage'],
      postId: json['postId'],
      notificationAction: json['notificationAction'],
      notificationTime: json['notificationTime'],
      notificationSeen: json['notificationSeen'],
    );
  }
}
