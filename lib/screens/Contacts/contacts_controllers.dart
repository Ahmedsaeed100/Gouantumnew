import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gouantum/model/users.dart';
import 'package:gouantum/utilities/firestore_constants.dart';

import '../../controllers/global_functions.dart';

class ContactsController extends GetxController {
  UserModel? user;
  List<UserModel>? userList;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  List<String>? followedUsersIds;

  var followedList = <UserModel>[].obs;

  List<UserModel>? followersList;

  GlobalFunctionsController globalFunctionsController =
      Get.put(GlobalFunctionsController());

  @override
  void onInit() async {
    super.onInit();
    getUserFeaturedProviders();
  }

  final FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  var isDataLoading = true.obs;

  var isFollowedListLoading = true.obs;

  var isFollowersListLoading = true.obs;

  /// Upload Any Thing
  UploadTask uploadFile(File image, String fileName) {
    Reference reference = firebaseStorage.ref().child(fileName);
    UploadTask uploadTask = reference.putFile(image);

    return uploadTask;
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

  // get all the users that I follow
  getFollowedUsers() async {
    try {
      if (globalFunctionsController.followedUsersIds!.isEmpty) {
        followedList.value = [];
        isFollowedListLoading(false);
      } else {
        await firestore
            .collection(FirestoreConstants.userCollection)
            .where(FirestoreConstants.id,
                whereIn: globalFunctionsController.followedUsersIds)
            .get()
            .then(
          (value) {
            if (value.docs.isEmpty) {
              followedList.value = [];
            } else {
              followedList.value = value.docs
                  .map(
                    (e) => UserModel.fromJson(
                      e.data(),
                    ),
                  )
                  .toList();
            }
          },
        ).whenComplete(() => isFollowedListLoading(false));
      }
    } catch (e) {
      isFollowedListLoading(false);
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

  // get all the users that follow me
  Future getFollowers() async {
    try {
      firestore
          .collection(FirestoreConstants.userCollection)
          .doc(auth.currentUser!.uid)
          .collection(FirestoreConstants.followersCollection)
          .get()
          .then(
        (value) async {
          if (value.docs.isEmpty) {
            followersList = [];
          } else {
            List<UserModel> list = [];
            for (var value in value.docs) {
              var doc = value.data()[FirestoreConstants.id];
              var d = await firestore
                  .collection(FirestoreConstants.userCollection)
                  .doc(doc)
                  .get()
                  .then(
                (value) {
                  return UserModel.fromJson(value.data()!);
                },
              );
              list.add(d);
            }

            followersList = list;
          }

          // ignore: void_checks
        },
      ).whenComplete(
        () {
          isFollowersListLoading(false);
        },
      );
    } catch (e) {
      isFollowersListLoading(false);
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


  List<QueryDocumentSnapshot<Map<String, dynamic>>> getCaseInsensitiveUsers(
      String searchKey ,
      List<QueryDocumentSnapshot<Map<String, dynamic>>> data){

    List<QueryDocumentSnapshot<Map<String, dynamic>>> results = [];
    for(var item in data){
      if(item['name'].toString().toLowerCase().contains(searchKey.toLowerCase())){
        results.add(item);
      }
    }
    return results;
  }

}
