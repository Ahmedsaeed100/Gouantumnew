import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gouantum/screens/calls/data/models/call_model.dart';
import 'package:gouantum/screens/calls/presentaion/views/home_views/home_screen_pageview.dart';
import 'package:gouantum/screens/home/home_controller.dart';
import 'package:gouantum/utilities/palette.dart';
import 'package:gouantum/widgets/widgets.dart';
import 'package:gouantum/utilities/extentions.dart';
import '../../model/users.dart';
import 'call_log_controller.dart';
import 'package:timeago/timeago.dart' as timeago;

// ignore: must_be_immutable
class OutGoing extends StatelessWidget {
  OutGoing({super.key, required this.users, required this.calls});
  CallLogController callLogController = Get.put(CallLogController());
  final List<UserModel> users;
  final List<CallModel> calls;
  HomeController homeController = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GetBuilder<CallLogController>(builder: (context) {
      return ListView.separated(
        shrinkWrap: true,
        physics: const ClampingScrollPhysics(),
        separatorBuilder: (context, index) => const Divider(),
        itemCount: callLogController.searchOutGoingCallLogs.length,
        itemBuilder: (context, index) {
          CallModel callLog = callLogController.searchOutGoingCallLogs[index];
          return Flex(
            direction: Axis.horizontal,
            children: [
              Expanded(
                child: Container(
                  margin: EdgeInsets.symmetric(
                    vertical: size.height * 0.02,
                    horizontal: size.width * 0.02,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          StreamBuilder(
                            stream: homeController.firestore
                                .collection('_users')
                                .doc(callLog.receiverId)
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                UserModel user =
                                    UserModel.fromJson(snapshot.data!.data()!);
                                return UserCircleImage(
                                  borderColor: user.accountStatus == 'Active'
                                      ? Palette.mainBlueColor
                                      : Palette.darkGrayColor2,
                                  userStateColor: user.accountStatus == 'Active'
                                      ? Palette.mainBlueColor
                                      : Palette.mGrayColor,
                                  userUid: callLog.receiverId,
                                  size: size,
                                  image: callLog.receiverAvatar ?? "",
                                  imageCircalSize: size.height * 0.027,
                                );
                              }
                              return UserCircleImage(
                                userUid: callLog.receiverId,
                                size: size,
                                image: callLog.callerAvatar ?? "",
                                borderColor: Palette.darkGrayColor2,
                                userStateColor: Palette.darkGrayColor2,
                                imageCircalSize: size.height * 0.027,
                              );
                            },
                          ),
                          SizedBox(
                            width: size.width * 0.02,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    callLog.receiverName ?? "",
                                    style: TextStyle(
                                      fontSize: size.height * 0.025,
                                      fontFamily: "Helvetica",
                                    ),
                                  ),
                                  SizedBox(width: size.width * 0.03),
                                  Icon(
                                    (callLog.status == 'cancel' ||
                                            callLog.status == 'unAnswer')
                                        ? Icons.call_missed_outgoing
                                        : Icons.call_end,
                                    color: (callLog.status == 'cancel' ||
                                            callLog.status == 'unAnswer')
                                        ? Colors.red
                                        : Colors.green,
                                    size: 20,
                                  )
                                ],
                              ),
                              SizedBox(height: size.height * 0.01),
                              Row(
                                children: [
                                  Text(
                                    "${callLog.duration?.formatDuration() ?? "0: 00"} min",
                                    style: TextStyle(
                                      fontSize: size.height * 0.015,
                                      color: Colors.grey,
                                      fontFamily: "Helvetica",
                                    ),
                                  ),
                                  SizedBox(width: size.width * 0.02),
                                  Text(
                                    "| ${timeago.format(
                                      DateTime.fromMillisecondsSinceEpoch(
                                        callLog.createAt as int,
                                      ),
                                    )} |",
                                    style: TextStyle(
                                      fontSize: size.height * 0.015,
                                      color: Colors.grey,
                                      fontFamily: "Helvetica",
                                    ),
                                  ),
                                  SizedBox(width: size.width * 0.02),
                                  Text(
                                    // "\$ ${callLog.callMinuteCast.toString()}",
                                    "G  ${homeController.user!.callMinuteCast}",
                                    style: TextStyle(
                                      fontSize: size.height * 0.017,
                                      fontFamily: "Helvetica",
                                      color: Palette.gouantColor,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          InkWell(
                            onTap: () {
                              startVideoCall(
                                receiverID: callLog.receiverId,
                                context: context,
                                isVideo: false,
                              );
                            },
                            child: Icon(
                              Icons.call,
                              size: size.height * 0.035,
                              color: Palette.mainBlueColor,
                            ),
                          ),
                          SizedBox(width: size.width * 0.05),
                          InkWell(
                            onTap: () {
                              startVideoCall(
                                receiverID: callLog.receiverId,
                                context: context,
                                isVideo: true,
                              );
                            },
                            child: Icon(
                              Icons.videocam,
                              size: size.height * 0.035,
                              color: Palette.mainBlueColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      );
    });
  }
}
