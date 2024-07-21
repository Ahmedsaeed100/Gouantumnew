import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gouantum/utilities/palette.dart';
import '../screens/home/home_controller.dart';

class MyBottomTabBar extends StatefulWidget {
  final int index;
  final ValueChanged<int> onChangeTab;

  const MyBottomTabBar({
    super.key,
    required this.index,
    required this.onChangeTab,
  });

  @override
  State<MyBottomTabBar> createState() => _MyBottomTabBarState();
}

class _MyBottomTabBarState extends State<MyBottomTabBar> {
  HomeController homeController = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return BottomAppBar(
      color: Palette.mainBlueColor,
      shape: const CircularNotchedRectangle(),
      notchMargin: size.height * 0.007,
      child: SizedBox(
        height: size.height * 0.085,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            BuildTabItem(
              key: const ValueKey('tab_home'),
              index: 0,
              icon: Icons.home_outlined,
              size: size,
              tabName: 'Home',
              isSelected: widget.index == 0,
              onChangeTab: widget.onChangeTab,
            ),
            BuildTabItem(
              key: const ValueKey('tab_contacts'),
              index: 1,
              icon: Icons.contact_phone_outlined,
              size: size,
              tabName: 'Contacts',
              isSelected: widget.index == 1,
              onChangeTab: widget.onChangeTab,
            ),
            const Spacer(),
            BuildTabItem(
              key: const ValueKey('tab_messages'),
              index: 2,
              icon: Icons.message_outlined,
              size: size,
              tabName: 'Messages',
              isSelected: widget.index == 2,
              onChangeTab: widget.onChangeTab,
            ),
            BuildTabItem(
              key: const ValueKey('tab_calls'),
              index: 3,
              icon: Icons.phone_outlined,
              size: size,
              tabName: 'Calls',
              isSelected: widget.index == 3,
              onChangeTab: widget.onChangeTab,
            ),
          ],
        ),
      ),
    );
  }

  // ignore: non_constant_identifier_names
  Widget BuildTabItem({
    required Key key,
    required int index,
    required String tabName,
    required IconData icon,
    required Size size,
    required bool isSelected,
    required ValueChanged<int> onChangeTab,
  }) {
    return Expanded(
      child: InkWell(
        key: key,
        onTap: () {
          onChangeTab(index);
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? Palette.goldenColor : Colors.white,
              size: size.height * (isSelected ? 0.030 : 0.025),
            ),
            Flexible(
              child: Container(
                margin: const EdgeInsets.only(top: 5),
                width: size.width * 0.19,
                child: Text(
                  tabName,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: isSelected ? Palette.goldenColor : Colors.white,
                    fontSize: size.height * (isSelected ? 0.015 : 0.013),
                    fontWeight:
                        isSelected ? FontWeight.w600 : FontWeight.normal,
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 5),
              height: size.height * 0.005,
              width: size.width * 0.19,
              decoration: BoxDecoration(
                color: isSelected ? Palette.goldenColor : Colors.transparent,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
