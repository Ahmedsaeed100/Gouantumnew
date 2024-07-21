import 'package:flutter/material.dart';
import 'package:gouantum/model/users.dart';
import 'package:gouantum/screens/calls/presentaion/views/home_views/home_screen_pageview.dart';
import 'package:gouantum/utilities/palette.dart';
import 'package:gouantum/widgets/user_circle_image.dart';

class UserItemView extends StatelessWidget {
  final UserModel userModel;

  const UserItemView({
    super.key,
    required this.userModel,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
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
                    UserCircleImage(
                      userUid: userModel.userUID,
                      size: size,
                      image: userModel.userImage,
                      borderColor: userModel.accountStatus == 'Active'
                          ? Palette.mainBlueColor
                          : Palette.darkGrayColor2,
                      userStateColor: userModel.accountStatus == 'Active'
                          ? Palette.mainBlueColor
                          : Palette.mGrayColor,
                      imageCircalSize: size.height * 0.027,
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
                              userModel.name,
                              style: TextStyle(
                                fontSize: size.height * 0.025,
                                fontFamily: "Helvetica",
                              ),
                            ),
                            // SizedBox(width: size.width * 0.015),
                            // const Icon(
                            //   Icons.favorite,
                            //   color: Colors.red,
                            // )
                          ],
                        ),
                        SizedBox(height: size.height * 0.01),
                        Row(
                          children: [
                            SizedBox(width: size.width * 0.02),
                            RichText(
                              text: TextSpan(
                                text: "Call Minute Cast ",
                                style: TextStyle(
                                  fontSize: size.height * 0.015,
                                  color: Colors.grey,
                                  fontFamily: "Helvetica",
                                ),
                                children: [
                                  TextSpan(
                                    text:
                                        " G ${userModel.callMinuteCast.toString()}",
                                    style: TextStyle(
                                      fontSize: size.height * 0.015,
                                      color: Palette.gouantColor,
                                      fontFamily: "Helvetica",
                                    ),
                                  ),
                                ],
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
                          receiverID: userModel.userUID,
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
                          receiverID: userModel.userUID,
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
  }
}
