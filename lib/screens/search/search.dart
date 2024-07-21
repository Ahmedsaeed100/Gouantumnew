import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gouantum/screens/Contacts/contacts_controllers.dart';
import 'package:gouantum/utilities/firestore_constants.dart';
import 'package:gouantum/utilities/palette.dart';
import 'package:gouantum/widgets/widgets.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  String searchKey = '';

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final ContactsController contactsController = Get.put(ContactsController());
    FirebaseAuth auth = FirebaseAuth.instance;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          foregroundColor: Palette.darkGrayColor,
          title: Text(
            "Search",
            style: TextStyle(
              color: Palette.darkGrayColor,
              fontSize: size.width * 0.05,
              fontFamily: "Helvetica",
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: size.width * 0.05),
                child: TextFormField(
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Search by name, email, category or tel.",
                    hintStyle: const TextStyle(
                      color: Palette.medGrayColor,
                    ),
                    suffixIcon: Icon(
                      Icons.search,
                      size: size.height * 0.035,
                    ),
                  ),
                  onChanged: (val) {
                    setState(
                      () {
                        searchKey = val;
                      },
                    );
                  },
                ),
              ),
              SizedBox(
                height: size.height * 0.8,
                child: StreamBuilder(
                  // ignore: unnecessary_null_comparison
                  stream: FirebaseFirestore.instance
                      .collection(FirestoreConstants.userCollection)
                      .where('user_UID', isNotEqualTo: auth.currentUser!.uid)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    var userData = (searchKey != "")
                        ? contactsController.getCaseInsensitiveUsers(
                            searchKey, snapshot.data!.docs)
                        : snapshot.data!.docs;

                    return userData.isEmpty
                        ? NoDataExist(size: size)
                        : (snapshot.connectionState == ConnectionState.waiting)
                            ? const Center(
                                child: CircularProgressIndicator(),
                              )
                            : Container(
                                margin:
                                    EdgeInsets.only(top: size.height * 0.02),
                                child: ListView.builder(
                                  itemCount: userData.length,
                                  itemBuilder: (ctx, index) {
                                    DocumentSnapshot data = userData[index];
                                    final currentProvider =
                                        contactsController.userList![index];
                                    return Container(
                                      margin: EdgeInsets.symmetric(
                                        horizontal: size.width * 0.05,
                                        vertical: size.height * 0.01,
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(35),
                                                child: Image.network(
                                                  data['userImage'],
                                                  height: size.height * 0.05,
                                                  width: size.width * 0.12,
                                                  fit: BoxFit.fill,
                                                ),
                                              ),
                                              Container(
                                                margin: EdgeInsets.only(
                                                  left: size.width * 0.03,
                                                ),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      data['name'],
                                                      style: TextStyle(
                                                        fontSize:
                                                            size.height * 0.024,
                                                        fontFamily: "Helvetica",
                                                      ),
                                                    ),
                                                    SizedBox(
                                                        height: size.height *
                                                            0.005),
                                                    const Text(
                                                      'IT Team leader',
                                                      style: TextStyle(
                                                        fontFamily: "Helvetica",
                                                      ),
                                                    ),
                                                    Container(
                                                      margin:
                                                          EdgeInsets.symmetric(
                                                        horizontal:
                                                            size.width * 0.005,
                                                        vertical:
                                                            size.height * 0.005,
                                                      ),
                                                      child: Row(
                                                        children: [
                                                          Image.asset(
                                                            'assets/img/egypt.png',
                                                            fit: BoxFit.cover,
                                                            height:
                                                                size.height *
                                                                    0.02,
                                                            width: size.width *
                                                                0.04,
                                                          ),
                                                          SizedBox(
                                                            width: size.width *
                                                                0.02,
                                                          ),
                                                          const Text("⭐⭐⭐⭐"),
                                                          SizedBox(
                                                            width: size.width *
                                                                0.02,
                                                          ),
                                                          const Text(
                                                            '3.5',
                                                            style: TextStyle(
                                                              color: Palette
                                                                  .medGrayColor,
                                                              fontFamily:
                                                                  "Helvetica",
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    RichText(
                                                      text: TextSpan(
                                                        text:
                                                            "G ${data['callMinuteCast']}",
                                                        style: TextStyle(
                                                          fontSize:
                                                              size.height *
                                                                  0.015,
                                                          color: Palette
                                                              .gouantColor,
                                                          fontFamily:
                                                              "Helvetica",
                                                        ),
                                                        children: [
                                                          TextSpan(
                                                            text:
                                                                ' / Minute  - ',
                                                            style: TextStyle(
                                                              fontSize:
                                                                  size.height *
                                                                      0.015,
                                                              color:
                                                                  Colors.grey,
                                                              fontFamily:
                                                                  "Helvetica",
                                                            ),
                                                          ),
                                                          TextSpan(
                                                            text:
                                                                " G ${data['videoMinuteCast']}",
                                                            style: TextStyle(
                                                              fontSize:
                                                                  size.height *
                                                                      0.015,
                                                              color: Palette
                                                                  .gouantColor,
                                                              fontFamily:
                                                                  "Helvetica",
                                                            ),
                                                          ),
                                                          TextSpan(
                                                            text: " / live",
                                                            style: TextStyle(
                                                              fontSize:
                                                                  size.height *
                                                                      0.015,
                                                              color:
                                                                  Colors.grey,
                                                              fontFamily:
                                                                  "Helvetica",
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
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
                              );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
