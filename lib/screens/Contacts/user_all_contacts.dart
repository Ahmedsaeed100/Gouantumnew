import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gouantum/screens/Contacts/contacts_controllers.dart';
import 'package:gouantum/screens/screens.dart';
import 'package:gouantum/utilities/palette.dart';
import 'package:gouantum/widgets/widgets.dart';

import '../../model/users.dart';

// This page to Get All users Follow And Unfollow
class UserAllContacts extends StatefulWidget {
  const UserAllContacts({super.key});

  @override
  State<UserAllContacts> createState() => _UserAllContactsState();
}

class _UserAllContactsState extends State<UserAllContacts> {
  final ContactsController contactsController = Get.put(ContactsController());

  final TextEditingController _controller = TextEditingController();
  String query = '';
  List<UserModel>? allContacts = [];
  List<UserModel>? seachedFollowedList = [];

  void searchContacts(String query) {
    // print('this is the data : $data');
    final seachedFollowedList = allContacts?.where((element) {
      final titleLower = element.name.toLowerCase();

      final searchLower = query.toLowerCase();

      return titleLower.contains(searchLower);
    }).toList();
    setState(
      () {
        this.query = query;
        this.seachedFollowedList = seachedFollowedList;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Obx(
      () => contactsController.isDataLoading.value
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Builder(
              builder: (context) {
                allContacts = contactsController.userList;
                List<UserModel>? filteredData;
                query.isEmpty
                    ? filteredData = allContacts
                    : filteredData = seachedFollowedList;

                return SingleChildScrollView(
                  physics: const NeverScrollableScrollPhysics(),
                  child: Column(
                    children: [
                      SearchTextField(
                        size: size,
                        hintText: "I'm looking for . . .",
                        controller: _controller,
                        onChange: (value) {
                          searchContacts(value);
                        },
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: filteredData!.length,
                        itemBuilder: (context, index) {
                          final currentProvider = filteredData![index];
                          return Container(
                            margin: EdgeInsets.symmetric(
                              vertical: size.height * 0.02,
                              horizontal: size.width * 0.02,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: size.width * .67,
                                  child: Row(
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          Get.to(
                                            OtherProfile(
                                              otherUid: currentProvider.userUID,
                                            ),
                                          );
                                        },
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          child: CachedNetworkImage(
                                            imageUrl: currentProvider.userImage,
                                            imageBuilder:
                                                (context, imageProvider) {
                                              return Image.network(
                                                currentProvider.userImage,
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
                                      SizedBox(
                                        width: size.width * 0.5,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              currentProvider.name,
                                              style: TextStyle(
                                                fontSize: size.height * 0.025,
                                                fontFamily: "Helvetica",
                                              ),
                                            ),
                                            SizedBox(
                                                height: size.height * 0.01),
                                            Wrap(
                                              children: [
                                                Text(
                                                  currentProvider.phoneNumber ==
                                                          "null"
                                                      ? ""
                                                      : currentProvider
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
                                                        "G ${currentProvider.callMinuteCast.toString()}",
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
                                      ),
                                    ],
                                  ),
                                ),
                                FollowAndUnfollowButton(
                                  size: size,
                                  user: currentProvider,
                                ),
                              ],
                            ),
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
