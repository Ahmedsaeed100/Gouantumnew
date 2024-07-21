import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:get/get.dart';
import 'package:gouantum/controllers/timer_controller.dart';
import 'package:gouantum/screens/calls/data/api/call_api.dart';
import 'package:gouantum/screens/calls/data/models/call_model.dart';
import 'package:gouantum/screens/calls/presentaion/cubit/home/home_cubit.dart';
import 'package:gouantum/screens/calls/shared/constats.dart';
// ignore: depend_on_referenced_packages
import 'package:quiver/async.dart';
import '../../../../home/home_controller.dart';
import 'call_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../../utilities/firestore_constants.dart';

class CallCubit extends Cubit<CallState> {
  CallCubit() : super(CallInitial());

  static CallCubit get(context) => BlocProvider.of(context);
  TimerController timerController = Get.put(TimerController());
  //Agora video room

  int? remoteUid;
  RtcEngine? engine;

  HomeController homeController = Get.put(HomeController());

  Future<void> initAgoraAndJoinChannel({
    required String channelToken,
    required String channelName,
    required int optionalUid,
    required bool isCaller,
    required bool isVideo,
  }) async {
    //create the engine
    engine = createAgoraRtcEngine();
    await engine?.initialize(const RtcEngineContext(
      appId: agoraAppId,
      channelProfile: ChannelProfileType.channelProfileCommunication,
    ));
    if (isVideo) {
      await engine!.enableVideo();
      videoEnabled = true;
    } else {
      await engine!.enableAudio();
      videoEnabled = false;
    }

    engine!.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          debugPrint("local user ${connection.localUid} joined");
          //remoteUid = uid;
        },
        onUserJoined: (RtcConnection connection, int uid, int elapsed) {
          debugPrint("remote user $uid joined");
          remoteUid = uid;
          timerController.startTimer(0);
          emit(AgoraRemoteUserJoinedEvent(uid));
        },
        onUserEnableVideo: (connection, remoteUid, enabled) {},
        onUserOffline:
            (RtcConnection connection, int uid, UserOfflineReasonType reason) {
          debugPrint("remote user $uid left channel");
          remoteUid = null;

          emit(AgoraUserLeftEvent());
        },
      ),
    );
    log('channelTokenIs $channelToken channelNameIs $channelName');
    //join channel
    try {
      await engine!.joinChannel(
          token: channelToken,
          channelId: channelName,
          uid: isCaller ? 0 : 1,
          options: const ChannelMediaOptions() //optionalUid,
          );
      if (isCaller) {
        emit(AgoraInitForSenderSuccessState());
        playContactingRing(isCaller: true);
      } else {
        emit(AgoraInitForReceiverSuccessState());
      }
    } catch (e, st) {
      log("st $st");
      log("error $e");
    }

    debugPrint('channelTokenIs $channelToken channelNameIs $channelName');
  }

  //Sender
  AudioPlayer assetsAudioPlayer = AudioPlayer();

  Future<void> playContactingRing({required bool isCaller}) async {
    if (isCaller) {
      startCountdownCallTimer();
    }
    String audioAsset = "assets/sounds/ringlong.mp3";
    ByteData bytes = await rootBundle.load(audioAsset);
    // ignore: unused_local_variable
    Uint8List soundBytes =
        bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes);
    FlutterRingtonePlayer.play(fromAsset: "assets/sounds/ringlong.mp3");
  }

// Call Counter //Time Of Call
  int current = 0;
  CountdownTimer? countDownTimer;

  void startCountdownCallTimer() {
    countDownTimer = CountdownTimer(
      const Duration(seconds: callDurationInSec),
      const Duration(seconds: 1),
    );
    var sub = countDownTimer!.listen(null);
    sub.onData((duration) {
      current = callDurationInSec - duration.elapsed.inSeconds;
      debugPrint("DownCount: $current");
    });

    sub.onDone(() {
      debugPrint("CallTimeDone");
      sub.cancel();
      emit(DownCountCallTimerFinishState());
    });
  }

  bool muted = false;
  Widget muteIcon = const Icon(
    Icons.keyboard_voice_rounded,
    color: Colors.black,
  );

// Toggle Mute Voice
  Future<void> toggleMuted() async {
    muted = !muted;
    muteIcon = muted
        ? const Icon(
            Icons.mic_off_rounded,
            color: Colors.black,
          )
        : const Icon(
            Icons.keyboard_voice_rounded,
            color: Colors.black,
          );
    await engine!.muteLocalAudioStream(muted);
    emit(AgoraToggleMutedState());
  }

// Open And Close Speaker
  bool openSpeaker = false;
  Widget speakerEnabled = const Icon(
    Icons.volume_up,
    color: Colors.blueAccent,
  );
