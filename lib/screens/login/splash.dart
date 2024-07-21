import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:gouantum/screens/login/login.dart';
import 'package:location/location.dart';

import '../main_screen/main_screen.dart';

class GouantumSplash extends StatefulWidget {
  const GouantumSplash({super.key});

  @override
  State<GouantumSplash> createState() => _GouantumSplashState();
}

class _GouantumSplashState extends State<GouantumSplash> {
  @override
  void initState() {
    super.initState();
    userState();
    // Uncomment the next line if you want to enable location service
    // locationService();
  }

  // User state check
  void userState() async {
    bool getState = false;
    Future.delayed(
      const Duration(milliseconds: 300),
      () {
        FirebaseAuth.instance.authStateChanges().listen(
          (User? user) {
            //  print('User email: ${user?.email}');
            if (user == null && !getState) {
              getState = true;
              Get.offAll(() => LoginScreen());
            } else if (!getState) {
              getState = true;
              Get.offAll(() => const MainScreen());
            }
          },
        );
      },
    );
  }

  Future<void> locationService() async {
    Location location = Location();

    bool serviceEnabled;
    PermissionStatus permissionLocation;

    // Check if the location service is enabled
    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    // Check for location permission
    permissionLocation = await location.hasPermission();
    if (permissionLocation == PermissionStatus.denied) {
      permissionLocation = await location.requestPermission();
      if (permissionLocation != PermissionStatus.granted) {
        return;
      }
    }

    // Get location data
    LocationData locData = await location.getLocation();

    setState(
      () {
        UserLocation.lat = locData.latitude!;
        UserLocation.long = locData.longitude!;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Positioned(
              top: size.height * 0.10,
              left: size.width * 0.14,
              child: SvgPicture.asset(
                "assets/img/logo/Guantum_Splash_logo1.svg",
                semanticsLabel: 'Logo',
              ),
            ),
            Positioned(
              bottom: size.height * 0.001,
              right: size.width * 0.001,
              child: SvgPicture.asset(
                "assets/img/logo/Guantum_Splash_logo2.svg",
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class UserLocation {
  static double lat = 0;
  static double long = 0;
}
