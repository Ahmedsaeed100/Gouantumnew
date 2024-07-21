// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:gouantum/utilities/palette.dart';

class GroupsStatus extends StatefulWidget {
  const GroupsStatus({super.key});

  @override
  State<GroupsStatus> createState() => _GroupsStatusState();
}

class _GroupsStatusState extends State<GroupsStatus> {
  bool changeGroupName = true;
  bool changeGroupPrice = true;
  bool changeGroupDescription = true;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: Text(
            "Group name",
            style: TextStyle(
              color: Palette.purpleColor,
              fontSize: size.height * 0.03,
              fontFamily: 'Helvetica',
            ),
          ),
          centerTitle: true,
          actions: [
            Container(
              margin: EdgeInsets.only(right: size.width * 0.03),
              child: Icon(
                Icons.close,
                size: size.height * 0.04,
                color: Colors.black,
              ),
            ),
          ],
        ),
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: true,
              snap: true,
              floating: true,
              expandedHeight: size.height * 0.2,
              backgroundColor: Colors.transparent,
              elevation: 0,
              flexibleSpace: Stack(
                children: [
                  FlexibleSpaceBar(
                    background: Image.asset(
                      'assets/img/Group_name.png',
                      fit: BoxFit.fill,
                    ),
                  ),
                  Positioned(
                    bottom: 10,
                    right: 10,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.photo_camera,
                          size: size.height * 0.035,
                          color: Palette.purpleColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            textformChangeGroupName(size),
            textformChangeSecondPrice(size),
            textformChangeGroupDescription(size),
            SliverToBoxAdapter(
              child: Container(
                height: size.height * 0.2,
                margin: EdgeInsets.symmetric(
                  horizontal: size.width * 0.03,
                  vertical: size.width * 0.01,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    GroupOptions(
                      size: size,
                      icon: Icons.mms,
                      iconColor: Colors.blue,
                      optionText: "Media, links and Doc",
                      otherText: '30',
                    ),
                    GroupOptions(
                      size: size,
                      icon: Icons.search,
                      iconColor: Colors.orange,
                      optionText: "Chat search",
                      otherText: '',
                    ),
                    GroupOptions(
                        size: size,
                        icon: Icons.volume_mute,
                        iconColor: Colors.green,
                        optionText: "Mute",
                        otherText: 'No'),
                    GroupOptions(
                      size: size,
                      icon: Icons.download,
                      iconColor: Colors.orangeAccent,
                      optionText: "Save to camera roll",
                      otherText: 'Default',
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                margin: EdgeInsets.symmetric(
                  horizontal: size.width * 0.05,
                  vertical: size.height * 0.01,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Divider(
                      height: 1,
                      color: Palette.medelGrayColor,
                    ),
                    SizedBox(height: size.height * 0.015),
                    Text(
                      "Users",
                      style: TextStyle(
                        fontSize: size.width * 0.05,
                        fontFamily: 'Helvetica',
                        color: Palette.purpleColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                height: size.height * 0.3,
                margin: EdgeInsets.symmetric(
                  horizontal: size.width * 0.03,
                  vertical: size.width * 0.01,
                ),
                child: ListView.builder(
                  itemCount: 50,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: EdgeInsets.symmetric(
                        vertical: size.height * 0.01,
                        horizontal: size.width * 0.01,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(5),
                                child: Image.asset(
                                  'assets/img/logo/testImage/user.png',
                                  height: size.height * 0.05,
                                  width: size.width * 0.12,
                                  fit: BoxFit.fill,
                                ),
                              ),
                              SizedBox(width: size.width * 0.01),
                              Text('Ahmed Elhadi $index'),
                            ],
                          ),
                          index == 0
                              ? Text(
                                  "Group admin",
                                  style: TextStyle(
                                    fontSize: size.width * 0.03,
                                    fontFamily: 'Helvetica',
                                    color: Colors.green,
                                  ),
                                )
                              : IconButton(
                                  onPressed: () {},
                                  icon: Icon(
                                    Icons.delete,
                                    size: size.height * 0.02,
                                    color: const Color(0xffC13749),
                                  ),
                                ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                margin: EdgeInsets.symmetric(
                  vertical: size.height * 0.05,
                  horizontal: size.width * 0.05,
                ),
                child: InkWell(
                  onTap: () {},
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.exit_to_app,
                            size: size.height * 0.035,
                            color: Palette.mainBlueColor,
                          ),
                          SizedBox(width: size.width * 0.03),
                          Text(
                            "Exit group",
                            style: TextStyle(
                              fontSize: size.width * 0.05,
                              fontFamily: 'Helvetica',
                              color: Palette.darkGrayColor,
                            ),
                          ),
                        ],
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: size.height * 0.025,
                        color: Palette.purpleColor,
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

//Group Name
  SliverPadding textformChangeGroupName(Size size) {
    return SliverPadding(
      padding: EdgeInsets.symmetric(
        horizontal: size.width * 0.07,
        vertical: size.height * 0.02,
      ),
      sliver: SliverToBoxAdapter(
        child: Container(
          height: size.height * 0.05,
          color: Colors.grey[300],
          child: TextFormField(
            readOnly: changeGroupName,
            decoration: InputDecoration(
              hintText: 'Group Name',
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(
                left: size.width * 0.01,
                top: size.height * 0.01,
              ),
              helperStyle: const TextStyle(
                fontFamily: 'Helvetica',
              ),
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    changeGroupName = !changeGroupName;
                    // when Press this button Change "Group Name" Save Data
                  });
                },
                icon: const Icon(Icons.edit_outlined),
              ),
            ),
          ),
        ),
      ),
    );
  }

//Group SecondPrice
  SliverPadding textformChangeSecondPrice(Size size) {
    return SliverPadding(
      padding: EdgeInsets.symmetric(
        horizontal: size.width * 0.07,
        vertical: size.height * 0.02,
      ),
      sliver: SliverToBoxAdapter(
        child: Container(
          height: size.height * 0.05,
          color: Colors.grey[300],
          child: TextFormField(
            readOnly: changeGroupName,
            decoration: InputDecoration(
              hintText: '\$0.50 per second',
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(
                left: size.width * 0.01,
                top: size.height * 0.01,
              ),
              helperStyle: const TextStyle(
                fontFamily: 'Helvetica',
              ),
              suffixIcon: Container(
                margin: EdgeInsets.symmetric(
                  vertical: size.height * 0.01,
                  horizontal: size.width * 0.02,
                ),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Palette.mainBlueColor,
                    shape: const StadiumBorder(),
                    elevation: 0,
                    foregroundColor: Colors.white,
                    textStyle: TextStyle(
                      fontFamily: "Helvetica",
                      fontSize: size.width * 0.05,
                    ),
                  ),
                  onPressed: () {
                    changeGroupPrice = !changeGroupPrice;
                  },
                  child: Text(
                    "Change",
                    style: TextStyle(
                      fontSize: size.width * 0.037,
                      fontFamily: 'Helvetica',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

//Group Description
  SliverPadding textformChangeGroupDescription(Size size) {
    return SliverPadding(
      padding: EdgeInsets.symmetric(
        horizontal: size.width * 0.07,
        vertical: size.height * 0.02,
      ),
      sliver: SliverToBoxAdapter(
        child: Container(
          height: size.height * 0.1,
          color: Colors.grey[300],
          child: TextFormField(
            readOnly: changeGroupName,
            maxLines: 5,
            decoration: InputDecoration(
              hintText:
                  'Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et',
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(
                left: size.width * 0.01,
                top: size.height * 0.01,
              ),
              helperStyle: const TextStyle(
                fontFamily: 'Helvetica',
              ),
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    changeGroupDescription = !changeGroupDescription;
                    // when Press this button Change "Group Name" Save Data
                  });
                },
                icon: const Icon(Icons.edit_outlined),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class GroupOptions extends StatelessWidget {
  const GroupOptions({
    super.key,
    required this.size,
    required this.optionText,
    required this.otherText,
    required this.icon,
    required this.iconColor,
  });

  final Size size;
  final String optionText;
  final String otherText;
  final IconData icon;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Icon(
          icon,
          size: size.height * 0.032,
          color: iconColor,
        ),
        SizedBox(width: size.width * 0.05),
        Text(
          textAlign: TextAlign.start,
          optionText,
          style: TextStyle(
            fontSize: size.width * 0.045,
            fontFamily: "Helvetica",
          ),
        ),
        const Spacer(),
        //number of Media
        Text(
          otherText,
          style: TextStyle(
            fontSize: size.width * 0.035,
            fontFamily: "Helvetica",
          ),
        ),
        SizedBox(width: size.width * 0.05),
        Icon(
          Icons.arrow_forward_ios,
          size: size.height * 0.02,
          color: Palette.purpleColor,
        ),
      ],
    );
  }
}
