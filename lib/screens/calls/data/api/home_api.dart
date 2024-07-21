import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gouantum/screens/calls/shared/network/cache_helper.dart';
import 'package:gouantum/utilities/firestore_constants.dart';

class HomeApi {
  //Not Used
  Future<QuerySnapshot<Map<String, dynamic>>> getUsers() async {
    return FirebaseFirestore.instance
        .collection(FirestoreConstants.userCollection)
        .where('user_UID', isNotEqualTo: CacheHelper.getString(key: 'uId'))
        .get();
  }

  StreamSubscription<QuerySnapshot<Map<String, dynamic>>> getUsersRealTime() {
    return FirebaseFirestore.instance
        .collection(FirestoreConstants.userCollection)
        .where('user_UID', isNotEqualTo: CacheHelper.getString(key: 'uId'))
        .snapshots()
        .listen((event) {});
  }

  StreamSubscription<QuerySnapshot<Map<String, dynamic>>> getUser() {
    return FirebaseFirestore.instance
        .collection(FirestoreConstants.userCollection)
        .where('user_UID', isEqualTo: CacheHelper.getString(key: 'uId'))
        .snapshots()
        .listen((event) {});
  }

  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>
      getCallHistoryRealTime() {
    return FirebaseFirestore.instance
        .collection(FirestoreConstants.callsCollection)
        .orderBy('createAt', descending: true)
        .snapshots()
        .listen((event) {});
  }
}
