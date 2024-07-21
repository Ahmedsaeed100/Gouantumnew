import 'package:any_link_preview/any_link_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../model/message_chat.dart';

class ItemChatUrl extends StatelessWidget {
  final MessageChat messageChat;
  final bool isMe;
  const ItemChatUrl({super.key, required this.isMe, required this.messageChat});
  Future<void> _launchUrl(String url) async {
    if (!await launchUrl(
      Uri.parse(url),
      webOnlyWindowName: '_blank',
      mode: LaunchMode.externalApplication,
    )) {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return ChatBubble(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 0, bottom: 0),
      clipper: ChatBubbleClipper1(
          type: isMe ? BubbleType.sendBubble : BubbleType.receiverBubble),
      alignment: Alignment.topRight,
      margin: const EdgeInsets.only(top: 10),
      backGroundColor: isMe ? const Color(0xFFDBF6C7) : Colors.white,
      child: SizedBox(
        height: size.height * 0.18,
        width: size.width * 0.80,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            SizedBox(
              height: size.height * 0.14,
              width: size.width * 0.80,
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 0,
                  right: 10,
                  top: 5,
                ),
                child: AnyLinkPreview(
                  link: messageChat.content,
                  borderRadius: 4,
                  showMultimedia: true,
                  onTap: () {
                    _launchUrl(messageChat.content);
                  },
                  displayDirection: UIDirection.uiDirectionHorizontal,
                  cache: const Duration(hours: 1),
                  backgroundColor: Colors.grey[300],
                  errorWidget: Container(
                    color: Colors.grey[300],
                    child: Image.asset("assets/img/Search.png"),
                  ),
                  errorImage: 'https://i.imgur.com/2YcJY9A.png',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                  DateFormat.jm().format(DateTime.fromMillisecondsSinceEpoch(
                      int.parse(messageChat.timestamp))),
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
