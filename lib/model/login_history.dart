class LoginHistory {
  final String? location;
  final DateTime? logOutDateTime;
  final DateTime? logInDateTime;
  final String? userAutoId;

  LoginHistory(
      {this.location,
      this.logOutDateTime,
      this.logInDateTime,
      this.userAutoId});

  factory LoginHistory.fromJson(Map<String, dynamic> json) {
    return LoginHistory(
        location: json['location'],
        logOutDateTime: json['logOutDateTime'],
        logInDateTime: json['logInDateTime'],
        userAutoId: json['userAutoId']);
  }
}
