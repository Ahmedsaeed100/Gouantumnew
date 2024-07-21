import 'dart:convert';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:gouantum/controllers/global_functions.dart';
import 'package:gouantum/model/users.dart';
import 'package:gouantum/screens/calls/data/api/call_api.dart';
import 'package:gouantum/screens/calls/data/api/home_api.dart';
import 'package:gouantum/screens/calls/data/models/call_model.dart';
import 'package:gouantum/screens/calls/data/models/user_model_call.dart';
import 'package:gouantum/services/fcm/firebase_notification_handler.dart';
import 'package:gouantum/screens/calls/shared/constats.dart';
import 'package:gouantum/screens/calls/shared/network/cache_helper.dart';
import 'package:gouantum/utilities/firestore_constants.dart';
import 'home_state.dart';

// ignore: constant_identifier_names
enum HomeTypes { Users, History }

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());

  static HomeCubit get(context) => BlocProvider.of(context);

  final firebaseNotifications = FirebaseNotifications();
  FirebaseAuth auth = FirebaseAuth.instance;

  int index = 0;

  void onChangeTab(int index) {
    this.index = index;
    emit(ChangeTapBarIndexState());
  }

  void initFcm(context) {
    firebaseNotifications.setUpFcm(
        context: context,
        onForegroundClickCallNotify: (NotificationResponse payload) {
          //  print('payload home cubit : $payload ');
          return payload;
          //  debugPrint('Foreground Click Call Notify: $payload');
        });
  }

  void updateFcmToken({required String uId}) {
    FirebaseMessaging.instance.getToken().then((token) {
      UserFcmTokenModel tokenModel =
          UserFcmTokenModel(token: token!, uId: auth.currentUser!.uid);
      FirebaseFirestore.instance
          .collection(FirestoreConstants.tokensCollectionForCallsid)
          .doc(auth.currentUser!.uid)
          .set(tokenModel.toMap())
          .then((value) {
        debugPrint('User Fcm Token Updated $token');
      }).catchError((onError) {
        debugPrint(onError.toString());
      });
    });
  }

  List<UserModel> users = [];

  final _homeApi = HomeApi();
  void getUsersRealTime() {
    emit(LoadingGetUsersState());
    _homeApi.getUsersRealTime().onData(
      (data) {
        if (data.size != 0) {
          users = []; // Clear existing users list
          for (var element in data.docs) {
            if (!users.any((e) => e.userUID == element.id)) {
              users.add(UserModel.fromJson(element.data()));
            }
          }
          emit(SuccessGetUsersState());
        } else {
          emit(ErrorGetUsersState('No users found'));
        }
      },
    );
  }

  List<CallModel> calls = [];

  void getCallHistoryRealTime() {
    emit(LoadingGetCallHistoryState());
    _homeApi.getCallHistoryRealTime().onData((data) {
      if (data.size != 0) {
        calls = []; // for realtime update the list
        for (var element in data.docs) {
          if (element.data()['callerId'] == CacheHelper.getString(key: 'uId') ||
              element.data()['receiverId'] ==
                  CacheHelper.getString(key: 'uId')) {
            //As firebase not allow multi where query, so we get all calls and filter it
            if (!calls.any((e) => e.id == element.id)) {
              var call = CallModel.fromJson(element.data());
              if (call.callerId == CacheHelper.getString(key: 'uId')) {
                call.otherUser = UserModelCall(
                    name: call.receiverName!, avatar: call.receiverAvatar!);
              } else {
                call.otherUser = UserModelCall(
                    name: call.callerName!, avatar: call.callerAvatar!);
              }
              calls.add(call);
            }
          }
        }
        emit(SuccessGetCallHistoryState());
      } else {
        emit(ErrorGetCallHistoryState('No Call History'));
      }
    });
  }

  //#region Get Data by Normal Request
  void getUser() {
    FirebaseFirestore.instance
        .collection(FirestoreConstants.userCollection)
        .get()
        .then((value) {
      if (value.size != 0) {
        for (var element in value.docs) {
          if (!users.any((e) => e.userUID == element.id)) {
            users.add(UserModel.fromJson(element.data()));
          } else {
            users[users.indexWhere((e) => e.userUID == element.id)] =
                UserModel.fromJson(element.data());
          }
        }
        emit(SuccessGetUsersState());
      } else {
        emit(ErrorGetUsersState('No users found'));
      }
    });
  }

  void getCallHistory() {
    FirebaseFirestore.instance
        .collection(FirestoreConstants.callsCollection)
        .get()
        .then((value) {
      debugPrint('sizeVal: ${value.size}');
      if (value.size != 0) {
        for (var element in value.docs) {
          if (element.data()['callerId'] == CacheHelper.getString(key: 'uId') ||
              element.data()['receiverId'] ==
                  CacheHelper.getString(key: 'uId')) {
            calls.add(CallModel.fromJson(element.data()));
          }
        }
        emit(SuccessGetCallHistoryState());
      } else {
        emit(
          ErrorGetCallHistoryState('No Call History'),
        );
      }
    }).catchError((onError) {
      emit(
        ErrorGetCallHistoryState(
          onError.toString(),
        ),
      );
    });
  }
  //#endregion
