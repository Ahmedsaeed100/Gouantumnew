import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gouantum/screens/Interactive_chat/widgets/item_chat/text.dart';
import 'package:gouantum/screens/Interactive_chat/widgets/item_chat/url.dart';
import 'package:gouantum/screens/Interactive_chat/widgets/item_chat/video.dart';
import '../../model/message_chat.dart';
import 'audio.dart';
import 'file.dart';
import 'image.dart';

class ItemChat extends StatelessWidget {
  final int index;
  final String currentUserId;
  final List<QueryDocumentSnapshot> listMessage;
  final DocumentSnapshot? document;
  const ItemChat(
      {super.key,
      required this.index,
      required this.document,
      required this.currentUserId,
      required this.listMessage});

  // bool isLastMessageRight(int index) {
  //   if ((index > 0 &&
  //           listMessage[index - 1].get(FirestoreConstants.idFrom) !=
  //               currentUserId) ||
  //       index == 0) {
  //     return true;
  //   } else {
  //     return false;
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    if (document != null) {
      MessageChat messageChat = MessageChat.fromDocument(document!);

      return Row(
        mainAxisAlignment: messageChat.idFrom == currentUserId
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          buildChatItem(messageChat),
          messageChat.idFrom != currentUserId
              ? const SizedBox.shrink()
              : messageChat.seen ?? false
                  ? const Icon(
                      Icons.done_all,
                      color: Colors.blue,
                    )
                  : const Icon(Icons.check)
        ],
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  buildChatItem(MessageChat messageChat) {
    switch (convertTypeNumToMessageType(messageChat.type)) {
      case MessageType.text:
        return ItemChatText(
          isMe: messageChat.idFrom == currentUserId ? true : false,
          messageChat: messageChat,
        );
      case MessageType.image:
        return ItemChatImage(
          isMe: messageChat.idFrom == currentUserId ? true : false,
          messageChat: messageChat,
        );
      case MessageType.video:
        return ItemChatVideo(
          isMe: messageChat.idFrom == currentUserId ? true : false,
          messageChat: messageChat,
        );
      case MessageType.audio:
        return ItemChatAudio(
          isMe: messageChat.idFrom == currentUserId ? true : false,
          messageChat: messageChat,
        );

      case MessageType.url:
        return ItemChatUrl(
          isMe: messageChat.idFrom == currentUserId ? true : false,
          messageChat: messageChat,
        );
      case MessageType.file:
        return ItemChatFile(
          isMe: messageChat.idFrom == currentUserId ? true : false,
          messageChat: messageChat,
        );
      default:
        return const SizedBox.shrink();
    }
  }
}
