// ignore_for_file: public_member_api_docs, sort_constructors_first
class LoginType {
  final String? loginTypeName;
  final String? loginTypeCode;

  LoginType({
    this.loginTypeName,
    this.loginTypeCode,
  });

  factory LoginType.fromJson(Map<String, dynamic> json) {
    return LoginType(
        loginTypeName: json['LoginTypeName'],
        loginTypeCode: json['LoginTypeCode']);
  }
}
