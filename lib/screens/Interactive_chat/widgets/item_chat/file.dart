// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
// ignore: depend_on_referenced_packages
import 'package:path_provider/path_provider.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../model/message_chat.dart';
import '../alert.dart';

var dio = Dio();

class ItemChatFile extends StatefulWidget {
  final MessageChat messageChat;
  final bool isMe;
  const ItemChatFile({super.key, required this.messageChat, required this.isMe});

  @override
  State<ItemChatFile> createState() => _ItemChatFileState();
}

class _ItemChatFileState extends State<ItemChatFile> {
  Future download(Dio dio, String url, String savePath) async {
    try {
      Response response = await dio
          .get(
        url,
        onReceiveProgress: showDownloadProgress,
        options: Options(
            responseType: ResponseType.bytes,
            followRedirects: false,
            validateStatus: (status) {
              return status! < 500;
            }),
      )
          .whenComplete(() {
        AlertSnackBar.showSnackBar(context, 'Download completed', Colors.green);
      });

      File file = File(savePath);
      var raf = file.openSync(mode: FileMode.write);
      raf.writeFromSync(response.data);

      await raf.close();
    } catch (e) {
      //AlertSnackBar.showSnackBar(context, "Download Fail$e", Colors.red);
      log(e.toString());
    }
  }

  double progressString = 0.0;
  void showDownloadProgress(received, total) {
    if (total != -1) {
      setState(() {
        progressString = (received / total * 100);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return ChatBubble(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 0, bottom: 0),
      clipper: ChatBubbleClipper1(
          type:
              widget.isMe ? BubbleType.sendBubble : BubbleType.receiverBubble),
      alignment: Alignment.topRight,
      margin: const EdgeInsets.only(top: 10),
      backGroundColor: widget.isMe ? const Color(0xFFDBF6C7) : Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            SizedBox(
              height: size.height * 0.12,
              width: size.width * 0.60,
              child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.grey[300],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GestureDetector(
                            onTap: () async {
                              if (await Permission.storage
                                  .request()
                                  .isGranted) {
                                final dir =
                                    await getApplicationDocumentsDirectory();
                                final path = dir.path;
                                final savePath =
                                    "$path/${widget.messageChat.content}";
                                download(
                                    dio, widget.messageChat.content, savePath);
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Permission Denied"),
                                  ),
                                );
                                ScaffoldMessenger.of(context)
                                    .showMaterialBanner(
                                  MaterialBanner(
                                    content: const Text("Permission Denied"),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Permission.storage
                                              .request()
                                              .isGranted;
                                        },
                                        child: const Text("OK"),
                                      ),
                                    ],
                                  ),
                                );
                              }
                            },
                            child: progressString == 0.0
                                ? const Icon(FontAwesomeIcons.download)
                                : CircularPercentIndicator(
                                    radius: 30.0,
                                    lineWidth: 5.0,
                                    percent: progressString / 100,
                                    center: Text("${progressString.toInt()}%"),
                                    progressColor: Colors.blue,
                                  )),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              widget.messageChat.name,
                              style: TextStyle(
                                color: const Color(0xff8E8E93),
                                fontWeight: FontWeight.bold,
                                fontSize: size.height * 0.020,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Text(
                                widget.messageChat.fileSize,
                                //"2.4 MB . png",
                                style: TextStyle(
                                  color: const Color(0xff8E8E93),
                                  fontFamily: 'SFPro',
                                  fontSize: size.height * 0.015,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Icon(
                          Icons.file_copy,
                          size: 50,
                          color: Colors.black,
                        ),
                      ],
                    ),
                  )),
            ),
            Text(
                DateFormat.jm().format(DateTime.fromMillisecondsSinceEpoch(
                    int.parse(widget.messageChat.timestamp))),
                style: const TextStyle(color: Colors.grey, fontSize: 12)),
          ],
        ),
      ),
    );
  }
}
