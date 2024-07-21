import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../model/users.dart';
import '../../../utilities/palette.dart';
import '../../../widgets/widgets.dart';
import '../home_controller.dart';

class FeaturedProviders extends StatelessWidget {
  FeaturedProviders({
    super.key,
    required this.size,
  });

  final Size size;
  final HomeController homeController = Get.put(HomeController());
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => homeController.isDataLoadingFeaturedProviders.value == true
          ? const Center(child: CircularProgressIndicator())
          : Container(
              height: size.height * 0.20,
              margin: EdgeInsets.symmetric(
                vertical: size.height * 0.01,
                horizontal: size.width * 0.01,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
              ),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: homeController.userFeaturedProviders!.length,
                itemBuilder: (context, index) {
                  final currentProvider =
                      homeController.userFeaturedProviders![index];
                  return SizedBox(
                    width: size.width * 0.25,
                    child: Column(
                      children: [
                        StreamBuilder(
                          stream: homeController.firestore
                              .collection('_users')
                              .doc(currentProvider.userUID)
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return UserCircleImage(
                                borderColor:
                                    UserModel.fromJson(snapshot.data!.data()!)
                                                .accountStatus ==
                                            'Active'
                                        ? Palette.mainBlueColor
                                        : Palette.darkGrayColor2,
                                userStateColor:
                                    UserModel.fromJson(snapshot.data!.data()!)
                                                .accountStatus ==
                                            'Active'
                                        ? Palette.mainBlueColor
                                        : Palette.darkGrayColor2,
                                userUid: currentProvider.userUID,
                                size: size,
                                image: currentProvider.userImage,
                                imageCircalSize: size.height * 0.030,
                              );
                            }
                            return UserCircleImage(
                              userUid: currentProvider.userUID,
                              size: size,
                              image: currentProvider.userImage,
                              borderColor: Palette.darkGrayColor2,
                              userStateColor: Palette.darkGrayColor2,
                              imageCircalSize: size.height * 0.035,
                            );
                          },
                        ),
                        SizedBox(height: size.width * 0.01),
                        Flexible(
                          child: Text(
                            currentProvider.name.length > 12
                                ? '${currentProvider.name.substring(0, 12)} '
                                : currentProvider.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: size.width * 0.029,
                              fontWeight: FontWeight.w600,
                              color: Palette.darkGrayColor,
                              fontFamily: "Poppins",
                            ),
                          ),
                        ),
                        SizedBox(height: size.width * 0.01),
                        Text(
                          "⭐⭐⭐⭐⭐",
                          style: TextStyle(
                            fontSize: size.width * 0.020,
                            fontWeight: FontWeight.w600,
                            color: Palette.darkGrayColor,
                            fontFamily: "Poppins",
                          ),
                        ),
                        SizedBox(height: size.width * 0.01),
                        RichText(
                          text: TextSpan(
                            text:
                                "G ${currentProvider.callMinuteCast.toString()}",
                            style: TextStyle(
                              fontSize: size.height * 0.015,
                              color: Palette.gouantColor,
                              fontFamily: "Helvetica",
                            ),
                            children: [
                              TextSpan(
                                text: ' /Min.',
                                style: TextStyle(
                                  fontSize: size.width * 0.030,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey[800],
                                  fontFamily: "Poppins",
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
    );
  }
}
