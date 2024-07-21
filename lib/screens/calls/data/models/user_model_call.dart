class UserModelCall {
  late String id;
  late String name;
  late String email;
  late String avatar;
  bool? busy;
  num? callMinuteCast;

  UserModelCall({required this.name, required this.avatar});

  UserModelCall.resister({
    required this.name,
    required this.id,
    required this.email,
    required this.avatar,
    required this.busy,
    required this.callMinuteCast,
  });

  UserModelCall.fromJsonMap(
      {required Map<String, dynamic> map, required String uId}) {
    id = map["user_UID"];
    name = map["name"];
    email = map["email"];
    avatar = map["userImage"];
    busy = map["busy"];
    callMinuteCast = map["callMinuteCast"];
  }

  Map<String, dynamic> toMap() {
    return {
      "user_UID": id,
      "name": name,
      "email": email,
      "userImage": avatar,
      "callMinuteCast": callMinuteCast,
    };
  }
}

class UserFcmTokenModel {
  late String uId, token;

  UserFcmTokenModel({required this.uId, required this.token});

  UserFcmTokenModel.fromJson(Map<String, dynamic> json) {
    uId = json['uId'];
    token = json['token'];
  }

  Map<String, dynamic> toMap() {
    return {
      'uId': uId,
      'token': token,
    };
  }
}
