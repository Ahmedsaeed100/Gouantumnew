import 'package:flutter/material.dart';
import 'package:gouantum/utilities/palette.dart';

class ConferenceCall extends StatefulWidget {
  const ConferenceCall({super.key});

  @override
  State<ConferenceCall> createState() => _ConferenceCallState();
}

class _ConferenceCallState extends State<ConferenceCall> {
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
                        Container(
                          margin: EdgeInsets.symmetric(
                            horizontal: size.width * 0.01,
                          ),
                          padding: EdgeInsets.all(size.width * 0.001),
                          child: const CircleAvatar(
                            backgroundImage: ExactAssetImage(
                              "assets/img/logo/testImage/person.png",
                            ),
                          ),
                        ),
                        SizedBox(
                          width: size.width * 0.02,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.group,
                                  size: size.height * 0.02,
                                  color: Palette.mainBlueColor,
                                ),
                                SizedBox(width: size.width * 0.015),
                                Text(
                                  "Group name $index",
                                  style: TextStyle(
                                    fontSize: size.height * 0.025,
                                    fontFamily: "Helvetica",
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: size.height * 0.01,
                            ),
                            Row(
                              children: [
                                SizedBox(width: size.width * 0.06),
                                Text(
                                  "2:13 min |",
                                  style: TextStyle(
                                    fontSize: size.height * 0.015,
                                    color: Colors.grey,
                                    fontFamily: "Helvetica",
                                  ),
                                ),
                                SizedBox(width: size.width * 0.02),
                                Text(
                                  "11:06 PM  |",
                                  style: TextStyle(
                                    fontSize: size.height * 0.015,
                                    color: Colors.grey,
                                    fontFamily: "Helvetica",
                                  ),
                                ),
                                SizedBox(width: size.width * 0.02),
                                Text(
                                  "\$0.10",
                                  style: TextStyle(
                                    fontSize: size.height * 0.017,
                                    color: Palette.greenColor,
                                    fontFamily: "Helvetica",
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    Container(
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
