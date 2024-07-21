// ignore: file_names
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gouantum/model/users.dart';
import 'package:gouantum/routes/routes.dart';
import 'package:gouantum/screens/calls/shared/network/cache_helper.dart';
import 'package:gouantum/utilities/firestore_constants.dart';
import 'package:gouantum/utilities/palette.dart';

class Signupontroller extends GetxController {
  final GlobalKey<FormState> signupOneFormKey = GlobalKey<FormState>();
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  @override
  void onInit() {
    getDropDownFromFirebase();
    getDropDownLanaguageFromFirebase();
    getDropDownCountryFromFirebse();
    super.onInit();
  }

  RxBool isLoading = false.obs;
  String name = '';
  String email = '';
  String password = '';
  String confirmPassword = '';
  String gender = '';
  String category = '';
  String langauage = '';
  String country = '';
  String phone = '';

  DateTime birthDate = DateTime.now();
  RxBool isPasswordVisible = false.obs;
  bool isMale = true;
  RxBool checkbox = false.obs;
  RxBool isDataLoading = true.obs;
// Show And hide Password
  showAndHidePassword() {
    if (isPasswordVisible.isTrue) {
      isPasswordVisible.value = false;
    } else {
      isPasswordVisible.value = true;
    }
    update();
  }

//
  Future<bool> shickIsEmailExist(String email) async {
    try {
      // ignore: deprecated_member_use
      final existingMethods = await auth.fetchSignInMethodsForEmail(email);
      if (existingMethods.isNotEmpty) {
        return true;

        // Email exists
      } else {
        return false;

        // Email does not exist
      }
    } catch (e) {
      log(e.toString());

      return true;
    }
  }

//
  // create New Account
  Future<void> signUp(String image) async {
    // If User Not Add Image
    if (image == '') {
      image == 'https://shorturl.at/fDRUZ';
    }
    //

    final token = await FirebaseMessaging.instance.getToken();
    isLoading(true);
    await auth
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((value) async {
      FirebaseFirestore.instance
          .collection(FirestoreConstants.userCollection)
          .doc(value.user!.uid)
          .set(
            UserModel(
              name: name.toLowerCase(), // Convert Name To Lower Case
              password: password,
              language: langauage,
              gender: isMale == true ? "Male" : "Female",
              educationCategory: category,
              dateOfBirth: birthDate.toString(),
              countries: country,
              accountStatus: "Active",
              email: email,
              businessAccount: false,
              // If frist Register Add Free Balance 50000 Gouant
              myBalance: 50000, // Gouant
              busy: false,
              phoneNumber: phone,
              regesterationDataTime: DateTime.now().toString(),
              token: token!,
              userImage: image,
              userUID: value.user!.uid,
              idDocuments: '',
              callMinuteCast: 1,
              videoMinuteCast: 1,
            ).toJson(),
          );
      CacheHelper.saveData(
        key: 'uId',
        value: value.user!.uid,
      );

      isLoading(false);
      Get.snackbar(
        "Success",
        "Account Created Successfully",
        colorText: Colors.white,
        backgroundColor: Palette.mainBlueColor,
        snackPosition: SnackPosition.BOTTOM,
      );
      Get.offAll(RoutesClass.getHomeRoute());
    }).catchError(
      (error) {
        isLoading(false);
        Get.snackbar(
          "Error ",
          colorText: Colors.white,
          error.toString(),
          backgroundColor: Palette.mainBlueColor,
          snackPosition: SnackPosition.BOTTOM,
        );
      },
    );
  }

//  Select Birthday
  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: birthDate,
      firstDate: DateTime(1940, 1),
      lastDate: birthDate,
    );
    if (picked != null && picked != birthDate) {
      birthDate = picked;
    }
    update();
  }

  agreement() {
    if (checkbox.isTrue) {
      checkbox.value = false;
    } else {
      checkbox.value = true;
    }

    update();
  }

// Select Gender
  userSelectGender() {
    isMale = !isMale;
    update();
  }

  DropdownMenuItem<String> buildMenuItem(String item) => DropdownMenuItem(
        value: item,
        child: Text(
          item,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
        ),
      );
// Select Education Category
  List<dynamic> educationCategory = [];
  void getDropDownFromFirebase() async {
    CollectionReference category = FirebaseFirestore.instance
        .collection(FirestoreConstants.educationCategoryCollection);
    await category.get().then((value) {
      educationCategory.addAll(value.docs);
    });
  }

  // Select Language
  // ignore: non_constant_identifier_names
  List<dynamic> Lanaguage = [];
  void getDropDownLanaguageFromFirebase() async {
    CollectionReference lanaguages = FirebaseFirestore.instance
        .collection(FirestoreConstants.langauageCollection);
    await lanaguages.get().then(
      (value) {
        Lanaguage.addAll(value.docs);
      },
    );
  }

  // Select Country
  // ignore: non_constant_identifier_names
  List<dynamic> Country = [];
  void getDropDownCountryFromFirebse() async {
    CollectionReference countries = FirebaseFirestore.instance
        .collection(FirestoreConstants.countryCollection);
    await countries.get().then(
      (value) {
        Country.addAll(value.docs);
        // print("sssssss$Country");
      },
    );
  }
}
