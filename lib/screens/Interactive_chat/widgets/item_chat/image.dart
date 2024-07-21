import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:intl/intl.dart';
import '../../constants/color_constants.dart';
import '../../model/message_chat.dart';
import '../full_photo_page.dart';

class ItemChatImage extends StatelessWidget {
  final MessageChat messageChat;
  final bool isMe;
  const ItemChatImage({super.key, required this.isMe, required this.messageChat});
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return ChatBubble(
      clipper: ChatBubbleClipper1(
          type: isMe ? BubbleType.sendBubble : BubbleType.receiverBubble),
      alignment: Alignment.topRight,
      margin: const EdgeInsets.only(top: 10),
      backGroundColor: isMe ? const Color(0xFFDBF6C7) : Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            constraints: BoxConstraints(
              maxHeight: size.height * 0.5,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.white,
            ),
            child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FullPhotoPage(
                        url: messageChat.content,
                      ),
                    ),
                  );
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: CachedNetworkImage(
                    imageUrl: messageChat.content,
                    placeholder: (context, url) => Container(
                      padding: const EdgeInsets.all(70.0),
                      decoration: const BoxDecoration(
                        color: ColorConstants.primaryColor,
                        borderRadius: BorderRadius.all(
                          Radius.circular(8.0),
                        ),
                      ),
                      child: const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                            ColorConstants.primaryColor),
                      ),
                    ),
                    errorWidget: (context, url, error) => Material(
                      borderRadius: BorderRadius.circular(8.0),
                      clipBehavior: Clip.hardEdge,
                      child: Image.asset(
                        'assets/img/logo copy.svg',
                        width: 200.0,
                        height: 200.0,
                        fit: BoxFit.cover,
                      ),
                    ),
                    width: 200.0,
                    fit: BoxFit.cover,
                  ),
                )),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Text(
                DateFormat.jm().format(DateTime.fromMillisecondsSinceEpoch(
                    int.parse(messageChat.timestamp))),
                style: TextStyle(
                  color: const Color(0xff8E8E93),
                  fontFamily: 'SFPro',
                  fontSize: size.height * 0.015,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
