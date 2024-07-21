import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:gouantum/controllers/global_functions.dart';
import 'package:gouantum/screens/home/home_controller.dart';
import 'package:gouantum/screens/home/model/post.dart';
import 'package:gouantum/screens/notifications/notification_controller.dart';
import 'package:image_picker/image_picker.dart';
import 'image.dart';

class Comments extends StatefulWidget {
  final PostsModel postsModel;
  const Comments({super.key, required this.postsModel});
  @override
  State<Comments> createState() => _CommentsState();
}

class _CommentsState extends State<Comments> {
  @override
  void initState() {
    controller.getCommentsFromFirebase(
      widget.postsModel.postId!,
    );
    super.initState();
  }

  HomeController controller = Get.put(HomeController());
  final TextEditingController commentController = TextEditingController();
  File? avatar;
  bool isUploading = false;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      height: size.height * 0.9,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          Obx(() => controller.isDataLoadingComments.value
              ? const Center(child: CircularProgressIndicator())
              : Expanded(
                  child: ListView.builder(
                    itemCount: controller.comments!.length,
                    itemBuilder: (context, index) {
                      final comment = controller.comments![index];
                      return ImageComments(
                        imagePost: comment.imagePost,
                        text: comment.comment,
                        image: comment.imageUser,
                        name: comment.name,
                        time: comment.createdAt,
                        isMe: comment.uid == controller.user!.userUID
                            ? true
                            : false,
                      );
                    },
                  ),
                )),
          avatar == null
              ? Container()
              : Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                          image: FileImage(avatar!),
                          fit: BoxFit.cover,
                        ),
                      ),
                      height: size.height * 0.1,
                      width: size.width * 0.5,
                    ),
                    IconButton(
                        onPressed: () {
                          setState(() {
                            avatar = null;
                          });
                        },
                        icon: const Icon(Icons.close, color: Colors.red)),
                  ],
                ),
          Row(
            children: [
              Expanded(
                child: Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: size.width * 0.02,
                    vertical: size.height * 0.01,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(
                      size.width * 0.03,
                    ),
                  ),
                  child: TextFormField(
                    controller: commentController,
                    decoration: InputDecoration(
                      hintText: 'Write a comment...',
                      border: InputBorder.none,
                      suffixIcon: IconButton(
                        onPressed: () {
                          showModalBottomSheet(
                              context: context,
                              builder: (context) => Container(
                                    height: size.height * 0.2,
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
                                                .then((value) async {
                                              setState(() {
                                                avatar = value;
                                              });
                                            });
                                          },
                                        ),
                                        ListTile(
                                          leading: const Icon(Icons.image),
                                          title: const Text("Gallery"),
                                          onTap: () {
                                            Navigator.pop(context);
                                            GlobalFunctionsController()
                                                .pickImage(ImageSource.gallery)
                                                .then((value) async {
                                              setState(() {
                                                avatar = value;
                                              });
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                  ));
                        },
                        icon: Icon(
                          Icons.attach_file_sharp,
                          color: Colors.grey,
                          size: size.height * 0.035,
                        ),
                      ),
                      contentPadding: const EdgeInsets.only(
                        left: 15,
                        bottom: 11,
                        top: 15,
                        right: 15,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: size.width * 0.01),
              IconButton(
                onPressed: () async {
                  if (avatar == null) {
                    controller.addCommentToFirebase(
                        commentController.text, widget.postsModel.postId!, "");
                    commentController.clear();

                    SystemChannels.textInput.invokeMethod('TextInput.hide');
                    controller.refreshCommentsFromFirebase(
                      widget.postsModel.postId!,
                    );
                  } else {
                    EasyLoading.show(status: 'loading...');
                    UploadTask uploadTask = GlobalFunctionsController()
                        .uploadFile(avatar!, "${DateTime.now()}", "comments");
                    TaskSnapshot snapshot = await uploadTask;

                    final imageUrl = await snapshot.ref.getDownloadURL();
                    controller.addCommentToFirebase(commentController.text,
                        widget.postsModel.postId!, imageUrl);
                    commentController.clear();

                    SystemChannels.textInput.invokeMethod('TextInput.hide');
                    controller.refreshCommentsFromFirebase(
                      widget.postsModel.postId!,
                    );
                    setState(() {
                      avatar = null;
                    });
                    EasyLoading.dismiss();
                  }
                  NotificationController notificationController =
                      NotificationController();
                  notificationController.addNewNotification(
                      widget.postsModel, "comment your post");
                },
                icon: const Icon(Icons.send),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
