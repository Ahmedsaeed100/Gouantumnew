import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gouantum/utilities/extentions.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';
import '../../../model/transactions/revenue.dart';
import '../../../model/users.dart';
import '../../../utilities/firestore_constants.dart';
import '../../calls/data/models/call_model.dart';
import '../../home/home_controller.dart';

class TransactionController extends GetxController {
  FirebaseFirestore fireStore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  late var myUid = auth.currentUser!.uid;

  List<CallSearchedFormat> allTransactionCalls = [];
  List<CallSearchedFormat> revenueCalls = [];
  List<CallSearchedFormat> costCalls = [];
  List<CallSearchedFormat> searchCalls = [];
  HomeController homeController = Get.put(HomeController());
  bool searchCheck = false ;

  @override
  void onInit() async {
    ///
    super.onInit();
  }

  Future<List<CallSearchedFormat>> getAllTransaction() async {
    try {
      if(!searchCheck){
        allTransactionCalls.clear();

        QuerySnapshot<Map<String, dynamic>> get = await fireStore
            .collection(FirestoreConstants.callsCollection)
            .orderBy('createAt', descending: true)
            .get();

        for (var e in get.docs) {
          CallModel callModel = CallModel.fromJson(e.data());
          if (callModel.receiverId! == homeController.userUid ||
              callModel.callerId! == homeController.userUid) {
            DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(
              callModel.createAt as int,
            );
            String date =
                "${dateTime.day} ${monthName(dateTime.month)} ${dateTime.year}";
            allTransactionCalls
                .add(CallSearchedFormat(call: callModel, date: date));
          }
        }
      }
    } catch (e) {
      log('error in call_log_controller getAllTransaction function :  $e');
    }
    return allTransactionCalls;
  }

  Future<List<CallSearchedFormat>> getRevenues() async {
    try {
      if(!searchCheck){
        revenueCalls.clear();

        QuerySnapshot<Map<String, dynamic>> get = await fireStore
            .collection(FirestoreConstants.callsCollection)
            .where('receiverId', isEqualTo: myUid)
            .orderBy('createAt', descending: true)
            .get();

        for (var e in get.docs) {
          CallModel callModel = CallModel.fromJson(e.data());
          DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(
            callModel.createAt as int,
          );
          String date =
              "${dateTime.day} ${monthName(dateTime.month)} ${dateTime.year}";
          revenueCalls.add(CallSearchedFormat(call: callModel, date: date));
        }
      }
    } catch (e) {
      log('error in call_log_controller getAllTransaction function :  $e');
    }
    return revenueCalls;
  }

  Future<List<CallSearchedFormat>> getCosts() async {
    try {
      if(!searchCheck){
        costCalls.clear();

        QuerySnapshot<Map<String, dynamic>> get = await fireStore
            .collection(FirestoreConstants.callsCollection)
            .where('callerId', isEqualTo: myUid)
            .orderBy('createAt', descending: true)
            .get();

        for (var e in get.docs) {
          CallModel callModel = CallModel.fromJson(e.data());
          DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(
            callModel.createAt as int,
          );
          String date =
              "${dateTime.day} ${monthName(dateTime.month)} ${dateTime.year}";
          costCalls.add(CallSearchedFormat(call: callModel, date: date));
        }
      }
    } catch (e) {
      log('error in call_log_controller getAllTransaction function :  $e');
    }
    return costCalls;
  }

  List<String> getDates(List<CallSearchedFormat> type) {
    if(searchCheck){
      type = searchCalls;
    }
    List<String> dates = [];
    for (var item in type) {
      if (!dates.contains(item.date)) {
        dates.add(item.date);
      }
    }
    return dates;
  }

