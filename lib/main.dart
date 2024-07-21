import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:gouantum/routes/routes.dart';
import 'package:gouantum/screens/Interactive_chat/model/message_chat.dart';
import 'package:gouantum/screens/calls/presentaion/cubit/auth/auth_cubit.dart';
import 'package:gouantum/screens/calls/presentaion/cubit/home/home_cubit.dart';
import 'package:gouantum/services/fcm/firebase_notification_handler.dart';
import 'package:gouantum/screens/calls/shared/dio_helper.dart';
import 'package:gouantum/screens/login/splash.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'routes.dart';
import 'screens/calls/shared/network/cache_helper.dart';
import 'utilities/palette.dart';
import 'package:gouantum/screens/calls/data/models/call_model.dart';
import 'package:gouantum/utilities/firestore_constants.dart';
import 'package:flutter_callkit_incoming/entities/call_event.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';

FirebaseMessaging messaging = FirebaseMessaging.instance;

Future<void> main() async {
  // Run the app within a guarded zone
  runZonedGuarded(() async {
    // Ensure Flutter bindings are initialized
    WidgetsFlutterBinding.ensureInitialized();
    // Initialize other async operations
    await CacheHelper.init();
    await Firebase.initializeApp();
    DioHelper.init();

    // Initialize Firebase Messaging
    await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    // Handle notifications
    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      debugPrint("notification onMessageOpenedApp: ${event.data}");
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint("notification onMessage: ${message.data}");
      if (message.notification != null) {
        // print('Message also contained a notification: ${message.notification}');
      }
    });

    FirebaseMessaging.onBackgroundMessage(_backgroundHandler);

    // Initialize SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Run the app
    runApp(MyApp(
      appRouter: AppRouter(),
      prefs: prefs,
    ));

    configLoading();
  }, (error, stackTrace) {
    debugPrint('Uncaught error: $error');
    debugPrint('Stack trace: $stackTrace');
  });
}

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.dark
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = Colors.yellow
    ..backgroundColor = Colors.green
    ..indicatorColor = Colors.yellow
    ..textColor = Colors.yellow
    ..maskColor = Colors.blue.withOpacity(0.5)
    ..userInteractions = true
    ..dismissOnTap = false;
}

void callKitListening() {
  FlutterCallkitIncoming.onEvent.listen((event) async {
    try {
      Map<Object?, Object?> eventCallData = event?.body['extra'];
      Map<String, dynamic> castedEventCallData =
          eventCallData.cast<String, dynamic>();
      CallModel callModel = CallModel.fromJson(castedEventCallData);

      if (event!.event == Event.actionCallIncoming) {
        int counterFlag = 0;
        FirebaseFirestore.instance
            .collection(FirestoreConstants.callsCollection)
            .doc(callModel.id)
            .snapshots()
            .listen((check) {
          CallModel call = CallModel.fromJson(check.data()!);
          if ((call.status == 'cancel' || call.status == 'unAnswer') &&
              call.acceptOut == null &&
              call.declineOut == null &&
              counterFlag < 1) {
            debugPrint("Missed Call Notification in cancel and unAnswer");
            FlutterCallkitIncoming.endCall(event.body['id']);
            FirebaseNotifications.showCallkitMissedCall(callModel: callModel);
            counterFlag++;
          }
        });
      }

      if (event.event == Event.actionCallDecline) {
        await FirebaseFirestore.instance
            .collection(FirestoreConstants.callsCollection)
            .doc(callModel.id)
            .update({'declineOut': true});
      }

      if (event.event == Event.actionCallAccept) {
        await FirebaseFirestore.instance
            .collection(FirestoreConstants.callsCollection)
            .doc(callModel.id)
            .update({'acceptOut': true});
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  });
}

class MyApp extends StatelessWidget {
  final SharedPreferences prefs;
  final AppRouter appRouter;
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseStorage firebaseStorage = FirebaseStorage.instance;

  MyApp({
    super.key,
    required this.prefs,
    required this.appRouter,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) =>
              AuthCubit()..getUserData(uId: CacheHelper.getString(key: 'uId')),
        ),
        BlocProvider(
          create: (_) => HomeCubit()
            ..listenToInComingCalls()
            ..getUsersRealTime()
            ..getCallHistoryRealTime()
            ..initFcm(context)
            ..updateFcmToken(uId: CacheHelper.getString(key: 'uId')),
        ),
      ],
      child: GetMaterialApp(
        builder: EasyLoading.init(),
        title: 'Gouantum',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: Palette.mainBlueColor,
            ),
          ),
        ),
        onGenerateRoute: appRouter.onGenerateRoute,
        home: const GouantumSplash(),
        getPages: RoutesClass.routes,
      ),
    );
  }
}

@pragma('vm:entry-point')
Future<void> _backgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  await CacheHelper.init();

  if (message.data['type'] == 'call') {
    Map<String, dynamic> bodyMap = jsonDecode(message.data['body']);
    await CacheHelper.saveData(
        key: 'terminateIncomingCallData', value: jsonEncode(bodyMap));
    FirebaseNotifications.showCallkitIncoming(body: message.data['body'] ?? "");
    callKitListening();
  } else {
    if (message.data['type'] == 'message') {
      Map<String, dynamic> data = jsonDecode(message.data['body']);
      MessageChat messageChat = MessageChat.fromJson(data);
      FirebaseNotifications.showNotification(
          title: message.data['title'],
          body: messageChat.content.contains('https://')
              ? "New ${messageChat.name}"
              : messageChat.content,
          type: message.data['type'],
          additionalData: messageChat.idFrom);
    } else {
      FirebaseNotifications.showNotification(
          title: message.data['title'],
          body: message.data['body'] ?? "",
          type: message.data['type']);
    }
  }
}
