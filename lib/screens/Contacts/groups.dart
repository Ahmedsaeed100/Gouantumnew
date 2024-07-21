import 'package:flutter/material.dart';
import 'package:gouantum/utilities/palette.dart';

class Groups extends StatefulWidget {
  const Groups({super.key});

  @override
  State<Groups> createState() => _GroupsState();
}

class _GroupsState extends State<Groups> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return ListView.builder(
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
      itemCount: 10,
      itemBuilder: (context, index) {
        return Flex(
          direction: Axis.horizontal,
          children: [
            // SearchTextField(
            //   size: size,
            //   hintText: "I'm looking for . . .",
            // ),
            Expanded(
              child: Container(
                margin: EdgeInsets.symmetric(
                  vertical: size.height * 0.02,
                  horizontal: size.width * 0.02,
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
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(width: size.width * 0.05),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Ahmed Saeed $index",
                              style: TextStyle(
                                fontSize: size.height * 0.025,
                                fontFamily: "Helvetica",
                              ),
                            ),
                            SizedBox(height: size.height * 0.01),
                            Row(
                              children: [
                                const Icon(
                                  Icons.volume_up,
                                  color: Palette.mainBlueColor,
                                ),
                                SizedBox(width: size.width * 0.02),
                                Text(
                                  "Meeting 03:37",
                                  style: TextStyle(
                                    fontSize: size.height * 0.015,
                                    color:
                                        const Color.fromARGB(255, 82, 74, 74),
                                    fontFamily: "Helvetica",
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        InkWell(
                          onTap: () {},
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: size.width * 0.015,
                              vertical: size.height * 0.008,
                            ),
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 220, 233, 220),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                              'Admin',
                              style: TextStyle(
                                fontFamily: "Helvetica",
                                color: Colors.green,
                              ),
                            ),
                          ),
                        ),
                        PopupMenuButton(
                            itemBuilder: (context) => const [
                                  PopupMenuItem(child: Text('data')),
                                  PopupMenuItem(child: Text('data')),
                                  PopupMenuItem(child: Text('data')),
                                ])
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
