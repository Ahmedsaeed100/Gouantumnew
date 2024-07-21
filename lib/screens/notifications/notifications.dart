import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gouantum/screens/notifications/notification_controller.dart';
import 'package:gouantum/utilities/palette.dart';
import 'package:gouantum/widgets/widgets.dart';
import 'package:timeago/timeago.dart' as timeago;

class Notifications extends StatefulWidget {
  const Notifications({super.key});

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  NotificationController notificationController =
      Get.put(NotificationController());

  @override
  void initState() {
    super.initState();
    notificationController.getNotificationFromFirebase();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: NestedScrollView(
          floatHeaderSlivers: true,
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            SliverAppBar(
              floating: true,
              snap: true,
              backgroundColor: Colors.transparent,
              elevation: 0,
              foregroundColor: Palette.darkGrayColor,
              leading: const BackButton(),
              title: Text(
                'Notifications',
                style: TextStyle(
                  fontFamily: "Helvetica",
                  fontSize: size.height * 0.025,
                  color: Palette.mainBlueColor,
                ),
              ),
              centerTitle: true,
            ),
          ],
          body:
              // ignore: sized_box_for_whitespace
              CustomScrollView(
            slivers: [
              // ignore: sized_box_for_whitespace

              SliverFillRemaining(
                // ignore: unnecessary_null_comparison

                child: notificationController.notificationsModel != null
                    ? Obx(
                        () => notificationController
                                .isDataLoadingNotification.value
                            ? const Center(child: CircularProgressIndicator())
                            : notificationController.notificationsModel!.isEmpty
                                ? NoDataExist(size: size)
                                : ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: notificationController
                                        .notificationsModel!.length,
                                    itemBuilder: (context, index) {
                                      var notification = notificationController
                                          .notificationsModel![index];
                                      // Update notification seen
                                      notificationController
                                          .updateNotificationSeen(
                                        true,
                                        notification.postId.toString(),
                                      );
                                      return Container(
                                        margin: EdgeInsets.symmetric(
                                          vertical: size.height * 0.02,
                                          horizontal: size.width * 0.02,
                                        ),
                                        child: Row(
                                          children: [
                                            InkWell(
                                              onTap: () {},
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                child: CircleAvatar(
                                                  radius: size.height * 0.030,
                                                  backgroundImage: NetworkImage(
                                                    notification.userImage
                                                        .toString(),
                                                    // size: size.height * 0.05,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: size.width * 0.05),
                                            SizedBox(
                                              width: size.width * 0.75,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        notification
                                                            .notificationAction
                                                            .toString(),
                                                        style: TextStyle(
                                                          fontSize:
                                                              size.height *
                                                                  0.020,
                                                          fontFamily:
                                                              "Helvetica",
                                                        ),
                                                      ),
                                                      Text(
                                                        timeago
                                                            .format(
                                                              notification
                                                                  .notificationTime
                                                                  .toDate(),
                                                            )
                                                            .toString(),
                                                        style: TextStyle(
                                                          fontSize:
                                                              size.height *
                                                                  0.012,
                                                          fontFamily:
                                                              "Helvetica",
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                      height:
                                                          size.height * 0.01),
                                                  Wrap(
                                                    children: [
                                                      Text(
                                                        "Has been rejected by your bank please contact your bank",
                                                        style: TextStyle(
                                                          fontSize:
                                                              size.height *
                                                                  0.016,
                                                          color: Colors.grey,
                                                          fontFamily:
                                                              "Helvetica",
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                      )
                    : NoDataExist(size: size),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
