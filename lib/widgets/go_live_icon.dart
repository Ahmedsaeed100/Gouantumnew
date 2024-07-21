import 'package:flutter/material.dart';
import 'package:gouantum/utilities/palette.dart';

class GoLiveIcon extends StatelessWidget {
  const GoLiveIcon({
    super.key,
    required this.size,
  });

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(
            right: size.width * 0.03,
            bottom: size.height * 0.005,
          ),
          height: size.height * 0.052,
          width: size.width * 0.109,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(
              size.width * 0.025,
            ),
          ),
          //Go Live Button
          child: IconButton(
            onPressed: () {
              /*   Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const IndexPage(),
                ),
              );*/
            },
            icon: Icon(
              Icons.videocam_outlined,
              color: Palette.mainBlueColor,
              size: size.height * 0.035,
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(right: size.width * 0.03),
          child: Text(
            "Go Live",
            style: TextStyle(
              color: Colors.white,
              fontFamily: "inter",
              fontSize: size.height * 0.015,
            ),
          ),
        ),
      ],
    );
  }
}
