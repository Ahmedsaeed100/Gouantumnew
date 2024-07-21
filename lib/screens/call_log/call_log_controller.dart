import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:gouantum/screens/calls/data/models/call_model.dart';
import 'package:gouantum/utilities/firestore_constants.dart';
import '../../model/users.dart';
import '../home/home_controller.dart';

class CallLogController extends GetxController {
  FirebaseFirestore fireStore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  late var myUid = auth.currentUser!.uid;
  List<CallModel> outGoingCallLogs = [];
  List<CallModel> inComingCallLogs = [];

  List<CallModel> searchOutGoingCallLogs = [];
  List<CallModel> searchIncomingCallLogs = [];

  HomeController homeController = Get.put(HomeController());

  String inComingSearchKey = '';
  String outGointSearchKey = '';

  var isDataLoading = true.obs;

  @override
  void onInit() async {
    // await getIncomingCallLogs();
    // await getOutGoingCallLogs();
    await getStreamIncomingCallLogs();
    await getStreamGoingCallLogs();
    isDataLoading.value = false;
    super.onInit();
  }

  search(String query, String type) {
    if (type == 'incoming') {
      if (query.isEmpty) {
        searchIncomingCallLogs = inComingCallLogs;
      } else {
        searchIncomingCallLogs = inComingCallLogs
            .where(
              (element) => element.callerName!
                  .toLowerCase()
                  .contains(query.toLowerCase()),
            )
            .toList();
      }
    } else if (type == 'outgoing') {
      if (query.isEmpty) {
        searchOutGoingCallLogs = outGoingCallLogs;
      } else {
        searchOutGoingCallLogs = outGoingCallLogs
            .where((element) => element.receiverName!
                .toLowerCase()
                .contains(query.toLowerCase()))
            .toList();
      }
    }
    update();
  }

// Get Incoming Calls // Get Received Calls
  ///not used
  Future getIncomingCallLogs() async {
    try {
      fireStore
          .collection(FirestoreConstants.callsCollection)
          .where('receiverId', isEqualTo: myUid)
          .orderBy('createAt', descending: true)
          .get()
          .then(
        (value) {
          // inComingCallLogs =
          //     value.docs.map((e) => CallModel.fromJson(e.data())).toList();
          // searchIncomingCallLogs =
          //     value.docs.map((e) => CallModel.fromJson(e.data())).toList();

          List<String> usersIds = [];
          inComingCallLogs.clear();
          searchIncomingCallLogs.clear();

          for (var e in value.docs) {
            CallModel call = CallModel.fromJson(e.data());
            if (!usersIds.contains(call.callerId)) {
              inComingCallLogs.add(call);
              searchIncomingCallLogs.add(call);
              usersIds.add(call.callerId!);
            }
          }
        },
      );
    } catch (e) {
      log('error in call_log_controller getIncomingCallsLogs function :  $e');
    }
  }

// Get OutGoing Calls
  ///not used
  Future getOutGoingCallLogs() async {
    try {
      fireStore
          .collection(FirestoreConstants.callsCollection)
          .where('callerId', isEqualTo: myUid)
          .orderBy('createAt', descending: true)
          .get()
          .then((value) {
        // outGoingCallLogs =
        //     value.docs.map((e) => CallModel.fromJson(e.data())).toList();
        // searchOutGoingCallLogs =
        //     value.docs.map((e) => CallModel.fromJson(e.data())).toList();

        List<String> usersIds = [];
        outGoingCallLogs.clear();
        searchOutGoingCallLogs.clear();

        for (var e in value.docs) {
          CallModel call = CallModel.fromJson(e.data());
          if (!usersIds.contains(call.receiverId)) {
            outGoingCallLogs.add(call);
            searchOutGoingCallLogs.add(call);
            usersIds.add(call.receiverId!);
          }
        }

        update();
      });
    } catch (e) {
      log('error in call_log_controller getOutGoingCallsLogs function :  $e');
    }
  }

  Future getStreamIncomingCallLogs() async {
    try {
      fireStore
          .collection(FirestoreConstants.callsCollection)
          .where('receiverId', isEqualTo: myUid)
          .orderBy('createAt', descending: true)
          .snapshots()
          .listen((event) {
        // inComingCallLogs =
        //     event.docs.map((e) => CallModel.fromJson(e.data())).toList();
        // searchIncomingCallLogs =
        //     event.docs.map((e) => CallModel.fromJson(e.data())).toList();

        List<String> usersIds = [];
        inComingCallLogs.clear();
        searchIncomingCallLogs.clear();

        for (var e in event.docs) {
          CallModel call = CallModel.fromJson(e.data());
          if (!usersIds.contains(call.callerId)) {
            inComingCallLogs.add(call);
            searchIncomingCallLogs.add(call);
            usersIds.add(call.callerId!);
          }
        }

        update();
      });
    } catch (e) {
      log('error in call_log_controller getIncomingCallsLogs function :  $e');
    }
  }

  Future getStreamGoingCallLogs() async {
    try {
      fireStore
          .collection(FirestoreConstants.callsCollection)
          .where('callerId', isEqualTo: myUid)
          .orderBy('createAt', descending: true)
          .snapshots()
          .listen((event) {
        // outGoingCallLogs =
        //     event.docs.map((e) => CallModel.fromJson(e.data())).toList();
        // searchOutGoingCallLogs =
        //     event.docs.map((e) => CallModel.fromJson(e.data())).toList();

        List<String> usersIds = [];
        outGoingCallLogs.clear();
        searchOutGoingCallLogs.clear();

        for (var e in event.docs) {
          CallModel call = CallModel.fromJson(e.data());
          if (!usersIds.contains(call.receiverId)) {
            outGoingCallLogs.add(call);
            searchOutGoingCallLogs.add(call);
            usersIds.add(call.receiverId!);
          }
        }

        update();
      });
    } catch (e) {
      log('error in call_log_controller getOutGoingCallsLogs function :  $e');
    }
  }

  num getIncomingCallCast(List<UserModel> users, String userID) {
    if (users.where((element) {
      return element.userUID == userID;
    }).isNotEmpty) {
      UserModel userModel = users.where((element) {
        return element.userUID == userID;
      }).first;
      return userModel.callMinuteCast;
    }
    return homeController.user?.callMinuteCast ?? 0;
  }

  void makeIncomingListUnique() {
    searchIncomingCallLogs = searchIncomingCallLogs.toSet().toList();
    inComingCallLogs = inComingCallLogs.toSet().toList();
  }

}
