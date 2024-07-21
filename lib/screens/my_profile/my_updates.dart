import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gouantum/widgets/widgets.dart';

import '../home/home_controller.dart';

// ignore: must_be_immutable
class MyUpdates extends StatelessWidget {
  MyUpdates({
    super.key,
    required this.size,
  });

  final Size size;
  HomeController homeController = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        for (var i = 0; i < homeController.postsModel!.length; i++)
          homeController.postsModel![i].uid !=
                  FirebaseAuth.instance.currentUser!.uid
              ? NoDataExist(size: size)
              : UserPosts(
                  size: size,
                  postsModel: homeController.postsModel![i],
                ),
      ],
    );
  }
}
