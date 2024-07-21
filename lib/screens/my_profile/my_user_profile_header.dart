import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:gouantum/controllers/global_functions.dart';
import 'package:gouantum/utilities/palette.dart';
import 'package:image_picker/image_picker.dart';
import '../../model/users.dart';
import '../../utilities/firestore_constants.dart';
import '../home/home_controller.dart';

// ignore: must_be_immutable
class MYUserProfileHeader extends StatefulWidget {
  const MYUserProfileHeader({
    super.key,
    required this.size,
    required this.user,
  });
  final UserModel user;
  final Size size;

  @override
  State<MYUserProfileHeader> createState() => _MYUserProfileHeaderState();
}

class _MYUserProfileHeaderState extends State<MYUserProfileHeader> {
  HomeController homeController = Get.put(HomeController());
  Future pickImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;
      final imageTemporary = File(image.path);
      setState(() => avatar = imageTemporary);
    } on PlatformException {
      //  print("failed");
    }
  }

  File? avatar;

  String imageUrl = "";
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          margin: EdgeInsets.only(left: widget.size.width * 0.05),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Palette.mainBlueColor,
              width: 2.0,
            ),
          ),
          child: InkWell(
            onTap: () {
              showModalBottomSheet(
                context: context,
                builder: (context) => Container(
                  height: widget.size.height * 0.2,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: Column(
                    children: [
                      ListTile(
                        leading: const Icon(
                          Icons.camera,
                        ),
                        title: const Text(
                          "Camera",
                        ),
                        onTap: () {
                          Navigator.pop(context);
                          pickImage(
                            ImageSource.camera,
                          ).then((value) async {
                            //  print("--------------- $value");
                            UploadTask uploadTask =
                                GlobalFunctionsController().uploadFile(
                              avatar!,
                              " ${homeController.userUid}",
                              "Profile_image",
                            );
                            TaskSnapshot snapshot = await uploadTask;

                            imageUrl = await snapshot.ref.getDownloadURL();

                            FirebaseFirestore.instance
                                .collection(FirestoreConstants.userCollection)
                                .doc(widget.user.userUID)
                                .update({"userImage": imageUrl});
                            setState(() {});
                          });
                        },
                      ),
                      ListTile(
                        leading: const Icon(
                          Icons.image,
                        ),
                        title: const Text(
                          "Gallery",
                        ),
                        onTap: () {
                          Navigator.pop(context);
                          pickImage(
                            ImageSource.gallery,
                          ).then(
                            (value) async {
                              UploadTask uploadTask =
                                  GlobalFunctionsController().uploadFile(
                                avatar!,
                                "${DateTime.now()}",
                                "Profile_Image",
                              );
                              TaskSnapshot snapshot = await uploadTask;

                              imageUrl = await snapshot.ref.getDownloadURL();

                              FirebaseFirestore.instance
                                  .collection(FirestoreConstants.userCollection)
                                  .doc(widget.user.userUID)
                                  .update({"userImage": imageUrl});
                              setState(() {});
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
            child: CircleAvatar(
              radius: widget.size.height * 0.045,
              backgroundImage: NetworkImage(
                widget.user.userImage,
              ),
            ),
          ),
        ),
        SizedBox(width: widget.size.width * 0.02),
        StreamBuilder(
          stream: homeController.firestore
              .collection('_users')
              .doc(widget.user.userUID)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              UserModel userData =
                  UserModel.fromJson(snapshot.data?.data() ?? {});
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Mr. ${userData.name} ',
                    style: const TextStyle(
                      color: Colors.white,
                      fontFamily: "Helvetica",
                    ),
                  ),
                  SizedBox(height: widget.size.height * 0.01),
                  const Text(
                    "Team leader , IT village",
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: "Helvetica",
                    ),
                  ),
                  SizedBox(height: widget.size.height * 0.01),
                  Row(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(right: 5),
                        child: Image.asset(
                          "assets/img/egypt.png",
                          height: widget.size.height * 0.025,
                          width: widget.size.width * 0.05,
                        ),
                      ),
                      const Text("⭐⭐⭐⭐"),
                      SizedBox(width: widget.size.width * 0.02),
                      const Text(
                        '4.5',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: "Helvetica",
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: widget.size.height * 0.01),
                  Text(
                    "${userData.callMinuteCast} / Minute - ${userData.videoMinuteCast} / live",
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
