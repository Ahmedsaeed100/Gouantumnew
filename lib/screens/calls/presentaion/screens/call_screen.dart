import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:get/get.dart';
import 'package:gouantum/controllers/timer_controller.dart';
import 'package:gouantum/screens/calls/data/models/call_model.dart';
import 'package:gouantum/screens/calls/presentaion/cubit/call/call_cubit.dart';
import 'package:gouantum/screens/calls/presentaion/cubit/call/call_state.dart';
import 'package:gouantum/screens/calls/presentaion/widgets/call_widgets/default_circle_image.dart';
import 'package:gouantum/screens/calls/presentaion/widgets/call_widgets/user_info_header.dart';
import 'package:gouantum/services/fcm/notification_handler.dart';
import 'package:gouantum/widgets/show_toast.dart';
import 'package:gouantum/utilities/palette.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:permission_handler/permission_handler.dart';

class CallScreen extends StatefulWidget {
  final bool isReceiver;
  final CallModel callModel;
  const CallScreen(
      {super.key, required this.isReceiver, required this.callModel});

  @override
  State<CallScreen> createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  late CallCubit _callCubit;
  TimerController timerController = Get.put(TimerController());

  @override
  void initState() {
    NotificationHandler.flutterLocalNotificationPlugin.cancelAll();
    super.initState();
    _callCubit = CallCubit.get(context);
    rePermission();
    _callCubit.listenToCallStatus(
        callModel: widget.callModel,
        context: context,
        isReceiver: widget.isReceiver);
    if (!widget.isReceiver) {
      //Caller
      _callCubit.initAgoraAndJoinChannel(
        optionalUid: widget.callModel.createAt!.toInt(),
        channelToken: widget.callModel.accessToken!,
        channelName: widget.callModel.channelName!,
        isCaller: true,
        isVideo: widget.callModel.isVideo!,
      );
    } else {
      //Receiver
      if (_callCubit.state is CallCancelState ||
          _callCubit.state is CallNoAnswerState) {
      } else {
        _callCubit.playContactingRing(isCaller: false);
      }
    }
    _callCubit.listen(widget.callModel.id, widget.isReceiver);
  }

  @override
  void dispose() {
    if (widget.isReceiver && _callCubit.engine != null) {
      _callCubit.performEndCall(
          callModel: widget.callModel, duration: timerController.Seconds.value);
    }

    if (_callCubit.engine != null) {
      _callCubit.engine!.release();
      _callCubit.engine!.leaveChannel();
      timerController.timer?.cancel();
      timerController.time.value = '00.00';
      timerController.duration = const Duration(seconds: 0);
    }
    FlutterRingtonePlayer.stop();
    _callCubit.assetsAudioPlayer.dispose();
    if (!widget.isReceiver) {
      //Sender
      _callCubit.countDownTimer?.cancel();
    }

    _callCubit.disposeOutCallStatus(widget.callModel.id);

    super.dispose();
  }

  Future<void> rePermission() async {
    // retrieve permissions
    await [Permission.microphone, Permission.camera].request();
  }

