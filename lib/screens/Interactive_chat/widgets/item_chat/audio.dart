import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:intl/intl.dart';
import '../../model/message_chat.dart';
import '../recording.dart';

class ItemChatAudio extends StatelessWidget {
  final MessageChat messageChat;
  final bool isMe;
  const ItemChatAudio({super.key, required this.isMe, required this.messageChat});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Expanded(
      child: ChatBubble(
        clipper: ChatBubbleClipper1(
            type: isMe ? BubbleType.sendBubble : BubbleType.receiverBubble),
        alignment: Alignment.topRight,
        margin: const EdgeInsets.only(top: 20),
        backGroundColor: isMe ? const Color(0xFFDBF6C7) : Colors.white,
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.only(right: size.width * 0.16),
              child: AudioPlayerChatItem(
                source: messageChat.content,
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Text(
                  DateFormat.jm().format(DateTime.fromMillisecondsSinceEpoch(
                      int.parse(messageChat.timestamp))),
                  style: const TextStyle(color: Colors.black, fontSize: 10)),
            ),
          ],
        ),
      ),
    );
  }
}
