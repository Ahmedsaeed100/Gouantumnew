import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:gouantum/model/users.dart';
import 'package:gouantum/utilities/firestore_constants.dart';
import 'package:image_picker/image_picker.dart';

///
/// Functions Used over All App
/// get Users
/// LIKE Function
/// Comments Function
/// Upload Function
/// Follow Function
FirebaseAuth auth = FirebaseAuth.instance;

///
///
class GlobalFunctionsController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  List<String>? followedUsersIds;

// Get User From Firebase
  Future<UserModel?> getUserFromFirebase(String? userUid) async {
    try {
      return await firestore
          .collection(FirestoreConstants.userCollection)
          .doc(userUid)
          .get()
          .then(
        (value) {
          //  log(value.data().toString());
          return UserModel.fromJson(value.data()!);
        },
      ).whenComplete(
        () {},
      );
    } catch (e) {
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
    return null;
  }

  getUserBalance(String? userUid) async {
    try {
      return await firestore
          .collection(FirestoreConstants.userCollection)
          .doc(userUid)
          .get()
          .then(
        (value) {
          //  log(value.data().toString());
          return UserModel.fromJson(value.data()!).myBalance;
        },
      ).whenComplete(
        () {},
      );
    } catch (e) {
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
    return null;
  }

// Get Followed Users ID
  getFollowedUsersIds(String? currentUserUid) async {
    try {
      FirebaseFirestore.instance
          .collection(FirestoreConstants.userCollection)
          .doc(currentUserUid)
          .collection(FirestoreConstants.followingCollection)
          .get()
          .then(
        (value) {
          if (value.docs.isEmpty) {
            followedUsersIds = [];
          } else {
            followedUsersIds = value.docs.map((e) {
              return e.data()[FirestoreConstants.id].toString();
            }).toList();
          }
        },
      ).whenComplete(() {
        update();
        // isFollowedUsersIdsLoading(false);
      });
    } catch (e) {
      // isFollowedUsersIdsLoading(false);
      log('Error while getting data is $e');
      //print('Error while getting data is $e');
    }
    return followedUsersIds;
  }

// Upload File
  final FirebaseStorage firebaseStorage = FirebaseStorage.instance;

  UploadTask uploadFile(File image, String fileName, String fileType) {
    Reference reference;
    // this function for file dereiction // أتجاه حفظ الملف //
    reference = firebaseStorage.ref(fileType).child(fileName).child("path");
    UploadTask uploadTask = reference.putFile(image);

    return uploadTask;
  }

  Future pickImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;
      final imageTemporary = File(image.path);
      return imageTemporary;
      // ignore: unused_catch_clause
    } on PlatformException catch (e) {
      //print("failed");
    }
  }

  Future pickMultiImage() async {
    try {
      final image = await ImagePicker().pickMultiImage();
      // ignore: unnecessary_null_comparison
      if (image == null) return;
      final imageTemporary = image.map((e) => File(e.path)).toList();
      return imageTemporary;
      // ignore: unused_catch_clause
    } on PlatformException catch (e) {
      // print("failed");
    }
  }

// Follow users
  Future followUser(UserModel otherUser) async {
    var usersCollection = FirebaseFirestore.instance
        .collection(FirestoreConstants.userCollection);

    var myUID = auth.currentUser!.uid;

    usersCollection
        .doc(myUID)
        .collection(FirestoreConstants.followingCollection)
        .doc(otherUser.userUID)
        .set({
      FirestoreConstants.id: otherUser.userUID,
    });

    usersCollection
        .doc(otherUser.userUID)
        .collection(FirestoreConstants.followersCollection)
        .doc(myUID)
        .set(
          await usersCollection.doc(myUID).get().then(
            (value) {
              var user = value.data()!;
              return {FirestoreConstants.id: user[FirestoreConstants.id]};
            },
          ),
        );

    followedUsersIds!.add(otherUser.userUID);
    update();

    // isFollowed.value = true;
  }
  //

// UnFollowUser users
  Future unFollowUser(UserModel otherUser) async {
    var usersCollection = FirebaseFirestore.instance
        .collection(FirestoreConstants.userCollection);
    var myUID = auth.currentUser!.uid;
    usersCollection
        .doc(myUID)
        .collection(FirestoreConstants.followingCollection)
        .where(FirestoreConstants.id, isEqualTo: otherUser.userUID)
        .get()
        .then((value) => value.docs[0].reference.delete());

    usersCollection
        .doc(otherUser.userUID)
        .collection(FirestoreConstants.followersCollection)
        .where(FirestoreConstants.id, isEqualTo: auth.currentUser!.uid)
        .get()
        .then((value) => value.docs[0].reference.delete());

    followedUsersIds!.remove(otherUser.userUID);
    update();
    // isFollowed.value = false;
  }

  // This function check whether  the other user is followed by me or not.
  bool checkFollowStatus(String uid) {
    if (followedUsersIds!.contains(uid)) {
      return true;
    } else {
      return false;
    }
  }

  // Following User -- get all the users that I follow
  Future<int?> getFollowingUsers(String? userUid) async {
    try {
      return await firestore
          .collection(FirestoreConstants.userCollection)
          .doc(userUid)
          .collection(FirestoreConstants.followingCollection)
          .count()
          .get()
          .then((value) => value.count);
    } catch (e) {
      log('Error while getting data is $e');
      //  print('this!');
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
      return null;
    }
  }

  // get all the users that follow me
  Future getFollowers(String? userUid) async {
    try {
      return firestore
          .collection(FirestoreConstants.userCollection)
          .doc(userUid)
          .collection(FirestoreConstants.followersCollection)
          .count()
          .get()
          .then((value) => value.count);
    } catch (e) {
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

// Send Notification
  var dio = Dio();

  sendNotification({required Map data, required String token}) async {
    try {
      dio.post(
        "https://fcm.googleapis.com/fcm/send",
        options: Options(
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization': FirestoreConstants.fCMToken,
          },
        ),
        data: {
          "priority": "high",
          "data": data,
          "to": token,
        },
      );
    } catch (e) {
      log("error $e");
    }
  }
}
