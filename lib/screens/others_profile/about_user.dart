import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:gouantum/screens/my_profile/my_profile_controller.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../../model/users.dart';

class AboutUser extends StatefulWidget {
  final UserModel? user;
  const AboutUser({super.key, required this.user});

  @override
  State<AboutUser> createState() => _AboutUserState();
}

class _AboutUserState extends State<AboutUser> {
  // HomeController homeController = Get.put(HomeController());
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
                                widget.user!.dateOfBirth != ''
                                    ? DateFormat('dd/MM/yyyy').format(
                                        DateTime.parse(
                                            widget.user!.dateOfBirth))
                                    : "Unknown",
                                style: TextStyle(
                                  fontFamily: 'Helvetica',
                                  fontSize: size.height * 0.02,
                                )),
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
                              widget.user!.countries,
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
                            Text(widget.user!.language),
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
                            Text(widget.user!.gender),
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
                        Text(widget.user!.educationCategory),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: size.height * 0.02),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                "Is Business Account  : ",
                style: TextStyle(
                  fontSize: size.height * 0.025,
                ),
              ),
              Text(
                controllerProfile.businessAccountStates.value == true
                    ? 'Yes'
                    : 'NO',
                style: TextStyle(
                  color: Colors.green,
                  fontSize: size.height * 0.025,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
