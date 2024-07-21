import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../model/transactions/revenue.dart';
import 'empty.dart';
import 'controllers/transaction_controller.dart';

class ALLTransaction extends StatelessWidget {
  ALLTransaction({super.key});

  final TransactionController transactionController =
  Get.put(TransactionController());

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return FutureBuilder(
      future: transactionController.getAllTransaction(),
      builder: (context, snapshot) {
        if(!snapshot.hasData){
          return const Center(
            child: CircularProgressIndicator(),
          );
        }else{
          List<String> dates = transactionController
              .getDates(transactionController.allTransactionCalls);

          return dates.isEmpty
              ? const Empty()
              : ListView.builder(
                  itemCount: dates.length,
                  itemBuilder: (context, index) {
                    List<ModelRevenue> data =
                        transactionController.getListDataFromDate(dates[index],
                            transactionController.allTransactionCalls);
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                color: Colors.grey[100]!,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      // snapshot!.data?[index].date ?? "",
                                      dates[index],
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w300,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        const Text(
                                          "Received amount",
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w300,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          "G ${transactionController.getTotal(data)}",
                                          style: const TextStyle(
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
                            itemCount: data.length,
                            itemBuilder: (context, index) {
                              return Column(
                                children: [
                                  ListTile(
                                    leading: Icon(data[index].icon,
                                        color: const Color(0xffC4C5F0)),
                                    title: Text(data[index].name,
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600)),
                                    subtitle: Text(data[index].description,
                                        style: const TextStyle(
                                            color: Colors.grey,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400)),
                                    trailing: Text("G ${data[index].amount}",
                                        style: TextStyle(
                                            color: data[index].status ==
                                                    "success"
                                                ? Colors.green
                                                : data[index].status == "fail"
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
                                    minimumSize:
                                        const Size(double.infinity, 70),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10))),
                                onPressed: () {},
                                child: const Text(
                                  "Download",
                                  style: TextStyle(color: Colors.black),
                                ))),
                      ],
                    );
                  },
                );
        }
      },
    );
  }
}