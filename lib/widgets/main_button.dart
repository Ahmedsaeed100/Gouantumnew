// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class MainButton extends StatelessWidget {
  const MainButton({
    super.key,
    required this.size,
    required this.buttonName,
    required this.function,
    required this.backGroundColor,
    required this.textColor,
  });

  final Size size;
  final String buttonName;
  final VoidCallback function;
  final Color backGroundColor;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: function,
      child: Container(
        margin: EdgeInsets.only(top: size.height * 0.01),
        width: size.width * 0.85,
        height: size.height * 0.06,
        decoration: BoxDecoration(
          color: backGroundColor,
        ),
        child: Center(
          child: Text(
            buttonName,
            style: TextStyle(
              color: textColor,
              fontSize: size.height * 0.020,
              fontFamily: 'Helvetica',
            ),
          ),
        ),
      ),
    );
  }
}