//
  // int userBalancecallDurationLimit(num myBalance, num receivedCallCost) {
  //   var value = (myBalance / receivedCallCost) * 60;
  //   return value.floor();
  // }

  //Call Logic ________________________________
  final _callApi = CallApi();
  bool fireCallLoading = false;
  Future<void> fireVideoCall({required CallModel callModel}) async {
    fireCallLoading = true;
    emit(LoadingFireVideoCallState());
    //1-generate call token
    // Generating Random And uniqe Number for channal Name and convert to string
    var random = Random();
    var n1 = random.nextInt(101);
    var n2 = random.nextInt(100);
    if (n2 >= n1) n2 += 1;
    Map<String, dynamic> queryMap = {
      'channelName': n2.toString(),
      'uid': callModel.callerId,
    };
    // go to Function to GeneratToken From Server
    _callApi.generateCallToken(queryMap: queryMap, call: callModel).then(
      (value) {
        callModel.accessToken = value['accessToken']['rtcToken'];
        callModel.channelName = queryMap['channelName'];
        // agoraTestToken = value['token'];
        //agoraTestChannelName = queryMap['channelName'];
        //2-post call in Firebase
        postCallToFirestore(callModel: callModel);
      },
    ).catchError((onError) {
      fireCallLoading = false;
      //For test
      // callModel.token = agoraTestToken;
      // callModel.channelName = agoraTestChannelName;
      postCallToFirestore(callModel: callModel);
      emit(
        ErrorFireVideoCallState(
          onError.toString(),
        ),
      );
    });
  }

  void postCallToFirestore({required CallModel callModel}) {
    _callApi.postCallToFirestore(callModel: callModel).then((value) {
      //3-update user busy status in Firebase
      _callApi
          .updateUserBusyStatusFirestore(callModel: callModel, busy: true)
          .then((value) {
        fireCallLoading = false;
        //4-send notification to receiver
        sendNotificationForIncomingCall(callModel: callModel);
      }).catchError((onError) {
        fireCallLoading = false;
        emit(ErrorUpdateUserBusyStatus(onError.toString()));
      });
    }).catchError((onError) {
      fireCallLoading = false;
      emit(ErrorPostCallToFirestoreState(onError.toString()));
    });
  }

  GlobalFunctionsController controller = Get.put(GlobalFunctionsController());
  void sendNotificationForIncomingCall({required CallModel callModel}) {
    FirebaseFirestore.instance
        .collection(FirestoreConstants.tokensCollectionForCallsid)
        .doc(callModel.receiverId)
        .get()
        .then((value) {
      if (value.exists) {
        Map<String, dynamic> bodyMap = {
          'type': 'call',
          'title': 'New call',
          'body': jsonEncode(
            callModel.toMap(),
          ),
        };
        //  FcmPayloadModel fcmSendData =
        //   FcmPayloadModel(to: value.data()!['token'], data: bodyMap);
        controller
            .sendNotification(token: value.data()!['token'], data: bodyMap)
            .then((value) {
          debugPrint('send notification successfully');
          emit(
            SuccessFireVideoCallState(callModel: callModel),
          );
        }).catchError((onError) {
          debugPrint('Error when send Notify: $onError');
          fireCallLoading = false;
          emit(
            ErrorSendNotification(
              onError.toString(),
            ),
          );
        });
      }
    }).catchError((onError) {
      debugPrint('Error when get user token: $onError');
      fireCallLoading = false;
      emit(ErrorSendNotification(onError.toString()));
    });
  }
  // CallModel inComingCall;

  CallStatus? currentCallStatus;
  void listenToInComingCalls() {
    _callApi.listenToInComingCall().onData(
      (data) {
        if (data.size != 0) {
          for (var element in data.docs) {
            if (element.data()['current'] == true) {
              String status = element.data()['status'];
              if (status == CallStatus.ringing.name) {
                currentCallStatus = CallStatus.ringing;
                debugPrint('ringingStatus');
                CallModel callModel = CallModel.fromJson(element.data());

                ///if call is out , listener will entered only when acceptOut is been true
                if (callModel.outCall) {
                  if (callModel.acceptOut != null) {
                    debugPrint("im entered");
                    emit(
                      SuccessInComingCallState(
                        callModel: callModel,
                      ),
                    );
                  }
                } else {
                  emit(
                    SuccessInComingCallState(
                      callModel: callModel,
                    ),
                  );
                }
              }
            }
          }
        }
      },
    );
  }
}
