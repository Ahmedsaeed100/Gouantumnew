import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ImageComments extends StatefulWidget {
  final String text;
  final DateTime time;
  final String name;
  final String image;
  final String imagePost;
  final bool isMe;
  const ImageComments(
      {super.key,
      required this.image,
      required this.text,
      required this.name,
      required this.time,
      required this.imagePost,
      required this.isMe});

  @override
  State<ImageComments> createState() => _ImageCommentsState();
}

class _ImageCommentsState extends State<ImageComments> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.only(
        top: 8.0,
        right: widget.text.characters.length < 20
            ? size.width * 0.38
            : widget.text.characters.length < 50
                ? size.width * 0.2
                : 8.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: size.width,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundImage: NetworkImage(
                          widget.image,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        widget.name,
                        maxLines: 1,
                        overflow: TextOverflow.fade,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      widget.text,
                      style: const TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ),
                  widget.imagePost != ""
                      ? Image.network(
                          widget.imagePost,
                          fit: BoxFit.cover,
                        )
                      : const SizedBox(),
                ],
              ),
            ),
          ),
          Text(
            " \n ${DateFormat.jm().format(widget.time)}",
            textAlign: TextAlign.start,
            style: const TextStyle(
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