  List<ModelRevenue> getListDataFromDate(
      String date, List<CallSearchedFormat> type) {
    List<ModelRevenue> result = [];
    Iterable<CallSearchedFormat> data = type.where((item) => item.date == date);
    for (var item in data) {
      UserModel? receiver ;
      if (homeController.userFeaturedProviders!
          .where((element) => element.userUID == item.call.receiverId)
          .isNotEmpty) {
        receiver = homeController.userFeaturedProviders
            ?.where((element) => element.userUID == item.call.receiverId)
            .first;
      } else{
        receiver = homeController.user;
      }

      result.add(ModelRevenue(
          id: "1",
          name: item.call.receiverId != homeController.user?.userUID
              ? item.call.receiverName!
              : item.call.callerName!,
          description:
          "${timeFormat(item.call.duration?.formatDuration() ?? "0: 00")} ",
          amount:
          "${double.parse(((item.call.duration ?? 0) * receiver!.callMinuteCast * 1000 /*MG = 1000 KG*/).toStringAsFixed(2))}",
          // amount:
          //     "0",
          date: item.date,
          status: item.call.receiverId == homeController.user?.userUID
              ? "success"
              : "fail",
          icon: item.call.receiverId == homeController.user?.userUID
              ? Icons.call_received_rounded
              : Icons.call_made_rounded,
          category: item.call.receiverId == homeController.user?.userUID
              ? "Revenue"
              : "Cost"));

    }
    return result;
  }

  String monthName(int month){
    List months = [
      'jan', 'feb', 'mar', 'apr', 'may', 'jun',
      'jul', 'aug', 'sep', 'oct', 'nov', 'dec'
    ];
    return months[month-1];
  }

  String timeFormat(String time){
    List<String> format = time.split(":");
    return "${format[0]} Minutes and${format[1]} Seconds";
  }

  double getTotal(List<ModelRevenue> data){
    double total = 0;
    for (var element in data) {
      total += double.parse(element.amount);
    }
    return total;
  }

  Future<String?> searchDatePicker(BuildContext context, int tapIndex) async {
    DateTime? dateTime = await showOmniDateTimePicker(
      context: context,
      initialDate: DateTime.now(),
      type: OmniDateTimePickerType.date,
      firstDate: DateTime(1600).subtract(const Duration(days: 3652)),
      lastDate: DateTime.now().add(
        const Duration(days: 3652),
      ),
      borderRadius: const BorderRadius.all(Radius.circular(16)),
      constraints: const BoxConstraints(
        maxWidth: 350,
        maxHeight: 650,
      ),
      transitionBuilder: (context, anim1, anim2, child) {
        return FadeTransition(
          opacity: anim1.drive(
            Tween(
              begin: 0,
              end: 1,
            ),
          ),
          child: child,
        );
      },
      barrierDismissible: true,
    );
    if (dateTime != null) {
      searchCheck = true;
      searchCalls.clear();
      String selectedDate =
          "${dateTime.day} ${monthName(dateTime.month)} ${dateTime.year}";
      if (tapIndex == 0) {
        searchCalls = allTransactionCalls
            .where((element) => element.date == selectedDate)
            .toList();
      }
      if (tapIndex == 1) {
        searchCalls = revenueCalls
            .where((element) => element.date == selectedDate)
            .toList();
      }
      if (tapIndex == 2) {
        searchCalls =
            costCalls.where((element) => element.date == selectedDate).toList();
      }
      return selectedDate;
    }
    return null;
  }

  Future<void> searchText(
      BuildContext context, int tapIndex, String text) async {
    searchCheck = true;
    searchCalls.clear();

    if (tapIndex == 0) {
      searchCalls = allTransactionCalls
          .where((element) => element.date.contains(text)).toList();
    }
    if (tapIndex == 1) {
      searchCalls = revenueCalls
          .where((element) => element.date.contains(text)).toList();
    }
    if (tapIndex == 2) {
      searchCalls =
          costCalls.where((element) => element.date.contains(text)).toList();
    }
  }

}

class CallSearchedFormat {
  late String date;
  late CallModel call;

  CallSearchedFormat({
    required this.date,
    required this.call,
  });

}