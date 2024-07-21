import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gouantum/utilities/firestore_constants.dart';

import '../models/user_model_call.dart';

class AuthApi {
  Future<UserCredential> login(
      {required String email, required String password}) {
    return FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<UserCredential> register(
      {required String email, required String password, required String name}) {
    return FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> createUser({required UserModelCall user}) {
    return FirebaseFirestore.instance
        .collection(FirestoreConstants.userCollection)
        .doc(user.id)
        .set(user.toMap());
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> checkUserExistInFirebase(
      {required String uId}) {
    return FirebaseFirestore.instance
        .collection(FirestoreConstants.userCollection)
        .doc(uId)
        .get();
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getUserData(
      {required String uId}) {
    return FirebaseFirestore.instance
        .collection(FirestoreConstants.userCollection)
        .doc(uId)
        .get();
  }
}
