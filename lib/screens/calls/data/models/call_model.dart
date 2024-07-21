import 'package:gouantum/screens/calls/data/models/user_model_call.dart';

class CallModel {
  late String id;
  String? accessToken;
  String? channelName;
  String? callerId;
  String? callerName;
  String? callerAvatar;
  String? receiverId;
  String? receiverName;
  String? receiverAvatar;
  String? status;
  num? createAt;
  bool? current;
  UserModelCall? otherUser; //UI
  int? duration;
  num? callMinuteCast;
  late bool outCall;
  bool? acceptOut;
  bool? isVideo;
  bool? declineOut;
  CallModel({
    required this.id,
    this.accessToken,
    this.callerId,
    this.callerName,
    this.callerAvatar,
    this.receiverId,
    this.receiverName,
    this.receiverAvatar,
    this.status,
    this.createAt,
    this.current,
    this.duration,
    this.callMinuteCast,
    required this.outCall,
    this.acceptOut,
    this.declineOut,
    this.isVideo,
  });

  CallModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    accessToken = json['accessToken'];
    channelName = json['channelName'];
    callerId = json['callerId'];
    callerName = json['callerName'];
    callerAvatar = json['callerAvatar'];
    receiverId = json['receiverId'];
    receiverName = json['receiverName'];
    receiverAvatar = json['receiverAvatar'];
    status = json['status'];
    createAt = json['createAt'];
    current = json['current'];
    duration = json['duration'];
    callMinuteCast = json['callMinuteCast'];
    outCall = json['outCall'] ?? false;
    acceptOut = json['acceptOut'];
    declineOut = json['declineOut'];
    isVideo = json['isVideo'];
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'accessToken': accessToken,
      'channelName': channelName,
      'callerId': callerId,
      'callerName': callerName,
      'callerAvatar': callerAvatar,
      'receiverId': receiverId,
      'receiverName': receiverName,
      'receiverAvatar': receiverAvatar,
      'status': status,
      'createAt': createAt,
      'current': current,
      'duration': duration,
      'callMinuteCast': callMinuteCast,
      'outCall': outCall,
      'acceptOut': acceptOut,
      'declineOut': declineOut,
      'isVideo': isVideo,
    };
  }
}
