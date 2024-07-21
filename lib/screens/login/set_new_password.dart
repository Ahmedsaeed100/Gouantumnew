import 'package:flutter/material.dart';
import 'package:gouantum/screens/login/header_logo.dart';
import 'package:gouantum/utilities/palette.dart';
import 'package:gouantum/widgets/widgets.dart';

class SetNewPassword extends StatelessWidget {
  const SetNewPassword({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final newPassword = TextEditingController();
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
              height: size.height * 0.5,
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
                    child: Text(
                      "Set Your New Password",
                      style: TextStyle(
                        color: Palette.mainBlueColor,
                        fontSize: size.height * 0.025,
                        fontFamily: "Helvetica",
                      ),
                    ),
                  ),
                  SizedBox(height: size.height * 0.04),
                  Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: size.width * 0.05,
                    ),
                    child: Column(
                      children: [
                        //
                        MytextField(
                          theController: newPassword,
                          onsave: (value) {},
                          validator: (value) {
                            return;
                          },
                          hintText: "New Password",
                          textInputType: TextInputType.phone,
                          autofocus: true,
                        ),
                        SizedBox(height: size.height * 0.04),
                        MytextField(
                          theController: newPassword,
                          onsave: (value) {},
                          validator: (value) {
                            return;
                          },
                          hintText: "Re-Password",
                          textInputType: TextInputType.phone,
                          autofocus: true,
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
                                buttonName: "Confirm",
                                backGroundColor: Palette.mainBlueColor,
                                textColor: Colors.white,
                                function: () {},
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
