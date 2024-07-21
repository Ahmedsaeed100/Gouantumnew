import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gouantum/screens/home/home_controller.dart';
import 'package:gouantum/screens/login/header_logo.dart';
import 'package:gouantum/utilities/palette.dart';
import 'package:gouantum/widgets/widgets.dart';
import 'my_profile_controller.dart';

// ignore: must_be_immutable
class MinutePricing extends StatelessWidget {
  MyProfileController myProfileController = Get.put(MyProfileController());

  TextEditingController callMinuteCastController = TextEditingController();
  TextEditingController videoMinuteCastController = TextEditingController();

  MinutePricing({super.key});
  @override
  Widget build(BuildContext context) {
    HomeController homecontroller = Get.put(HomeController());
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
                        SizedBox(height: size.height * 0.03),
                        Container(
                          margin: EdgeInsets.only(right: size.width * 0.02),
                          child: Text(
                            "The rate you set here represents your minute price that other users shall pay when they call you on QB Call- that is effectively charged by seconds.Make sure to price yourself carefully in a way that really reflects your business value within the range (Min 1 – Max 100) MG /Min",
                            style: TextStyle(
                              height: 1.2,
                              color: Palette.darkGrayColor,
                              fontSize: size.height * 0.020,
                              fontFamily: "Helvetica",
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: size.height * 0.05),
                  Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: size.width * 0.05,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //
                        Text(
                          'Your rate pricing per minute',
                          style: TextStyle(
                            fontSize: size.height * 0.019,
                            fontFamily: 'Helvetica',
                          ),
                        ),
                        SizedBox(height: size.height * 0.01),
                        TextField(
                          controller: callMinuteCastController,
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            hintText:
                                "MG ${homecontroller.user!.callMinuteCast}",
                            hintStyle:
                                const TextStyle(color: Palette.medGrayColor),
                            filled: true,
                            fillColor: Palette.lightGrayColor,
                            //  errorText: 'PassWord is Wrong',
                          ),
                          keyboardType: TextInputType.phone,
                        ),

                        SizedBox(height: size.height * 0.03),
                        Text(
                          'Your video pricing per minute',
                          style: TextStyle(
                            fontSize: size.height * 0.019,
                            fontFamily: 'Helvetica',
                          ),
                        ),
                        SizedBox(height: size.height * 0.01),
                        TextField(
                          controller: videoMinuteCastController,
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            hintText:
                                "MG ${homecontroller.user!.videoMinuteCast}",
                            hintStyle:
                                const TextStyle(color: Palette.medGrayColor),
                            filled: true,
                            fillColor: Palette.lightGrayColor,
                            //  errorText: 'PassWord is Wrong',
                          ),
                          keyboardType: TextInputType.phone,
                        ),

                        SizedBox(height: size.height * 0.05),
                        SizedBox(
                          height: size.height * 0.07,
                          child: Center(
                            child: MainButton(
                              size: size,
                              buttonName: "Update My Rate",
                              backGroundColor: Palette.mainBlueColor,
                              textColor: Colors.white,
                              function: () {
                                if (callMinuteCastController.text.trim() !=
                                        "" &&
                                    videoMinuteCastController.text.trim() !=
                                        "") {
                                  myProfileController.checkMinutePrice(
                                    num.parse(
                                      callMinuteCastController.text.trim(),
                                    ),
                                    num.parse(
                                      videoMinuteCastController.text.trim(),
                                    ),
                                  );
                                  Navigator.pop(context);
                                } else {
                                  Navigator.pop(context);
                                  return;
                                }
                              },
                            ),
                          ),
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
