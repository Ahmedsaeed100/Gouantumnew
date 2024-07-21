import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gouantum/screens/others_profile/other_profile_controller.dart';
import 'package:gouantum/utilities/palette.dart';
import '../../controllers/global_functions.dart';
import '../../model/users.dart';
import '../Interactive_chat/chat.dart';
import '../Interactive_chat/model/chat_page_arguments.dart';
import '../calls/presentaion/views/home_views/home_screen_pageview.dart';

// ignore: must_be_immutable
class OtherUserProfileHeader extends StatelessWidget {
  const OtherUserProfileHeader({
    super.key,
    required this.size,
    required this.user,
  });
  final Size size;
  final UserModel user;
  @override
  Widget build(BuildContext context) {
    GlobalFunctionsController globalFunctionsController =
        Get.put(GlobalFunctionsController());
    OtherProfileController otherProfileController =
        Get.put(OtherProfileController());

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.04),
      child: Column(
        children: [
          SizedBox(height: size.height * 0.02),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white,
                        width: 2.0,
                      ),
                    ),
                    child: CircleAvatar(
                      radius: size.height * 0.045,
                      backgroundImage: NetworkImage(
                        user.userImage,
                      ),
                    ),
                  ),
                  // Is User Available Open
                  Container(
                    margin: EdgeInsets.only(
                      top: size.height * 0.01,
                    ),
                    padding: EdgeInsets.all(size.height * 0.005),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(
                        Radius.circular(size.height * 0.01),
                      ),
                    ),
                    child: Text(
                      user.accountStatus == "Active"
                          ? "Available"
                          : "Not Available",
                      style: TextStyle(
                        fontFamily: 'Helvetica',
                        color: user.accountStatus == "Active"
                            ? const Color.fromARGB(255, 55, 139, 58)
                            : Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: size.height * 0.015,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(width: size.width * 0.02),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Mr. ${user.name} ',
                    style: const TextStyle(
                      color: Colors.white,
                      fontFamily: "Helvetica",
                    ),
                  ),
                  SizedBox(height: size.height * 0.01),
                  const Text(
                    "Team leader , IT village",
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: "Helvetica",
                    ),
                  ),
                  SizedBox(height: size.height * 0.01),
                  Row(
                    children: [
                      Image.asset(
                        "assets/img/egypt.png",
                        height: size.height * 0.025,
                        width: size.width * 0.05,
                      ),
                      SizedBox(width: size.width * 0.02),
                      const Text("⭐⭐⭐⭐"),
                      SizedBox(width: size.width * 0.02),
                      const Text(
                        '4.5',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: "Helvetica",
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: size.height * 0.01),
                  Text(
                    "${user.callMinuteCast} / Minute - ${user.videoMinuteCast} / live",
                    style: const TextStyle(
                      color: Colors.white,
                      fontFamily: "Helvetica",
                    ),
                  ),
                ],
              ),
              Container(
                margin: EdgeInsets.only(
                  top: size.height * 0.05,
                  left: size.width * 0.02,
                ),
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(
                        // right: size.width * 0.03,
                        bottom: size.height * 0.005,
                      ),
                      height: size.height * 0.052,
                      width: size.width * 0.109,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 11, 64, 100),
                        borderRadius: BorderRadius.circular(
                          size.width * 0.025,
                        ),
                      ),
                      // Copy User Profile
                      child: IconButton(
                        onPressed: () {
                          /*   Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const IndexPage(),
                          ),
                        );*/
                        },
                        icon: Icon(
                          Icons.copy,
                          color: Colors.white,
                          size: size.height * 0.035,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                        // right: size.width * 0.03,
                        top: size.height * 0.005,
                      ),
                      child: Text(
                        "Copy Link",
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: "inter",
                          fontSize: size.height * 0.015,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: size.height * 0.02),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  GetBuilder(
                      init: GlobalFunctionsController(),
                      builder: (controller) {
                        if (globalFunctionsController.followedUsersIds ==
                            null) {
                          return const SizedBox();
                        } else {
                          var isFollowed = globalFunctionsController
                              .checkFollowStatus(user.userUID);
                          return GestureDetector(
                            onTap: () {
                              if (isFollowed) {
                                //    print('unfollow');
                                globalFunctionsController.unFollowUser(user);
                              } else {
                                globalFunctionsController.followUser(user);
                                // print('follow');
                              }
                            },
                            child: Container(
                              padding: EdgeInsets.all(size.height * 0.015),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(size.height * 0.01),
                                ),
                              ),
                              child: Text(
                                isFollowed ? "Unfollow" : "Follow",
                                style: TextStyle(
                                  fontFamily: 'Helvetica',
                                  color: Palette.mainBlueColor,
                                  fontWeight: FontWeight.w400,
                                  fontSize: size.height * 0.016,
                                ),
                              ),
                            ),
                          );
                        }
                      }),
                  Container(
                    margin: EdgeInsets.only(
                      // top: size.height * 0.01,
                      left: size.width * 0.02,
                    ),
                    padding: EdgeInsets.all(size.height * 0.015),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(
                        Radius.circular(size.height * 0.01),
                      ),
                    ),
                    child: Text(
                      "Block",
                      style: TextStyle(
                        fontFamily: 'Helvetica',
                        color: Palette.mainBlueColor,
                        fontWeight: FontWeight.w400,
                        fontSize: size.height * 0.016,
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Container(
                    margin: EdgeInsets.only(
                      right: size.width * 0.03,
                    ),
                    height: size.height * 0.052,
                    width: size.width * 0.109,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 11, 64, 100),
                      borderRadius: BorderRadius.circular(
                        size.width * 0.025,
                      ),
                    ),
                    child: IconButton(
                      onPressed: () async {
                        otherProfileController.isCalling.value = true;
                        await startVideoCall(
                          receiverID: user.userUID,
                          context: context,
                          isVideo: false,
                        );

                        otherProfileController.isCalling.value = false;
                      },
                      icon: Icon(
                        Icons.phone,
                        color: Colors.white,
                        size: size.height * 0.035,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                      right: size.width * 0.03,
                    ),
                    height: size.height * 0.052,
                    width: size.width * 0.109,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 11, 64, 100),
                      borderRadius: BorderRadius.circular(
                        size.width * 0.025,
                      ),
                    ),
                    // Start Vedio Call
                    child: IconButton(
                      onPressed: () async {
                        otherProfileController.isCalling.value = true;
                        await startVideoCall(
                          receiverID: user.userUID,
                          context: context,
                          isVideo: true,
                        );

                        otherProfileController.isCalling.value = false;
                      },
                      icon: Icon(
                        Icons.videocam,
                        color: Colors.white,
                        size: size.height * 0.035,
                      ),
                    ),
                  ),
                  Container(
                    height: size.height * 0.052,
                    width: size.width * 0.109,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 11, 64, 100),
                      borderRadius: BorderRadius.circular(
                        size.width * 0.025,
                      ),
                    ),
                    child: IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatPage(
                              arguments: ChatPageArguments(
                                peerId: user.userUID,
                                token: user.token,
                                peerAvatar: user.userImage,
                                peerNickname: user.name,
                                callMinuteCast: user.callMinuteCast,
                              ),
                            ),
                          ),
                        );
                      },
                      icon: Icon(
                        Icons.message,
                        color: Colors.white,
                        size: size.height * 0.035,
                      ),
                    ),
                  ),
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}
