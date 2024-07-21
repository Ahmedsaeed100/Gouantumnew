class Gender {
  final String? genderNameEN;
  final String? genderNameAR;

  Gender({
    this.genderNameEN,
    this.genderNameAR,
  });

  factory Gender.fromJson(Map<String, dynamic> json) {
    return Gender(
      genderNameEN: json['GenderNameEN'],
      genderNameAR: json['GenderNameAR'],
    );
  }
}
