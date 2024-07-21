import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gouantum/screens/home/home_controller.dart';
import 'package:gouantum/screens/my_profile/my_profile.dart';
import '../model/users.dart';
import '../utilities/setting.dart';

// ignore: must_be_immutable
class UserShortState extends StatelessWidget {
  UserShortState({
    super.key,
    required this.size,
  });

  final Size size;
  HomeController homeController = Get.put(HomeController());
  @override
  Widget build(BuildContext context) {
    //print(controller.user);
    return Row(
      children: [
        GestureDetector(
          onTap: () => Get.to(const MyProfile()),
          child: CircleAvatar(
            radius: size.height * 0.025,
            backgroundImage:
                NetworkImage(homeController.user?.userImage ?? defUserImg),
          ),
        ),
        SizedBox(width: size.width * 0.025),
        StreamBuilder(
          stream: homeController.firestore
              .collection('_users')
              .doc(homeController.userUid)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              UserModel userData =
                  UserModel.fromJson(snapshot.data?.data() ?? {});
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        userData.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontFamily: "Helvetica",
                        ),
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
                    'G ${userData.callMinuteCast} / Minute - G ${userData.videoMinuteCast} / live',
                    style: const TextStyle(
                      color: Colors.white,
                      fontFamily: "Helvetica",
                    ),
                  ),
                ],
              );
            }
            return Container();
          },
        ),
      ],
    );
  }
}
