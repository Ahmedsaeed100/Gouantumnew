import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:gouantum/controllers/global_functions.dart';
import 'package:gouantum/screens/home/home_controller.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'my_profile_controller.dart';

class MyInfo extends StatefulWidget {
  const MyInfo({super.key});

  @override
  State<MyInfo> createState() => _MyInfoState();
}

class _MyInfoState extends State<MyInfo> {
  HomeController homeController = Get.put(HomeController());
  MyProfileController controllerProfile = Get.put(MyProfileController());

  @override
  void initState() {
    super.initState();
  }

  Future pickImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;
      final imageTemporary = File(image.path);
      setState(() => avatar = imageTemporary);
    } on PlatformException {
      //print("failed");
    }
  }

  File? avatar;

  String imageUrl = "";
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      color: Colors.white,
      child: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Container(
                decoration: const BoxDecoration(
                  color: Color(0xffF3F3F3),
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
                child: ExpansionTile(
                    trailing: const Icon(
                      Icons.add,
                    ),
                    title: Text(
                      "Personal",
                      style: TextStyle(
                        fontFamily: 'Helvetica',
                        fontSize: size.height * 0.02,
                      ),
                    ),
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: size.height * 0.01,
                          horizontal: size.width * 0.02,
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.calendar_month_rounded),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              homeController.user!.dateOfBirth == ""
                                  ? "add Your Birthdate"
                                  : DateFormat('dd/MM/yyyy').format(
                                      DateTime.parse(
                                          homeController.user!.dateOfBirth)),
                              style: TextStyle(
                                fontFamily: 'Helvetica',
                                fontSize: size.height * 0.02,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: size.height * 0.01,
                          horizontal: size.width * 0.02,
                        ),
                        child: Row(
                          children: [
                            // ignore: deprecated_member_use
                            const Icon(FontAwesomeIcons.globeAfrica),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              homeController.user!.countries,
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: size.height * 0.01,
                          horizontal: size.width * 0.02,
                        ),
                        child: Row(
                          children: [
                            // ignore: deprecated_member_use
                            const Icon(FontAwesomeIcons.language),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(homeController.user!.language),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: size.height * 0.01,
                          horizontal: size.width * 0.02,
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.person),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(homeController.user!.gender),
                          ],
                        ),
                      ),
                    ])),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Container(
              decoration: const BoxDecoration(
                color: Color(0xffF3F3F3),
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              child: ExpansionTile(
                trailing: const Icon(
                  Icons.add,
                ),
                title: Text(
                  "Business",
                  style: TextStyle(
                    fontFamily: 'Helvetica',
                    fontSize: size.height * 0.02,
                  ),
                ),
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: size.height * 0.01,
                      horizontal: size.width * 0.02,
                    ),
                    child: const Row(
                      children: [
                        // ignore: deprecated_member_use
                        Icon(FontAwesomeIcons.globeAfrica),
                        SizedBox(
                          width: 10,
                        ),
                        Text("Cairo - Egypt"),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Container(
              decoration: const BoxDecoration(
                color: Color(0xffF3F3F3),
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              child: ExpansionTile(
                trailing: const Icon(
                  Icons.add,
                ),
                title: Text(
                  "Education",
                  style: TextStyle(
                    fontFamily: 'Helvetica',
                    fontSize: size.height * 0.02,
                  ),
                ),
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: size.height * 0.01,
                      horizontal: size.width * 0.02,
                    ),
                    child: Row(
                      children: [
                        // ignore: deprecated_member_use
                        const Icon(Icons.school),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(homeController.user!.educationCategory),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Obx(
            () => SwitchListTile.adaptive(
              value: controllerProfile.businessAccountStates.value,
              onChanged: (value) {
                setState(
                  () {
                    controllerProfile.updateBusinessAccount(value);
                    controllerProfile.businessAccountStates.value = value;
                  },
                );
              },
              title: const Text("Business Account"),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Container(
              decoration: const BoxDecoration(
                color: Color(0xffF3F3F3),
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              child: ExpansionTile(
                trailing: const Icon(
                  Icons.add,
                ),
                title: Text(
                  "Upload Documents",
                  style: TextStyle(
                    fontFamily: 'Helvetica',
                    fontSize: size.height * 0.02,
                  ),
                ),
                children: [
                  avatar != null
                      ? Column(
                          children: [
                            Image.file(
                              avatar!,
                              fit: BoxFit.cover,
                            ),
                            TextButton(
                                onPressed: () {
                                  if (imageUrl != "") {
                                    controllerProfile
                                        .uploadImageDocumentsId(imageUrl);
                                  } else {
                                    Get.snackbar(
                                        "Error", "Please Wait Image Uploading");
                                  }
                                },
                                child: const Text("Upload"))
                          ],
                        )
                      : const SizedBox(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          avatar != null ? "choose other ID" : "choose your ID",
                          style: const TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            showModalBottomSheet(
                                context: context,
                                builder: (context) => Container(
                                      height: size.height * 0.2,
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
                                            leading: const Icon(Icons.camera),
                                            title: const Text("Camera"),
                                            onTap: () {
                                              Navigator.pop(context);
                                              pickImage(ImageSource.camera)
                                                  .then((value) async {
                                                UploadTask uploadTask =
                                                    GlobalFunctionsController()
                                                        .uploadFile(
                                                            avatar!,
                                                            "${DateTime.now()}",
                                                            "image");
                                                TaskSnapshot snapshot =
                                                    await uploadTask;

                                                imageUrl = await snapshot.ref
                                                    .getDownloadURL();
                                              });
                                            },
                                          ),
                                          ListTile(
                                            leading: const Icon(Icons.image),
                                            title: const Text("Gallery"),
                                            onTap: () {
                                              Navigator.pop(context);
                                              pickImage(ImageSource.gallery)
                                                  .then((value) async {
                                                UploadTask uploadTask =
                                                    GlobalFunctionsController()
                                                        .uploadFile(
                                                            avatar!,
                                                            "${DateTime.now()}",
                                                            "image");
                                                TaskSnapshot snapshot =
                                                    await uploadTask;

                                                imageUrl = await snapshot.ref
                                                    .getDownloadURL();
                                              });
                                            },
                                          ),
                                        ],
                                      ),
                                    ));
                          },
                          icon: const Icon(
                            FontAwesomeIcons.paperclip,
                            color: Colors.grey,
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
