import 'package:flutter/material.dart';
import 'package:gouantum/utilities/palette.dart';

class UsersPostsVideos extends StatelessWidget {
  const UsersPostsVideos({
    super.key,
    required this.size,
  });

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: size.width * 0.03,
              vertical: size.height * 0.01,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: size.height * 0.035,
                      backgroundImage: const ExactAssetImage(
                        "assets/img/logo/testImage/user.png",
                      ),
                    ),
                    SizedBox(width: size.width * 0.02),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Text(
                              'Ahmed Elhadi',
                              style: TextStyle(
                                fontFamily: "Helvetica",
                              ),
                            ),
                            SizedBox(width: size.width * 0.02),
                            const Text(
                              '3.5',
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: "Helvetica",
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: size.height * 0.005),
                        const Text(
                          '1 Hour ago',
                          style: TextStyle(
                            fontFamily: "Helvetica",
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const Text(
                  '\$0.5/Min',
                  style: TextStyle(
                    fontFamily: "Helvetica",
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: size.height * 0.005),
          // Video
          Image.asset(
            "assets/img/logo/testImage/video.png",
          ),
          SizedBox(height: size.height * 0.02),

          //coments
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Row(
                children: [
                  const Icon(Icons.thumb_up),
                  SizedBox(width: size.width * 0.01),
                  const Text("260")
                ],
              ),
              const Text("26 Comments"),
            ],
          ),
          const TextField(
            decoration: InputDecoration(
              hintText: "Write a coment...",
              border: InputBorder.none,
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(25.0)),
                borderSide: BorderSide(
                  color: Palette.lightwhiteColor,
                ),
              ),
              contentPadding:
                  EdgeInsets.only(bottom: 10.0, left: 10.0, right: 10.0),
            ),
            keyboardType: TextInputType.text,
          ),
        ],
      ),
    );
  }
}
