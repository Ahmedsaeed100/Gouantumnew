import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:gouantum/model/users.dart';
import 'package:gouantum/screens/calls/data/models/call_model.dart';
import 'package:gouantum/screens/calls/shared/network/cache_helper.dart';
import 'package:gouantum/utilities/firestore_constants.dart';

class CallApi {
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>
      listenToInComingCall() {
    // print("receiverId ${CacheHelper.getString(key: 'uId')}");
    return FirebaseFirestore.instance
        .collection(FirestoreConstants.callsCollection)
        .where('receiverId', isEqualTo: CacheHelper.getString(key: 'uId'))
        .snapshots()
        .listen((event) {});
  }

  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>> listenToCallStatus(
      {required String callId}) {
    return FirebaseFirestore.instance
        .collection(FirestoreConstants.callsCollection)
        .doc(callId)
        .snapshots()
        .listen((event) {});
  }

  Future<void> postCallToFirestore({required CallModel callModel}) {
    return FirebaseFirestore.instance
        .collection(FirestoreConstants.callsCollection)
        .doc(callModel.id)
        .set(callModel.toMap());
  }

  Future<void> updateUserBusyStatusFirestore(
      {required CallModel callModel, required bool busy}) {
    Map<String, dynamic> busyMap = {'busy': busy};
    return FirebaseFirestore.instance
        .collection(FirestoreConstants.userCollection)
        .doc(callModel.callerId)
        .update(busyMap)
        .then((value) {
      FirebaseFirestore.instance
          .collection(FirestoreConstants.userCollection)
          .doc(callModel.receiverId)
          .update(busyMap);
    });
  }

  final dio = Dio();
  //Sender
  Future<dynamic> generateCallToken(
      {required Map<String, dynamic> queryMap, required CallModel call}) async {
    try {
      final response = await dio.get(
          'https://agoraserver.onrender.com/api/generateTokenRTE?channel=${queryMap["channelName"]}&uid=0&role=publisher');

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception(
            'Error: ${response.data} Status Code: ${response.statusCode}');
      }
      // ignore: deprecated_member_use
    } on DioError catch (error) {
      debugPrint("fireVideoCallError: ${error.toString()}");
    }
  }

  Future<void> updateCallStatus(
      {required String callId, required String status}) {
    return FirebaseFirestore.instance
        .collection(FirestoreConstants.callsCollection)
        .doc(callId)
        .update({'status': status});
  }

  Future<void> endCurrentCall({
    required CallModel callModel,
    required String callerId,
    required String receiverId,
    required String callId,
    required int duration,
  }) {
    //print("rrrrr$duration");
    // Update User Balance After Call
    updateUserBalanceAfterCall(
      callerId: callerId,
      receiverId: receiverId,
      durationSec: duration,
    );

// Add Time of Call After Call
    return FirebaseFirestore.instance
        .collection(FirestoreConstants.callsCollection)
        .doc(callId)
        .update({'current': false, 'duration': duration});
  }
}

// Update User Balance After Call
Future updateUserBalanceAfterCall({
  required String callerId,
  required String receiverId,
  required int durationSec,
}) async {
  var instance = FirebaseFirestore.instance;

  var caller = await instance
      .collection(FirestoreConstants.userCollection)
      .doc(callerId)
      .get()
      .then((value) => UserModel.fromJson(value.data()!));

  var receiver = await instance
      .collection(FirestoreConstants.userCollection)
      .doc(receiverId)
      .get()
      .then((value) => UserModel.fromJson(value.data()!));

  var receiverMinCost = receiver.callMinuteCast;
  var callerBalance = caller.myBalance;
  var receiverBalance = receiver.myBalance;

  var callCost = double.parse(
      ((durationSec) * receiverMinCost /*  1000 MG = 1000 KG*/)
          .toStringAsFixed(2));

  /// when calc with seconds not minutes
  // var callCost =
  // double.parse(((duration / 60) * receiverMinCost).toStringAsFixed(2));

  // First Take Money From Caller
  return instance
      .collection(FirestoreConstants.userCollection)
      .doc(callerId)
      .update({
    'myBalance': callerBalance > callCost
        ? double.parse((callerBalance - callCost).toStringAsFixed(2))
        : 0
  }).then(
    // Then Add Money From receiver
    (_) => instance
        .collection(FirestoreConstants.userCollection)
        .doc(receiverId)
        .update({'myBalance': receiverBalance + callCost}),
  );
}
