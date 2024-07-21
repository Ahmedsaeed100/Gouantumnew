import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../model/transactions/revenue.dart';

class ChargeTransactions extends StatelessWidget {
  const ChargeTransactions({super.key});

  @override
  Widget build(BuildContext context) {
    return AllData();
  }
}


class AllData extends StatelessWidget {
  AllData({super.key});
  final _list = [
    ModelRevenue(
        id: "1",
        name: "Charge",
        description: "5 Mintes and 37 Seconds",
        amount: "500",
        date: "Today",
        status: "pending",
        icon: FontAwesomeIcons.wallet,
        category: "Revenue"),
    ModelRevenue(
        id: "2",
        name: "Charge",
        description: "5 Mintes and 37 Seconds",
        amount: "500",
        date: "Today",
        status: "pending",
        icon: FontAwesomeIcons.wallet,
        category: "Revenue"),
    ModelRevenue(
        id: "2",
        name: "Charge",
        description: "5 Mintes and 37 Seconds",
        amount: "500",
        date: "Today",
        status: "pending",
        icon: FontAwesomeIcons.wallet,
        category: "Revenue"),
    ModelRevenue(
        id: "2",
        name: "Charge",
        description: "5 Mintes and 37 Seconds",
        amount: "500",
        date: "Today",
        status: "pending",
        icon: FontAwesomeIcons.wallet,
        category: "Revenue"),
    ModelRevenue(
        id: "2",
        name: "Charge",
        description: "5 Mintes and 37 Seconds",
        amount: "500",
        date: "Today",
        status: "pending",
        icon: FontAwesomeIcons.wallet,
        category: "Revenue"),
  ];
  final _list2 = [
    ModelRevenue(
        id: "1",
        name: "Charge",
        description: "5 Mintes and 37 Seconds",
        amount: "500",
        date: "Today",
        status: "pending",
        icon: FontAwesomeIcons.wallet,
        category: "Revenue"),
    ModelRevenue(
        id: "2",
        name: "Charge",
        description: "5 Mintes and 37 Seconds",
        amount: "500",
        date: "Today",
        status: "pending",
        icon: FontAwesomeIcons.wallet,
        category: "Revenue"),
    ModelRevenue(
        id: "2",
        name: "Charge",
        description: "5 Mintes and 37 Seconds",
        amount: "500",
        date: "Today",
        status: "pending",
        icon: FontAwesomeIcons.wallet,
        category: "Revenue"),
    ModelRevenue(
        id: "2",
        name: "Charge",
        description: "5 Mintes and 37 Seconds",
        amount: "500",
        date: "Today",
        status: "pending",
        icon: FontAwesomeIcons.wallet,
        category: "Revenue"),
    ModelRevenue(
        id: "2",
        name: "Charge",
        description: "5 Mintes and 37 Seconds",
        amount: "500",
        date: "Today",
        status: "pending",
        icon: FontAwesomeIcons.wallet,
        category: "Revenue"),
  ];
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
              height: 50,
              decoration: BoxDecoration(
                color: Colors.grey[100]!,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Today",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          "Paid amount",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "\$54.32",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )),
        ),
        SizedBox(
          height: size.height * 0.30,
          child: ListView.builder(
            itemCount: _list.length,
            itemBuilder: (context, index) {
              return _list[index].date == "Today"
                  ? Column(
                      children: [
                        ListTile(
                          leading: Icon(_list[index].icon,
                              color: const Color(0xffC4C5F0)),
                          title: Text(_list[index].name,
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600)),
                          subtitle: Text(_list[index].description,
                              style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400)),
                          trailing: Text("\$${_list[index].amount}",
                              style: TextStyle(
                                  color: _list[index].status == "success"
                                      ? Colors.green
                                      : _list[index].status == "fail"
                                          ? Colors.red
                                          : const Color(0xff2f2f6b),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400)),
                        ),
                        Divider(
                          color: Colors.grey.shade300,
                          height: 0.5,
                          thickness: 0.5,
                          indent: 20,
                          endIndent: 20,
                        )
                      ],
                    )
                  : const SizedBox();
            },
          ),
        ),
        Padding(
            padding: const EdgeInsets.all(8.0),
            child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 70),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10))),
                onPressed: () {},
                child: const Text(
                  "Download",
                  style: TextStyle(color: Colors.black),
                ))),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
              height: 50,
              decoration: BoxDecoration(
                color: Colors.grey[100]!,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "31 November 2019",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          "Total amount",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "\$54.32",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )),
        ),
        SizedBox(
          height: size.height * 0.30,
          child: ListView.builder(
            itemCount: _list2.length,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  ListTile(
                    leading: Icon(_list2[index].icon,
                        color: const Color(0xffC4C5F0)),
                    title: Text(_list2[index].name,
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w600)),
                    subtitle: Text(_list2[index].description,
                        style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                            fontWeight: FontWeight.w400)),
                    trailing: Text("\$${_list2[index].amount}",
                        style: TextStyle(
                            color: _list[index].status == "success"
                                ? Colors.green
                                : _list[index].status == "fail"
                                    ? Colors.red
                                    : const Color(0xff2f2f6b),
                            fontSize: 16,
                            fontWeight: FontWeight.w400)),
                  ),
                  Divider(
                    color: Colors.grey.shade300,
                    height: 0.5,
                    thickness: 0.5,
                    indent: 20,
                    endIndent: 20,
                  )
                ],
              );
            },
          ),
        ),
        Padding(
            padding: const EdgeInsets.all(8.0),
            child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 70),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10))),
                onPressed: () {},
                child: const Text(
                  "Download",
                  style: TextStyle(color: Colors.black),
                ))),
      ],
    );
  }
}
