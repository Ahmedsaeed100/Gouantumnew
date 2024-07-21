// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gouantum/screens/screens.dart';
import 'package:gouantum/utilities/palette.dart';

// User Online Or Offline
// User Circle Image With User State
class UserCircleImage extends StatelessWidget {
  const UserCircleImage({
    super.key,
    required this.size,
    required this.borderColor,
    required this.userStateColor,
    required this.image,
    required this.imageCircalSize,
    required this.userUid,
  });
  final String? userUid;
  final Size size;
  final Color borderColor;
  final Color userStateColor;
  final String image;
  final double imageCircalSize;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          margin: EdgeInsets.symmetric(
            horizontal: size.width * 0.01,
          ),
          padding: EdgeInsets.all(size.width * 0.004),
          decoration: BoxDecoration(
            border: Border.all(
              width: 2.7,
              color: borderColor,
            ),
            borderRadius: BorderRadius.circular(35),
          ),
          child: InkWell(
            onTap: () {
              Get.to(
                OtherProfile(
                  otherUid: userUid,
                ),
              );
            },
            child: CircleAvatar(
              radius: imageCircalSize,
              child: CachedNetworkImage(
                imageUrl: image,
                imageBuilder: (context, imageProvider) {
                  return Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.cover,
                      ),
                      shape: BoxShape.circle,
                    ),
                  );
                },
                placeholder: (context, url) {
                  return const CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Palette.mainBlueColor),
                  );
                },
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            ),
          ),
        ),
        Positioned(
          right: 5,
          bottom: 4,
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                width: 2,
                color: Colors.white,
              ),
              borderRadius: BorderRadius.circular(35),
            ),
            child: Container(
              height: 11,
              width: 11,
              decoration: BoxDecoration(
                color: userStateColor,
                borderRadius: BorderRadius.circular(25),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
