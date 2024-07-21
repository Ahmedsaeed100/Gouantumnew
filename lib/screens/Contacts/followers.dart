import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gouantum/screens/Contacts/contacts_controllers.dart';
import 'package:gouantum/screens/screens.dart';
import 'package:gouantum/utilities/palette.dart';
import 'package:gouantum/widgets/widgets.dart';

import '../../model/users.dart';

class Followers extends StatefulWidget {
  const Followers({super.key});

  @override
  State<Followers> createState() => _FollowersState();
}

class _FollowersState extends State<Followers> {
  final TextEditingController followersController = TextEditingController();
  String query = '';
  List<UserModel>? allfollowersList = [];
  List<UserModel>? seachedFollowedList = [];

  void searchContacts(String query) {
    // print('this is the data : $data');
    final seachedFollowedList = allfollowersList?.where((element) {
      final titleLower = element.name.toLowerCase();

      final searchLower = query.toLowerCase();

      return titleLower.contains(searchLower);
    }).toList();
    setState(() {
      this.query = query;
      this.seachedFollowedList = seachedFollowedList;
    });
  }

  @override
  Widget build(BuildContext context) {
    final ContactsController controller = Get.put(ContactsController());

    if (controller.followersList == null) {
      controller.getFollowers();
    } else {
      controller.isFollowersListLoading.value = false;
    }

    Size size = MediaQuery.of(context).size;
    return Obx(
      () => controller.isFollowersListLoading.value ||
              controller.isFollowedListLoading.value
          ? const Center(child: CircularProgressIndicator())
          : Builder(
              builder: (context) {
                allfollowersList = controller.followersList;
                List<UserModel>? filteredData;
                query.isEmpty
                    ? filteredData = allfollowersList
                    : filteredData = seachedFollowedList;
                return SingleChildScrollView(
                  physics: const NeverScrollableScrollPhysics(),
                  child: Column(
                    children: [
                      SearchTextField(
                        size: size,
                        hintText: "I'm looking for . . .",
                        controller: followersController,
                        onChange: (value) {
                          searchContacts(value);
                        },
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const ClampingScrollPhysics(),
                        itemCount: filteredData!.length,
                        itemBuilder: (context, index) {
                          final currentFollowers = filteredData![index];
                          return Flex(
                            direction: Axis.horizontal,
                            children: [
                              Expanded(
                                child: Container(
                                  margin: EdgeInsets.symmetric(
                                    vertical: size.height * 0.02,
                                    horizontal: size.width * 0.02,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              Get.to(
                                                OtherProfile(
                                                  otherUid:
                                                      currentFollowers.userUID,
                                                ),
                                              );
                                            },
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              child: CachedNetworkImage(
                                                imageUrl:
                                                    currentFollowers.userImage,
                                                imageBuilder:
                                                    (context, imageProvider) {
                                                  return Image.network(
                                                    currentFollowers.userImage,
                                                    height: size.height * 0.05,
                                                    width: size.width * 0.12,
                                                    fit: BoxFit.cover,
                                                  );
                                                },
                                                placeholder: (context, url) {
                                                  return const CircularProgressIndicator(
                                                    valueColor:
                                                        AlwaysStoppedAnimation<
                                                            Color>(
                                                      Palette.mainBlueColor,
                                                    ),
                                                  );
                                                },
                                                errorWidget:
                                                    (context, url, error) =>
                                                        const Icon(Icons.error),
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: size.width * 0.05),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                currentFollowers.name,
                                                style: TextStyle(
                                                  fontSize: size.height * 0.025,
                                                  fontFamily: "Helvetica",
                                                ),
                                              ),
                                              SizedBox(
                                                  height: size.height * 0.01),
                                              Row(
                                                children: [
                                                  Text(
                                                    currentFollowers
                                                                .phoneNumber ==
                                                            "null"
                                                        ? ""
                                                        : currentFollowers
                                                            .phoneNumber,
                                                    style: TextStyle(
                                                      fontSize:
                                                          size.height * 0.016,
                                                      color: Colors.grey,
                                                      fontFamily: "Helvetica",
                                                    ),
                                                  ),
                                                  SizedBox(
                                                      width: size.width * 0.02),
                                                  RichText(
                                                    text: TextSpan(
                                                      text:
                                                          "G ${currentFollowers.callMinuteCast.toString()}",
                                                      style: TextStyle(
                                                        fontSize:
                                                            size.height * 0.015,
                                                        color:
                                                            Palette.gouantColor,
                                                        fontFamily: "Helvetica",
                                                      ),
                                                      children: [
                                                        TextSpan(
                                                          text: ' /Min.',
                                                          style: TextStyle(
                                                            fontSize:
                                                                size.height *
                                                                    0.015,
                                                            color: Colors.grey,
                                                            fontFamily:
                                                                "Helvetica",
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      FollowAndUnfollowButton(
                                        size: size,
                                        user: currentFollowers,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
