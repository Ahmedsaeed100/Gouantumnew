import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:gouantum/controllers/global_functions.dart';
import 'package:gouantum/utilities/setting.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../utilities/palette.dart';
import '../../home_controller.dart';

class UserAddPost extends StatefulWidget {
  const UserAddPost({
    super.key,
    required this.size,
  });

  final Size size;

  @override
  State<UserAddPost> createState() => _UserAddPostState();
}

class _UserAddPostState extends State<UserAddPost> {
  HomeController homeController = Get.put(HomeController());

  final TextEditingController postController = TextEditingController();

  final FocusNode postFocusNode = FocusNode();

  File? image;
  List<File>? images;
  List<String> imagesUrl = [];

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: widget.size.height * 0.020,
        horizontal: widget.size.width * 0.03,
      ),
      height: image == null && images == null
          // ? widget.size.height * 0.22
          ? widget.size.height * 0.22
          : widget.size.height * 0.35,
      width: widget.size.width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(
          widget.size.width * 0.025,
        ),
      ),
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(
              top: widget.size.height * 0.01,
              left: widget.size.width * 0.020,
              bottom: widget.size.height * 0.001,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: widget.size.height * 0.018,
                      backgroundImage: NetworkImage(
                        homeController.user?.userImage ?? defUserImg,
                      ),
                    ),
                    SizedBox(
                      width: widget.size.width * 0.02,
                    ),
                    Text(
                      'Mr. ${homeController.user?.name ?? ""}',
                      style: const TextStyle(
                        color: Palette.darkGrayColor,
                        fontFamily: "Helvetica",
                      ),
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) => Container(
                        height: widget.size.height * 0.2,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                        ),
                        child: Column(
                          children: [
                            ListTile(
                              leading: const Icon(Icons.camera),
                              title: const Text("Camera"),
                              onTap: () {
                                Navigator.pop(context);
                                GlobalFunctionsController()
                                    .pickImage(ImageSource.camera)
                                    .then(
                                  (value) async {
                                    setState(
                                      () {
                                        image = value;
                                      },
                                    );
                                  },
                                );
                              },
                            ),
                            ListTile(
                              leading: const Icon(Icons.image),
                              title: const Text("Gallery"),
                              onTap: () {
                                Navigator.pop(context);
                                GlobalFunctionsController()
                                    .pickMultiImage()
                                    .then(
                                  (value) async {
                                    setState(
                                      () {
                                        images = value;
                                      },
                                    );
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  icon: Icon(
                    Icons.attach_file_sharp,
                    color: Colors.grey,
                    size: widget.size.height * 0.035,
                  ),
                ),
              ],
            ),
          ),
          TextFormField(
            controller: postController,
            onEditingComplete: () async {
              if (image == null && images == null) {
                homeController.addPostToFirebase(postController.text, "", []);
                SystemChannels.textInput.invokeMethod('TextInput.hide');
                postController.clear();
              } else if (image != null || images != null) {
                EasyLoading.show(status: 'loading...');
                if (images != null) {
                  for (int i = 0; i < images!.length; i++) {
                    UploadTask uploadTask = GlobalFunctionsController()
                        .uploadFile(images![i], "${DateTime.now()}", "post");
                    TaskSnapshot snapshot = await uploadTask;
                    final imageUrl = await snapshot.ref.getDownloadURL();
                    imagesUrl.add(imageUrl);
                  }
                  homeController.addPostToFirebase(
                      postController.text, "", imagesUrl);
                  EasyLoading.dismiss();
                } else {
                  UploadTask uploadTask = GlobalFunctionsController()
                      .uploadFile(image!, "${DateTime.now()}", "post");
                  TaskSnapshot snapshot = await uploadTask;
                  final imageUrl = await snapshot.ref.getDownloadURL();
                  homeController
                      .addPostToFirebase(postController.text, imageUrl, []);
                  EasyLoading.dismiss();
                }
                postController.clear();
                setState(() {
                  image = null;
                  images = null;
                });
                SystemChannels.textInput.invokeMethod('TextInput.hide');
              }
            },
            keyboardType: TextInputType.multiline,
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              contentPadding: EdgeInsets.only(
                left: widget.size.width * 0.03,
                right: widget.size.width * 0.02,
              ),
              hintText: 'What’s on your mind?',
              hintStyle: TextStyle(fontSize: widget.size.width * 0.032),
            ),
            maxLines: 4,
          ),
          image == null
              ? Container()
              : Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                          image: FileImage(image!),
                          fit: BoxFit.cover,
                        ),
                      ),
                      height: widget.size.height * 0.1,
                      width: widget.size.width * 0.5,
                    ),
                    IconButton(
                        onPressed: () {
                          setState(
                            () {
                              image = null;
                            },
                          );
                        },
                        icon: const Icon(Icons.close, color: Colors.red)),
                  ],
                ),
          images == null
              ? const SizedBox.shrink()
              : SizedBox(
                  height: widget.size.height * 0.1,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: images!.length,
                    itemBuilder: (context, index) {
                      return Stack(
                        children: [
                          Container(
                            margin:
                                EdgeInsets.only(left: widget.size.width * 0.02),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                image: FileImage(images![index]),
                                fit: BoxFit.cover,
                              ),
                            ),
                            height: widget.size.height * 0.1,
                            width: widget.size.width * 0.5,
                          ),
                          IconButton(
                            onPressed: () {
                              setState(
                                () {
                                  images!.removeAt(index);
                                },
                              );
                            },
                            icon: const Icon(Icons.close, color: Colors.red),
                          ),
                        ],
                      );
                    },
                  ),
                ),
          Align(
            alignment: Alignment.bottomRight,
            child: InkWell(
              onTap: () async {
                if (image == null && images == null) {
                  homeController.addPostToFirebase(postController.text, "", []);
                  SystemChannels.textInput.invokeMethod('TextInput.hide');
                  postController.clear();
                } else if (image != null || images != null) {
                  EasyLoading.show(status: 'loading...');
                  if (images != null) {
                    for (int i = 0; i < images!.length; i++) {
                      UploadTask uploadTask = GlobalFunctionsController()
                          .uploadFile(images![i], "${DateTime.now()}", "post");
                      TaskSnapshot snapshot = await uploadTask;
                      final imageUrl = await snapshot.ref.getDownloadURL();
                      imagesUrl.add(imageUrl);
                    }
                    homeController.addPostToFirebase(
                        postController.text, "", imagesUrl);
                    EasyLoading.dismiss();
                  } else {
                    UploadTask uploadTask = GlobalFunctionsController()
                        .uploadFile(image!, "${DateTime.now()}", "post");
                    TaskSnapshot snapshot = await uploadTask;
                    final imageUrl = await snapshot.ref.getDownloadURL();
                    homeController
                        .addPostToFirebase(postController.text, imageUrl, []);
                    EasyLoading.dismiss();
                  }
                  postController.clear();
                  setState(() {
                    image = null;
                    images = null;
                  });
                  SystemChannels.textInput.invokeMethod('TextInput.hide');
                }
              },
              child: Container(
                width: widget.size.width * 0.22,
                height: widget.size.height * 0.032,
                margin: EdgeInsets.symmetric(
                  horizontal: widget.size.width * 0.025,
                ),
                decoration: BoxDecoration(
                  color: Palette.mainBlueColor,
                  borderRadius:
                      BorderRadius.circular(widget.size.width * 0.015),
                ),
                child: const Center(
                  child: Text(
                    "Post",
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: "Helvetica",
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
