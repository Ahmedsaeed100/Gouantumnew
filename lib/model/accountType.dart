// ignore_for_file: file_names

class AccountType {
  final String? accountTypeAR;
  final String? accountTypeEN;

  AccountType({
    this.accountTypeAR,
    this.accountTypeEN,
  });

  factory AccountType.fromJson(Map<String, dynamic> json) {
    return AccountType(
      accountTypeAR: json['name'],
      accountTypeEN: json['accountTypeEN'],
    );
  }
}
