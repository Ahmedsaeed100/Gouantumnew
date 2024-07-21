import 'package:flutter/material.dart';

class MyButtons extends StatelessWidget {
  final String text;
  final double width;
  final Color color;
  final VoidCallback onPressed;
  const MyButtons(
      {super.key,
      required this.text,
      required this.onPressed,
      required this.color,
      required this.width});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        style: ButtonStyle(
            minimumSize: WidgetStateProperty.all(Size(size.width * width, 50)),
            elevation: WidgetStateProperty.all(0),
            backgroundColor: WidgetStateProperty.all(
              color,
            ),
            padding: WidgetStateProperty.all(
                const EdgeInsets.symmetric(horizontal: 40, vertical: 25)),
            textStyle: WidgetStateProperty.all(const TextStyle(
              color: Colors.white,
            )),
            shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ))),
        onPressed: onPressed,
        child: Text(text),
      ),
    );
  }
}
