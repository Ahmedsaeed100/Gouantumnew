import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gouantum/controllers/global_functions.dart';
import 'package:gouantum/model/users.dart';
import 'package:gouantum/screens/Interactive_chat/constants/constants.dart';
import 'package:gouantum/screens/home/model/category.dart';
import 'package:gouantum/screens/home/model/comment.dart';
import 'package:gouantum/screens/home/model/post.dart';
import 'package:gouantum/utilities/palette.dart';

class MyProfileController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final GlobalKey<FormState> updateFormKey = GlobalKey<FormState>();
  FirebaseAuth auth = FirebaseAuth.instance;
  String? userUid;
  UserModel? user;
  List<UserModel>? userFeaturedProviders;
  List<PostsModel>? postsModel;
  List<Comment>? comments;
  List<Category>? categories;
  RxBool isDataLoading = true.obs;
  RxBool isDataLoadingPosts = true.obs;
  RxBool isDataLoadingMorePosts = true.obs;
  RxBool isDataLoadingCategory = true.obs;
  RxBool isDataLoadingFeaturedProviders = true.obs;
  RxBool isDataLoadingComments = true.obs;
  RxBool businessAccountStates = true.obs;

  var userCallMinuteCast = 0.obs;
  var userVideoMinuteCast = 0.obs;

////
  RxBool isUserBalanceLoading = true.obs;
  RxDouble userBalance = 0.0.obs;

  List<UserModel>? userList;
  List<String>? followedUsersIds;
  RxList<UserModel> followedList = <UserModel>[].obs;

  List<UserModel>? followersList;
  GlobalFunctionsController globalFunctionsController =
      Get.put(GlobalFunctionsController());

////
  ///
  @override
  Future<void> onInit() async {
    super.onInit();
    // await getUserFromFirebase();
    // await getPostsFromFirebase();
    // await getCategoryFromFirebase();
    //await getUserFeaturedProviders();

    getBusinessAccountStates();
    userUid = auth.currentUser!.uid;
    userBalance.value = await globalFunctionsController
            .getUserBalance(userUid)
            .whenComplete(() => isUserBalanceLoading(false)) ??
        0;
  }

  /// TO DO:  User

  // update business account  true/false
  Future<void> updateBusinessAccount(bool value) async {
    await firestore
        .collection(FirestoreConstants.userCollection)
        .doc(auth.currentUser!.uid)
        .update({
      FirestoreConstants.businessAccount: value,
    });
  }

  Future getBusinessAccountStates() async {
    var variable = await FirebaseFirestore.instance
        .collection(FirestoreConstants.userCollection)
        .doc(auth.currentUser!.uid)
        .get();
    businessAccountStates.value = variable['businessAccount'];
  }

  Future<void> uploadImageDocumentsId(String url) async {
    await firestore
        .collection(FirestoreConstants.userCollection)
        .doc(auth.currentUser!.uid)
        .update({
      FirestoreConstants.idDocuments: url,
    }).whenComplete(() {
      Get.snackbar('Success', 'Your documents has been uploaded');
    }).catchError((e) {
      Get.snackbar('Error', 'Something went wrong please try again');
    });
  }

  // get All Users /// FeaturedProviders
  Future<List<UserModel>?> getUserFeaturedProviders() async {
    try {
      firestore
          .collection(FirestoreConstants.userCollection)
          .where(
            'user_UID',
            isNotEqualTo: FirebaseAuth.instance.currentUser!.uid,
          )
          //.where('isFeaturedProvider', isEqualTo: true)
          .get()
          .then(
        (value) {
          userList = value.docs
              .map(
                (e) => UserModel.fromJson(
                  e.data(),
                ),
              )
              .toList();
          // ignore: void_checks
        },
      ).whenComplete(
        () {
          isDataLoading(false);
        },
      );
    } catch (e) {
      isDataLoading(false);
      log('Error while getting data is $e');
      Get.dialog(
        AlertDialog(
          title: const Text('Error'),
          content: Text('Error while getting data is $e'),
          actions: [
            TextButton(
              onPressed: () {
                Get.back();
              },
              child: const Text('Ok'),
            ),
          ],
        ),
      );
    }
    return userList;
  }

  ///
  /// Update User Minute Price

// Check check Minute Price
  Future? checkMinutePrice(num callMinuteCast, videoMinuteCast) {
    // ignore: unrelated_type_equality_checks
    if (callMinuteCast == "") {
      customSnackBar(
          "Call Minute Cast Can't be empty", "Please Enter Call Minute Cast");
      return null;
      // ignore: unrelated_type_equality_checks
    } else if (callMinuteCast == "0") {
      customSnackBar("incorrect data", "Call Minute Cast can't be 0");
      return null;
    } else if (callMinuteCast > 100) {
      customSnackBar(
          "incorrect data", "The Max Minute Cast can't be bigger than 100 MG");
      return null;
    }
    // Video Minute Cost
    else if (videoMinuteCast == "") {
      customSnackBar(
          "Video Minute Cast Can't be empty", "Please enter Video Minute Cast");
      return null;
    } else if (videoMinuteCast == "0") {
      customSnackBar("incorrect data", "Video Minute Cast can't be 0");
      return null;
    } else if (videoMinuteCast > 100) {
      customSnackBar(
          "incorrect data", "The Max Minute Cast can't be bigger than 100 MG");
      return null;
    }
    updateUserMinutePrice(callMinuteCast, videoMinuteCast);
    return null;
    // signUp(email, password, email);
  }

  // Login User By Email and password
  void updateUserMinutePrice(num callMinuteCast, videoMinuteCast) async {
    // final token = await FirebaseMessaging.instance.getToken();
    try {
      FirebaseFirestore.instance
          .collection(FirestoreConstants.userCollection)
          .doc(userUid)
          .update(
        {
          "callMinuteCast": callMinuteCast,
          "videoMinuteCast": videoMinuteCast,
        },
      );
      globalFunctionsController.getUserFromFirebase(userUid);
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

  ///

//Custom Snackbar
  customSnackBar(String titleText, messageBody) {
    Get.snackbar(
      "Login Error",
      "User Message",
      backgroundColor: Palette.mainBlueColor,
      snackPosition: SnackPosition.BOTTOM,
      titleText: Text(
        titleText,
        style: const TextStyle(
          color: Colors.white,
        ),
      ),
      messageText: Text(
        messageBody,
        style: const TextStyle(
          color: Colors.white,
        ),
      ),
    );
  }

  ///End Custom Snackbar
}
