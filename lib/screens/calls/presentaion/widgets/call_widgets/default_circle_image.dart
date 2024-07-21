import 'package:flutter/cupertino.dart';

class DefaultCircleImage extends StatelessWidget {
  final Widget image;
  final Color bgColor;
  final bool center;
  final double width;
  final double height;
  const DefaultCircleImage(
      {super.key,
      required this.image,
      required this.bgColor,
      this.center = false,
      this.width = 45,
      this.height = 45});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: bgColor,
      ),
      child: center
          ? Center(child: image)
          : Padding(
              padding: const EdgeInsets.all(13.0),
              child: image,
            ),
    );
  }
}
