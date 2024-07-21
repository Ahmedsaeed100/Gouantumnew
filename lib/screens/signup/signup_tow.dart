import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gouantum/routes/routes.dart';
import 'package:gouantum/screens/login/header_logo.dart';
import 'package:gouantum/utilities/palette.dart';
import 'package:gouantum/widgets/widgets.dart';
import 'signup_controller.dart';

// ignore: must_be_immutable
class SignupTow extends StatelessWidget {
  Signupontroller controller = Get.put(Signupontroller());

  TextEditingController phoneController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String valueChoose = "";

  SignupTow({super.key});
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Palette.mainBlueColor,
        body: ListView(
          children: [
            HeaderLogo(size: size, imgwidth: 0.38),
            Container(
              margin: EdgeInsets.only(top: size.height * 0.05),
              height: size.height * 0.75,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(
                      vertical: size.height * 0.03,
                      horizontal: size.width * 0.09,
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Gander",
                            style: TextStyle(
                              color: Palette.darkGrayColor,
                              fontSize: size.height * 0.02,
                              fontFamily: "Helvetica",
                            ),
                          ),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              //Male
                              InkWell(
                                onTap: () {
                                  controller.userSelectGender();
                                },
                                child: GetBuilder<Signupontroller>(
                                  init: controller.userSelectGender(),
                                  builder: (_) => Container(
                                    margin: EdgeInsets.symmetric(
                                      vertical: size.height * 0.02,
                                    ),
                                    padding: EdgeInsets.symmetric(
                                      horizontal: size.height * 0.06,
                                      vertical: size.height * 0.02,
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                          size.height * 0.01),
                                      border: Border.all(
                                        color: controller.isMale != false
                                            ? Palette.mainBlueColor
                                            : Colors.transparent,
                                      ),
                                    ),
                                    child: Text(
                                      "Male",
                                      style: TextStyle(
                                        color: Palette.mainBlueColor,
                                        fontSize: size.height * 0.022,
                                        fontFamily: "Helvetica",
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              // Female
                              InkWell(
                                onTap: () {
                                  controller.userSelectGender();
                                },
                                child: GetBuilder<Signupontroller>(
                                  init: controller.userSelectGender(),
                                  builder: (_) => Container(
                                    margin: EdgeInsets.symmetric(
                                      vertical: size.height * 0.02,
                                    ),
                                    padding: EdgeInsets.symmetric(
                                      horizontal: size.height * 0.06,
                                      vertical: size.height * 0.02,
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                          size.height * 0.01),
                                      border: Border.all(
                                        color: controller.isMale != true
                                            ? Palette.mainBlueColor
                                            : Colors.transparent,
                                      ),
                                    ),
                                    child: Text(
                                      "Female",
                                      style: TextStyle(
                                        color: Palette.mainBlueColor,
                                        fontSize: size.height * 0.020,
                                        fontFamily: "Helvetica",
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: size.height * 0.05),

                          // Select Category
                          Text(
                            "Select Category",
                            style: TextStyle(
                              color: Palette.darkGrayColor,
                              fontSize: size.height * 0.018,
                              fontFamily: "Helvetica",
                            ),
                          ),
                          DropdownButtonFormField(
                            validator: (value) {
                              if (value == null) {
                                return 'Please select Category';
                              }
                              return null;
                            },
                            items: controller.educationCategory
                                .map((e) => DropdownMenuItem<String>(
                                      value: e['name'],
                                      child: Text(e['name']),
                                    ))
                                .toList(),
                            onChanged: (value) {
                              //  print(value.toString());
                              controller.category = value.toString();
                            },
                          ),

                          SizedBox(height: size.height * 0.05),
                          //
                          Text(
                            "Phone number",
                            style: TextStyle(
                              color: Palette.darkGrayColor,
                              fontSize: size.height * 0.018,
                              fontFamily: "Helvetica",
                            ),
                          ),
                          TextFormField(
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Please enter your phone number";
                              }
                              return null;
                            },
                            controller: phoneController,
                            keyboardType: TextInputType.phone,
                            maxLength: 11,
                            decoration: const InputDecoration(
                              hintText: "Enter your phone no.",
                              hintStyle: TextStyle(color: Palette.medGrayColor),
                              filled: true,
                              fillColor: Palette.lightGrayColor,
                              //  errorText: 'PassWord is Wrong',
                            ),
                          ),
                          SizedBox(height: size.height * 0.05),
                          //Date of birth
                          Text(
                            "Date of birth",
                            style: TextStyle(
                              color: Palette.darkGrayColor,
                              fontSize: size.height * 0.018,
                              fontFamily: "Helvetica",
                            ),
                          ),
                          SizedBox(height: size.height * 0.02),
                          InkWell(
                            onTap: () {
                              controller.selectDate(context);
                            },
                            child: GetBuilder<Signupontroller>(
                              builder: (_) => Text(
                                controller.birthDate
                                    .toLocal()
                                    .toString()
                                    .split(' ')[0],
                                style: TextStyle(
                                  fontSize: size.height * 0.02,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: size.height * 0.05),
                          /*       Align(
                            alignment: Alignment.bottomRight,
                            child: GestureDetector(
                              onTap: () {
                                Get.toNamed(RoutesClass.getsignupThreeRoute());
                              },
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
                          ),*/
                          Container(
                            margin: EdgeInsets.only(top: size.height * 0.03),
                            width: size.width * 0.85,
                            height: size.height * 0.06,
                            child: MainButton(
                              size: size,
                              buttonName: "Next",
                              backGroundColor: Palette.mainBlueColor,
                              textColor: Colors.white,
                              function: () {
                                if (_formKey.currentState!.validate() &&
                                    controller.category != '') {
                                  controller.phone = phoneController.text;
                                  Get.toNamed(
                                    RoutesClass.getsignupThreeRoute(),
                                  );
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
