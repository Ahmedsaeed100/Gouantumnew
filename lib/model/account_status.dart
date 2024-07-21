class AccountStatus {
  final String? userState;

  AccountStatus({this.userState});

  factory AccountStatus.fromJson(Map<String, dynamic> json) {
    return AccountStatus(
      userState: json['userState'],
    );
  }
}
