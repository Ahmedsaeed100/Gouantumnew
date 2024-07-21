import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gouantum/screens/notifications/user_notification_widget.dart';
import 'package:gouantum/screens/screens.dart';
import 'package:gouantum/utilities/palette.dart';

import '../calls/presentaion/cubit/home/home_cubit.dart';

class AllContacts extends StatefulWidget {
  const AllContacts({super.key});

  @override
  State<AllContacts> createState() => _AllContactsState();
}

class _AllContactsState extends State<AllContacts>
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
    if (mounted) {
      setState(() {});
    }
  }

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
                'All Contacts',
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
                    text: 'All Contacts',
                  ),
                  Tab(
                    text: 'Following',
                  ),
                  Tab(
                    text: 'Followers',
                  ),
                  // Tab(
                  //   text: 'Groups',
                  // ),
                ],
              ),
            ),
          ],
          body: CustomScrollView(
            slivers: [
              // ignore: sized_box_for_whitespace
              SliverFillRemaining(
                child: TabBarView(
                  controller: _tabController,
                  children: const [
                    UserAllContacts(),
                    Following(),
                    Followers(),
                    //  Groups(),
                  ],
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: _bottomButtons(size),
      ),
    );
  }

// To Change Flouting Action button ICON
  Widget _bottomButtons(Size size) {
    return _tabController!.index == 0
        ? FloatingActionButton(
            shape: BeveledRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            onPressed: null,
            backgroundColor: Palette.mainBlueColor,
            clipBehavior: Clip.antiAlias,
            isExtended: true,
            child: Icon(
              Icons.person_add,
              size: size.width * 0.07,
            ),
          )
        : _tabController!.index == 3
            ? FloatingActionButton(
                shape: BeveledRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                onPressed: null,
                backgroundColor: Palette.mainBlueColor,
                clipBehavior: Clip.antiAlias,
                isExtended: true,
                child: Icon(
                  Icons.group_add,
                  size: size.width * 0.07,
                ),
              )
            : Container();
  }
}
