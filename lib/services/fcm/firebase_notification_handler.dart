import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:gouantum/screens/calls/data/models/call_model.dart';
import '../../model/users.dart';
import '../../routes/routes.dart';
import '../../screens/Interactive_chat/chat_controllers.dart';
import '../../screens/Interactive_chat/model/chat_page_arguments.dart';
import '../../screens/Interactive_chat/model/message_chat.dart';
import '../../screens/home/home_controller.dart';
import '../../utilities/firestore_constants.dart';
import 'notification_handler.dart';
import 'package:flutter_callkit_incoming/entities/android_params.dart';
import 'package:flutter_callkit_incoming/entities/call_kit_params.dart';
import 'package:flutter_callkit_incoming/entities/ios_params.dart';
import 'package:flutter_callkit_incoming/entities/notification_params.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
// ignore_for_file: depend_on_referenced_packages
import 'package:uuid/uuid.dart';

class FirebaseNotifications {
  late FirebaseMessaging _messaging;
  late BuildContext myContext;

  HomeController homeController = Get.put(HomeController());

  void setUpFcm(
      {required BuildContext context,
      required Function onForegroundClickCallNotify}) {
    _messaging = FirebaseMessaging.instance;
    NotificationHandler.initNotification(
      context: context,
      selectNotificationCallback: (NotificationResponse? payload) async {
        if (payload != null) {
          // ignore: prefer_interpolation_to_compose_strings
          debugPrint('notification payload: ' + payload.input.toString());
          Map<String, dynamic> data = jsonDecode(payload.payload as String);
          if (data['type'] == 'call') {
            onForegroundClickCallNotify();
          }
          if(data['type'] == 'message'){
            debugPrint("clicked on notifiction done ${payload.payload}");
            String peerId = data['idFrom'];
            FirebaseFirestore.instance
                .collection(FirestoreConstants.userCollection).doc(peerId)
                .get().then((value) {
              UserModel userModel = UserModel.fromJson(value.data()!);
              var arg = ChatPageArguments(
                  peerId: peerId,
                  peerAvatar: userModel.userImage,
                  token: userModel.token,
                  peerNickname: userModel.name,
                  callMinuteCast: userModel.callMinuteCast);
              RoutesClass.arguments = arg;
              Get.toNamed(RoutesClass.getChatRoute());
            });
          }
        }
      },
    );
    firebaseCloudMessageListener(context);
    myContext = context;
  }