// Toggle Mute Voice
  Future<void> toggleSpeaker() async {
    openSpeaker = !openSpeaker;
    speakerEnabled = openSpeaker
        ? const Icon(
            Icons.volume_mute,
            color: Colors.blueAccent,
          )
        : const Icon(
            Icons.volume_up,
            color: Colors.blueAccent,
          );
    await engine!.setEnableSpeakerphone(openSpeaker);
    emit(AgoraToggleMutedState());
  }
  //End Toggle Mute Voice

//Disable And Enable Video
  bool videoEnabled = false;
  Widget videocamIcon = const Icon(
    Icons.videocam,
    color: Colors.black,
  );
// Disable And Enable Video
  Future<void> disableAndEnableVideo() async {
    videoEnabled = !videoEnabled;
    videocamIcon = videoEnabled
        ? const Icon(
            Icons.videocam_off,
            color: Colors.black,
          )
        : const Icon(
            Icons.videocam,
            color: Colors.black,
          );
    if (videoEnabled) {
      await engine!.disableVideo();
      await engine!.enableAudio();
    } else {
      await engine!.enableVideo();
      await engine!.enableAudio();
    }
    emit(AgoraToggleMutedState());
  }

// Swich Camera
  Future<void> switchCamera() async {
    await engine!.switchCamera();
    emit(AgoraSwitchCameraState());
  }

  // Sharing
  bool screenSharing = false;
  int _selectedDisplayId = -1;
  int _selectedWindowId = -1;
  // List<MediaDeviceInfo> recordings = [];
  final String _selectedLoopBackRecordingDeviceName = "";
// Start Share
  startShare() {
    _startScreenShare();
  }

// Stop Share
  stopShare() {
    _stopScreenShare();
  }

  _startScreenShare() async {
    if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
      const ScreenAudioParameters parametersAudioParams = ScreenAudioParameters(
        sampleRate: 100,
      );
      const VideoDimensions videoParamsDimensions = VideoDimensions(
        width: 1280,
        height: 720,
      );
      const ScreenVideoParameters parametersVideoParams = ScreenVideoParameters(
        dimensions: videoParamsDimensions,
        frameRate: 15,
        bitrate: 1000,
        contentHint: VideoContentHint.contentHintMotion,
      );
      const ScreenCaptureParameters2 parameters = ScreenCaptureParameters2(
        captureAudio: true,
        audioParams: parametersAudioParams,
        captureVideo: true,
        videoParams: parametersVideoParams,
      );

      await engine!.startScreenCapture(parameters);
    } else if (Platform.isWindows || Platform.isMacOS) {
      if (_selectedDisplayId != -1) {
        await engine!.startScreenCaptureByDisplayId(
          displayId: _selectedDisplayId,
          regionRect: const Rectangle(),
          captureParams: const ScreenCaptureParameters(),
        );
        await engine!.enableAudio();
        await engine!.enableLoopbackRecording(
            enabled: true, deviceName: _selectedLoopBackRecordingDeviceName);
      } else if (_selectedWindowId != -1) {
        await engine!.startScreenCaptureByWindowId(
          windowId: _selectedWindowId,
          regionRect: const Rectangle(),
          captureParams: const ScreenCaptureParameters(),
        );
        await engine!.enableAudio();
        await engine!.enableLoopbackRecording(
            enabled: true, deviceName: _selectedLoopBackRecordingDeviceName);
      } else {
        return;
      }
    }
    screenSharing = true;
    emit(AgoraStartSharingState());
  }

  _stopScreenShare() async {
    await engine!.stopScreenCapture();
    screenSharing = false;
    _selectedDisplayId = -1;
    _selectedWindowId = -1;
    emit(AgoraStopSharingState());
  }

////

/////
  ///
  ///
  //Update Call Status
  final _callApi = CallApi();
  void updateCallStatusToUnAnswered({required CallModel callModel}) {
    emit(LoadingUnAnsweredVideoChatState());

    updateUserBusyStatusFirestore(callModel: callModel);

    _callApi
        .updateCallStatus(
            callId: callModel.id, status: CallStatus.unAnswer.name)
        .then((value) {
      emit(SuccessUnAnsweredVideoChatState());
    }).catchError((onError) {
      emit(ErrorUnAnsweredVideoChatState(onError.toString()));
    });
  }

  Future<void> updateCallStatusToCancel({required CallModel callModel}) async {
    updateUserBusyStatusFirestore(callModel: callModel);

    await _callApi.updateCallStatus(
      callId: callModel.id,
      status: CallStatus.cancel.name,
    );
    await FlutterRingtonePlayer.stop();
  }

// When Call Rejected
  Future<void> updateCallStatusToReject({required CallModel callModel}) async {
    updateUserBusyStatusFirestore(callModel: callModel);

    await _callApi.updateCallStatus(
      callId: callModel.id,
      status: CallStatus.reject.name,
    );
    await FlutterRingtonePlayer.stop();
  }

