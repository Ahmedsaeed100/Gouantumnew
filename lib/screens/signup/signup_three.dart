import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:gouantum/controllers/global_functions.dart';
import 'package:gouantum/screens/login/header_logo.dart';
import 'package:gouantum/utilities/palette.dart';
import 'package:gouantum/widgets/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'signup_controller.dart';

// ignore: must_be_immutable
class SignupThree extends StatefulWidget {
  const SignupThree({super.key});

  @override
  State<SignupThree> createState() => _SignupThreeState();
}

class _SignupThreeState extends State<SignupThree> {
  Signupontroller controller = Get.put(Signupontroller());

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
    Size size = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Palette.mainBlueColor,
        body: SingleChildScrollView(
          child: Column(
            children: [
              HeaderLogo(size: size, imgwidth: 0.38),
              Container(
                margin: EdgeInsets.only(top: size.height * 0.05),
                height: size.height * 0.80,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25),
                  ),
                ),
                child: Container(
                  margin: EdgeInsets.symmetric(
                    vertical: size.height * 0.03,
                    horizontal: size.width * 0.09,
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: size.height * 0.15,
                          width: size.width * 0.9,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade50,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: avatar == null
                              ? Center(
                                  child: InkWell(
                                    onTap: () {
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
                                                    UploadTask uploadTask =
                                                        GlobalFunctionsController()
                                                            .uploadFile(
                                                      avatar!,
                                                      "${DateTime.now()}",
                                                      "image",
                                                    );
                                                    TaskSnapshot snapshot =
                                                        await uploadTask;

                                                    imageUrl = await snapshot
                                                        .ref
                                                        .getDownloadURL();
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
                                                          GlobalFunctionsController()
                                                              .uploadFile(
                                                        avatar!,
                                                        "${DateTime.now()}",
                                                        "image",
                                                      );
                                                      TaskSnapshot snapshot =
                                                          await uploadTask;

                                                      imageUrl = await snapshot
                                                          .ref
                                                          .getDownloadURL();
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
                                    child: Icon(
                                      Icons.person,
                                      size: size.height * 0.10,
                                    ),
                                  ),
                                )
                              : Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Stack(
                                    children: [
                                      Center(
                                        child: Image.file(
                                          avatar!,
                                          fit: BoxFit.cover,
                                          height: size.height * 0.14,
                                          width: size.width * 0.6,
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          setState(
                                            () {
                                              avatar = null;
                                            },
                                          );
                                        },
                                        icon: const Icon(
                                          Icons.close,
                                          color: Colors.red,
                                          size: 30,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                        ),
                        Center(
                          child: Text(
                            "Add Your Image",
                            style: TextStyle(
                              color: Palette.darkGrayColor,
                              fontSize: size.height * 0.022,
                              fontFamily: "Helvetica",
                            ),
                          ),
                        ),
                        SizedBox(height: size.height * 0.05),
                        Text(
                          "Select Lanaguage ",
                          style: TextStyle(
                            color: Palette.darkGrayColor,
                            fontSize: size.height * 0.018,
                            fontFamily: "Helvetica",
                          ),
                        ),
                        DropdownButtonFormField(
                          validator: (value) {
                            if (value == null) {
                              return 'Please select Lanaguage';
                            }
                            return null;
                          },
                          items: controller.Lanaguage.map(
                              (e) => DropdownMenuItem<String>(
                                    value: e['name'],
                                    child: Text(e['name']),
                                  )).toList(),
                          onChanged: (value) {
                            controller.langauage = value.toString();
                          },
                        ),
                        SizedBox(height: size.height * 0.05),
                        //
                        Text(
                          "Choose your country",
                          style: TextStyle(
                            color: Palette.darkGrayColor,
                            fontSize: size.height * 0.018,
                            fontFamily: "Helvetica",
                          ),
                        ),
                        DropdownButtonFormField(
                          validator: (value) {
                            if (value == null) {
                              return 'Please select Lanaguage';
                            }
                            return null;
                          },
                          items: controller.Country.map(
                              (e) => DropdownMenuItem<String>(
                                    value: e['name'],
                                    child: Text(e['name']),
                                  )).toList(),
                          onChanged: (value) {
                            controller.country = value.toString();
                          },
                        ),
                        SizedBox(height: size.height * 0.05),
                        Obx(
                          () => controller.isLoading.value
                              ? const Center(
                                  child: CircularProgressIndicator(),
                                )
                              : InkWell(
                                  onTap: () {
                                    controller.signUp(imageUrl);
                                  },
                                  child: Align(
                                    alignment: Alignment.bottomRight,
                                    child: Text(
                                      textDirection: TextDirection.ltr,
                                      "Skip for now",
                                      style: TextStyle(
                                        decoration: TextDecoration.underline,
                                        color: Palette.mainBlueColor,
                                        fontSize: size.height * 0.018,
                                        fontFamily: "Helvetica",
                                      ),
                                    ),
                                  ),
                                ),
                        ),
                        SizedBox(height: size.height * 0.01),
                        Row(
                          children: [
                            Obx(
                              () => Checkbox(
                                value: controller.checkbox.value,
                                onChanged: ((_) {
                                  controller.agreement();
                                }),
                              ),
                            ),
                            Text(
                              "Agree on gouantum Terms and Conditions",
                              style: TextStyle(
                                color: Palette.darkGrayColor,
                                fontSize: size.height * 0.016,
                                fontFamily: "Helvetica",
                              ),
                            ),
                          ],
                        ),
                        Container(
                          margin: EdgeInsets.only(top: size.height * 0.03),
                          width: size.width * 0.85,
                          height: size.height * 0.06,
                          child: Obx(
                            () => controller.isLoading.value
                                ? const Center(
                                    child: CircularProgressIndicator(),
                                  )
                                : MainButton(
                                    size: size,
                                    buttonName: "Create My Account",
                                    backGroundColor:
                                        (controller.checkbox.value == true)
                                            ? Palette.mainBlueColor
                                            : Colors.grey,
                                    textColor: Colors.white,
                                    function: () {
                                      if (_formKey.currentState!.validate()) {
                                        if (controller.checkbox.value == true) {
                                          if (avatar != null &&
                                              imageUrl != "") {
                                            controller.signUp(imageUrl);
                                          } else {
                                            controller.signUp(
                                                "https://shorturl.at/fDRUZ");
                                            // Get.snackbar(
                                            //   "Error",
                                            //   "Please add your avatar",
                                            //   snackPosition:
                                            //       SnackPosition.BOTTOM,
                                            //   backgroundColor: Colors.red,
                                            //   colorText: Colors.white,
                                            // );
                                          }
                                        } else {
                                          Get.snackbar(
                                            "Error",
                                            "Please agree on gouantum Terms and Conditions",
                                            snackPosition: SnackPosition.BOTTOM,
                                            backgroundColor: Colors.red,
                                            colorText: Colors.white,
                                          );
                                        }
                                      }
                                    },
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
