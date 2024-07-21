import 'package:flutter/material.dart';
import 'package:gouantum/screens/my_balance/charge.dart';
import 'package:gouantum/screens/my_balance/transfer.dart';
import 'package:gouantum/screens/my_balance/withdraw.dart';
import 'package:gouantum/screens/notifications/user_notification_widget.dart';
import 'package:gouantum/utilities/palette.dart';
import 'invest.dart';

class MainBalance extends StatefulWidget {
  const MainBalance({super.key});

  @override
  State<MainBalance> createState() => _MainBalanceState();
}

class _MainBalanceState extends State<MainBalance>
    with TickerProviderStateMixin {
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
          backgroundColor: Colors.white,
          elevation: 0,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.search),
                color: Palette.mainBlueColor,
                iconSize: size.height * 0.035,
              ),
              UserNotificationWidget(size: size),
            ],
          ),
        ),
        body: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: SizedBox(
                height: size.height * 0.15,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                        // ignore: prefer_const_literals_to_create_immutables
                        children: [
                          Text(
                            'Your balance :',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontFamily: 'Helvetica'),
                          ),
                          Text(
                            '\$ 3,827.12',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontFamily: 'Helvetica',
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'View Transactions',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontFamily: 'Helvetica'),
                          )
                        ],
                      ),
                      Column(
                        children: [
                          Container(
                            margin: EdgeInsets.only(
                                right: size.width * 0.03,
                                bottom: size.height * 0.005,
                                top: size.height * 0.007),
                            height: size.height * 0.052,
                            width: size.width * 0.109,
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(148, 204, 204, 204),
                              borderRadius: BorderRadius.circular(
                                size.width * 0.025,
                              ),
                            ),
                            //Go Live Button
                            child: IconButton(
                              onPressed: () {},
                              icon: Icon(
                                Icons.attach_file,
                                color: Palette.mainBlueColor,
                                size: size.height * 0.035,
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(right: size.width * 0.03),
                            child: Text(
                              "Attach ID ",
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: "inter",
                                fontSize: size.height * 0.015,
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
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
                          text: "Charge",
                        ),
                        Tab(
                          text: "Withdraw",
                        ),
                        Tab(
                          text: "Transfer",
                        ),
                        Tab(
                          text: 'Invest',
                        )
                      ],
                    ),
                    SizedBox(
                      height: size.height,
                      child: TabBarView(
                        controller: tabController,
                        children: const [
                          Charge(),
                          /*  Container(
                            margin: EdgeInsets.symmetric(
                              vertical: size.height * 0.04,
                              horizontal: size.width * 0.04,
                            ),
                            child: Column(
                              children: [
                                Charge(),
                                Withdraw(),
                                Transfer(),
                                UsersPostsVideos(size: size),
                              ],
                            ),
                          ),*/
                          Withdraw(),
                          Transfer(),
                          Invest(),
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
