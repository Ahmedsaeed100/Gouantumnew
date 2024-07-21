import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:gouantum/controllers/auth_controllers.dart';
import 'package:gouantum/model/users.dart';
import 'package:gouantum/screens/calls/shared/network/cache_helper.dart';
import 'package:gouantum/screens/main_screen/main_screen.dart';
import 'package:gouantum/screens/screens.dart';
import 'package:gouantum/utilities/firestore_constants.dart';
import 'package:gouantum/utilities/palette.dart';

class LoginController extends GetxController {
  // To Know which Screen User is Exist
  static AuthController instance = Get.find();
  FirebaseAuth auth = FirebaseAuth.instance;
  //
  GoogleSignIn googleSignIn = GoogleSignIn();

  final GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();

  bool isPasswordVisible = false;
  var email = '';
  var password = '';
  //
  String country = '';
  String city = '';
  String name = '';
  String street = '';
  String postalCode = '';
  String useraddress = '';
  //

  ///
  Future<void> getLocation() async {
    List<Placemark> placemark = await placemarkFromCoordinates(
      UserLocation.lat,
      UserLocation.long,
      //localeIdentifier: 'eg', get Arbic Address
    );

    country = placemark[0].country!;
    city = placemark[0].locality!;
    name = placemark[0].name!;
    street = placemark[0].street!;
    postalCode = placemark[0].postalCode!;
    useraddress = '$city -- $country -- $name -- \n$street \n $postalCode';
  }

//For Test only Remove It Latter
  getuserAddress() {
    Get.snackbar(
      duration: const Duration(seconds: 8),
      "User country is : $country",
      "User city is : $city \n User name is : $name \n User street is : $street \n User postalCode is : $postalCode",
      backgroundColor: Palette.mainBlueColor,
      snackPosition: SnackPosition.BOTTOM,
      titleText: Text(
        useraddress,
        style: const TextStyle(
          color: Colors.white,
        ),
      ),
    );
  }

  ///

// Check Is Email is correct
  String? validateEmail(String value) {
    if (!GetUtils.isEmail(value)) {
      return "Provide valid Email";
    }
    return null;
  }

// Check Is Password is correct
  String? validatePassword(String value) {
    if (value.length < 6) {
      return "Password must be of 6 characters";
    }
    return null;
  }

// Show And hide Password
  showAndHidePassword() {
    isPasswordVisible = !isPasswordVisible;
    update();
  }

// Check Login
  Future? checkLogin(String email, password) {
    final isValid = loginFormKey.currentState!.validate();
    if (!isValid) {
      // ignore: null_check_always_fails
      return null!;
    }
    loginFormKey.currentState!.save();
    login(email, password);
    return null;
    // signUp(email, password, email);
  }

// sign Up

  // Login User By Email and password
  void login(String email, password) async {
    final token = await FirebaseMessaging.instance.getToken();
    try {
      await auth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((value) {
        FirebaseFirestore.instance
            .collection(FirestoreConstants.userCollection)
            .doc(value.user!.uid)
            .update({"token": token});
        CacheHelper.saveData(key: 'uId', value: value.user!.uid);
        Get.offAll(() => const MainScreen());
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        Get.snackbar(
          "No user found for that email.",
          "No user found for that email.",
          backgroundColor: Palette.mainBlueColor,
          snackPosition: SnackPosition.BOTTOM,
          titleText: const Text(
            "No user found for that email.",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        );
      } else if (e.code == 'wrong-password') {
        Get.snackbar(
          "Wrong password provided for that user.",
          "Wrong password provided for that user.",
          backgroundColor: Palette.mainBlueColor,
          snackPosition: SnackPosition.BOTTOM,
          titleText: const Text(
            "Wrong password provided for that user.",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        );
      }
    } catch (e) {
      // ignore: avoid_print
      print(e);
      Get.snackbar(
        "Login Error",
        "User Message",
        backgroundColor: Palette.mainBlueColor,
        snackPosition: SnackPosition.BOTTOM,
        titleText: const Text(
          "Account Login Faild",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        messageText: Text(
          e.toString(),
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      );
    }
  }

  /// Google SignUp
  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    // print("00000000000");
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;
    // print("---------------------");
    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    final firebaseUser =
        await FirebaseAuth.instance.signInWithCredential(credential);
    // print("1111111111");
    // ignore: unnecessary_null_comparison
    if (firebaseUser != null) {
      String? token = await FirebaseMessaging.instance.getToken();

      // Check is already sign up
      // print("22222222");
      final QuerySnapshot result = await FirebaseFirestore.instance
          .collection(FirestoreConstants.userCollection)
          .where('user_UID', isEqualTo: firebaseUser.user!.uid)
          .get();
      CacheHelper.saveData(key: 'uId', value: firebaseUser.user!.uid);
      final List<DocumentSnapshot> documents = result.docs;
      if (documents.isEmpty) {
        // print("33333333333333");
        FirebaseFirestore.instance
            .collection(FirestoreConstants.userCollection)
            .doc(firebaseUser.user!.uid)
            .set(UserModel(
              name: firebaseUser.user!.displayName.toString(),
              password: "",
              language: '',
              gender: "",
              educationCategory: "",
              dateOfBirth: "",
              countries: "",
              accountStatus: "Active",
              email: firebaseUser.user!.email.toString(),
              businessAccount: false,
              // If frist Register Add Free Balance 50000 Gouant
              myBalance: 50000, // Gouant
              busy: false,
              phoneNumber: firebaseUser.user!.phoneNumber.toString(),
              regesterationDataTime: DateTime.now().toString(),
              token: token.toString(),
              userImage: firebaseUser.user!.photoURL.toString(),
              userUID: firebaseUser.user!.uid,
              idDocuments: '',
              callMinuteCast: 1,
              videoMinuteCast: 1,
            ).toJson());
      }
    }
    // print("4444444444444444");
    return firebaseUser;
  }
}
