import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gouantum/controllers/global_functions.dart';
import 'package:gouantum/model/users.dart';
import 'package:gouantum/screens/home/model/post.dart';
import 'package:gouantum/screens/notifications/notification_controller.dart';
import 'package:gouantum/utilities/firestore_constants.dart';

class LikeAndUnlike extends StatefulWidget {
  final PostsModel postsModel;

  const LikeAndUnlike({super.key, required this.postsModel});

  @override
  // ignore: library_private_types_in_public_api
  _LikeAndUnlikeState createState() => _LikeAndUnlikeState();
}

GlobalFunctionsController globalFunctionsController =
    Get.put(GlobalFunctionsController());

class _LikeAndUnlikeState extends State<LikeAndUnlike> {
  FirebaseAuth? _user;
  int _likes = 0;
  bool _isLiked = false;
  UserModel? userModel;

  @override
  void initState() {
    super.initState();
    _getCurrentUser();
  }

  void _getCurrentUser() async {
    _user = FirebaseAuth.instance;

    _checkIfLiked();
  }

  void _checkIfLiked() async {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('_posts')
        .doc(widget.postsModel.postId)
        .get();
    if (snapshot.exists) {
      Map<String, dynamic> data = snapshot.data()! as Map<String, dynamic>;
      if (mounted) {
        setState(() {
          _likes = data["likes"];
          _isLiked = data.containsKey(_user!.currentUser!.uid);
        });
      }
    } else {
      if (mounted) {
        setState(() {
          _likes = 0;
        });
      }
    }
  }

  void _like() async {
    userModel = await globalFunctionsController
        .getUserFromFirebase(widget.postsModel.uid);
    if (mounted) {
      setState(() {
        _likes++;
        _isLiked = true;
      });
    }

    FirebaseFirestore.instance
        .collection('_posts')
        .doc(widget.postsModel.postId)
        .set(
      {
        'likes': _likes,
        _user!.currentUser!.uid: true,
      },
      SetOptions(merge: true),
    );
    FirebaseFirestore.instance.collection(FirestoreConstants.userCollection);

    NotificationController notificationController = NotificationController();

    notificationController.addNewNotification(
        widget.postsModel, "Like your post");

    // Send Notification
    globalFunctionsController.sendNotification(
      data: {
        'title': 'New notification',
        'type': 'notification',
        'body': 'your post has been liked by ${userModel!.name} '
      },
      // token: userLikePost!.token,
      token: widget.postsModel.uid ?? "",
    );
  }

  void _unlike() {
    if (mounted) {
      setState(() {
        _likes--;
        _isLiked = false;
      });
    }

    FirebaseFirestore.instance
        .collection('_posts')
        .doc(widget.postsModel.postId)
        .update({
      'likes': _likes,
      _user!.currentUser!.uid: FieldValue.delete(),
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (_isLiked)
          IconButton(
            icon: const Icon(Icons.thumb_up, color: Colors.blueAccent),
            onPressed: _unlike,
          )
        else
          IconButton(
            icon: const Icon(
              Icons.thumb_up,
              color: Colors.grey,
            ),
            onPressed: _like,
          ),
        Text(' $_likes'),
      ],
    );
  }
}
