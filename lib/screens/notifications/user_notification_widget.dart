import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gouantum/routes/routes.dart';
import 'package:gouantum/screens/notifications/notification_controller.dart';
import 'package:gouantum/utilities/palette.dart';

class UserNotificationWidget extends StatelessWidget {
  const UserNotificationWidget({
    super.key,
    required this.size,
  });

  final Size size;

  @override
  Widget build(BuildContext context) {
    NotificationController notificationController =
        Get.put(NotificationController());
    return Stack(
      children: [
        IconButton(
          onPressed: () {
            Get.toNamed(RoutesClass.getNotificationsRoute());
          },
          icon: Icon(
            Icons.notifications,
            size: size.height * 0.045,
            color: Palette.darkGrayColor,
          ),
        ),
        StreamBuilder<QuerySnapshot>(
          stream: notificationController.getNotificationStream(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            // print(
            //   "nnn ${notificationController.notificationsModel![0].notificationSeen}",
            // );
            if (snapshot.hasError) {
              //  print("nnn ${snapshot.error}");
              return Container();
            }

            if (snapshot.hasData) {
              List<QueryDocumentSnapshot<Object?>> notificationNumber =
                  snapshot.data!.docs;
              //  print("nnn ${notificationNumber.length}");

              return Positioned(
                top: 5,
                left: 22,
                // Check If notification is not empty or seen before
                // ignore: prefer_is_empty
                child: notificationNumber.length > 0
                    ? Container(
                        height: size.height * 0.023,
                        width: size.height * 0.023,
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.all(
                            Radius.circular(25),
                          ),
                        ),
                        child: Container(
                          margin: EdgeInsets.only(
                            left: size.width * 0.012,
                            top: size.height * 0.001,
                          ),
                          child: Text(
                            notificationNumber.length.toString(),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: size.width * 0.035,
                            ),
                          ),
                        ),
                      )
                    : Container(),
              );
            } else {
              return Container();
            }
          },
        ),
      ],
    );
  }
}
