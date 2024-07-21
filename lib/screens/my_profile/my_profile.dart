import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gouantum/routes/routes.dart';
import 'package:gouantum/screens/my_profile/my_profile_controller.dart';
import 'package:gouantum/screens/notifications/user_notification_widget.dart';
import 'package:gouantum/screens/screens.dart';
import 'package:gouantum/utilities/palette.dart';
import '../home/home_controller.dart';

class MyProfile extends StatefulWidget {
  const MyProfile({super.key});

  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> with TickerProviderStateMixin {
  HomeController homeController = Get.put(HomeController());
  MyProfileController myProfileController = Get.put(MyProfileController());

  @override
  Widget build(BuildContext context) {
    TabController tabController = TabController(
      length: 4,
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
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(width: size.width * 0.6),
              UserNotificationWidget(size: size),
            ],
          ),
        ),
        body: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: SizedBox(
                height: size.height * 0.2,
                child:
                    MYUserProfileHeader(size: size, user: homeController.user!),
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
                    Container(
                      margin: EdgeInsets.symmetric(
                        vertical: size.height * 0.035,
                        horizontal: size.width * 0.025,
                      ),
                      height: size.height * 0.12,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Palette.mainBlueColor,
                        borderRadius: BorderRadius.all(
                          Radius.circular(size.height * 0.012),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Get.to(const MainBalance());
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  "My Balance",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: size.height * 0.02,
                                    fontFamily: 'Helvetica',
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Obx(
                                  () => myProfileController
                                          .isUserBalanceLoading.value
                                      ? const Center(
                                          child: CircularProgressIndicator(),
                                        )
                                      : Text(
                                          myProfileController.userBalance.value
                                              .toStringAsFixed(2),
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: size.height * 0.02,
                                            fontFamily: 'Helvetica',
                                            fontWeight: FontWeight.w300,
                                          ),
                                        ),
                                ),
                              ],
                            ),
                          ),
                          const VerticalDivider(
                            color: Colors.white,
                            endIndent: 15,
                            indent: 15,
                            thickness: 1.5,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                "myFollowers",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: size.height * 0.02,
                                  fontFamily: 'Helvetica',
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Obx(
                                () =>
                                    homeController.isFollowersListLoading.value
                                        ? const Center(
                                            child: CircularProgressIndicator(),
                                          )
                                        : Text(
                                            homeController.followersNumber.value
                                                .toString(),
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: size.height * 0.02,
                                              fontFamily: 'Helvetica',
                                              fontWeight: FontWeight.w300,
                                            ),
                                          ),
                              ),
                            ],
                          ),
                          const VerticalDivider(
                            color: Colors.white,
                            endIndent: 15,
                            indent: 15,
                            thickness: 1.5,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                "I’m Following",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: size.height * 0.02,
                                  fontFamily: 'Helvetica',
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Obx(
                                () =>
                                    homeController.isFollowingListLoading.value
                                        ? const Center(
                                            child: CircularProgressIndicator(),
                                          )
                                        : Text(
                                            homeController.followingNumber.value
                                                .toString(),
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: size.height * 0.02,
                                              fontFamily: 'Helvetica',
                                              fontWeight: FontWeight.w300,
                                            ),
                                          ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // user Rate And Transactions
                    SizedBox(
                      height: size.height * 0.1,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Get.toNamed(
                                RoutesClass.getMinutePricingRoute(),
                              );
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "G",
                                  style: TextStyle(
                                    fontSize: size.height * 0.05,
                                    fontFamily: 'Helvetica',
                                    color: Palette.mainBlueColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "My Rates",
                                  style: TextStyle(
                                    fontSize: size.height * 0.02,
                                    fontFamily: 'Helvetica',
                                  ),
                                ),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Get.toNamed(
                                RoutesClass.getTransactionsRoute(),
                              );
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Icon(
                                  Icons.repeat,
                                  size: size.height * 0.05,
                                  color: Palette.mainBlueColor,
                                ),
                                Text(
                                  "Transactions",
                                  style: TextStyle(
                                    fontSize: size.height * 0.02,
                                    fontFamily: 'Helvetica',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
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
                          text: "My Updates",
                        ),
                        Tab(
                          text: "My Info",
                        ),
                        Tab(
                          text: "My Reviews",
                        ),
                        Tab(
                          text: 'Settings',
                        )
                      ],
                    ),
                    SizedBox(
                      height: size.height * 0.6,
                      child: TabBarView(
                        physics: const NeverScrollableScrollPhysics(),
                        controller: tabController,
                        children: [
                          MyUpdates(size: size),
                          const MyInfo(),
                          MyReviews(size: size),
                          Settings(size: size),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
