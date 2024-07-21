import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:intl/intl.dart';
import 'package:readmore/readmore.dart';
import '../../model/message_chat.dart';

class ItemChatText extends StatelessWidget {
  final bool isMe;
  final MessageChat messageChat;
  const ItemChatText({super.key, required this.messageChat, required this.isMe});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return ChatBubble(
      clipper: ChatBubbleClipper1(
          type: isMe ? BubbleType.sendBubble : BubbleType.receiverBubble),
      alignment: Alignment.topRight,
      margin: EdgeInsets.only(top: size.height * 0.02),
      backGroundColor: isMe ? const Color(0xFFDBF6C7) : Colors.white,
      child: Container(
        padding: EdgeInsets.symmetric(
            horizontal: size.width * 0.02, vertical: size.height * 0.02),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.7,
        ),
        child: GestureDetector(
          onLongPress: () {
            //TO DO: copy text
            Clipboard.setData(ClipboardData(text: messageChat.content))
                .then((value) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Copied to Clipboard'),
                ),
              );
            });
          },
          child: ReadMoreText(
            messageChat.content,
            trimLines: 10,
            textAlign: messageChat.content.characters.first == 'ا' ||
                    messageChat.content.characters.first == 'أ' ||
                    messageChat.content.characters.first == 'إ' ||
                    messageChat.content.characters.first == 'آ' ||
                    messageChat.content.characters.first == 'ء' ||
                    messageChat.content.characters.first == 'ؤ' ||
                    messageChat.content.characters.first == 'ئ' ||
                    messageChat.content.characters.first == 'ب' ||
                    messageChat.content.characters.first == 'ت' ||
                    messageChat.content.characters.first == 'ث' ||
                    messageChat.content.characters.first == 'ج' ||
                    messageChat.content.characters.first == 'ح' ||
                    messageChat.content.characters.first == 'خ' ||
                    messageChat.content.characters.first == 'د' ||
                    messageChat.content.characters.first == 'ذ' ||
                    messageChat.content.characters.first == 'ر' ||
                    messageChat.content.characters.first == 'ز' ||
                    messageChat.content.characters.first == 'س' ||
                    messageChat.content.characters.first == 'ش' ||
                    messageChat.content.characters.first == 'ص' ||
                    messageChat.content.characters.first == 'ض' ||
                    messageChat.content.characters.first == 'ط' ||
                    messageChat.content.characters.first == 'ظ' ||
                    messageChat.content.characters.first == 'ع' ||
                    messageChat.content.characters.first == 'غ' ||
                    messageChat.content.characters.first == 'ف' ||
                    messageChat.content.characters.first == 'ق' ||
                    messageChat.content.characters.first == 'ك' ||
                    messageChat.content.characters.first == 'ل' ||
                    messageChat.content.characters.first == 'م' ||
                    messageChat.content.characters.first == 'ن' ||
                    messageChat.content.characters.first == 'ه' ||
                    messageChat.content.characters.first == 'و' ||
                    messageChat.content.characters.first == 'ي'
                ? TextAlign.right
                : TextAlign.left,
            colorClickableText: Colors.pink,
            trimMode: TrimMode.Length,
            trimCollapsedText: '  Show more',
            trimExpandedText: '  Show less',
            delimiterStyle: const TextStyle(
              color: Colors.blueAccent,
              height: 1,
            ),
            lessStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.blueAccent,
            ),
            postDataTextStyle: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
            postDataText:
                " \n ${DateFormat.jm().format(DateTime.fromMillisecondsSinceEpoch(int.parse(messageChat.timestamp)))}",
            moreStyle:
                const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
