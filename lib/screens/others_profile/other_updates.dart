import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gouantum/screens/home/model/post.dart';
import 'package:gouantum/widgets/widgets.dart';

// ignore: must_be_immutable
class OtherUpdates extends StatelessWidget {
  const OtherUpdates({
    super.key,
    required this.size,
    required this.postsModel,
  });

  final Size size;
  final List<PostsModel> postsModel;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        if (postsModel.isEmpty) NoDataExist(size: size),
        for (var i = 0; i < postsModel.length; i++)
          postsModel[i].uid != FirebaseAuth.instance.currentUser!.uid
              ? UserPosts(
                  size: size,
                  postsModel: postsModel[i],
                )
              : NoDataExist(size: size)
      ],
    );
  }
}
