import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../model/users.dart';

class PostsModel {
  final int likes;
  final String? uid;
  //final Comment? comments;
  final String? postId;
  final String? post;
  // final String? user;
  final String? image;
  final List<dynamic>? images;
  // final String? userImage;
  final Timestamp time;
  // UserModel? userModel;
  UserModel? userData;

  PostsModel(
      {required this.uid,
      required this.post,
      required this.likes,
      required this.postId,
      //required this.comments,
      // required this.user,
      required this.image,
      required this.images,
      // required this.userImage,
      required this.time,
      this.userData});

  factory PostsModel.fromJson(Map<String, dynamic> json, {UserModel? user}) {
    // debugger();
    return PostsModel(
        likes: json['likes'],
        //comments: json['comments'],
        uid: json['uid'],
        postId: json['id'],
        post: json['post'],
        // user: json['user'],
        image: json['image'],
        images: json['images'],
        // userImage: json['userImage'],
        time: json['time'],
        userData: user
        // userData: json['userData'] != null ?
        //   UserModel.fromJson( json['userData']) : null
        );
  }
}
