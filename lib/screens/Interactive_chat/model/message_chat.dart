import 'package:cloud_firestore/cloud_firestore.dart';

import '../constants/constants.dart';

class MessageChat {
  String idFrom;
  String idTo;
  String timestamp;
  String content;
  String name;
  String fileSize;
  int type;
  bool? seen;
  MessageChat({
    required this.idFrom,
    required this.idTo,
    required this.timestamp,
    required this.content,
    required this.name,
    required this.fileSize,
    required this.type,
    required this.seen,
  });

  Map<String, dynamic> toJson() {
    return {
      FirestoreConstants.idFrom: idFrom,
      FirestoreConstants.idTo: idTo,
      FirestoreConstants.timestamp: timestamp,
      FirestoreConstants.content: content,
      FirestoreConstants.name: name,
      FirestoreConstants.fileSize: fileSize,
      FirestoreConstants.type: type,
      'seen': false
    };
  }

  factory MessageChat.fromJson(Map<String, dynamic> json) {
    return MessageChat(
        idFrom: json[FirestoreConstants.idFrom],
        idTo: json[FirestoreConstants.idTo],
        timestamp: json[FirestoreConstants.timestamp],
        content: json[FirestoreConstants.content],
        name: json[FirestoreConstants.name],
        fileSize: json[FirestoreConstants.fileSize],
        type: json[FirestoreConstants.type],
        seen: json['seen']);
  }

  factory MessageChat.fromDocument(DocumentSnapshot doc) {
    return MessageChat(
        name: doc[FirestoreConstants.name],
        idFrom: doc[FirestoreConstants.idFrom],
        idTo: doc[FirestoreConstants.idTo],
        timestamp: doc[FirestoreConstants.timestamp],
        content: doc[FirestoreConstants.content],
        fileSize: doc[FirestoreConstants.fileSize],
        type: doc[FirestoreConstants.type],
        seen: (doc.data() as Map)['seen'] ?? false);
  }
}

enum MessageType {
  text,
  image,
  video,
  audio,
  url,
  file,
}

MessageType convertTypeNumToMessageType(int typeNum) {
  switch (typeNum) {
    case 0:
      return MessageType.text;
    case 1:
      return MessageType.image;
    case 2:
      return MessageType.video;
    case 3:
      return MessageType.audio;
    case 4:
      return MessageType.url;
    case 5:
      return MessageType.file;
    default:
      return MessageType.text;
  }
}
