import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gouantum/screens/login/login_controller.dart';
import 'package:gouantum/routes/routes.dart';
import 'package:gouantum/screens/login/header_logo.dart';
import 'package:gouantum/utilities/palette.dart';
import 'package:gouantum/widgets/widgets.dart';
import '../main_screen/main_screen.dart';

// ignore: must_be_immutable
class LoginScreen extends StatelessWidget {
  LoginController loginController = Get.put(LoginController());

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  LoginScreen({super.key});
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Palette.mainBlueColor,
        body: SingleChildScrollView(
          child: Column(
            children: [
              HeaderLogo(
                size: size,
                imgwidth: 0.38,
                showBackButton: false,
              ),
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () {
                        loginController.getuserAddress();
                      },
                      child: Container(
                        margin: EdgeInsets.only(
                          top: size.height * 0.03,
                          left: size.width * 0.05,
                        ),
                        child: Text(
                          textAlign: TextAlign.start,
                          "Welcome to GOUANTUM",
                          style: TextStyle(
                            color: Palette.mainBlueColor,
                            fontSize: size.height * 0.030,
                            fontFamily: "Helvetica",
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(
                        vertical: size.height * 0.03,
                        horizontal: size.width * 0.09,
                      ),
                      child: Form(
                        key: loginController.loginFormKey,
                        //0autovalidateMode: AutovalidateMode.onUserInteraction,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Email
                            Text(
                              "Signing via Email or Phone Number",
                              style: TextStyle(
                                color: Palette.darkGrayColor,
                                fontSize: size.height * 0.020,
                                fontFamily: "Helvetica",
                              ),
                            ),
                            SizedBox(height: size.height * 0.01),
                            TextFormField(
                              controller: emailController,
                              onSaved: (value) {
                                loginController.email = value!;
                              },
                              validator: (value) {
                                return loginController.validateEmail(value!);
                              },
                              decoration: const InputDecoration(
                                // labelText: "full phone no.",
                                border: InputBorder.none,
                                hintText: 'Enter your mail or full phone no.',
                                hintStyle:
                                    TextStyle(color: Palette.medGrayColor),
                                filled: true,
                                fillColor: Palette.lightGrayColor,
                              ),
                              keyboardType: TextInputType.emailAddress,
                            ),
                            SizedBox(height: size.height * 0.05),
                            // Password
                            Text(
                              "Password",
                              style: TextStyle(
                                color: Palette.darkGrayColor,
                                fontSize: size.height * 0.020,
                                fontFamily: "Helvetica",
                              ),
                            ),
                            GetBuilder<LoginController>(
                              builder: (_) => TextFormField(
                                obscureText: !loginController.isPasswordVisible,
                                controller: passwordController,
                                onSaved: (value) {
                                  loginController.password = value!;
                                },
                                validator: (value) {
                                  return loginController
                                      .validatePassword(value!);
                                },
                                decoration: InputDecoration(
                                  // Enter your password",
                                  border: InputBorder.none,
                                  hintText: "Enter your password",
                                  hintStyle: const TextStyle(
                                      color: Palette.medGrayColor),
                                  filled: true,
                                  fillColor: Palette.lightGrayColor,
                                  //  errorText: 'PassWord is Wrong',
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      loginController.isPasswordVisible
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                      color: Palette.darkGrayColor2,
                                    ),
                                    onPressed: () {
                                      loginController.showAndHidePassword();
                                    },
                                  ),
                                ),
                                keyboardType: TextInputType.text,
                              ),
                            ),
                            SizedBox(height: size.height * 0.02),
                            GestureDetector(
                              onTap: () {
                                Get.toNamed(
                                  RoutesClass.getForgetpasswordRoute(),
                                );
                              },
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  "Forgot Your Password?",
                                  style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    color: Palette.mainBlueColor,
                                    fontSize: size.height * 0.019,
                                    fontFamily: "Helvetica",
                                  ),
                                ),
                              ),
                            ),

                            SizedBox(height: size.height * 0.015),
                            // Login button
                            MainButton(
                              size: size,
                              buttonName: "Login",
                              backGroundColor: Palette.mainBlueColor,
                              textColor: Colors.white,
                              function: () {
                                loginController.checkLogin(
                                  emailController.text.trim(),
                                  passwordController.text.trim(),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        // Login by Google
                        loginController.signInWithGoogle().then((value) {
                          // ignore: unnecessary_null_comparison
                          if (value != null) {
                            Get.offAll(
                              const MainScreen(),
                            );
                          } else {
                            Get.snackbar("Error", "Something went wrong");
                          }
                        });
                      },
                      child: Container(
                        margin: EdgeInsets.symmetric(
                          vertical: size.height * 0.04,
                          horizontal: size.width * 0.07,
                        ),
                        padding: EdgeInsets.all(size.width * 0.02),
                        decoration: const BoxDecoration(
                          color: Palette.lightGrayColor,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset("assets/icons/google-icon.png"),
                            SizedBox(width: size.width * 0.02),
                            Text(
                              "Sign in with Google",
                              style: TextStyle(
                                color: Palette.darkGrayColor,
                                fontSize: size.height * 0.018,
                                fontFamily: "Helvetica",
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: size.height * 0.015),
                    Center(
                      child: Text(
                        "Or sign in with",
                        style: TextStyle(
                          color: Palette.darkGrayColor,
                          fontSize: size.height * 0.018,
                          fontFamily: "Helvetica",
                        ),
                      ),
                    ),
                    SizedBox(height: size.height * 0.04),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        LogoButton(
                          function: () {},
                          svgPath: "assets/icons/facebook.svg",
                        ),
                        SizedBox(width: size.width * 0.09),
                        LogoButton(
                          function: () {},
                          svgPath: "assets/icons/linkedin.svg",
                        ),
                        SizedBox(width: size.width * 0.09),
                        LogoButton(
                          function: () {},
                          svgPath: "assets/icons/icloud.svg",
                        ),
                      ],
                    ),
                    SizedBox(height: size.height * 0.04),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don’t have an account? ",
                          style: TextStyle(
                            color: Palette.darkGrayColor,
                            fontSize: size.height * 0.018,
                            fontFamily: "Helvetica",
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Get.toNamed(
                              RoutesClass.getSinUpOneRoute(),
                            );
                          },
                          child: Text(
                            "Sign up",
                            style: TextStyle(
                              decoration: TextDecoration.underline,
                              color: Palette.mainBlueColor,
                              fontSize: size.height * 0.018,
                              fontFamily: "Helvetica",
                            ),
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
      ),
    );
  }
}
