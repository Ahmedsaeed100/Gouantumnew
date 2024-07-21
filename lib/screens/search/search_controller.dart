import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gouantum/model/users.dart';
import 'package:gouantum/utilities/firestore_constants.dart';

class SearchController extends GetxController {
  UserModel? user;
  List<UserModel>? userList;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void onInit() {
    super.onInit();
    getUserFeaturedProviders();
  }

  var isDataLoading = true.obs;

  // get user FeaturedProviders
  Future<List<UserModel>?> getUserFeaturedProviders() async {
    try {
      firestore
          .collection(FirestoreConstants.userCollection)
          .where('user_UID',
              isNotEqualTo: FirebaseAuth.instance.currentUser!.uid)
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
      //print('Error while getting data is $e');
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
}
