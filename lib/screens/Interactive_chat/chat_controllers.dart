import 'dart:async';
import 'dart:io';
import 'dart:math' as math;
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:gouantum/controllers/global_functions.dart';
import 'package:gouantum/model/users.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';

import '../home/home_controller.dart';
import 'constants/constants.dart';
import 'model/message_chat.dart';

class ChatController extends GetxController {
  final loading = false.obs;
  final path = 'test'.obs;

  changePath(RxString value) {
    path.value = value.value;
  }

  changeLoading(RxBool value) {
    loading.value = value.value;
  }

  File? imageFile;
  String imageUrl = "";
  File? fileSize;
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  var dio = Dio();
  /// this for controlling seen of message
  late StreamSubscription<QuerySnapshot<Map<String, dynamic>>> messageStreamSub;

  GlobalFunctionsController globalController =
      Get.put(GlobalFunctionsController());

  HomeController homeController = Get.put(HomeController());

  void onSendMessage(
      {required String content,
      required int type,
      required String nameFile,
      required String groupChatId,
      required String peerId,
      required String fileSize,
      required String token,
      required String currentUserId}) {
    if (content.trim().isNotEmpty) {
      MessageChat messageChat = MessageChat(
          idFrom: currentUserId,
          idTo: peerId,
          name: nameFile,
          fileSize: fileSize,
          timestamp: DateTime.now().millisecondsSinceEpoch.toString(),
          content: content,
          type: type,
          seen: false);

      sendMessage(
          groupChatId: groupChatId,
          messageChat: messageChat);
      var data = {
        'title': '${homeController.user?.name ?? "New"} message',
        'type': 'message',
        // 'body': content
        'body': messageChat.toJson()
      };
      globalController.sendNotification(data: data, token: token);
    } else {
      Fluttertoast.showToast(
          msg: 'Nothing to send', backgroundColor: ColorConstants.greyColor);
    }
  }

// رفع اي ملف سوا صوره او فديو او ملف او ريكورد
  Future uploadFileFirst({
    required int type,
    required String name,
    required String pathLottie,
    required File content,
    required String groupChatId,
    required String currentUserId,
    required String peerId,
    required String fileSize,
    required String fileTypeName,
    required String token,
  }) async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    UploadTask uploadTask = GlobalFunctionsController().uploadFile(
      content,
      fileName,
      "chat",
    );
    try {
      changePath(pathLottie.obs);
      changeLoading(true.obs);
      TaskSnapshot snapshot = await uploadTask;
      imageUrl = await snapshot.ref.getDownloadURL();

      if (imageUrl.isNotEmpty) {
        changeLoading(false.obs);
        changePath("".obs);
        MessageChat messageChat = MessageChat(
            idFrom: currentUserId,
            idTo: peerId,
            name: fileTypeName,
            fileSize: fileSize,
            timestamp: DateTime.now().millisecondsSinceEpoch.toString(),
            content: imageUrl,
            type: type,
            seen: false);

        sendMessage(
            messageChat: messageChat,
            groupChatId: groupChatId
        );
        var data = {
          'title': '${homeController.user?.name ?? "New"} message',
          'type': 'message',
          // 'body': 'New $fileTypeName'
          'body': messageChat.toJson()
        };
        globalController.sendNotification(data: data, token: token);
      }
    } on FirebaseException catch (e) {
      changeLoading(false.obs);
      changePath("".obs);
      Fluttertoast.showToast(msg: e.message ?? e.toString());
    }
  }

  Future<void> updateDataFirestore(String collectionPath, String docPath,
      Map<String, dynamic> dataNeedUpdate) {
    return firebaseFirestore
        .collection(collectionPath)
        .doc(docPath)
        .update(dataNeedUpdate);
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getChatStream(
      String groupChatId, int limit) {
    var stream = firebaseFirestore
        .collection(FirestoreConstants.pathMessageCollection)
        .doc(groupChatId)
        .collection(groupChatId)
        .orderBy(FirestoreConstants.timestamp, descending: true)
        .limit(limit)
        .snapshots();

    return stream;
  }

  void initChatListener(String groupChatId,String peerID, int limit){
    // This listens for the new message when the user is on the chat page to change the status of the new message to seen.
    var stream = getChatStream(groupChatId, limit);

    Iterable<SortedUser> sortedUser =
    homeController.usersLastMessages.where((element) {
      return element.user.userUID == peerID;
    });

    messageStreamSub = stream.listen(
          (event) {
        if (event.docs.isEmpty) {
          return;
        }
        var newestMessage = event.docs.first;
        if (newestMessage['idFrom'] != FirebaseAuth.instance.currentUser!.uid) {
          if (newestMessage['timestamp'] == sortedUser.first.lastMessageTime &&
              !sortedUser.first.seenSendMessage) {
            sortedUser.first.seenSendMessage = true;
            homeController.numOfSeenMessages--;
            homeController.seenMessages.sink
                .add(homeController.numOfSeenMessages);
          }
          //  print('object');
          firebaseFirestore
              .collection(FirestoreConstants.pathMessageCollection)
              .doc(groupChatId)
              .collection(groupChatId)
              .doc(newestMessage.id)
              .update(
            {'seen': true},
          );
        }
      },
    );
  }

  void updateUserStatus(
      {required List<QueryDocumentSnapshot<Map<String, dynamic>>> snapList,
      required int userIndex}) {
    SortedUser targetUser = homeController.usersLastMessages[userIndex];

    Iterable<QueryDocumentSnapshot<Map<String, dynamic>>> ss =
        snapList.where((element) {
      return UserModel.fromJson(element.data()).userUID ==
          targetUser.user.userUID;
    });
    targetUser.user = UserModel.fromJson(ss.first.data());
  }

  getLastMessage(String groupChatId, int limit) {
    var stream = firebaseFirestore
        .collection(FirestoreConstants.pathMessageCollection)
        .doc(groupChatId)
        .collection(groupChatId)
        .orderBy(FirestoreConstants.timestamp, descending: true)
        .limit(1)
        .get();
    return stream;
  }

  // This functions gets called on page initialization to change all unseen messages to seen.
  Future changeUnseenMessagesStatus(String groupChatId) async {
    if (await firebaseFirestore
        .collection(FirestoreConstants.pathMessageCollection)
        .doc(groupChatId)
        .collection(groupChatId)
        .limit(1)
        .get()
        .then((value) => value.docs.isNotEmpty ? true : false)) {
      firebaseFirestore
          .collection(FirestoreConstants.pathMessageCollection)
          .doc(groupChatId)
          .collection(groupChatId)
          .where('seen', isEqualTo: false)
          .get()
          .then(
        (messages) {
          for (var message in messages.docs) {
            if (message['idFrom'] != FirebaseAuth.instance.currentUser!.uid) {
              firebaseFirestore
                  .collection(FirestoreConstants.pathMessageCollection)
                  .doc(groupChatId)
                  .collection(groupChatId)
                  .doc(message.id)
                  .update(
                {'seen': true},
              );
            }
          }
        },
      );
    }
  }

  sendMessage({required String groupChatId, required MessageChat messageChat}){
    DocumentReference documentReference = firebaseFirestore
        .collection(FirestoreConstants.pathMessageCollection)
        .doc(groupChatId)
        .collection(groupChatId)
        .doc(messageChat.timestamp);

    FirebaseFirestore.instance.runTransaction((transaction) async {
      transaction.set(
        documentReference,
        messageChat.toJson(),
      );
    });

  }

  void updateMainLastMessageList(
      {required String peerId, required String specificTime,
        required String idFrom, required bool lastNewMessageSeen}) async {
    Iterable<SortedUser> data =
        homeController.usersLastMessages.where((element) {
      return element.user.userUID == peerId;
    });
    if(int.parse(data.first.lastMessageTime) < int.parse(specificTime)){

      data.first.lastMessageTime = specificTime;
      if (!lastNewMessageSeen && idFrom != homeController.userUid &&
          data.first.seenSendMessage) {
        data.first.seenSendMessage = false;
        homeController.numOfSeenMessages++;
        homeController.seenMessages.add(homeController.numOfSeenMessages);
      }
      updateDataFirestore(
        FirestoreConstants.userCollection,
        peerId,
        {
          FirestoreConstants.chattingWith:
          "Receiver update :${Random().nextInt(1000)}"
        },
      );
    }
  }

  Future getImageGallery({
    required int type,
    required String name,
    required String content,
    required String groupChatId,
    required String currentUserId,
    required String peerId,
    required String token,
  }) async {
    ImagePicker imagePicker = ImagePicker();
    XFile? pickedFile;

    // ignore: deprecated_member_use
    pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      imageFile = File(pickedFile.path);
      if (imageFile != null) {
        uploadFileFirst(
            type: type,
            name: name,
            fileSize: await getFileSize(imageFile!.path, 1),
            pathLottie: "assets/json/image-uploading.json",
            content: imageFile!,
            groupChatId: groupChatId,
            currentUserId: currentUserId,
            fileTypeName: '🖼️ image',
            token: token,
            peerId: peerId);
      }
    }
  }

  Future<void> getLauncherUrl(String url) async {
    if (!await launchUrl(
      Uri.parse(url),
      webOnlyWindowName: '_blank',
      mode: LaunchMode.externalApplication,
    )) {
      throw 'Could not launch $url';
    }
  }

  Future getImageCamera({
    required int type,
    required String name,
    required String content,
    required String groupChatId,
    required String currentUserId,
    required String peerId,
    required String token,
  }) async {
    ImagePicker imagePicker = ImagePicker();
    XFile? pickedFile;

    // ignore: deprecated_member_use
    pickedFile = await imagePicker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      imageFile = File(pickedFile.path);
      if (imageFile != null) {
        uploadFileFirst(
            type: type,
            name: name,
            pathLottie: "assets/json/image-uploading.json",
            fileSize: await getFileSize(imageFile!.path, 1),
            content: imageFile!,
            groupChatId: groupChatId,
            currentUserId: currentUserId,
            fileTypeName: '🖼️ image',
            token: token,
            peerId: peerId);
      }
    }
  }

  getFileSize(String filepath, int decimals) async {
    var file = File(filepath);
    int bytes = await file.length();
    if (bytes <= 0) return "0 B";
    const suffixes = ["B", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"];
    var i = (math.log(bytes) / math.log(1024)).floor();
    return '${(bytes / math.pow(1024, i)).toStringAsFixed(decimals)} ${suffixes[i]}';
  }

  Future getVideo({
    required int type,
    required String name,
    required String content,
    required String groupChatId,
    required String currentUserId,
    required String peerId,
    required String token,
  }) async {
    ImagePicker imagePicker = ImagePicker();
    XFile? pickedFile;

    // ignore: deprecated_member_use
    pickedFile = await imagePicker.pickVideo(
        source: ImageSource.gallery, maxDuration: const Duration(minutes: 5));
    if (pickedFile != null) {
      imageFile = File(pickedFile.path);
      if (imageFile != null) {
        uploadFileFirst(
            type: type,
            name: name,
            pathLottie: "assets/json/play-video-loader.json",
            fileSize: await getFileSize(imageFile!.path, 1),
            content: imageFile!,
            groupChatId: groupChatId,
            currentUserId: currentUserId,
            fileTypeName: '🎥 video',
            token: token,
            peerId: peerId);
      }
    }
  }

  Future getFile({
    required int type,
    required String name,
    required String content,
    required String groupChatId,
    required String currentUserId,
    required String peerId,
    required String token,
  }) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      imageFile = File(result.files.single.path!);
      if (imageFile != null) {
        uploadFileFirst(
            type: type,
            name: name,
            fileSize: await getFileSize(imageFile!.path, 1),
            content: imageFile!,
            pathLottie: "assets/json/upload-files-loader.json",
            groupChatId: groupChatId,
            currentUserId: currentUserId,
            fileTypeName: "📎 file",
            token: token,
            peerId: peerId);
      }
    }
  }
}

class TypeMessage {
  static const text = 0;
  static const image = 1;
  static const video = 2;
  static const audio = 3;
  static const url = 4;
  static const file = 5;
}

class SortedUser {
  late UserModel user;
  late String lastMessageTime;
  late bool seenSendMessage;
  SortedUser(
      {required this.user,
        required this.seenSendMessage,
        required this.lastMessageTime});
}
