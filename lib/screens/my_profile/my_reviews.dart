// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:gouantum/utilities/palette.dart';

class MyReviews extends StatefulWidget {
  const MyReviews({
    super.key,
    required this.size,
  });
  final Size size;

  @override
  State<MyReviews> createState() => _MyReviewsState();
}

class _MyReviewsState extends State<MyReviews> {
  bool _switchVal = true;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: widget.size.width * 0.05,
      ),
      child: ListView(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Hide My Reviews',
                style: TextStyle(
                  fontFamily: 'Helvetica',
                  fontSize: widget.size.height * 0.025,
                ),
              ),
              Switch(
                activeColor: Palette.mainBlueColor,
                value: _switchVal,
                onChanged: (val) {
                  setState(
                    () {
                      _switchVal = val;
                    },
                  );
                },
              ),
            ],
          ),
          ListView.builder(
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
                        vertical: widget.size.height * 0.02,
                        horizontal: widget.size.width * 0.02,
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
                                  height: widget.size.height * 0.05,
                                  width: widget.size.width * 0.12,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              SizedBox(width: widget.size.width * 0.05),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Ahmed Saeed $index",
                                    style: TextStyle(
                                      fontSize: widget.size.height * 0.025,
                                      fontFamily: "Helvetica",
                                    ),
                                  ),
                                  SizedBox(height: widget.size.height * 0.01),
                                  Text(
                                    "Group name",
                                    style: TextStyle(
                                      fontSize: widget.size.height * 0.015,
                                      color: Colors.grey,
                                      fontFamily: "Helvetica",
                                    ),
                                  ),
                                  SizedBox(height: widget.size.height * 0.01),
                                  const Text("⭐⭐⭐⭐⭐"),
                                  SizedBox(height: widget.size.height * 0.01),
                                  SizedBox(
                                    width: widget.size.width * 0.65,
                                    child: Text(
                                      "“Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.”",
                                      overflow: TextOverflow.fade,
                                      maxLines: 3,
                                      style: TextStyle(
                                        fontSize: widget.size.width * 0.035,
                                        fontWeight: FontWeight.w500,
                                        color: Palette.darkGrayColor,
                                        fontFamily: "Poppins",
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
          SizedBox(height: widget.size.height * 0.05),
        ],
      ),
    );
  }
}
