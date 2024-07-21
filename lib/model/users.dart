import '../utilities/firestore_constants.dart';

class UserModel {
  final String accountStatus;
  final String countries;
  final String dateOfBirth;
  final String educationCategory;
  final String email;
  final String name;
  final String password;
  final String phoneNumber;
  final String language;
  final String gender;
  final String userImage;
  final String userUID;
  final String token;
  final String regesterationDataTime;
  final String idDocuments;
  final num myBalance;
  final bool businessAccount;
  final bool busy;
  final num callMinuteCast;
  final num videoMinuteCast;

  UserModel({
    required this.accountStatus,
    required this.countries,
    required this.dateOfBirth,
    required this.educationCategory,
    required this.email,
    required this.name,
    required this.gender,
    required this.password,
    required this.phoneNumber,
    required this.language,
    required this.userImage,
    required this.userUID,
    required this.token,
    required this.regesterationDataTime,
    required this.myBalance,
    required this.businessAccount,
    required this.idDocuments,
    required this.busy,
    required this.callMinuteCast,
    required this.videoMinuteCast,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
        accountStatus: json[FirestoreConstants.accountStatus],
        countries: json[FirestoreConstants.country],
        dateOfBirth: json[FirestoreConstants.dateOfBirth],
        educationCategory: json[FirestoreConstants.educationCategory],
        email: json[FirestoreConstants.email],
        name: json[FirestoreConstants.nickname],
        password: json[FirestoreConstants.password],
        phoneNumber: json[FirestoreConstants.phoneNumber],
        language: json[FirestoreConstants.preferdLang],
        userImage: json[FirestoreConstants.photoUrl] ?? '',
        userUID: json[FirestoreConstants.id],
        token: json[FirestoreConstants.token],
        gender: json[FirestoreConstants.gender],
        myBalance: json[FirestoreConstants.myBalance],
        regesterationDataTime: json[FirestoreConstants.dateOfBirth],
        businessAccount: json[FirestoreConstants.businessAccount],
        idDocuments: json[FirestoreConstants.idDocuments],
        busy: json[FirestoreConstants.busy],
        callMinuteCast: json[FirestoreConstants.callMinuteCast],
        videoMinuteCast: json[FirestoreConstants.videoMinuteCast]);
  }

  Map<String, dynamic> toJson() {
    return {
      FirestoreConstants.accountStatus: accountStatus,
      FirestoreConstants.country: countries,
      FirestoreConstants.dateOfBirth: dateOfBirth,
      FirestoreConstants.educationCategory: educationCategory,
      FirestoreConstants.email: email,
      FirestoreConstants.name: name,
      FirestoreConstants.password: password,
      FirestoreConstants.phoneNumber: phoneNumber,
      FirestoreConstants.preferdLang: language,
      FirestoreConstants.gender: gender,
      FirestoreConstants.photoUrl: userImage,
      FirestoreConstants.id: userUID,
      FirestoreConstants.token: token,
      FirestoreConstants.regesterationDataTime: regesterationDataTime,
      FirestoreConstants.idDocuments: idDocuments,
      FirestoreConstants.myBalance: myBalance,
      FirestoreConstants.businessAccount: businessAccount,
      FirestoreConstants.busy: busy,
      FirestoreConstants.callMinuteCast: callMinuteCast,
      FirestoreConstants.videoMinuteCast: videoMinuteCast,
    };
  }
}
