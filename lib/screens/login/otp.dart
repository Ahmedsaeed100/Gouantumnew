import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gouantum/routes/routes.dart';
import 'package:gouantum/screens/login/header_logo.dart';
import 'package:gouantum/utilities/palette.dart';
import 'package:gouantum/widgets/widgets.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class OTP extends StatelessWidget {
  const OTP({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        backgroundColor: Palette.mainBlueColor,
        body: ListView(
          children: [
            HeaderLogo(size: size, imgwidth: 0.5),
            Container(
              margin: EdgeInsets.only(top: size.height * 0.12),
              height: size.height,
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
                          "Code",
                          style: TextStyle(
                            color: Palette.mainBlueColor,
                            fontSize: size.height * 0.025,
                            fontFamily: "Helvetica",
                          ),
                        ),
                        SizedBox(height: size.height * 0.03),
                        Text(
                          "Please fill below the 4-digit access code\nalready sent to your mobile number (via SMS)\nfor validation",
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
                    margin: EdgeInsets.symmetric(horizontal: size.width * 0.05),
                    child: PinCodeTextField(
                      appContext: context,
                      autoFocus: true,
                      cursorColor: Palette.darkGrayColor,
                      keyboardType: TextInputType.number,
                      length: 6,
                      obscureText: false,
                      animationType: AnimationType.scale,
                      enablePinAutofill: true,
                      pinTheme: PinTheme(
                        shape: PinCodeFieldShape.underline,
                        borderWidth: 1.5,
                        fieldHeight: 50,
                        fieldWidth: 50,
                        activeFillColor: Colors.white,
                        activeColor: Colors.black,
                        inactiveColor: Colors.grey,
                        selectedColor: Palette.mainBlueColor,
                        disabledColor: Palette.mainBlueColor,
                        selectedFillColor: Colors.white,
                        inactiveFillColor: Colors.white,
                      ),
                      animationDuration: const Duration(milliseconds: 300),
                      enableActiveFill: true,
                      // when user enter All Code
                      onCompleted: (code) {
                        //otpCode = code;
                        //  print("Completed");
                      },
                      onChanged: (value) {
                        //print(value);
                      },
                    ),
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
                          buttonName: "Resend A Code",
                          backGroundColor: Colors.transparent,
                          textColor: Colors.black,
                          function: () {},
                        ),
                      ),
                      SizedBox(
                        width: size.width * 0.45,
                        height: size.height * 0.06,
                        child: MainButton(
                          size: size,
                          buttonName: "Confirm",
                          backGroundColor: Palette.mainBlueColor,
                          textColor: Colors.white,
                          function: () => Get.toNamed(
                            RoutesClass.getsignupThreeRoute(),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
