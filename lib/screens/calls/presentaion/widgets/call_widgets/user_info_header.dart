import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gouantum/controllers/timer_controller.dart';
import 'package:gouantum/utilities/palette.dart';

import '../../../shared/theme.dart';

class UserInfoHeader extends StatelessWidget {
  final String avatar;
  final String name;

  const UserInfoHeader({
    super.key,
    required this.avatar,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    TimerController timerController = Get.put(TimerController());
    return Row(
      children: [
        CircleAvatar(
          radius: 24.0,
          backgroundColor: Colors.grey.withOpacity(0.2),
          child: avatar.isNotEmpty
              ? CircleAvatar(
                  backgroundColor: defaultColor,
                  radius: 25.0,
                  backgroundImage: CachedNetworkImageProvider(
                    avatar,
                  ),
                )
              : const Icon(Icons.person),
        ),
        const SizedBox(
          width: 10.0,
        ),
        Expanded(
          child: Text(
            name,
            style: const TextStyle(
              color: Palette.mainBlueColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(7),
          decoration: BoxDecoration(
            color: Palette.mainBlueColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Obx(
            () => Center(
              child: Text(
                timerController.time.value,
                style: const TextStyle(
                  fontSize: 25,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