  void firebaseCloudMessageListener(BuildContext context) async {
    final bool? result = await NotificationHandler
        .flutterLocalNotificationPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );

    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      debugPrint('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      debugPrint('User granted provisional permission');
    } else {
      debugPrint('User declined or has not accepted permission');
    }
    debugPrint(
        'Setting ${settings.authorizationStatus} LocalPer ${result.toString()}');
    //Get Token
    //Handle message
    FirebaseMessaging.onMessage.listen((remoteMessage) {
      //Foreground Msg
      if (remoteMessage.data['type'] != 'call') {
        if (remoteMessage.data['type'] == 'message') {
          Map<String, dynamic> data = jsonDecode(remoteMessage.data['body']);

          MessageChat messageChat = MessageChat.fromJson(data);
          Iterable<SortedUser> sortedUser =
          homeController.usersLastMessages.where((element) {
            return element.user.userUID == messageChat.idFrom;
          });

          if (!messageChat.seen! && sortedUser.first.seenSendMessage) {
            sortedUser.first.seenSendMessage = false;
            homeController.numOfSeenMessages++;
            homeController.seenMessages.add(homeController.numOfSeenMessages);
          }

          showNotification(
              title: remoteMessage.data['title'],
              body: messageChat.content.contains('https://')
                  ? "New ${messageChat.name}"
                  : messageChat.content,
              type: remoteMessage.data['type']);
        }
        else{
          showNotification(
              title: remoteMessage.data['title'],
              body: remoteMessage.data['body'] ?? "",
              type: remoteMessage.data['type']);
        }
      }
    });
    FirebaseMessaging.onMessageOpenedApp.listen((remoteMessage) {
      debugPrint('Receive open app: $remoteMessage ');
      debugPrint(
          'InOpenAppNotifyBody ${remoteMessage.data['body'].toString()}');
      if (Platform.isIOS) {
        showDialog(
            context: myContext,
            builder: (context) => CupertinoAlertDialog(
                  title: Text(remoteMessage.notification!.title ?? ''),
                  content: Text(remoteMessage.notification!.body ?? ''),
                  actions: [
                    CupertinoDialogAction(
                      isDefaultAction: true,
                      child: const Text('OK'),
                      onPressed: () => Navigator.of(
                        context,
                        rootNavigator: true,
                      ).pop(),
                    )
                  ],
                ));
      }
    });
  }

  static AndroidNotificationDetails callChannel =
      /*const*/ AndroidNotificationDetails(
          'com.example.gouantum', 'call_channel',
          autoCancel: false,
          sound: RawResourceAndroidNotificationSound(
              "ringlong.wav".split('.').first),
          playSound: true,
          enableVibration: true,
          audioAttributesUsage: AudioAttributesUsage.alarm,
          additionalFlags: Int32List.fromList(<int>[4]),
          actions: [
            const AndroidNotificationAction(
              "1",
              "Accept",
              titleColor: Colors.green,
              cancelNotification: false,
            ),
            const AndroidNotificationAction("2", "cancel",
                titleColor: Colors.red, cancelNotification: true),
          ],
          ongoing: true,
          importance: Importance.max,
          priority: Priority.max);
  static AndroidNotificationDetails normalChannel =
      const AndroidNotificationDetails('com.example.gouantum', 'normal_channel',
          playSound: true,
          enableVibration: true,
          autoCancel: true,
          ongoing: false,
          audioAttributesUsage: AudioAttributesUsage.notification,
          importance: Importance.max,
          priority: Priority.max);

  static void showNotification(
      {String? title,String? additionalData, required String body, required String type}) async {
    // debugPrint('callDataFromNotify $body');
    int notificationId = Random().nextInt(1000);
    var ios = const DarwinNotificationDetails();
    var platform = NotificationDetails(android: normalChannel, iOS: ios);
    //print(title);
    Map<String, dynamic> data = {};
    if(additionalData!=null){
      data = {
        'title': title,
        'body': body,
        'type': type,
        'idFrom':additionalData
      };
    }else{
      data = {
        'title': title,
        'body': body,
        'type': type,
      };
    }
    await NotificationHandler.flutterLocalNotificationPlugin
        .show(notificationId, title, body, platform, payload: jsonEncode(data));
  }

  static Future<void> showCallkitIncoming({required String body}) async {
    Uuid uuid0 = const Uuid();

    Map<String, dynamic> bodyJson = jsonDecode(body);
    CallModel callModel = CallModel.fromJson(bodyJson);

    final params = CallKitParams(
      id: uuid0.v4(),
      nameCaller: callModel.callerName,
      appName: 'Gouantum',
      avatar: callModel.callerAvatar,
      handle: '📞 Ringing...',
      type: callModel.isVideo == false ? 0 : 1,
      duration: 30000,
      textAccept: 'Accept',
      textDecline: 'Decline',
      missedCallNotification: NotificationParams(
        showNotification: false,
        isShowCallback: false,
        subtitle: 'Missed call from ${callModel.callerName}',
      ),
      extra: callModel.toMap(),
      headers: <String, dynamic>{'apiKey': 'Abc@123!', 'platform': 'flutter'},
      android: const AndroidParams(
        isCustomNotification: true,
        isShowLogo: true,
        ringtonePath: 'system_ringtone_default',
        backgroundColor: '#0955fa',
        backgroundUrl: 'assets/test.png',
        actionColor: '#4CAF50',
      ),
      ios: const IOSParams(
        iconName: 'CallKitLogo',
        handleType: '',
        supportsVideo: true,
        maximumCallGroups: 2,
        maximumCallsPerCallGroup: 1,
        audioSessionMode: 'default',
        audioSessionActive: true,
        audioSessionPreferredSampleRate: 44100.0,
        audioSessionPreferredIOBufferDuration: 0.005,
        supportsDTMF: true,
        supportsHolding: true,
        supportsGrouping: false,
        supportsUngrouping: false,
        ringtonePath: 'system_ringtone_default',
      ),
    );
    await FlutterCallkitIncoming.showCallkitIncoming(params);
  }

  static Future<void> showCallkitMissedCall(
      {required CallModel callModel}) async {
    Uuid uuid0 = const Uuid();
    final params = CallKitParams(
      id: uuid0.v4(),
      nameCaller: callModel.callerName,
      appName: 'Gouantum',
      avatar: callModel.callerAvatar,
      handle: '📞 missedCall from ${callModel.callerName}',
      extra: callModel.toMap(),
      headers: <String, dynamic>{'apiKey': 'Abc@123!', 'platform': 'flutter'},
      android: const AndroidParams(
        isCustomNotification: false,
        isShowLogo: true,
      ),
      ios: const IOSParams(
        iconName: 'CallKitLogo',
        audioSessionMode: 'default',
        audioSessionActive: true,
        audioSessionPreferredSampleRate: 44100.0,
        audioSessionPreferredIOBufferDuration: 0.005,
      ),
      missedCallNotification: const NotificationParams(
        isShowCallback: false,
      ),
    );
    await FlutterCallkitIncoming.showMissCallNotification(params);
  }
}
