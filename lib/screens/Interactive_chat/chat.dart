import 'dart:core';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:gouantum/screens/calls/presentaion/views/home_views/home_screen_pageview.dart';
import 'package:gouantum/screens/screens.dart';
import 'package:gouantum/utilities/palette.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'chat_controllers.dart';
import 'constants/constants.dart';
import 'model/chat_page_arguments.dart';
import 'widgets/item_chat/item_chat.dart';
import 'widgets/loading_view.dart';
import 'widgets/recording.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key, required this.arguments});

  final ChatPageArguments arguments;

  @override
  ChatPageState createState() => ChatPageState();
}

class ChatPageState extends State<ChatPage> {
  late String currentUserId;

  List<QueryDocumentSnapshot> listMessage = [];
  int _limit = 20;
  final int _limitIncrement = 20;
  String groupChatId = "";

  File? imageFile;
  File? nameFile;
  bool isLoading = false;
  bool isShowSticker = false;
  String imageUrl = "";

  final TextEditingController textEditingController = TextEditingController();
  final ScrollController listScrollController = ScrollController();
  final FocusNode focusNode = FocusNode();

  late ChatController chatProvider;
  //late AuthProvider authProvider;
  late final SharedPreferences prefs;
  @override
  void initState() {
    super.initState();
    chatProvider = Get.put(ChatController());
    // authProvider = context.read<AuthProvider>();
    focusNode.addListener(onFocusChange);
    listScrollController.addListener(_scrollListener);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // ignore: unnecessary_null_comparison
      if (chatProvider != null) {
        setState(() {
          isLoading = false;
        });
      }
      readLocal();
    });
  }

  @override
  void dispose() {
    chatProvider.messageStreamSub.cancel();
    super.dispose();
  }

  _scrollListener() {
    if (!listScrollController.hasClients) return;
    if (listScrollController.offset >=
            listScrollController.position.maxScrollExtent &&
        !listScrollController.position.outOfRange &&
        _limit <= listMessage.length) {
      setState(() {
        _limit += _limitIncrement;
      });
    }
  }

  void onFocusChange() {
    if (focusNode.hasFocus) {
      setState(() {
        isShowSticker = false;
      });
    }
  }

  void readLocal() {
    if (FirebaseAuth.instance.currentUser != null) {
      currentUserId = FirebaseAuth.instance.currentUser!.uid;
    } else {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => LoginScreen()),
        (Route<dynamic> route) => false,
      );
    }

    String peerId = widget.arguments.peerId;
    if (currentUserId.compareTo(peerId) > 0) {
      groupChatId = '$currentUserId-$peerId';
    } else {
      groupChatId = '$peerId-$currentUserId';
    }

    chatProvider.updateDataFirestore(
      FirestoreConstants.userCollection,
      currentUserId,
      {FirestoreConstants.chattingWith: peerId},
    );

    chatProvider.changeUnseenMessagesStatus(groupChatId);
    chatProvider.initChatListener(groupChatId,peerId, _limit);
  }

  bool isLastMessageLeft(int index) {
    if ((index > 0 &&
            listMessage[index - 1].get(FirestoreConstants.idFrom) ==
                currentUserId) ||
        index == 0) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> onBackPress() {
    if (isShowSticker) {
      setState(() {
        isShowSticker = false;
      });
    } else {
      chatProvider.updateDataFirestore(
        FirestoreConstants.userCollection,
        currentUserId,
        {FirestoreConstants.chattingWith: null},
      );
      Navigator.pop(context);
    }

    return Future.value(false);
  }

  String valueMic = '';
  bool emojiShowing = false;

  bool valueMicShow = false;
  ValueNotifier<bool> isDialOpen = ValueNotifier(false);
  @override
  Widget build(BuildContext context) {
    final ChatController controller = Get.put(ChatController());
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Palette.mGrayColor,
          // leadingWidth: 20,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.blue,
              size: size.height * 0.03,
            ),
          ),
          titleSpacing: 0,
          centerTitle: false,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Get.to(
                      OtherProfile(
                        otherUid: widget.arguments.peerId,
                      ),
                    ),
                    child: CircleAvatar(
                      radius: 20,
                      backgroundImage:
                          NetworkImage(widget.arguments.peerAvatar),
                      backgroundColor: Colors.blueGrey,
                    ),
                  ),
                  SizedBox(width: size.width * 0.02),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.arguments.peerNickname,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontFamily: 'SFPro',
                          color: Colors.black,
                          fontSize: size.height * 0.02,
                        ),
                      ),
                      Text(
                        "Team leader , IT village",
                        style: TextStyle(
                          color: const Color(0xff8E8E93),
                          fontFamily: 'SFPro',
                          fontSize: size.height * 0.015,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(width: size.width * 0.2),
              // Call Button

              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                //   crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      startVideoCall(
                        receiverID: widget.arguments.peerId,
                        context: context,
                        isVideo: false,
                      );
                    },
                    child: const Icon(
                      Icons.phone_outlined,
                      color: Color(0xff979797),
                    ),
                  ),
                  SizedBox(height: size.height * 0.002),
                  Text(
                    "${widget.arguments.callMinuteCast} /Min",
                    style: TextStyle(
                      fontWeight: FontWeight.w300,
                      fontFamily: 'SFPro',
                      fontSize: size.width * 0.03,
                      color: Palette.mainBlueColor,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
        // ignore: deprecated_member_use
        body: WillPopScope(
          onWillPop: onBackPress,
          child: Stack(
            children: [
              SizedBox(
                height: double.infinity,
                width: double.infinity,
                child: SvgPicture.asset(
                  "assets/img/chat_img.svg",
                  fit: BoxFit.fill,
                  height: 100,
                  width: 100,
                ),
              ),
              Column(
                children: [
                  // List of messages
                  buildListMessage(),
                  Obx(
                    () => controller.loading == true.obs
                        ? SizedBox(
                            height: size.height * 0.15,
                            width: size.width * 0.80,
                            child: Lottie.asset(
                              height: size.height * 0.1,
                              controller.path.value,
                            ),
                          )
                        : const SizedBox(),
                  ),
                  Offstage(
                    offstage: !emojiShowing,
                    child: SizedBox(
                        height: size.height * 0.3,
                        child: EmojiPicker(
                          textEditingController: textEditingController,
                          onEmojiSelected: (emoji, category) {
                            setState(() {});
                          },
                          onBackspacePressed: () {
                            setState(() {
                              emojiShowing = false;
                            });
                          },
                          config: Config(
                            columns: 7,
                            emojiSizeMax: 32 *
                                (foundation.defaultTargetPlatform ==
                                        TargetPlatform.iOS
                                    ? 1.30
                                    : 1.0),
                            verticalSpacing: 0,
                            horizontalSpacing: 0,
                            gridPadding: EdgeInsets.zero,
                            initCategory: Category.RECENT,
                            bgColor: const Color(0xFFF2F2F2),
                            indicatorColor: Colors.blue,
                            iconColor: Colors.grey,
                            iconColorSelected: Colors.blue,
                            backspaceColor: Colors.blue,
                            skinToneDialogBgColor: Colors.white,
                            skinToneIndicatorColor: Colors.grey,
                            enableSkinTones: true,
                            //showRecentsTab: true,
                            recentsLimit: 28,
                            replaceEmojiOnLimitExceed: false,
                            noRecents: const Text(
                              'No Recents',
                              style: TextStyle(
                                  fontSize: 20, color: Colors.black26),
                              textAlign: TextAlign.center,
                            ),
                            loadingIndicator: const SizedBox.shrink(),
                            tabIndicatorAnimDuration: kTabScrollDuration,
                            categoryIcons: const CategoryIcons(),
                            buttonMode: ButtonMode.MATERIAL,
                            checkPlatformCompatibility: true,
                          ),
                        )),
                  ),
                  if (valueMicShow)
                    SizedBox(
                      height: size.height * 0.15,
                      width: double.infinity,
                      child: RecordingWidget(
                        sendAudio: (
                          File path,
                        ) {
                          setState(() {
                            imageFile = path;
                            valueMicShow = false;
                            valueMic = '';
                          });
                          chatProvider.uploadFileFirst(
                            type: TypeMessage.audio,
                            content: imageFile!,
                            fileSize: "",
                            pathLottie: "assets/json/audio-waves.json",
                            peerId: widget.arguments.peerId,
                            groupChatId: groupChatId,
                            name: "audio",
                            currentUserId: currentUserId,
                            fileTypeName: '🎙️ audio',
                            token: widget.arguments.token,
                          );
                        },
                        cancelRecord: () {
                          setState(
                            () {
                              valueMicShow = false;
                              valueMic = '';
                            },
                          );
                        },
                      ),
                    ),
                  buildInput(),
                ],
              ),

              //buildLoading(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildLoading() {
    return Positioned(
      child: isLoading ? const LoadingView() : const SizedBox.shrink(),
    );
  }

  Widget buildInput() {
    final size = MediaQuery.of(context).size;
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Palette.medGrayColor,
            ),
          ),
        ),
        height: 70,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: size.height * 0.07,
                    margin: EdgeInsets.only(left: size.width * 0.01),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: TextField(
                        onChanged: (value) {
                          setState(() {
                            valueMic = value;
                          });
                        },
                        onSubmitted: (value) {
                          if (value.contains('https://')) {
                            chatProvider.onSendMessage(
                              content: textEditingController.text,
                              type: TypeMessage.url,
                              fileSize: "",
                              token: widget.arguments.token,
                              peerId: widget.arguments.peerId,
                              groupChatId: groupChatId,
                              currentUserId: currentUserId,
                              nameFile: 'url',
                            );
                            textEditingController.clear();
                            // print('The message contains a well-formed URL');
                          } else {
                            chatProvider.onSendMessage(
                              content: textEditingController.text,
                              type: TypeMessage.text,
                              fileSize: "",
                              token: widget.arguments.token,
                              peerId: widget.arguments.peerId,
                              groupChatId: groupChatId,
                              currentUserId: currentUserId,
                              nameFile: 'text',
                            );
                            textEditingController.clear();
                            //  print(
                            //   'The message does not contain a well-formed URL');
                          }

                          valueMic = '';
                        },
                        style: const TextStyle(
                            color: ColorConstants.primaryColor, fontSize: 15),
                        controller: textEditingController,
                        keyboardType: TextInputType.text,

                        textInputAction: TextInputAction.send,
                        decoration: InputDecoration(
                          prefixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  emojiShowing = !emojiShowing;
                                });
                              },
                              icon: const Icon(Icons.emoji_emotions_outlined)),
                          suffixIcon: SizedBox(
                            width: size.width * 0.25,
                            child: FittedBox(
                              fit: BoxFit.fitWidth,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  IconButton(
                                    padding: EdgeInsets.zero,
                                    onPressed: () {
                                      chatProvider.getImageCamera(
                                        currentUserId: currentUserId,
                                        peerId: widget.arguments.peerId,
                                        name: "image",
                                        type: 1,
                                        groupChatId: groupChatId,
                                        content: "",
                                        token: widget.arguments.token,
                                      );
                                    },
                                    icon: const Icon(
                                      Icons.camera_alt,
                                      color: ColorConstants.primaryColor,
                                    ),
                                  ),
                                  SpeedDial(
                                    openCloseDial: isDialOpen,
                                    icon: Icons.attach_file_sharp,
                                    direction: SpeedDialDirection.up,
                                    backgroundColor: Colors.transparent,
                                    iconTheme: const IconThemeData(
                                        color: Colors.black),
                                    activeIcon: Icons.close,
                                    elevation: 0,
                                    activeBackgroundColor: Colors.transparent,
                                    activeForegroundColor: Colors.black,
                                    visible: true,
                                    children: [
                                      SpeedDialChild(
                                        child: const Icon(Icons.camera_alt,
                                            color: Colors.white),
                                        backgroundColor: Colors.pink,
                                        onTap: () {
                                          chatProvider.getImageCamera(
                                            currentUserId: currentUserId,
                                            peerId: widget.arguments.peerId,
                                            name: "image",
                                            type: 1,
                                            groupChatId: groupChatId,
                                            content: "",
                                            token: widget.arguments.token,
                                          );
                                        },
                                      ),
                                      SpeedDialChild(
                                        child: const Icon(Icons.image,
                                            color: Colors.white),
                                        backgroundColor: Colors.purple,
                                        onTap: () {
                                          chatProvider.getImageGallery(
                                            currentUserId: currentUserId,
                                            peerId: widget.arguments.peerId,
                                            name: "image",
                                            type: 1,
                                            groupChatId: groupChatId,
                                            content: "",
                                            token: widget.arguments.token,
                                          );
                                        },
                                      ),
                                      SpeedDialChild(
                                        child: const Icon(
                                            Icons.video_camera_back_outlined,
                                            color: Colors.white),
                                        backgroundColor: Colors.red,
                                        onTap: () {
                                          chatProvider.getVideo(
                                            currentUserId: currentUserId,
                                            peerId: widget.arguments.peerId,
                                            name: "video",
                                            type: 2,
                                            groupChatId: groupChatId,
                                            content: "",
                                            token: widget.arguments.token,
                                          );
                                        },
                                      ),
                                      SpeedDialChild(
                                        child: const Icon(Icons.file_copy,
                                            color: Colors.white),
                                        backgroundColor: Colors.blue,
                                        onTap: () {
                                          chatProvider.getFile(
                                            currentUserId: currentUserId,
                                            peerId: widget.arguments.peerId,
                                            name: "file",
                                            type: 5,
                                            groupChatId: groupChatId,
                                            content: "",
                                            token: widget.arguments.token,
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          border: InputBorder.none,
                          hintText: 'Type your message...',
                          hintStyle: const TextStyle(color: Colors.grey),
                          contentPadding: const EdgeInsets.all(
                            10,
                          ),
                        ),
                        focusNode: focusNode,
                        //autofocus: true,
                      ),
                    ),
                  ),
                ),
                textEditingController.text.isNotEmpty
                    ? IconButton(
                        onPressed: () {
                          if (textEditingController.text.contains('https://')) {
                            chatProvider.onSendMessage(
                              content: textEditingController.text,
                              type: TypeMessage.url,
                              fileSize: "",
                              token: widget.arguments.token,
                              peerId: widget.arguments.peerId,
                              groupChatId: groupChatId,
                              currentUserId: currentUserId,
                              nameFile: '',
                            );
                            textEditingController.clear();
                            //print('The message contains a well-formed URL');
                          } else {
                            chatProvider.onSendMessage(
                              content: textEditingController.text,
                              type: TypeMessage.text,
                              fileSize: "",
                              token: widget.arguments.token,
                              peerId: widget.arguments.peerId,
                              groupChatId: groupChatId,
                              currentUserId: currentUserId,
                              nameFile: '',
                            );
                            textEditingController.clear();
                            //print(
                            //  'The message does not contain a well-formed URL');
                          }
                        },
                        icon: const Icon(FontAwesomeIcons.paperPlane))
                    : IconButton  (
                        onPressed: () {
                          setState(() {
                            valueMicShow = !valueMicShow;
                          });
                        },
                        icon: const Icon(FontAwesomeIcons.microphone)),
              ],
            ),
            //  show ? emojiSelect() : Container(),
          ],
        ),
      ),
    );
  }

  Widget buildListMessage() {
    return Flexible(
      child: groupChatId.isNotEmpty
          ? StreamBuilder<QuerySnapshot>(
              stream: chatProvider.getChatStream(groupChatId, _limit),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasData) {
                  listMessage = snapshot.data!.docs;
                  if (listMessage.isNotEmpty) {
                    return ListView.builder(
                      padding: const EdgeInsets.all(10),
                      itemBuilder: (context, index) => ItemChat(
                        index: index,
                        document: snapshot.data?.docs[index],
                        currentUserId: currentUserId,
                        listMessage: listMessage,
                      ),
                      itemCount: snapshot.data?.docs.length,
                      reverse: true,
                      controller: listScrollController,
                    );
                  } else {
                    return const Center(child: Text("No message here yet..."));
                  }
                } else {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: ColorConstants.themeColor,
                    ),
                  );
                }
              },
            )
          : const Center(
              child: CircularProgressIndicator(
                color: ColorConstants.themeColor,
              ),
            ),
    );
  }
}