// When Call is Accept
  Future<void> updateCallStatusToAccept({required CallModel callModel}) async {
    await _callApi.updateCallStatus(
      callId: callModel.id,
      status: CallStatus.accept.name,
    );
    initAgoraAndJoinChannel(
      optionalUid: callModel.createAt!.toInt(),
      channelToken: callModel.accessToken!,
      channelName: callModel.channelName!,
      isCaller: false,
      isVideo: callModel.isVideo!,
    );
    await FlutterRingtonePlayer.stop();
  }

// When Call End
  Future<void> updateCallStatusToEnd({required String callId}) async {
    await _callApi.updateCallStatus(
      callId: callId,
      status: CallStatus.end.name,
    );
    await FlutterRingtonePlayer.stop();
  }

  Future<void> endCurrentCall({
    required CallModel callModel,
    required String callId,
    required int duration,
  }) async {
    await _callApi.endCurrentCall(
      callModel: callModel,
      callerId: callModel.callerId!,
      receiverId: callModel.receiverId!,
      callId: callId,
      duration: duration,
    );
  }

  Future<void> updateUserBusyStatusFirestore(
      {required CallModel callModel}) async {
    await _callApi.updateUserBusyStatusFirestore(
      callModel: callModel,
      busy: false,
    );
    await FlutterRingtonePlayer.stop();
  }

  Future<void> performEndCall(
      {required CallModel callModel, required int duration}) async {
    await endCurrentCall(
        callId: callModel.id, duration: duration, callModel: callModel);
    await updateUserBusyStatusFirestore(callModel: callModel);
    await FlutterRingtonePlayer.stop();
  }

// Call State
  StreamSubscription? callStatusStreamSubscription;
  void listenToCallStatus({
    required CallModel callModel,
    required BuildContext context,
    required bool isReceiver,
  }) {
    var homeCubit = HomeCubit.get(context);
    callStatusStreamSubscription =
        _callApi.listenToCallStatus(callId: callModel.id);
    callStatusStreamSubscription!.onData((data) {
      if (data.exists) {
        String status = data.data()!['status'];
        if (status == CallStatus.accept.name) {
          homeCubit.currentCallStatus = CallStatus.accept;
          debugPrint('acceptStatus');
          emit(CallAcceptState());
        }
        if (status == CallStatus.reject.name) {
          if(callModel.receiverId == homeController.userUid){
            homeController.numOfMissedCall++;
            homeController.missedCalls.sink.add(homeController.numOfMissedCall);
          }
          homeCubit.currentCallStatus = CallStatus.reject;
          debugPrint('rejectStatus');
          callStatusStreamSubscription!.cancel();
          emit(CallRejectState());
        }
        if (status == CallStatus.unAnswer.name) {
          if(callModel.receiverId == homeController.userUid){
            homeController.numOfMissedCall++;
            homeController.missedCalls.sink.add(homeController.numOfMissedCall);
          }
          homeCubit.currentCallStatus = CallStatus.unAnswer;
          debugPrint('unAnswerStatusHere');
          callStatusStreamSubscription!.cancel();
          emit(CallNoAnswerState());
        }
        if (status == CallStatus.cancel.name) {
          homeCubit.currentCallStatus = CallStatus.cancel;
          debugPrint('cancelStatus');
          callStatusStreamSubscription!.cancel();
          emit(CallCancelState());
        }
        if (status == CallStatus.end.name) {
          homeCubit.currentCallStatus = CallStatus.end;
          debugPrint('endStatus');
          callStatusStreamSubscription!.cancel();

          emit(CallEndState());
        }
      }
    });
  }

  void disposeOutCallStatus(String callId) {
    // FirebaseFirestore.instance.collection(FirestoreConstants.callsCollection)
    //     .doc(callId).update({'declineOut':null});
    //
    // FirebaseFirestore.instance.collection(FirestoreConstants.callsCollection)
    //     .doc(callId).update({'acceptOut':null});

    FirebaseFirestore.instance
        .collection(FirestoreConstants.callsCollection)
        .doc(callId)
        .update({'outCall': false});

    outCallStreamSubscription?.cancel();
    timerController.timer?.cancel();
    timerController.time.value = '00.00';
    timerController.duration = const Duration(seconds: 0);
  }

  StreamSubscription? outCallStreamSubscription;
  void listen(String callId, bool isReceiver) {
    DocumentReference<Map<String, dynamic>> doc = FirebaseFirestore.instance
        .collection(FirestoreConstants.callsCollection)
        .doc(callId);
    outCallStreamSubscription = doc.snapshots().listen((event) {
      CallModel callModel = CallModel.fromJson(event.data() ?? {});
      if (callModel.acceptOut == true && isReceiver) {
        doc.update({'acceptOut': null});
        updateCallStatusToAccept(callModel: callModel);
      }
      if (callModel.declineOut == true) {
        doc.update({'declineOut': null});
        updateCallStatusToReject(callModel: callModel);
      }
    });
  }
}
