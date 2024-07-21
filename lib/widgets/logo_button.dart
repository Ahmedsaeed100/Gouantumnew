import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

// Soft Login by Facebook Linkedin etc.
class LogoButton extends StatelessWidget {
  final Function function;
  final String svgPath;
  const LogoButton({
    required this.function,
    required this.svgPath,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        function();
      },
      child: SvgPicture.asset(
        svgPath,
        fit: BoxFit.fill,
      ),
    );
  }
}
