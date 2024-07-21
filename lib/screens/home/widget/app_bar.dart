import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gouantum/screens/notifications/user_notification_widget.dart';
import 'package:gouantum/screens/screens.dart';
import '../../../utilities/palette.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({
    super.key,
    required this.size,
  });

  final Size size;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      automaticallyImplyLeading: false,
      actions: [
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Home  Search Button
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Search(),
                    ),
                  );
                },
                icon: Icon(
                  Icons.search,
                  color: Palette.mainBlueColor,
                  size: size.height * 0.04,
                ),
              ),
              SvgPicture.asset(
                "assets/img/logo/gountum_main.svg",
                fit: BoxFit.contain,
              ),
              // User Notification
              UserNotificationWidget(size: size),
            ],
          ),
        ),
      ],
    );
  }
}
