import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gouantum/model/users.dart';
import 'package:gouantum/screens/calls/data/models/call_model.dart';
import 'package:gouantum/screens/home/home_controller.dart';
import 'package:gouantum/utilities/palette.dart';
import 'package:gouantum/widgets/widgets.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:gouantum/utilities/extentions.dart';

import '../calls/presentaion/views/home_views/home_screen_pageview.dart';
import 'call_log_controller.dart';

// ignore: must_be_immutable
class InComing extends StatelessWidget {
  InComing({super.key, required this.users, required this.calls});

  CallLogController callLogController = Get.put(CallLogController());
  final List<UserModel> users;
  final List<CallModel> calls;
  HomeController homeController = Get.put(HomeController());
  @override
  Widget build(BuildContext context) {
    removeMissedCalls();
    Size size = MediaQuery.of(context).size;
    return GetBuilder<HomeController>(builder: (context) {
      return ListView.separated(
        shrinkWrap: true,
        physics: const ClampingScrollPhysics(),
        separatorBuilder: (context, index) => const Divider(),
        itemCount: callLogController.searchIncomingCallLogs.length,
        itemBuilder: (context, index) {
          CallModel callLog = callLogController.searchIncomingCallLogs[index];

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
                                .doc(callLog.callerId)
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
                                  userUid: callLog.callerId,
                                  size: size,
                                  image: callLog.callerAvatar ?? "",
                                  imageCircalSize: size.height * 0.027,
                                );
                              }
                              return UserCircleImage(
                                userUid: callLog.callerId,
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
                                    callLog.callerName ?? "",
                                    style: TextStyle(
                                      fontSize: size.height * 0.025,
                                      fontFamily: "Helvetica",
                                    ),
                                  ),
                                  SizedBox(width: size.width * 0.03),
                                  Icon(
                                    (callLog.status == 'cancel' ||
                                            callLog.status == 'unAnswer')
                                        ? Icons.phone_missed
                                        : Icons.phone_callback,
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
                                    "G  ${callLogController.getIncomingCallCast(users, callLog.callerId!)}",
                                    style: TextStyle(
                                      fontSize: size.height * 0.017,
                                      color: Palette.gouantColor,
                                      fontFamily: "Helvetica",
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
                                receiverID: callLog.callerId,
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
                                receiverID: callLog.callerId,
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

  void removeMissedCalls(){
    homeController.numOfMissedCall = 0;
    homeController.missedCalls.sink.add(homeController.numOfMissedCall);
  }

}
