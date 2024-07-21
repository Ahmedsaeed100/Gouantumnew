import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gouantum/screens/Contacts/contacts_controllers.dart';
import 'package:gouantum/utilities/palette.dart';
import 'package:gouantum/widgets/widgets.dart';

import '../../model/users.dart';

class Following extends StatefulWidget {
  const Following({super.key});

  @override
  State<Following> createState() => _FollowingState();
}

class _FollowingState extends State<Following> {
  final ContactsController controller = Get.put(ContactsController());

  @override
  void initState() {
    controller.getFollowedUsers();
    super.initState();
  }

  final TextEditingController followingsController = TextEditingController();

  String query = '';
  List<UserModel>? allfollowedList = [];
  List<UserModel>? seachedFollowedList = [];

  void searchContacts(String query) {
    // print('this is the data : $data');
    final seachedFollowedList = allfollowedList?.where((element) {
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
    Size size = MediaQuery.of(context).size;
    return Obx(
      () => controller.isFollowedListLoading.value
          ? const Center(child: CircularProgressIndicator())
          : Builder(builder: (context) {
              allfollowedList = controller.followedList;
              List<UserModel>? filteredData;
              query.isEmpty
                  ? filteredData = allfollowedList
                  : filteredData = seachedFollowedList;
              return SingleChildScrollView(
                physics: const NeverScrollableScrollPhysics(),
                child: Column(
                  children: [
                    SearchTextField(
                      size: size,
                      hintText: "I'm looking for . . .",
                      controller: followingsController,
                      onChange: (value) {
                        searchContacts(value);
                      },
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: filteredData!.length,
                      itemBuilder: (context, index) {
                        final currentFollowing = filteredData![index];
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
                                        UserCircleImage(
                                          userUid: currentFollowing.userUID,
                                          image: currentFollowing.userImage,
                                          size: size,
                                          borderColor: Palette.greenColor,
                                          userStateColor: Palette.greenColor,
                                          imageCircalSize: size.height * 0.027,
                                        ),
                                        SizedBox(
                                          width: size.width * 0.02,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              currentFollowing.name,
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
                                                  currentFollowing
                                                              .phoneNumber ==
                                                          "null"
                                                      ? ""
                                                      : currentFollowing
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
                                                        "G ${currentFollowing.callMinuteCast.toString()}",
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
                                      user: currentFollowing,
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
            }),
    );
  }
}
