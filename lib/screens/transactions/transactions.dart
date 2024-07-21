import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gouantum/screens/transactions/all_transaction.dart';
import 'package:gouantum/screens/transactions/withdrawa.dart';
import '../../utilities/palette.dart';
import 'charge.dart';
import 'controllers/transaction_controller.dart';
import 'cost.dart';
import 'invest.dart';
import 'revenue.dart';
import 'transfer.dart';

class Transactions extends StatefulWidget {
  const Transactions({super.key});

  @override
  State<Transactions> createState() => _TransactionsState();
}

class _TransactionsState extends State<Transactions>
    with TickerProviderStateMixin {

  final TransactionController transactionController =
      Get.put(TransactionController());
  var initialIndex = 0;
  @override
  Widget build(BuildContext context) {
    TabController tabController = TabController(
      length: 7,
      vsync: this,
      initialIndex: initialIndex,
    );
    final size = MediaQuery.of(context).size;
    return Scaffold(
      // endDrawer: const Drawer() ,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0.3,
        title: const Text(
          'Transactions',
          style: TextStyle(
            color: Colors.purple,
          ),
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            height: size.height * 0.10,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          decoration: const InputDecoration(
                            suffixIcon: Icon(Icons.search),
                            hintText: 'I\'M LOOKING FOR THIS DATE...',
                            hintStyle: TextStyle(
                              color: Colors.grey,
                            ),
                            border: InputBorder.none,
                          ),
                          onSubmitted: (value) {
                            transactionController.searchText(
                                context, tabController.index, value);
                          },
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ),
                  )),
                  IconButton(
                      onPressed: () async{
                        String? date = await transactionController
                            .searchDatePicker(context, tabController.index);
                        if(date != null){
                          initialIndex = tabController.index;
                          setState(() {});
                        }
                      },
                      icon: const Icon(
                        Icons.calendar_month_sharp,
                        color: Colors.purple,
                      )),
                ],
              ),
            ),
          ),
          TabBar(
            controller: tabController,
            labelColor: Palette.mainBlueColor,
            onTap: (value) {
              transactionController.searchCheck = false;
            },
            physics: const NeverScrollableScrollPhysics(),
            isScrollable: true,
            indicator: const BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Palette.mainBlueColor,
                  width: 2.0,
                ),
              ),
            ),
            labelStyle: TextStyle(
              fontFamily: 'Helvetica',
              fontWeight: FontWeight.w700,
              fontSize: size.height * 0.02,
            ),
            unselectedLabelColor: Palette.medGrayColor,
            unselectedLabelStyle: TextStyle(
              fontFamily: 'Helvetica',
              fontWeight: FontWeight.w400,
              fontSize: size.height * 0.015,
            ),
            tabs: const [
              Tab(
                text: "ALL",
              ),
              Tab(
                text: "Revenue",
              ),
              Tab(
                text: "Cost",
              ),
              Tab(
                text: 'Charge',
              ),
              Tab(
                text: 'Withdrawal',
              ),
              Tab(
                text: 'Transfer',
              ),
              Tab(
                text: 'Invest',
              ),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: tabController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                ALLTransaction(),
                Revenue(),
                Cost(),
                const ChargeTransactions(),
                const WithdrawalTransactions(),
                const TransferTransactions(),
                const InvestTransactions(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
