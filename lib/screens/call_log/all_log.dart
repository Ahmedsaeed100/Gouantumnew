import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:gouantum/screens/calls/presentaion/cubit/home/home_cubit.dart';
import 'package:gouantum/screens/calls/presentaion/cubit/home/home_state.dart';
import 'package:gouantum/screens/calls/presentaion/screens/home_screen.dart';
import 'package:gouantum/screens/home/home_controller.dart';
import 'package:gouantum/screens/notifications/user_notification_widget.dart';
import 'package:gouantum/screens/screens.dart';
import 'package:gouantum/utilities/palette.dart';
import 'package:gouantum/widgets/widgets.dart';
import 'call_log_controller.dart';

class AllCallsLog extends StatefulWidget {
  const AllCallsLog({super.key});

  @override
  State<AllCallsLog> createState() => _AllCallsLogState();
}

class _AllCallsLogState extends State<AllCallsLog>
    with TickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this, initialIndex: 0);
    _tabController!.addListener(_handleTabIndex);
  }

  @override
  void dispose() {
    _tabController!.removeListener(_handleTabIndex);
    _tabController!.dispose();
    super.dispose();
  }

  void _handleTabIndex() {
    setState(() {});
  }

  CallLogController controller = Get.put(CallLogController());

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        body: NestedScrollView(
          floatHeaderSlivers: true,
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            SliverAppBar(
              floating: true,
              snap: true,
              backgroundColor: Colors.transparent,
              elevation: 0,
              foregroundColor: Palette.darkGrayColor,
              leading: IconButton(
                onPressed: () {
                  BlocProvider.of<HomeCubit>(context).onChangeTab(0);
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => const MainScreen()),
                  // );
                },
                icon: const Icon(Icons.arrow_back),
              ),
              title: Text(
                'All',
                style: TextStyle(
                  fontFamily: "Helvetica",
                  fontSize: size.height * 0.025,
                ),
              ),
              centerTitle: true,
              actions: [
                UserNotificationWidget(size: size),
              ],
              bottom: TabBar(
                controller: _tabController,
                isScrollable: true,
                labelColor: Palette.mainBlueColor,
                labelStyle: TextStyle(
                  fontFamily: "Helvetica",
                  fontSize: size.height * 0.022,
                ),
                unselectedLabelStyle: TextStyle(
                  fontFamily: "Helvetica",
                  color: Palette.darkGrayColor,
                  fontSize: size.height * 0.02,
                ),
                indicatorColor: Palette.mainBlueColor,
                indicatorPadding:
                    EdgeInsets.symmetric(horizontal: size.width * 0.05),
                unselectedLabelColor: Colors.black,
                tabs: const [
                  Tab(
                    text: 'All ',
                  ),
                  Tab(
                    text: 'Incoming',
                  ),
                  Tab(
                    text: 'OutGoing',
                  ),
                  // Tab(
                  //   text: 'Conference calls',
                  // ),
                ],
              ),
            ),
          ],
          body: Obx(
            () => controller.isDataLoading.value
                ? const Center(child: CircularProgressIndicator())
                : CustomScrollView(
                    slivers: [
                      SliverToBoxAdapter(
                        child: SearchTextField(
                          size: size,
                          hintText: "I'm looking for . . .",
                          onChange: (value) {
                            if (_tabController!.index == 0) {
                              //  print(value);
                              Get.put(HomeController())
                                  .search(value, 'all contacts');
                            } else if (_tabController!.index == 1) {
                              controller.search(value, 'incoming');
                            } else if (_tabController!.index == 2) {
                              controller.search(value, 'outgoing');
                            }
                          },
                        ),
                      ),

                      // ignore: sized_box_for_whitespace
                      BlocBuilder<HomeCubit, HomeState>(
                          builder: (context, state) {
                        var homeCubit = HomeCubit.get(context);
                        return SliverFillRemaining(
                          child: TabBarView(
                            controller: _tabController,
                            children: [
                              const HomeScreen(),
                              InComing(
                                calls: homeCubit.calls,
                                users: homeCubit.users,
                              ),
                              OutGoing(
                                calls: homeCubit.calls,
                                users: homeCubit.users,
                              ),
                              //  ConferenceCall(),
                            ],
                          ),
                        );
                      }),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
