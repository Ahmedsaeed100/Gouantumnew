import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gouantum/routes/routes.dart';
import 'package:gouantum/screens/login/header_logo.dart';
import 'package:gouantum/utilities/palette.dart';
import 'package:gouantum/widgets/widgets.dart';

class ForgetPassword extends StatelessWidget {
  const ForgetPassword({super.key});

  @override
  Widget build(BuildContext context) {
    final phoneController = TextEditingController();
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Palette.mainBlueColor,
        body: ListView(
          children: [
            HeaderLogo(size: size, imgwidth: 0.5),
            Container(
              margin: EdgeInsets.only(top: size.height * 0.12),
              height: size.height * 0.7,
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
                    margin: EdgeInsets.only(
                      top: size.height * 0.03,
                      left: size.width * 0.05,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Forgot Your Password",
                          style: TextStyle(
                            color: Palette.mainBlueColor,
                            fontSize: size.height * 0.025,
                            fontFamily: "Helvetica",
                          ),
                        ),
                        SizedBox(height: size.height * 0.03),
                        Text(
                          "Write down your registered phone number\nand we shall send to you for password\nresetting",
                          style: TextStyle(
                            height: 1.2,
                            color: Palette.darkGrayColor,
                            fontSize: size.height * 0.020,
                            fontFamily: "Helvetica",
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: size.height * 0.07),
                  Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: size.width * 0.05,
                    ),
                    child: Column(
                      children: [
                        //
                        TextField(
                          controller: phoneController,
                          decoration: const InputDecoration(
                            hintText: "Enter your phone no.",
                            hintStyle: TextStyle(color: Palette.medGrayColor),
                            filled: true,
                            fillColor: Palette.lightGrayColor,
                            //  errorText: 'PassWord is Wrong',
                          ),
                          keyboardType: TextInputType.phone,
                        ),

                        SizedBox(height: size.height * 0.07),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            SizedBox(
                              width: size.width * 0.45,
                              height: size.height * 0.06,
                              child: MainButton(
                                size: size,
                                buttonName: "Cancel For Now",
                                backGroundColor: Colors.transparent,
                                textColor: Colors.black,
                                function: () {
                                  Get.toNamed(RoutesClass.getLoginRoute());
                                },
                              ),
                            ),
                            SizedBox(
                              width: size.width * 0.45,
                              height: size.height * 0.06,
                              child: MainButton(
                                size: size,
                                buttonName: "Send",
                                backGroundColor: Palette.mainBlueColor,
                                textColor: Colors.white,
                                function: () {
                                  Get.toNamed(RoutesClass.getLoginRoute());
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
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
