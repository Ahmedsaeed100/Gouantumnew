import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:intl/intl.dart';
import '../../model/message_chat.dart';
// import '../full_video_page.dart';
import 'package:video_player/video_player.dart';

class ItemChatVideo extends StatefulWidget {
  final bool isMe;

  final MessageChat messageChat;
  const ItemChatVideo({super.key, required this.messageChat, required this.isMe});

  @override
  State<ItemChatVideo> createState() => _ItemChatVideoState();
}

class _ItemChatVideoState extends State<ItemChatVideo> {
  late VideoPlayerController videoPlayerController;

  late var isVideoInitialized = videoPlayerController.value.isInitialized;

  ChewieController? chewieController;

  void initPlayer() async {
    videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(
      "${widget.messageChat.content}.mp4",
    ))
      ..initialize().then(
        (value) => setState(
          () {
            isVideoInitialized = true;
          },
        ),
      );
    chewieController = ChewieController(
      videoPlayerController: videoPlayerController,
    );
  }

  @override
  void initState() {
    initPlayer();
    super.initState();
  }

  @override
  void dispose() {
    videoPlayerController.dispose();
    chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    chewieController = ChewieController(
      videoPlayerController: videoPlayerController,
      autoPlay: false,
      looping: false,
    );
    return ChatBubble(
      padding: const EdgeInsets.all(4),
      clipper: ChatBubbleClipper1(
          type:
              widget.isMe ? BubbleType.sendBubble : BubbleType.receiverBubble),
      alignment: Alignment.topRight,
      margin: const EdgeInsets.only(top: 10),
      backGroundColor: widget.isMe ? const Color(0xFFDBF6C7) : Colors.white,
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 4, right: 15, left: 4),
            constraints: BoxConstraints(
              maxHeight: size.height * 0.5,
            ),
            child: GestureDetector(
              onTap: () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => VideoScreen(
                //       url: widget.messageChat.content,
                //     ),
                //   ),
                // );
              },
              child: Material(
                borderRadius: const BorderRadius.all(
                  Radius.circular(8),
                ),
                clipBehavior: Clip.hardEdge,
                child: chewieController != null
                    ? SizedBox(
                        height: 200,
                        width: 200,
                        child: AspectRatio(
                          aspectRatio: videoPlayerController.value.aspectRatio,
                          child: !isVideoInitialized
                              ? const Center(child: CircularProgressIndicator())
                              : Chewie(controller: chewieController!),
                        ),
                      )
                    : Container(
                        height: 200,
                        width: 100,
                        color: Colors.grey,
                      ),

                //       AspectRatio(
                //   aspectRatio: videoPlayerController.value.aspectRatio,
                //   child: !isVideoInitialized
                //       ? const Center(child: CircularProgressIndicator())
                //       : Chewie(controller: chewieController!),
                // ),
                //  FijkView(
                //   player: player,
                //   fsFit: FijkFit.cover,
                //   height: MediaQuery.of(context).size.height * 0.3,
                //   width: MediaQuery.of(context).size.width * 0.5,
                //   fs: false,
                //   fit: FijkFit.cover,
                // ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: SizedBox(
              width: size.width * 0.5,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    widget.messageChat.fileSize,
                    style: TextStyle(
                      color: const Color(0xff8E8E93),
                      fontFamily: 'SFPro',
                      fontSize: size.height * 0.015,
                    ),
                  ),
                  Text(
                    DateFormat.jm().format(DateTime.fromMillisecondsSinceEpoch(
                        int.parse(widget.messageChat.timestamp))),
                    style: TextStyle(
                      color: const Color(0xff8E8E93),
                      fontFamily: 'SFPro',
                      fontSize: size.height * 0.015,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
