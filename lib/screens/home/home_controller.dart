import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gouantum/utilities/firestore_constants.dart';
import '../../controllers/global_functions.dart';
import '../../model/users.dart';
import '../Interactive_chat/chat_controllers.dart';
import 'model/category.dart';
import 'model/comment.dart';
import 'model/post.dart';

class HomeController extends GetxController {
  UserModel? user;
  List<UserModel>? userFeaturedProviders;
  List<PostsModel>? postsModel;
  List<Comment>? comments;
  List<Category>? categories;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  var isDataLoading = true.obs;
  var isDataLoadingPosts = true.obs;
  var isDataLoadingMorePosts = true.obs;
  var isDataLoadingCategory = true.obs;
  var isDataLoadingFeaturedProviders = true.obs;
  var isDataLoadingComments = true.obs;
  String userUid = '';

  String allContactsSearchKey = '';
  String inComingSearchKey = '';
  String outGointSearchKey = '';

  //
  RxBool isFollowingListLoading = true.obs;
  RxBool isFollowersListLoading = true.obs;
  RxInt followingNumber = 0.obs;
  RxInt followersNumber = 0.obs;

  //
  ScrollController scrollController = ScrollController();

  int limit = 5;

  GlobalFunctionsController globalFunctionsController =
      Get.put(GlobalFunctionsController());

  List<SortedUser> usersLastMessages = [];
  final seenMessages = StreamController<int>();
  final missedCalls = StreamController<int>();
  int numOfSeenMessages = 0;
  int numOfMissedCall = 0;

  @override
  Future<void> onInit() async {
    super.onInit();
    userUid = auth.currentUser!.uid;
    await globalFunctionsController.getFollowedUsersIds(userUid);
    // get Current User
    user = await globalFunctionsController
        .getUserFromFirebase(userUid)
        .whenComplete(
          () => isDataLoading(false),
        );

    followingNumber.value = await globalFunctionsController
            .getFollowingUsers(userUid)
            .whenComplete(() => isFollowingListLoading(false)) ??
        0;

    followersNumber.value = await globalFunctionsController
            .getFollowers(userUid)
            .whenComplete(() => isFollowersListLoading(false)) ??
        0;
    await getPostsFromFirebase();
    await getCategoryFromFirebase();
    await getUserFeaturedProviders();
  }

  getUsersLastMessages() async{

    for (var item in userFeaturedProviders!) {
      String groupChatId = '';

      if (user!.userUID.compareTo(item.userUID) > 0) {
        groupChatId = '${user!.userUID}-${item.userUID}';
      } else {
        groupChatId = '${item.userUID}-${user!.userUID}';
      }

      await firestore
          .collection(FirestoreConstants.pathMessageCollection)
          .doc(groupChatId)
          .collection(groupChatId)
          .orderBy(FirestoreConstants.timestamp, descending: true)
          .get()
          .then(
            (value) {
          usersLastMessages.add(SortedUser(
              user: item,
              seenSendMessage: value.docs.isNotEmpty
                  ? !value.docs.first.data()['seen']
                      ? value.docs.first.data()['idFrom'] == user!.userUID
                          ? true
                          : false
                      : true
                  : true,
              lastMessageTime: value.docs.isNotEmpty
                  ? value.docs.first.data()['timestamp']
                  : ""));
        },
      );
    }

    for (var item in usersLastMessages) {
      if(!item.seenSendMessage){
        numOfSeenMessages++;
      }
    }
    seenMessages.sink.add(numOfSeenMessages);
  }

