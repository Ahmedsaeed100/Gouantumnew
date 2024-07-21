import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:gouantum/screens/home/widget/posts/like.dart';
import 'package:gouantum/screens/screens.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../../../utilities/palette.dart';
import '../../../../utilities/setting.dart';
import '../../../Interactive_chat/widgets/full_photo_page.dart';
import '../../home_controller.dart';
import '../../model/post.dart';
import '../comment/comments.dart';
import 'item_text.dart';

// ignore: must_be_immutable
class UserPosts extends StatelessWidget {
  final Size size;
  final PostsModel postsModel;
  HomeController homeController = Get.put(HomeController());
  final TextEditingController commentController = TextEditingController();

  UserPosts({super.key, required this.size, required this.postsModel});
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Card(
        margin: EdgeInsets.symmetric(
            horizontal: size.width * 0.05, vertical: size.height * 0.02),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      InkWell(
                        onTap: () {
                          // Check if current User Go To "His Profile" else go to "Other Profile"
                          homeController.userUid != postsModel.uid
                              ? Get.to(
                                  OtherProfile(
                                    otherUid: postsModel.uid,
                                  ),
                                )
                              : Get.to(const MyProfile());
                        },
                        child: CircleAvatar(
                          radius: size.height * 0.022,
                          child: CachedNetworkImage(
                            imageUrl:
                                postsModel.userData?.userImage ?? defUserImg,
                            imageBuilder: (context, imageProvider) {
                              return Container(
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: imageProvider,
                                    fit: BoxFit.cover,
                                  ),
                                  shape: BoxShape.circle,
                                ),
                              );
                            },
                            placeholder: (context, url) {
                              return const CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Palette.mainBlueColor,
                                ),
                              );
                            },
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          ),
                        ),
                      ),
                      SizedBox(width: size.width * 0.02),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                // 'Mr. ${post.user}',
                                'Mr. ${postsModel.userData?.name ?? ""}',
                                style: const TextStyle(
                                  fontFamily: "Helvetica",
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(width: size.width * 0.02),
                              const Text(
                                '4.5',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: "Helvetica",
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: size.height * 0.005),
                          Text(
                            timeago.format(
                              postsModel.time.toDate(),
                            ),
                            style: TextStyle(
                              fontSize: size.width * 0.025,
                              fontFamily: "Helvetica",
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Text(
                    // ' /Min get Call Minute',
                    "${postsModel.userData?.callMinuteCast} G",
                    style: const TextStyle(
                      fontFamily: "Helvetica",
                      color: Palette.gouantColor,
                    ),
                  ),
                ],
              ),
            ),
            postsModel.post! != ""
                ? Container(
                    margin: EdgeInsets.symmetric(horizontal: size.width * 0.16),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: ItemPostText(
                        text: postsModel.post!,
                      ),
                    ),
                  )
                : const SizedBox(),
            postsModel.image != ""
                ? InkWell(
                    onTap: () {
                      Get.to(FullPhotoPage(url: postsModel.image!));
                    },
                    child: Hero(
                      tag: postsModel.image!,
                      child: Padding(
                        padding: EdgeInsets.all(size.height * 0.01),
                        child: Image.network(
                          height: size.height * 0.3,
                          width: size.width,
                          postsModel.image!,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  )
                : const SizedBox(),
            postsModel.images!.isEmpty
                ? const SizedBox.shrink()
                : buildImages(context),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                LikeAndUnlike(
                  postsModel: postsModel,
                ),
                TextButton(
                  child: const Text(
                    'Comment',
                    style: TextStyle(
                      color: Palette.darkGrayColor,
                      fontFamily: "Helvetica",
                    ),
                  ),
                  onPressed: () async {
                    // await controller.clearComments();
                    Get.bottomSheet(
                      Comments(
                        postsModel: postsModel,
                      ),
                      isScrollControlled: true,
                    );
                  },
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 59, vertical: 0),
              child: TextFormField(
                controller: commentController,
                onTap: () async {
                  Get.bottomSheet(
                    Comments(
                      postsModel: postsModel,
                    ),
                    isScrollControlled: true,
                  );
                },
                onFieldSubmitted: (value) {
                  homeController.addCommentToFirebase(
                      value, postsModel.postId!, "");
                  commentController.clear();
                  SystemChannels.textInput.invokeMethod('TextInput.hide');
                },
                decoration: InputDecoration(
                  hintText: "Write a coment...",
                  hintStyle: TextStyle(fontSize: size.height * 0.015),
                  border: InputBorder.none,
                  focusedBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(25.0),
                    ),
                    borderSide: BorderSide(
                      color: Palette.lightwhiteColor,
                    ),
                  ),
                  contentPadding: const EdgeInsets.only(
                    bottom: 10.0,
                    left: 10.0,
                    right: 10.0,
                  ),
                ),
                keyboardType: TextInputType.text,
              ),
            ),
          ],
        ),
      ),
    );
  }

  buildImages(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(
        viewportFraction: 1,
        autoPlay: false,
        aspectRatio: 16 / 9,
        autoPlayInterval: const Duration(seconds: 3),
        autoPlayAnimationDuration: const Duration(milliseconds: 800),
        autoPlayCurve: Curves.fastOutSlowIn,
        enlargeCenterPage: true,
        scrollDirection: Axis.horizontal,
      ),
      items: postsModel.images!.map((i) {
        return Builder(
          builder: (BuildContext context) {
            return InkWell(
              onTap: () {
                Get.to(FullPhotoPage(url: i));
              },
              child: Hero(
                tag: i,
                child: Image.network(
                  i,
                  fit: BoxFit.cover,
                  width: MediaQuery.of(context).size.width,
                ),
              ),
            );
          },
        );
      }).toList(),
    );
  }
}
