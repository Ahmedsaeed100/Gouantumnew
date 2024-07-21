import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:gouantum/model/users.dart';
import 'package:gouantum/screens/calls/presentaion/cubit/home/home_cubit.dart';
import 'package:gouantum/screens/calls/presentaion/cubit/home/home_state.dart';
import 'package:gouantum/screens/notifications/user_notification_widget.dart';
import 'package:gouantum/screens/others_profile/about_user.dart';
import 'package:gouantum/screens/others_profile/other_profile_controller.dart';
import 'package:gouantum/screens/screens.dart';
import 'package:gouantum/utilities/palette.dart';

class OtherProfile extends StatefulWidget {
  final String? otherUid;
  const OtherProfile({
    super.key,
    required this.otherUid,
  });

  @override
  State<OtherProfile> createState() => _OtherProfileState();
}

class _OtherProfileState extends State<OtherProfile>
    with TickerProviderStateMixin {
  // HomeController homeController = Get.put(HomeController());
  late OtherProfileController otherProfileController =
      Get.put(OtherProfileController(userUid: widget.otherUid));

  @override
  Widget build(BuildContext context) {
    TabController tabController = TabController(
      length: 3,
      vsync: this,
      initialIndex: 0,
    );

    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Palette.mainBlueColor,
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Palette.mainBlueColor),
          backgroundColor: Colors.white,
          elevation: 0,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(),
              UserNotificationWidget(size: size),
            ],
          ),
        ),
        body: Stack(
          children: [
            FutureBuilder(
              future: otherProfileController.getUserProfile(widget.otherUid),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                  UserModel? user = snapshot.data;
                  if (user == null) {
                    return const Center(
                      child:
                          Text("some thing went wrong could not load the data"),
                    );
                  } else {
                    return CustomScrollView(
                      slivers: [
                        SliverToBoxAdapter(
                          child: SizedBox(
                            height: size.height * 0.25,
                            child: OtherUserProfileHeader(
                              size: size,
                              user: user,
                            ),
                          ),
                        ),
                        SliverToBoxAdapter(
                          child: Container(
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(20),
                                topLeft: Radius.circular(20),
                              ),
                            ),
                            child: Column(
                              children: [
                                SizedBox(height: size.height * 0.02),
                                TabBar(
                                  controller: tabController,
                                  labelColor: Palette.mainBlueColor,
                                  isScrollable: true,
                                  indicator: const BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                        color: Palette.mainBlueColor,
                                        width: 2.0,
                                      ),
                                    ),
                                  ),
                                  labelStyle: TextStyle(
                                    fontFamily: 'Helvetica',
                                    fontWeight: FontWeight.w700,
                                    fontSize: size.height * 0.02,
                                  ),
                                  unselectedLabelColor: Palette.medGrayColor,
                                  unselectedLabelStyle: TextStyle(
                                    fontFamily: 'Helvetica',
                                    fontWeight: FontWeight.w400,
                                    fontSize: size.height * 0.015,
                                  ),
                                  tabs: const [
                                    Tab(
                                      text: "Updates",
                                    ),
                                    Tab(
                                      text: "About",
                                    ),
                                    Tab(
                                      text: "Reviews",
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: size.height * 0.6,
                                  child: TabBarView(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    controller: tabController,
                                    children: [
                                      Obx(() => otherProfileController
                                              .isDataLoadingPosts.value
                                          ? const Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            )
                                          : OtherUpdates(
                                              size: size,
                                              postsModel: otherProfileController
                                                  .postsModel!,
                                            )),
                                      AboutUser(user: user),
                                      OtherReviews(size: size),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  }
                }
              },
            ),
            BlocBuilder<HomeCubit, HomeState>(
              builder: (context, state) {
                if (state is LoadingFireVideoCallState) {
                  return Container(
                    height: double.infinity,
                    width: double.infinity,
                    color: Colors.black45,
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
                return const SizedBox();
              },
            )
          ],
        ),
      ),
    );
  }
}
