import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gouantum/controllers/global_functions.dart';
import 'package:gouantum/model/users.dart';
import 'package:gouantum/screens/Interactive_chat/constants/constants.dart';

import '../home/model/post.dart';

class OtherProfileController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  List<UserModel>? userList;
  List<PostsModel>? postsModel;

  List<String>? followedUsersIds;
  var followedList = <UserModel>[].obs;
  var isFollowingListLoading = true.obs;
  var isFollowersListLoading = true.obs;
  var isDataLoadingPosts = true.obs;

  var isCalling = false.obs;

  RxInt followingNumber = 0.obs;
  RxInt followersNumber = 0.obs;
  // List<UserModel>? followersList;
  final String? userUid;
  OtherProfileController({this.userUid});

  @override
  void onInit() async {
    // print('object');
    followingNumber.value = await globalFunctionsController
            .getFollowingUsers(userUid)
            .whenComplete(() => isFollowingListLoading(false)) ??
        0;

    followersNumber.value = await globalFunctionsController
            .getFollowers(userUid)
            .whenComplete(() => isFollowersListLoading(false)) ??
        0;
    getPostsFromFirebase();
    super.onInit();
  }

  GlobalFunctionsController globalFunctionsController =
      Get.put(GlobalFunctionsController());
////

  // update business account  true/false
  Future<void> updateBusinessAccount(bool value) async {
    await firestore
        .collection(FirestoreConstants.userCollection)
        .doc(auth.currentUser!.uid)
        .update({
      FirestoreConstants.businessAccount: value,
    });
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

  Future<UserModel?> getUserProfile(userUid) =>
      globalFunctionsController.getUserFromFirebase(userUid);

  Future<void> getPostsFromFirebase() async {
    // print('getPostsFromFirebase');
    try {
      return await firestore
          .collection('_posts')
          .where('uid', isEqualTo: userUid)
          .orderBy('time', descending: true)
          //.orderBy('time', descending: true)
          // .limit(_limit)
          .get()
          .then((value) async {
        postsModel =
            value.docs.map((e) => PostsModel.fromJson(e.data())).toList();

        ///Get User Data

        debugPrint("Get User Data");

        for (int i = 0; i < (postsModel?.length ?? 0); i++) {
          await firestore
              .collection("_users")
              .doc(postsModel?[i].uid)
              .get()
              .then((item) {
            postsModel?[i].userData = UserModel.fromJson(item.data() ?? {});
          });
        }
      }).whenComplete(() {
        isDataLoadingPosts(false);
        // log("postsModel is $postsModel");
        update();
      });
    } catch (e) {
      isDataLoadingPosts(false);
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
  }
}