  getUserFeaturedProviders() async {
    try {
      firestore
          .collection(FirestoreConstants.userCollection)
          .where('user_UID',
              isNotEqualTo: FirebaseAuth.instance.currentUser!.uid)
          //.where('isFeaturedProvider', isEqualTo: true)
          .get()
          .then((value) {
        userFeaturedProviders =
            value.docs.map((e) => UserModel.fromJson(e.data())).toList();
      }).whenComplete(() async{
        isDataLoadingFeaturedProviders(false);
        await getUsersLastMessages();
      });
    } catch (e) {
      isDataLoadingFeaturedProviders(false);
      log('Error while getting data is $e');
      // print('Error while getting data is $e');
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

  // get user FeaturedProviders
  Stream<QuerySnapshot<Map<String, dynamic>>>? streamFeaturedProviders() {
    try {
      // print(allContactsSearchKey.isNotEmpty);
      return FirebaseFirestore.instance
              .collection(FirestoreConstants.userCollection)
              .where('user_UID', isNotEqualTo: auth.currentUser!.uid)
              .snapshots();
    } catch (e) {
      log('Error while getting data is $e');
      // print('Error while getting data is $e');
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

  List<QueryDocumentSnapshot<Map<String, dynamic>>> getCaseInsensitiveUsers(
      List<QueryDocumentSnapshot<Map<String, dynamic>>> data){

    List<QueryDocumentSnapshot<Map<String, dynamic>>> results = [];
    for(var item in data){
      if(item['name'].toString().toLowerCase().contains(allContactsSearchKey.toLowerCase())){
        results.add(item);
      }
    }
    return results;
  }

  search(String query, String type) {
    if (type == 'all contacts') {
      allContactsSearchKey = query;
      update();
    }
  }

  /// TO DO:  Posts
  // Add post to firebase
  Future<void> addPostToFirebase(String text, image, images) async {
    if (text == "" && image == '' && images == [0]) {
      Get.snackbar(
        'Error',
        'Please Don\'t leave the post empty',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } else {
      final DocumentReference ref =
          FirebaseFirestore.instance.collection("_posts").doc();
      ref.set({
        'post': text,
        'image': image,
        'images': images,
        //'user': user!.name,
        //'userImage': user!.userImage,
        "uid": auth.currentUser!.uid,
        'time': DateTime.now(),
        'likes': 0,
        'id': ref.id,
        'comments': null,
        //'userData':user?.toJson()
      }).whenComplete(
        () {
          getPostsFromFirebase();
          Get.snackbar(
            'Success',
            'Post Added Successfully',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
        },
      );
    }
  }

  int _limit = 5;
  // Get Posts From Firebase
  Future<void> getPostsFromFirebase() async {
    // print('getPostsFromFirebase');
    isDataLoadingPosts(true);
    try {
      return await firestore
          .collection('_posts')
          .orderBy('time', descending: true)
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

        /*List<QueryDocumentSnapshot<Map<String, dynamic>>> x = value.docs;

        x.map((e) async{
          await firestore.collection("_users").doc(e.data()['uid']).get().then((value2) {
            userModel = UserModel.fromJson(value2.data() ?? {});
          });
          PostsModel post =  PostsModel.fromJson(e.data(),user: userModel);
          postTest.add(post);
          return null;
        }).toList();*/
      }).whenComplete(() {
        isDataLoadingPosts(false);
        log("postsModel is $postsModel");
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

  // Get More Posts From Firebase
  void loadMorePosts() {
    //  print('loadMorePosts');
    _limit += 5;
    isDataLoadingPosts(true);
    try {
      firestore
          .collection('_posts')
          .orderBy('time')
          .limit(_limit + 5)
          .get()
          .then((value) {
        //print('value is ${value.docs.length}');
        postsModel =
            value.docs.map((e) => PostsModel.fromJson(e.data())).toList();
        log("postsModel is $postsModel");
        isDataLoadingPosts(false);
      }).whenComplete(() {
        // print("whenComplete");
        isDataLoadingMorePosts(false);
        update();
      });
    } catch (e) {
      isDataLoadingMorePosts(false);
      update();
    }
  }

  // Add Comment to firebase
  Future<void> addCommentToFirebase(
      String text, String postId, String image) async {
    if (text == "") {
      Get.snackbar(
        'Error',
        'Please Don\'t leave the Comment empty',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } else {
      final DocumentReference ref =
          FirebaseFirestore.instance.collection("_posts").doc(postId);
      ref
          .collection('comments')
          .add(Comment(
            imagePost: image,
            comment: text,
            uid: auth.currentUser!.uid,
            createdAt: DateTime.now(),
            id: ref.id,
            imageUser: user!.userImage,
            name: user!.name,
          ).toJson())
          .whenComplete(() {
        Get.snackbar('Success', 'Comment Added Successfully');
      });
    }
  }

  // get Comments From Firebase
  Future<void> getCommentsFromFirebase(String postId) async {
    comments = [];
    // print('postId is $postId');
    isDataLoadingComments(true);
    try {
      return await firestore
          .collection('_posts')
          .doc(postId)
          .collection('comments')
          .orderBy('createdAt')
          .get()
          .then((value) {
        comments = value.docs
            .map((e) => Comment.fromJson(e.data()))
            .toList()
            .reversed
            .toList();
        update();
      }).whenComplete(() {
        isDataLoadingComments(false);
        log("comments is $comments");

        update();
      });
    } catch (e) {
      log('Error while getting data is $e');
      //  print('Error while getting data is $e');
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

  // clear all data from Comments
  clearComments() {
    comments!.clear();
  }

  // Make Post Like
  makePostLike(String postId) async {
    try {
      firestore.collection('_posts').doc(postId).update({
        'likes': FieldValue.increment(1),
      }).whenComplete(() {
        Get.snackbar('Success', 'Post Liked Successfully');
      });
    } catch (e) {
      log('Error while getting data is $e');
      // print('Error while getting data is $e');
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

  // Delete Post From Firebase
  deletePostFromFirebase(String id) async {
    try {
      firestore.collection('_posts').doc(id).delete().whenComplete(() {
        Get.snackbar('Success', 'Post Deleted Successfully');
      });
    } catch (e) {
      log('Error while getting data is $e');
      // print('Error while getting data is $e');
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

  // Update Post From Firebase
  updatePostFromFirebase(String id) async {
    try {
      firestore.collection('_posts').doc(id).update({
        'post': 'Updated Post',
      }).whenComplete(() {
        Get.snackbar('Success', 'Post Updated Successfully');
      });
    } catch (e) {
      log('Error while getting data is $e');
      // print('Error while getting data is $e');
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

  // refresh Posts From Firebase
  refreshPostsFromFirebase() async {
    isDataLoadingPosts(true);
    return getPostsFromFirebase();
  }

  // refresh Comments From Firebase
  refreshCommentsFromFirebase(String id) async {
    isDataLoadingComments(true);
    return getCommentsFromFirebase(id);
  }

  /// TO DO:  Category
  // Get Category From Firebase
  getCategoryFromFirebase() async {
    try {
      return await firestore
          .collection('EducationCategory')
          .get()
          .then((value) {
        categories = value.docs
            .map((e) => Category.fromJson(e.data()))
            .toList()
            .reversed
            .toList();
      }).whenComplete(
        () {
          isDataLoadingCategory(false);
          log("categories is $categories");
          update();
        },
      );
    } catch (e) {
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
  }

  // Add Category To Firebase
  addCategoryToFirebase({
    required String name,
    required String desc,
    required String image,
  }) async {
    final DocumentReference ref =
        FirebaseFirestore.instance.collection("EducationCategory").doc();
    ref
        .set(
      Category(
        name: name,
        image: image,
        id: ref.id,
        createdAt: DateTime.now().toIso8601String(),
        description: desc,
        updatedAt: DateTime.now().toIso8601String(),
      ).toJson(),
    )
        .whenComplete(
      () {
        Get.snackbar('Success', 'Category Added Successfully');
      },
    );
  }

  // Get Height of Image
  Future<double> getImageHeight(File image) async {
    final Completer<double> completer = Completer<double>();
    final ImageStream stream =
        Image.file(image).image.resolve(const ImageConfiguration());
    stream.addListener(
      ImageStreamListener(
        (ImageInfo info, bool _) {
          completer.complete(info.image.height.toDouble());
          stream.removeListener(ImageStreamListener(
            (ImageInfo info, bool _) {
              completer.complete(
                info.image.height.toDouble(),
              );
            },
          ));
        },
      ),
    );
    return completer.future;
  }
}