  int? remoteUid;
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CallCubit, CallState>(
      listener: (BuildContext context, Object? state) {
        if (state is ErrorUnAnsweredVideoChatState) {
          showToast(msg: 'UnExpected Error!: ${state.error}');
        }
        if (state is DownCountCallTimerFinishState) {
          if (_callCubit.remoteUid == null) {
            _callCubit.updateCallStatusToUnAnswered(
              callModel: widget.callModel,
            );
          }
        }

        if (state is AgoraRemoteUserJoinedEvent) {
          setState(() {
            // print('remoteUidCaller: ${state.uid}');
            remoteUid = state.uid;
          });
          //remote user join channel
          if (!widget.isReceiver) {
            //Caller
            _callCubit.countDownTimer?.cancel();
          }
          FlutterRingtonePlayer.stop();
          _callCubit.assetsAudioPlayer.stop(); //Sender, Receiver
        }

        //Call States
        if (state is CallNoAnswerState) {
          if (!widget.isReceiver) {
            //Caller
            showToast(msg: 'No response!');
          }
          Navigator.pop(context);
        }
        if (state is CallCancelState) {
          if (widget.isReceiver) {
            //Receiver
            showToast(msg: 'Caller cancel the call!');
          }
          Navigator.pop(context);
        }
        if (state is CallRejectState) {
          if (!widget.isReceiver) {
            //Caller
            showToast(msg: 'Receiver reject the call!');
          }
          Navigator.pop(context);
        }
        if (state is CallEndState) {
          showToast(msg: 'Call ended!');
          Navigator.pop(context);
        }
      },
      builder: (BuildContext context, state) {
        var cubit = CallCubit.get(context);

        return ModalProgressHUD(
          inAsyncCall: false,
          // ignore: deprecated_member_use
          child: WillPopScope(
            onWillPop: () async {
              return false;
            },
            child: Scaffold(
              body: Stack(
                alignment: AlignmentDirectional.center,
                children: [
                  remoteUid == null
                      ? !widget.isReceiver
                          ? Container(
                              color: Palette.lightwhiteColor,
                              child: AgoraVideoView(
                                controller: VideoViewController(
                                  rtcEngine: _callCubit.engine!,
                                  canvas: const VideoCanvas(uid: 0),
                                ),
                              ),
                            )
                          : Container(
                              //res
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image:
                                      widget.callModel.callerAvatar!.isNotEmpty
                                          ? NetworkImage(
                                              widget.callModel.callerAvatar!,
                                            )
                                          : const NetworkImage(
                                              'https://picsum.photos/200/300',
                                            ),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            )
                      : Stack(
                          children: [
                            Center(
                              child: _remoteVideo(remoteUserId: remoteUid!),
                            ),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: SizedBox(
                                width: 122,
                                height: 219.0,
                                child: Center(
                                  child: AgoraVideoView(
                                    controller: VideoViewController(
                                      rtcEngine: _callCubit.engine!,
                                      canvas: const VideoCanvas(uid: 0),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                  Container(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(
                          height: 50.0,
                        ),
                        !widget.isReceiver
                            ? UserInfoHeader(
                                //Caller -> Show Receiver INFO
                                avatar: widget.callModel.receiverAvatar!,
                                name: widget.callModel.receiverName!,
                              )
                            : UserInfoHeader(
                                //Receiver -> Show Caller INFO
                                avatar: widget.callModel.callerAvatar!,
                                name: widget.callModel.callerName!,
                              ),
                        const SizedBox(
                          height: 30.0,
                        ),
                        cubit.remoteUid == null
                            ? Expanded(
                                child: widget.isReceiver
                                    ? Text(
                                        !widget.callModel.outCall
                                            ? '${widget.callModel.callerName} is calling you..'
                                            : 'Contacting Please Wait...',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 39.0,
                                        ),
                                      )
                                    : const Text(
                                        'Contacting..',
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 39.0,
                                        ),
                                      ),
                              )
                            : Expanded(
                                child: Container(),
                              ),
                        cubit.remoteUid == null
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  widget.isReceiver
                                      ? widget.callModel.outCall
                                          ? Container()
                                          : Expanded(
                                              child: InkWell(
                                                onTap: () {
                                                  //receiverAcceptVideoChat
                                                  _callCubit
                                                      .updateCallStatusToAccept(
                                                    callModel: widget.callModel,
                                                  );
                                                },
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                      15.0,
                                                    ),
                                                    color: Colors.green,
                                                  ),
                                                  child: const Center(
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                        horizontal: 30.0,
                                                        vertical: 8.0,
                                                      ),
                                                      child: Text(
                                                        'Acceptance',
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 13.0,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            )
                                      : Container(),
                                  widget.isReceiver
                                      ? const SizedBox(
                                          width: 15.0,
                                        )
                                      : Container(),
                                  Expanded(
                                    child: widget.callModel.outCall &&
                                            widget.isReceiver
                                        ? Container()
                                        : InkWell(
                                            onTap: () {
                                              if (widget.isReceiver) {
                                                //receiverRejectVideoChat
                                                _callCubit
                                                    .updateCallStatusToReject(
                                                  callModel: widget.callModel,
                                                );
                                              } else {
                                                //callerCancelVideoChat
                                                _callCubit
                                                    .updateCallStatusToCancel(
                                                  callModel: widget.callModel,
                                                );
                                              }
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(15.0),
                                                color: Colors.red,
                                              ),
                                              child: Center(
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                    horizontal: 30.0,
                                                    vertical: 8.0,
                                                  ),
                                                  child: Text(
                                                    widget.isReceiver
                                                        ? 'Reject'
                                                        : 'Cancel',
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 13.0,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                  )
                                ],
                              )
                            : Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  // End Call Button
                                  RawMaterialButton(
                                    onPressed: () {
                                      cubit.updateCallStatusToEnd(
                                        callId: widget.callModel.id,
                                      );
                                    },
                                    shape: const CircleBorder(),
                                    elevation: 2.0,
                                    fillColor: Colors.red,
                                    padding: const EdgeInsets.all(10.0),
                                    child: const Icon(
                                      Icons.call_end_rounded,
                                      color: Colors.white,
                                      size: 20.0,
                                    ),
                                  ),

                                  // Switch Camera

                                  GestureDetector(
                                    onTap: () {
                                      cubit.switchCamera();
                                    },
                                    child: const DefaultCircleImage(
                                      bgColor: Colors.white,
                                      image: Icon(
                                        Icons.switch_camera_outlined,
                                        color: Colors.black,
                                      ),
                                      center: true,
                                      width: 35,
                                      height: 35,
                                    ),
                                  ),

                                  // Share
                                  RawMaterialButton(
                                    onPressed: () {
                                      cubit.screenSharing
                                          ? cubit.stopShare()
                                          : cubit.startShare();
                                    },
                                    shape: const CircleBorder(),
                                    elevation: 2.0,
                                    fillColor: Colors.white,
                                    padding: const EdgeInsets.all(10.0),
                                    child: const Icon(
                                      Icons.share,
                                      color: Colors.blueAccent,
                                      size: 20.0,
                                    ),
                                  ),

                                  // Open And Close Camera
                                  // RawMaterialButton(
                                  //   onPressed: () {
                                  //     cubit.disableAndEnableVideo();
                                  //   },
                                  //   shape: const CircleBorder(),
                                  //   elevation: 2.0,
                                  //   fillColor: Colors.green,
                                  //   padding: const EdgeInsets.all(12.0),
                                  //   child: cubit.videocamIcon,
                                  // ),
                                  // Open Speaker
                                  RawMaterialButton(
                                    onPressed: () {
                                      cubit.toggleSpeaker();
                                    },
                                    shape: const CircleBorder(),
                                    elevation: 1.0,
                                    fillColor: Colors.white,
                                    padding: const EdgeInsets.all(10.0),
                                    child: cubit.speakerEnabled,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      cubit.toggleMuted();
                                    },
                                    child: DefaultCircleImage(
                                      bgColor: Colors.white,
                                      image: cubit.muteIcon,
                                      center: true,
                                      width: 35,
                                      height: 35,
                                    ),
                                  ),
                                ],
                              ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // Display remote user's video
  Widget _remoteVideo({required int remoteUserId}) {
    return AgoraVideoView(
        controller: VideoViewController.remote(
      rtcEngine: _callCubit.engine!,
      canvas: VideoCanvas(uid: remoteUserId),
      connection: RtcConnection(channelId: widget.callModel.channelName!),
    ));
  }
}
