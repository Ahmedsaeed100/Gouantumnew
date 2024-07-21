// ignore_for_file: public_member_api_docs, sort_constructors_first
class UserGroup {
  final int? activityTypeAUTOID;
  final int? rate;
  final String? userGroupName;
  final String? userAutoID;
  UserGroup({
    this.activityTypeAUTOID,
    this.rate,
    this.userGroupName,
    this.userAutoID,
  });

  factory UserGroup.fromJson(Map<String, dynamic> json) {
    return UserGroup(
        activityTypeAUTOID: json['activityTypeAUTOID'],
        rate: json['rate'],
        userGroupName: json['UserGroupName'],
        userAutoID: json['UserAutoID']);
  }
}
