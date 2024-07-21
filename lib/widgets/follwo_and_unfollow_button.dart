import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gouantum/controllers/global_functions.dart';
import 'package:gouantum/utilities/palette.dart';

import '../model/users.dart';

class FollowAndUnfollowButton extends StatefulWidget {
  const FollowAndUnfollowButton({
    super.key,
    required this.size,
    required this.user,
  });

  final Size size;
  final UserModel user;

  @override
  State<FollowAndUnfollowButton> createState() =>
      _FollowAndUnfollowButtonState();
}

class _FollowAndUnfollowButtonState extends State<FollowAndUnfollowButton> {
  GlobalFunctionsController globalFunctionsController =
      Get.put(GlobalFunctionsController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GlobalFunctionsController>(
      init: GlobalFunctionsController(),
      builder: (context) {
        if (globalFunctionsController.followedUsersIds == null) {
          return const SizedBox();
        } else {
          var isFollowed =
              globalFunctionsController.checkFollowStatus(widget.user.userUID);
          return InkWell(
            onTap: () {
              if (isFollowed) {
                globalFunctionsController.unFollowUser(widget.user);
              } else {
                globalFunctionsController.followUser(widget.user);
              }
            },
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: widget.size.height * 0.025,
                vertical: widget.size.height * 0.007,
              ),
              decoration: BoxDecoration(
                color: Palette.mainBlueColor,
                border: Border.all(
                  color: Palette.darkGrayColor,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                isFollowed ? 'Unfollow' : "Follow",
                style: const TextStyle(
                  fontFamily: "Helvetica",
                  color: Colors.white,
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
//assets/img/logo/testImage/user.png

// ignore_for_file: public_member_api_docs, sort_constructors_first
// import 'dart:developer';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';

// import 'package:gouantum/model/users.dart';
// import 'package:gouantum/utilities/firestore_constants.dart';

// class FollowAndUnfollowButton extends StatefulWidget {
//   const FollowAndUnfollowButton({
//     Key? key,
//     required this.size,
//     required this.userId,
//   }) : super(key: key);

//   final Size size;
//   final String userId;

//   @override
//   State<FollowAndUnfollowButton> createState() =>
//       _FollowAndUnfollowButtonState();
// }

// class _FollowAndUnfollowButtonState extends State<FollowAndUnfollowButton> {
  
//   @override
// bool isFollowing = false;
//   UserModel? currentUser;
//    var isDataLoading = true;
//   Widget build(BuildContext context) {
//       FirebaseFirestore firestore = FirebaseFirestore.instance;
//         FirebaseAuth auth = FirebaseAuth.instance;
//           firestore
//           .collection(FirestoreConstants.userCollection)
//           .doc(auth.currentUser!.uid)
//           .get()
//           .then((value) {
//         log(value.data().toString());
//         currentUser = UserModel.fromJson(value.data()!);
//       }).whenComplete(() {
//         isDataLoading =false;
//       });

//     return
//     ElevatedButton(
//           onPressed: () {
//             setState(() {
//               isFollowing = !isFollowing;
//             });
//             if (isFollowing) {
//               // Add the current user's ID to the followed user's following array
//               FirebaseFirestore.instance.collection('users').doc(widget.userId).update({
//                 'following': FieldValue.arrayUnion([currentUser!.user_UID])
//               });
//               // Add the followed user's ID to the current user's following array
//               FirebaseFirestore.instance.collection('users').doc(currentUser!.user_UID).update({
//                 'following': FieldValue.arrayUnion([widget.userId])
//               });
//             } else {
//               // Remove the current user's ID from the followed user's following array
//               FirebaseFirestore.instance.collection('users').doc(widget.userId).update({
//                 'following': FieldValue.arrayRemove([currentUser!.user_UID])
//               });
//               // Remove the followed user's ID from the current user's following array
//               FirebaseFirestore.instance.collection('users').doc(currentUser!.user_UID).update({
//                 'following': FieldValue.arrayRemove([widget.userId])
//               });
//             }
//           },
//           child: Text(isFollowing ? 'Unfollow' : 'Follow'),
//     );
//     // InkWell(
//     //   onTap: () {
//     //     setState(() {
          
//     //     });
//     //   },
//     //   child: Container(
//     //     padding: EdgeInsets.symmetric(
//     //       horizontal: widget.size.height * 0.025,
//     //       vertical: widget.size.height * 0.007,
//     //     ),
//     //     decoration: BoxDecoration(
//     //       color: Palette.mainBlueColor,
//     //       border: Border.all(
//     //         color: Palette.darkGrayColor,
//     //       ),
//     //       borderRadius: BorderRadius.circular(10),
//     //     ),
//     //     child: const Text(
//     //       'Follow',
//     //       style: TextStyle(
//     //         fontFamily: "Helvetica",
//     //         color: Colors.white,
//     //       ),
//     //     ),
//     //   ),
//     // );
//  // }
// }}