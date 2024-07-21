import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:gouantum/model/users.dart';
import 'package:gouantum/screens/Interactive_chat/chat_controllers.dart';
import 'package:gouantum/utilities/palette.dart';
import 'package:gouantum/widgets/my_buttons.dart';
import 'package:gouantum/widgets/widgets.dart';
import '../home/home_controller.dart';
import '../login/login.dart';
import 'chat.dart';
import 'model/chat_page_arguments.dart';
import 'model/message_chat.dart';

class ChatContacts extends StatefulWidget {
  const ChatContacts({super.key});

  @override
  State<ChatContacts> createState() => _ChatContactsState();
}

class _ChatContactsState extends State<ChatContacts> {
  List<dynamic> radioValues = [];
  bool isAllSelected = false;
  //
  List<QueryDocumentSnapshot> listMessage = [];

  String groupChatId = "";
  ChatController chatProvider = ChatController();
  //
  HomeController homeController = Get.put(HomeController());

  String currentUserId = "";
  void readLocal(String peerid) {
    if (FirebaseAuth.instance.currentUser != null) {
      currentUserId = FirebaseAuth.instance.currentUser!.uid;
    } else {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => LoginScreen()),
        (Route<dynamic> route) => false,
      );
    }

    // peerId = doc.userUID;
    if (currentUserId.compareTo(peerid) > 0) {
      groupChatId = '$currentUserId-$peerid';
    } else {
      groupChatId = '$peerid-$currentUserId';
    }
  }

  String convertTimestamp(String timestamp) {
    var date = DateTime.fromMillisecondsSinceEpoch(int.parse(timestamp));
    return "${date.day}/${date.month}/${date.year}";
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: TextButton(
            child: Text(
              'Edit',
              style: TextStyle(
                fontSize: size.height * 0.021,
                color: Palette.mainBlueColor,
                fontFamily: "SFPro",
              ),
            ),
            onPressed: () {
              setState(
                () {
                  isAllSelected = true;
                },
              );
            },
          ),
          title: Text(
            'Chats',
            style: TextStyle(
              fontSize: size.height * 0.023,
              color: Colors.black,
              fontFamily: "SFPro",
            ),
          ),
          centerTitle: true,
          backgroundColor: Palette.lightwhiteColor,
          elevation: 0,
        ),
        bottomNavigationBar: Container(
          width: MediaQuery.of(context).size.width,
          height:
              isAllSelected == true ? size.height * 0.1 : size.height * 0.001,
          color: Palette.lightwhiteColor,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextButton(
                child: Text(
                  'Delete',
                  style: TextStyle(
                    fontSize: size.height * 0.021,
                    color: Colors.grey,
                    fontFamily: "SFPro",
                  ),
                ),
                onPressed: () {
                  setState(
                    () {
                      isAllSelected = false;
                    },
                  );
                },
              ),
              TextButton(
                child: Text(
                  'Read All',
                  style: TextStyle(
                    fontSize: size.height * 0.021,
                    color: Colors.grey,
                    fontFamily: "SFPro",
                  ),
                ),
                onPressed: () {
                  setState(
                    () {
                      isAllSelected = false;
                    },
                  );
                },
              ),
              TextButton(
                child: Text(
                  'Archive',
                  style: TextStyle(
                    fontSize: size.height * 0.021,
                    color: Palette.mainBlueColor,
                    fontFamily: "SFPro",
                  ),
                ),
                onPressed: () {
                  setState(
                    () {
                      isAllSelected = false;
                    },
                  );
                },
              ),
            ],
          ),
        ),

        // New Group
        body: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                stream: homeController.firestore
                    .collection('_users')
                    .where('user_UID',
                        isNotEqualTo: FirebaseAuth.instance.currentUser!.uid)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    homeController.usersLastMessages.sort((a, b) =>
                        b.lastMessageTime.compareTo(a.lastMessageTime));
                    return ListView.builder(
                      itemBuilder: (context, index) {
                        chatProvider.updateUserStatus(
                            snapList: snapshot.data!.docs, userIndex: index);
                        return buildItem(
                          context,
                          homeController.usersLastMessages[index].user,
                        );
                      },
                      itemCount: homeController.usersLastMessages.length,
                    );
                  }
                  return Center(
                      child: Text(
                    "No User Yet",
                    style: TextStyle(
                      fontSize: size.height * 0.025,
                      fontFamily: "SFPro",
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  buildItem(BuildContext context, UserModel user) {
    final size = MediaQuery.of(context).size;

    String peerId = user.userUID;
    readLocal(peerId);

    String displayLastMessage(MessageChat message) {
      String lastMessage = '';

      switch (convertTypeNumToMessageType(message.type)) {
        case MessageType.text:
          lastMessage = message.content.length > 30
              ? '${message.content.substring(0, 30)}...'
              : message.content;
          break;
        case MessageType.image:
          lastMessage = '🖼️ image';
          break;
        case MessageType.video:
          lastMessage = '🎥 video';
          break;
        case MessageType.audio:
          lastMessage = '🎙️ audio';
          break;
        case MessageType.url:
          lastMessage = '🔗 link';
          break;
        case MessageType.file:
          lastMessage = '📎 file';
          break;
      }

      return lastMessage;
    }

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatPage(
              arguments: ChatPageArguments(
                peerId: user.userUID,
                token: user.token,
                peerAvatar: user.userImage,
                peerNickname: user.name,
                callMinuteCast: user.callMinuteCast,
              ),
            ),
          ),
        );
      },
      child: Slidable(
        endActionPane: ActionPane(
          motion: const StretchMotion(),
          children: [
            SlidableAction(
              autoClose: true,
              flex: 1,
              onPressed: (context) {
                showModalBottomSheet(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(size.height * 0.45),
                        topRight: Radius.circular(size.height * 0.45),
                      ),
                    ),
                    context: context,
                    builder: (BuildContext context) {
                      return Container(
                        height: size.height * 0.45,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(size.height * 0.45),
                            topRight: Radius.circular(size.height * 0.45),
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            TextButton(
                              onPressed: () {},
                              child: Text(
                                'Mute',
                                style: TextStyle(
                                  fontSize: size.height * 0.025,
                                  color: Palette.darkGrayColor,
                                  fontFamily: 'Inter',
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () {},
                              child: Text(
                                'Clear Chat',
                                style: TextStyle(
                                  fontSize: size.height * 0.025,
                                  color: Palette.darkGrayColor,
                                  fontFamily: 'Inter',
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () {},
                              child: Text(
                                'Copy group link',
                                style: TextStyle(
                                  fontSize: size.height * 0.025,
                                  color: Palette.darkGrayColor,
                                  fontFamily: 'Inter',
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () {},
                              child: Text(
                                'Delete Chat',
                                style: TextStyle(
                                  fontSize: size.height * 0.025,
                                  color: Palette.darkGrayColor,
                                  fontFamily: 'Inter',
                                ),
                              ),
                            ),
                            MyButtons(
                              text: "Cancel",
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              color: const Color(0xffCCCCCC),
                              width: .90,
                            )
                          ],
                        ),
                      );
                    });
              },
              backgroundColor: Palette.darkGrayColor,
              icon: Icons.more_horiz,
              label: 'More',
              foregroundColor: Colors.white,
            ),
            SlidableAction(
              autoClose: true,
              flex: 1,
              onPressed: (context) {},
              backgroundColor: Palette.mainBlueColor,
              icon: Icons.inventory,
              label: 'Archive',
            ),
          ],
        ),
        child: Container(
          margin: EdgeInsets.symmetric(
            vertical: size.height * 0.01,
            horizontal: size.width * 0.02,
          ),
          padding: EdgeInsets.all(size.height * 0.005),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              UserCircleImage(
                userUid: user.userUID,
                image: user.userImage,
                size: size,
                borderColor: user.accountStatus == 'Active'
                    ? Palette.mainBlueColor
                    : Palette.darkGrayColor2,
                userStateColor: user.accountStatus == 'Active'
                    ? Palette.mainBlueColor
                    : Palette.mGrayColor,
                imageCircalSize: size.height * 0.033,
              ),
              SizedBox(width: size.width * 0.01),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: size.width * 0.4,
                          child: Text(
                            user.name,
                            style: TextStyle(
                              fontSize: size.height * 0.025,
                              fontFamily: "SFPro",
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: isAllSelected == true
                              ? size.width * 0.10
                              : size.width * 0.15,
                        ),
                      ],
                    ),
                    SizedBox(height: size.height * 0.015),
                    StreamBuilder<QuerySnapshot>(
                      stream: chatProvider.getChatStream(groupChatId, 1),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasData) {
                          listMessage = snapshot.data!.docs;
                          if (listMessage.isNotEmpty) {
                            var lastMessage = MessageChat.fromDocument(
                                snapshot.data!.docs[0]);
                            chatProvider.updateMainLastMessageList(
                                lastNewMessageSeen: (snapshot.data?.docs[0]
                                    .data() as Map)["seen"],
                                idFrom: (snapshot.data?.docs[0].data()
                                    as Map)["idFrom"],
                                peerId: user.userUID,
                                specificTime: (snapshot.data?.docs[0].data()
                                    as Map)["timestamp"]);
                            return Row(
                              children: [
                                if (lastMessage.idTo !=
                                    homeController.user?.userUID)
                                  lastMessage.seen!
                                      ? Icon(
                                          Icons.done_all,
                                          size: size.height * 0.020,
                                          color: Colors.blue,
                                        )
                                      : Icon(
                                          Icons.check,
                                          size: size.height * 0.020,
                                        ),
                                SizedBox(width: size.width * 0.01),
                                Expanded(
                                  child: Text(
                                    displayLastMessage(lastMessage),
                                    style: TextStyle(
                                      // overflow: TextOverflow.fade ,
                                      fontSize: size.height * 0.018,
                                      color: lastMessage.idFrom !=
                                              homeController.user?.userUID
                                          ? lastMessage.seen!
                                              ? Colors.grey
                                              : Colors.black
                                          : Colors.grey,
                                      fontWeight: lastMessage.idFrom !=
                                              homeController.user?.userUID
                                          ? lastMessage.seen!
                                              ? FontWeight.normal
                                              : FontWeight.bold
                                          : FontWeight.normal,
                                      fontFamily: "SFPro",
                                    ),
                                    // overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const Spacer(),
                                Text(
                                  convertTimestamp((snapshot.data?.docs[0]
                                      .data() as Map)["timestamp"]),
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            );
                          } else {
                            return const Align(
                              alignment: AlignmentDirectional.bottomStart,
                              child: Text(
                                "No message here yet...",
                                textAlign: TextAlign.end,
                              ),
                            );
                          }
                        } else {
                          return const Align(
                            alignment: AlignmentDirectional.bottomStart,
                            child: Text(
                              ".......",
                              textAlign: TextAlign.end,
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
