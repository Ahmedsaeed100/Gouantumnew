// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

// ignore: must_be_immutable
class HeaderLogo extends StatelessWidget {
  HeaderLogo({
    super.key,
    required this.size,
    required this.imgwidth,
    this.showBackButton = true,
  });

  final Size size;
  final double imgwidth;
  bool showBackButton = true;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        showBackButton
            ? Positioned(
                child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ),
                ),
              )
            : const SizedBox(),
        Positioned(
          child: Container(
            margin: EdgeInsets.only(top: size.height * 0.05),
            child: Center(
              child: SvgPicture.asset(
                "assets/img/logo/logo.svg",
                fit: BoxFit.contain,
                width: size.width * imgwidth,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
