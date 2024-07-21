import 'package:flutter/material.dart';
import 'package:gouantum/utilities/palette.dart';

class NoDataExist extends StatelessWidget {
  const NoDataExist({
    super.key,
    required this.size,
  });

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: size.height * 0.2),
        Image.asset("assets/img/Search.png"),
        Text(
          "Huh! All clear for now",
          style: TextStyle(
            fontSize: size.height * 0.03,
            fontFamily: "Helvetica",
          ),
        ),
        SizedBox(height: size.height * 0.018),
        Text(
          "Come back later for more actions =)",
          style: TextStyle(
            fontSize: size.height * 0.02,
            fontFamily: "Helvetica",
            color: Palette.medGrayColor,
          ),
        ),
      ],
    );
  }
}
