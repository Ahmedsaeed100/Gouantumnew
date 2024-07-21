import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gouantum/routes/routes.dart';
import 'package:gouantum/screens/signup/signup_controller.dart';
import 'package:gouantum/screens/login/header_logo.dart';
import 'package:gouantum/utilities/palette.dart';
import 'package:gouantum/widgets/widgets.dart';

class SignupOne extends StatefulWidget {
  const SignupOne({super.key});

  @override
  State<SignupOne> createState() => _SignupOneState();
}

class _SignupOneState extends State<SignupOne> {
  Signupontroller signupController = Get.put(Signupontroller());

  bool isPasswordConfirmVisible = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();

  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  TextEditingController confirmpasswordController = TextEditingController();

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
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.symmetric(
                          vertical: size.height * 0.03,
                          horizontal: size.width * 0.09,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Name",
                              style: TextStyle(
                                color: Palette.darkGrayColor,
                                fontSize: size.height * 0.019,
                                fontFamily: "Helvetica",
                              ),
                            ),
                            TextFormField(
                              controller: nameController,
                              textInputAction:
                                  TextInputAction.next, // Moves focus to next.
                              validator: (value) {
                                if (value == null ||
                                    value.isEmpty ||
                                    value.length < 4) {
                                  return 'Please enter Name';
                                }
                                return null;
                              },
                              decoration: const InputDecoration(
                                // labelText: "full phone no.",
                                border: InputBorder.none,
                                hintText: 'Enter your full name',
                                hintStyle:
                                    TextStyle(color: Palette.medGrayColor),
                                filled: true,
                                fillColor: Palette.lightGrayColor,
                              ),
                              keyboardType: TextInputType.emailAddress,
                            ),
                            SizedBox(height: size.height * 0.05),
                            Text(
                              "E-mail Address",
                              style: TextStyle(
                                color: Palette.darkGrayColor,
                                fontSize: size.height * 0.019,
                                fontFamily: "Helvetica",
                              ),
                            ),
                            TextFormField(
                              controller: emailController,
                              textInputAction: TextInputAction.next,
                              onEditingComplete: () {
                                _formKey.currentState!.validate();
                              },
                              onSaved: (value) {
                                emailController.text = value!;
                              },
                              validator: (value) {
                                // print('User submitted: $value');
                                if (value == null ||
                                    value.isEmpty ||
                                    !value.contains('@')) {
                                  return 'Please enter Email';
                                } else if (value == "") {
                                  return 'this Email Address Already Exist';
                                }
                                return null;
                              },
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: "Enter your mail",
                                hintStyle:
                                    TextStyle(color: Palette.medGrayColor),
                                filled: true,
                                fillColor: Palette.lightGrayColor,
                                //  errorText: 'PassWord is Wrong',
                              ),
                              keyboardType: TextInputType.emailAddress,
                            ),
                            SizedBox(height: size.height * 0.05),
                            Text(
                              "Password",
                              style: TextStyle(
                                color: Palette.darkGrayColor,
                                fontSize: size.height * 0.019,
                                fontFamily: "Helvetica",
                              ),
                            ),
                            Obx(
                              () => TextFormField(
                                controller: passwordController,
                                textInputAction: TextInputAction
                                    .next, // Moves focus to next.
                                onSaved: (value) {
                                  passwordController.text = value!;
                                },
                                validator: (value) {
                                  if (value == null ||
                                      value.isEmpty ||
                                      value.length < 6) {
                                    return 'Please enter password';
                                  }
                                  return null;
                                },
                                obscureText:
                                    !signupController.isPasswordVisible.value,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Enter your password",
                                  hintStyle: const TextStyle(
                                    color: Palette.medGrayColor,
                                  ),
                                  filled: true,
                                  fillColor: Palette.lightGrayColor,
                                  //  errorText: 'PassWord is Wrong',
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      signupController.isPasswordVisible.value
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                      color: Palette.darkGrayColor,
                                    ),
                                    onPressed: () {
                                      signupController.showAndHidePassword();
                                    },
                                  ),
                                ),
                                keyboardType: TextInputType.text,
                              ),
                            ),
                            SizedBox(height: size.height * 0.05),
                            Text(
                              "Confirm Password",
                              style: TextStyle(
                                color: Palette.darkGrayColor,
                                fontSize: size.height * 0.019,
                                fontFamily: "Helvetica",
                              ),
                            ),
                            Obx(
                              () => TextFormField(
                                controller: confirmpasswordController,
                                textInputAction: TextInputAction
                                    .done, // Moves focus to next.
                                validator: (value) {
                                  if (value == null ||
                                      value.isEmpty ||
                                      value.length < 6) {
                                    return 'Please enter Confirm your password';
                                  }
                                  return null;
                                },
                                obscureText:
                                    !signupController.isPasswordVisible.value,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Confirm your password",
                                  hintStyle: const TextStyle(
                                    color: Palette.medGrayColor,
                                  ),
                                  filled: true,
                                  fillColor: Palette.lightGrayColor,
                                  //  errorText: 'PassWord is Wrong',
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      signupController.isPasswordVisible.value
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                      color: Palette.darkGrayColor,
                                    ),
                                    onPressed: () {
                                      signupController.showAndHidePassword();
                                    },
                                  ),
                                ),
                                keyboardType: TextInputType.text,
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: size.height * 0.1),
                              width: size.width * 0.85,
                              height: size.height * 0.06,
                              child: MainButton(
                                size: size,
                                buttonName: "Next",
                                backGroundColor: Palette.mainBlueColor,
                                textColor: Colors.white,
                                function: () {
                                  if (_formKey.currentState!.validate()) {
                                    // print("name: ${nameController.text}");
                                    if (passwordController.text ==
                                        confirmpasswordController.text) {
                                      signupController.name =
                                          nameController.text;
                                      signupController.email =
                                          emailController.text;
                                      signupController.password =
                                          passwordController.text;
                                      signupController.confirmPassword =
                                          confirmpasswordController.text;
                                      Get.toNamed(
                                        RoutesClass.signupTow,
                                      );
                                    } else {
                                      Get.snackbar(
                                        "Error",
                                        "Password and Confirm Password not match",
                                        snackPosition: SnackPosition.BOTTOM,
                                        backgroundColor: Colors.red,
                                        colorText: Colors.white,
                                      );
                                      //  print("password not match");
                                    }
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
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
