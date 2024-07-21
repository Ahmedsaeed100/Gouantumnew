import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:gouantum/controllers/global_functions.dart';
import 'package:gouantum/screens/home/home_controller.dart';
import 'package:gouantum/screens/home/model/post.dart';
import 'package:gouantum/utilities/firestore_constants.dart';
import 'model/notification_model.dart';

class NotificationController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  List<NotificationsModel>? notificationsModel;
  var isDataLoadingNotification = true.obs;
  Stream<QuerySnapshot<Map<String, dynamic>>>? stream;

  @override
  Future<void> onInit() async {
    await getNotificationFromFirebase();
    super.onInit();
  }

// Streaming
  Stream<QuerySnapshot> getNotificationStream() {
    try {
      stream = firestore
          .collection(FirestoreConstants.userCollection)
          .doc(auth.currentUser!.uid)
          .collection(FirestoreConstants.notificationCollection)
          // ignore: unrelated_type_equality_checks
          .where("notificationSeen", isEqualTo: false)
          .orderBy('notificationTime', descending: true)
          .snapshots();

      // This listens for the new message when the user is on the chat page to change the status of the new message to seen.
      stream!.listen(
        (event) {
          if (event.docs.isEmpty) {
            return;
          } else {
            // Stream data to Notifications Model
            // notificationsModel = stream
            //     .map((e) => NotificationsModel.fromJson(e.data()))
            //     .toList() as List<NotificationsModel>?;
          }
        },
      );
      stream!.map((snapShot) => snapShot.docs
          .map(
            (e) => NotificationsModel.fromJson(
              e.data(),
            ),
          )
          .toList());
      return stream!;
    } catch (e) {
      return stream!;
    }
  }

  // Update Notification Seen To True
  updateNotificationSeen(bool notificationSeen, String postId) {
    firestore
        .collection(FirestoreConstants.userCollection)
        .doc(auth.currentUser?.uid)
        .collection(FirestoreConstants.notificationCollection)
        .doc(postId)
        .update({"notificationSeen": notificationSeen});

    ///getNotificationFromFirebase();
  }

  //Future Get Notification From Firebase
  Future<void> getNotificationFromFirebase() async {
    // print('getPostsFromFirebase');
    try {
      isDataLoadingNotification(true);
      return await firestore
          .collection(FirestoreConstants.userCollection)
          .doc(auth.currentUser?.uid)
          .collection(FirestoreConstants.notificationCollection)
          // .where("notificationSeen", isEqualTo: [false])
          .orderBy('notificationTime', descending: true)
          .get()
          .then((value) {
        notificationsModel = value.docs
            .map((e) => NotificationsModel.fromJson(e.data()))
            .toList();
      }).whenComplete(() {
        isDataLoadingNotification(false);
        log("notificationsModel is $notificationsModel");
        update();
      });
    } catch (e) {
      //isDataLoadingNotification(false);
      log('Error while getting data is $e');
      // Get.dialog(
      //   AlertDialog(
      //     title: const Text('Error'),
      //     content: Text('Error while getting data is $e'),
      //     actions: [
      //       TextButton(
      //         onPressed: () {
      //           Get.back();
      //         },
      //         child: const Text('Ok'),
      //       ),
      //     ],
      //   ),
      // );
    }
  }

  HomeController homeController = Get.put(HomeController());
  GlobalFunctionsController globalFunctionsController =
      GlobalFunctionsController();
// User Notification List
  addNewNotification(PostsModel post, String notificationType) {
    FirebaseFirestore.instance
        .collection(FirestoreConstants.userCollection)
        .doc(post.uid)
        .collection(FirestoreConstants.notificationCollection)
        .doc(post.postId)
        .set({
      'userName': homeController.user!.name,
      'userImage': homeController.user!.userImage,
      "postId": post.postId,
      "notificationAction": "${homeController.user!.name} $notificationType",
      "notificationTime": DateTime.now(),
      "notificationSeen": false,
    });
//
    getNotificationFromFirebase();
    // Send Notification
    globalFunctionsController.sendNotification(
      data: {
        'title': 'New notification',
        'type': 'notification',
        'body': 'your post has been liked by ${homeController.user!.name}'
      },
      // token: homeController.user!.token,
      token: post.userData!.token,
    );
  } //500036.74
}
