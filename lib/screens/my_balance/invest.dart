import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gouantum/utilities/palette.dart';
import 'package:gouantum/widgets/my_buttons.dart';

class Invest extends StatefulWidget {
  const Invest({super.key});

  @override
  State<Invest> createState() => _InvestState();
}

class _InvestState extends State<Invest> {
  final _list = [
    "100",
    "200",
    "300",
    "400",
    "500",
    "600",
  ];

  String _selected = "100";

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Column(
      children: [
        const SizedBox(height: 20),
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Icon(
            FontAwesomeIcons.moneyBillWheat,
            color: Color(0XFFAAACFF),
          ),
        ),
        const SizedBox(height: 20),
        const Text("Select one of Fixed Amounts to ",
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
            )),
        const SizedBox(height: 20),
        SizedBox(
          height: size.height * 0.35,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: GridView.builder(
                itemCount: _list.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 5.0,
                  mainAxisSpacing: 5.0,
                  childAspectRatio: 2.5,
                ),
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _selected = _list[index];
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: _selected != _list[index]
                              ? const Color(0xffF4F4F4)
                              : Palette.mainBlueColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                            child: Text(
                          "\$ ${_list[index]}",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: _selected != _list[index]
                                ? Colors.black
                                : Colors.white,
                          ),
                        )),
                      ),
                    ),
                  );
                }),
          ),
        ),
        MyButtons(
          color: Palette.mainBlueColor,
          width: .90,
          text: 'Invest',
          onPressed: () {
            //  print("Invest");
            showBottomSheet(
                enableDrag: false,
                context: context,
                builder: (context) => _buildBottomSheet(context));
          },
        )
      ],
    );
  }

  _buildBottomSheet(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      height: size.height * 0.7,
      width: double.infinity,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Charge",
                  style: TextStyle(
                      color: Colors.purple,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    Text(
                      "Amount is ",
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                    Text("\$ 11.32",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        )),
                  ],
                ),
              ],
            ),
            const Text(
              "Card Number",
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: const TextField(
                decoration: InputDecoration(
                  hintText: "0000 - 0000 - 0000 - 0000",
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(10),
                  hintStyle: TextStyle(
                    color: Colors.grey,
                    wordSpacing: 5,
                  ),
                ),
              ),
            ),
            const Text(
              "Card Owner Name",
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: const TextField(
                decoration: InputDecoration(
                  hintText: "Enter The Name as typed on the card",
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(10),
                  hintStyle: TextStyle(
                    color: Colors.grey,
                    wordSpacing: 1,
                  ),
                ),
              ),
            ),
            Row(
              children: [
                SizedBox(
                  width: size.width * 0.68,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Expiry Date",
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Container(
                              width: size.width * 0.3,
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const TextField(
                                decoration: InputDecoration(
                                  hintText: "00 Month",
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.all(10),
                                  hintStyle: TextStyle(
                                    color: Colors.grey,
                                    wordSpacing: 1,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              width: size.width * 0.3,
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const TextField(
                                decoration: InputDecoration(
                                  hintText: "00 Year",
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.all(10),
                                  hintStyle: TextStyle(
                                    color: Colors.grey,
                                    wordSpacing: 1,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: size.width * 0.25,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "CVV/CVC",
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      Container(
                        width: size.width * 0.28,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const TextField(
                          decoration: InputDecoration(
                            hintText: "123",
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.all(10),
                            hintStyle: TextStyle(
                              color: Colors.grey,
                              wordSpacing: 1,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Row(
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    "Cancel For Now",
                    style: TextStyle(
                      color: Colors.purple,
                      fontSize: 18,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
                const Spacer(),
                MyButtons(
                  width: .40,
                  color: Colors.purple,
                  text: 'Confirm',
                  onPressed: () {
                    // print("Pay");
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
